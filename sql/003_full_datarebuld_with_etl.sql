-- Function
DROP function if exists run_etl_backup_process();

CREATE OR REPLACE FUNCTION public.run_etl_backup_process()
RETURNS trigger AS $BODY$
DECLARE
  prefix TEXT := 'partitions';
  plugin TEXT;
  type_instance TEXT;
  etlnumber bigint;
  partition TEXT;
BEGIN
  -- Wenn Daten unvollständig abbrechen
  IF NEW.collectd_type IS null
    OR NEW.plugin_instance IS NULL
    OR NEW.type::text IS NULL then
    RETURN NULL;
  END IF;
  
  plugin := NEW.plugin::text;
  type_instance := NEW.type_instance::text;
  
  IF type_instance is null then
    type_instance := 'null';
  end if;
  
  partition := 'etl_' || plugin || '_' || type_instance;
  
  IF EXISTS(
      SELECT b.nspname, a.relname
      FROM pg_class a, pg_catalog.pg_namespace b
      WHERE relname=partition
        and a.relnamespace = b.oid
        and b.nspname=prefix
    ) THEN  
    EXECUTE 'select id from ' || prefix || '.' || partition ||
    ' where datacontent->>''host'' = ''' || NEW.host::text || '''::text '
    ' AND datacontent->>''collectd_type'' = ''' || NEW.collectd_type::text || '''::text '
    ' AND datacontent->>''plugin_instance'' = ''' || NEW.plugin_instance::text || '''::text '
    ' AND datacontent->>''type'' = ''' || NEW.type::text || '''::text ;' into etlnumber;
  ELSE
    partition := 'etl_master';
    prefix := 'public';
    EXECUTE 'select id from ' || prefix || '.' || partition ||
    ' where datacontent->>''host'' = ''' || NEW.host::text || '''::text '
    ' AND datacontent->>''collectd_type'' = ''' || NEW.collectd_type::text || '''::text '
    ' AND datacontent->>''plugin_instance'' = ''' || NEW.plugin_instance::text || '''::text '
    ' AND datacontent->>''type_instance'' = ''' || type_instance::text || '''::text '
    ' AND datacontent->>''plugin'' = ''' || plugin::text || '''::text '
    ' AND datacontent->>''type'' = ''' || NEW.type::text || '''::text ;' into etlnumber;
  END IF;
    
  if etlnumber is null then
    
    etlnumber := nextval('public.etl_master_etl_id');
    
    INSERT INTO public.etl_master VALUES (
    etlnumber,
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
CREATE TRIGGER run_etl_backup_process AFTER INSERT ON log_backup FOR EACH ROW EXECUTE PROCEDURE run_etl_backup_process();
CREATE TRIGGER run_etl_process AFTER INSERT ON log FOR EACH ROW EXECUTE PROCEDURE run_etl_backup_process();

-- DROP TRIGGER run_etl_backup_process ON log_backup;

-- Test
insert into log_backup
select * from log
where substring(log.timestamp::text from 1 for 13) = '2017-02-15 19'
order by log.timestamp;

INSERT INTO log (host, timestamp, type_instance, plugin_instance, plugin, collectd_type, type, value)
VALUES('ci-slave2', CAST ('2017-04-01T19:27:13.035+02:00' AS timestamptz), 'test', 'reserved', 'df_inodes', 'nikolai', 'collectd', CAST('0' AS FLOAT));
