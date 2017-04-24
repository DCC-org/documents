--- Create Function ---
"host";"character varying";
"timestamp";"timestamp with time zone";
"plugin";"character varying";
"type_instance";"character varying";
"collectd_type";"character varying";
"plugin_instance";"character varying";
"type";"character varying";
"value";"double precision";
"version";"character varying";

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
	id_count integer := 0;
 BEGIN
	return 'Ok ' || in_host || ' stop';
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