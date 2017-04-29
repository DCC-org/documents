CREATE TABLE log_backup as 
	select * from log limit 1;
	
truncate table log_backup;


-- Function
DROP function if exists run_etl_backup_process();

CREATE OR REPLACE FUNCTION public.run_etl_backup_process()
RETURNS trigger AS $BODY$
DECLARE
	etlnumber TEXT;
	etlrownumber bigint;
BEGIN
	
	select etldata->>'etlid', id into etlnumber, etlrownumber
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
		nextval('public.etl_master_etl_row_id'),
		json_build_object(
			'etlid', etlnumber::text,
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
	RAISE NOTICE 'Error run_etl_backup_process';
	raise notice '% %', SQLERRM, SQLSTATE;
	RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.run_etl_backup_process()
  OWNER TO metrics;
  
 -- Active
CREATE TRIGGER etl_backup_process AFTER INSERT ON log_backup FOR EACH ROW EXECUTE PROCEDURE run_etl_backup_process();

-- DROP TRIGGER run_etl_process ON log_backup;

insert into log_backup
select * from log LIMIT 100;