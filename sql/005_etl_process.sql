--- Create Function ---
/*
collectd_type
│ percent        │
│ percent_inodes │
│ df_inodes      │
│ count          │
│ df_complex     │
│ conntrack      │
│ nikolai        │
│ percent_bytes  │
│ entropy 
*/

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