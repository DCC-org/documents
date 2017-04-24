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
	t_timestamp timestamp;
 BEGIN
	d_value := cast(in_value as double precision);
	
	if in_timestamp !~* '[0-9][0-9][0-9][0-9]\-[0-9][0-9]\-[0-9][0-9]\s[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]\.[0-9][0-9][0-9]\+[0-9][0-9]' then
		RAISE EXCEPTION 'Error @ Timestamp Format';
	end if;
	
	return 'done';
	
exception when others then -- On Error
	return 'Error :-('; -- Do something
	
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