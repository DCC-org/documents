-- Testing ETL for partition

DROP function if exists test_etl_process_partition();

CREATE OR REPLACE FUNCTION public.test_etl_process_partition()
  RETURNS trigger AS $BODY$
 BEGIN
	INSERT INTO measurement_master VALUES (nextval('public.measurement_master_metadata_id'),
			json_build_object(
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
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.test_etl_process_partition()
  OWNER TO metrics;

-- Active
CREATE TRIGGER etl_process_sample AFTER INSERT ON log FOR EACH ROW EXECUTE PROCEDURE test_etl_process_partition();

-- DROP TRIGGER etl_process_sample ON log;
 
-- Test
INSERT INTO log (host, timestamp, type_instance, plugin_instance, plugin, collectd_type, type, value)
VALUES('ci-slave2', CAST ('2017-04-01 02:39:13.034+02' AS timestamp), 'test', 'reserved', 'df_inodes', 'nikolai', 'collectd', CAST('0' AS FLOAT));