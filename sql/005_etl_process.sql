--- Create Error Log Table ---
drop table if exists public.etl_error_log;
create table public.etl_error_log
(
	error_info TEXT not null,
	data TEXT not null
);

--- Create ETL Table - Last Objects ---
drop table if exists public.etl_master;
create table public.etl_master
(
	last_data_information json not null,
	last_value double precision
);

--- Create ETL Trigger - Last Object  DONT WORK YET :-( ---
CREATE OR REPLACE FUNCTION update_last_data_information() RETURNS trigger AS
$BODY$
DECLARE
	etl_metadata_id TEXT := NEW.metadata->'metadata_id';
BEGIN
	EXECUTE 'DELETE FROM public.etl_master where last_data_information->>''metadata_id''::text = ''' || etl_metadata_id || '''::text ;';
	
	
	INSERT INTO public.etl_master VALUES (
					json_build_object
					(
					'metadata_id', etl_metadata_id,
					'insert_at', current_timestamp::timestamp,
					'timestamp', NEW.data->'timestamp',
					'host', NEW.data->'host',
					'plugin', NEW.data->'plugin',
					'type_instance', NEW.data->'type_instance',
					'collectd_type', NEW.data->'collectd_type',
					'plugin_instance', NEW.data->'plugin_instance',
					'type', NEW.data->'type',
					'version', NEW.data->'version'
					)
					,
					round(cast(NEW.data->'value' as numeric),2)
				);
	RETURN NULL;
exception when others then
	INSERT INTO public.etl_error_log VALUES (
		'ERROR: '::text,
		'Metadata: '::text
	);
	RETURN NULL;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- Create trigger
CREATE TRIGGER run_update_last_data_information AFTER INSERT ON measurement_master FOR EACH ROW EXECUTE PROCEDURE update_last_data_information();

--Disable Trigger
-- DROP TRIGGER run_update_last_data_information ON measurement_master;

--- Create Function ---

DROP function if exists public.write_to_database_etl
	(
	in_host TEXT, 
	in_timestamp TEXT,
	in_plugin TEXT,
	in_type_instance TEXT,
	in_collectd_type TEXT, 
	in_plugin_instance TEXT,
	in_type TEXT, 
	in_value TEXT,
	in_version TEXT
	);

CREATE OR REPLACE FUNCTION public.write_to_database_etl
	(
	in_host TEXT, 
	in_timestamp TEXT,
	in_plugin TEXT,
	in_type_instance TEXT,
	in_collectd_type TEXT, 
	in_plugin_instance TEXT,
	in_type TEXT, 
	in_value TEXT,
	in_version TEXT
	)
  RETURNS character AS $BODY$
DECLARE
	d_value double precision;
	d_ timestamp;
 BEGIN	
	-- Prüfe ob Timestamp richtiges Format besitzt -> 2017-02-15 19:31:23.034+01
	if in_timestamp !~* '[0-9][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9]\s[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]\.[0-9][0-9][0-9]\+[0-9][0-9]' then
		RAISE EXCEPTION 'Error @ Timestamp Format';
	end if;
	
	-- Prüfe ob collectd_type valide ist
	if in_collectd_type = 'percent' OR 
	in_collectd_type = 'percent_inodes' OR
	in_collectd_type = 'df_inodes' OR
	in_collectd_type = 'count' OR
	in_collectd_type = 'df_complex' OR 
	in_collectd_type = 'conntrack' OR
	in_collectd_type = 'percent_bytes' OR
	in_collectd_type = 'entropy'
	then
		-- Runde Value auf zwei Zahlen nach dem .
		d_value := round(cast(in_value as numeric),2);
		if d_value < 1 then -- wenn kleiner 1 nicht einfügen (Daten Basis klein halten)
			return 'Done Code 001 ' || d_value;
		else
			return 'Insert Data here';
		end if;
	else
		RAISE EXCEPTION 'Error @ collectd_type Name -> not found'; 
	end if;
	
	return 'done';
	
--exception when others then -- On Error
	--return 'Error :-('; -- Do something
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  

ALTER FUNCTION public.write_to_database_etl
	(
	in_host TEXT, 
	in_timestamp TEXT,
	in_plugin TEXT,
	in_type_instance TEXT,
	in_collectd_type TEXT, 
	in_plugin_instance TEXT,
	in_type TEXT, 
	in_value TEXT,
	in_version TEXT
	)
  OWNER TO metrics;

--- Test Function ---

select public.write_to_database_etl('ci-slave2','2017-02-15 19:31:23.034+01','df','used','df_complex','var-lib-docker-devicemapper','collectd','4079718400','');