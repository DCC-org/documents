-- Testing ETL for partition

DROP function if exists run_etl_process_partition();

CREATE OR REPLACE FUNCTION public.run_etl_process_partition()
RETURNS trigger AS $BODY$
DECLARE
	etlnumber TEXT;
	etlrownumber TEXT;
BEGIN
	
	select etldata->>'etlid', etldata->>'etlrowid' into etlnumber, etlrownumber
		from public.etl_master
		where datacontent->>'host' = NEW.host::text
		AND datacontent->>'plugin' = NEW.plugin::text
		AND datacontent->>'type_instance' = NEW.type_instance::text
		AND datacontent->>'collectd_type' = NEW.collectd_type::text
		AND datacontent->>'plugin_instance' = NEW.plugin_instance::text
		AND datacontent->>'type' = NEW.type::text;
		
	if etlnumber is null then
		
		etlnumber := nextval('public.etl_master_etl_id')::text;
		
		INSERT INTO public.etl_master VALUES (
		json_build_object(
			'etlid', etlnumber::text,
			'etlrowid', nextval('public.etl_master_etl_id')::text,
			'update_at', current_timestamp::timestamp),
		json_build_object(
			'host',NEW.host::text,
			'plugin',NEW.plugin::text,
			'type_instance',NEW.type_instance::text,
			'collectd_type',NEW.collectd_type::text,
			'plugin_instance',NEW.plugin_instance::text,
			'type',NEW.type::text)
		);
		
	else
		EXECUTE 'DELETE FROM public.etl_master where etldata->>''etlrowid'' = ''' || etlrownumber::text || ''':text ;';
	
		INSERT INTO public.etl_master VALUES (
		json_build_object(
			'etlid', etlnumber::text,
			'etlrowid', nextval('public.etl_master_etl_id')::text,
			'update_at', current_timestamp::timestamp),
		json_build_object(
			'host',NEW.host::text,
			'plugin',NEW.plugin::text,
			'type_instance',NEW.type_instance::text,
			'collectd_type',NEW.collectd_type::text,
			'plugin_instance',NEW.plugin_instance::text,
			'type',NEW.type::text)
		);
		
	end if;
	
	INSERT INTO measurement_master VALUES (nextval('public.measurement_master_metadata_id'),
										json_build_object(
											'etlid', etlnumber::text,
											'insert_at', current_timestamp::timestamp,
											'aggregation_type', 'seconds'),
										json_build_object(
											'host',NEW.host,
											'timestamp',NEW."timestamp",
											'plugin',NEW.plugin,
											'type_instance',NEW.type_instance,
											'collectd_type',NEW.collectd_type,
											'plugin_instance',NEW.plugin_instance,
											'type',NEW.type,
											'value',NEW.value,
											'version',NEW.version)
										);
										
	RETURN NULL;
exception when others then
	RAISE NOTICE 'Error';
	raise notice '% %', SQLERRM, SQLSTATE;
	RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.run_etl_process_partition()
  OWNER TO metrics;

-- Active
CREATE TRIGGER run_etl_process AFTER INSERT ON log FOR EACH ROW EXECUTE PROCEDURE run_etl_process_partition();

-- DROP TRIGGER run_etl_process ON log;
 
-- Test
INSERT INTO log (host, timestamp, type_instance, plugin_instance, plugin, collectd_type, type, value)
VALUES('ci-slave2', CAST ('2017-04-01T19:27:13.035+02:00' AS timestamptz), 'test', 'reserved', 'df_inodes', 'nikolai', 'collectd', CAST('0' AS FLOAT));