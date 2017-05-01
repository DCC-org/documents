DROP FUNCTION select_host_cpu_option_value(TEXT, TEXT, TEXT, int, int);

CREATE OR REPLACE FUNCTION select_host_cpu_option_value(IN in_hostname TEXT, IN in_plugin TEXT, IN in_type_instance TEXT, IN in_start_time int, IN in_end_time int) 
RETURNS table (out_timestamp int, out_value float, out_plugin_instance TEXT, out_collectd_type TEXT)
LANGUAGE plpgsql
AS
$$
DECLARE
  format_start_time timestamp;
  format_end_time timestamp;
  partition_start TEXT;
  partition_end TEXT;
  prefix TEXT := 'partitions';
  temp_table TEXT := 'tmp_' || md5(''||now()::text||random()::text)::text;
  
  etlid TEXT;
  this_record RECORD;
BEGIN
  EXECUTE 'SELECT string_agg(etldata->>''etlid'', ''", "'') FROM public.etl_master WHERE datacontent->>''host'' = ''' || in_hostname || ''' AND datacontent->>''plugin'' = ''' || in_plugin || ''' AND datacontent->>''type_instance'' = ''' || in_type_instance || ''' ;' into etlid;
  etlid := '"' || etlid || '"';
  etlid := replace(etlid, '"', '''');
  RAISE NOTICE '%', etlid;
  
  format_start_time := to_timestamp(in_start_time)::timestamp;
  format_end_time := to_timestamp(in_end_time)::timestamp;
  
  partition_start := substring(format_start_time::text from 1 for 13);
  partition_start := replace(partition_start,'-', '_');
  partition_start := replace(partition_start,' ', 't');
  partition_start := 'measurement_' || partition_start;
  
  partition_end := substring(format_start_time::text from 1 for 13);
  partition_end := replace(partition_end,'-', '_');
  partition_end := replace(partition_end,' ', 't');
  partition_end := 'measurement_' || partition_end;
  
   
  EXECUTE 'create temporary table ' || temp_table || ' (etlid TEXT, out_timestamp int, out_value float, out_plugin_instance TEXT, out_collectd_type TEXT) on commit drop;';

  EXECUTE 'INSERT INTO ' || temp_table || ' SELECT metadata->>''etlid'', extract(epoch from to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp)::int, CAST(data->>''value'' AS FLOAT)::float, data->>''plugin_instance''::text, data->>''collectd_type''::text FROM ' || prefix || '.' || partition_start || ' WHERE metadata->>''etlid'' in (' || etlid || ') AND to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp <= ''' || format_end_time || '''::timestamp AND to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp >= ''' || format_start_time || '''::timestamp ORDER BY data->>''timestamp'';'; 
  
  IF partition_start != partition_end THEN
    EXECUTE 'INSERT INTO ' || temp_table || ' SELECT metadata->>''etlid'', extract(epoch from to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp)::int, CAST(data->>''value'' AS FLOAT)::float, data->>''plugin_instance''::text, data->>''collectd_type''::text FROM ' || prefix || '.' || partition_end || ' WHERE metadata->>''etlid'' in (' || etlid || ') AND to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp <= ''' || format_end_time || '''::timestamp AND to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp >= ''' || format_start_time || '''::timestamp ORDER BY data->>''timestamp'';'; 
  END IF;
  
  FOR this_record IN
  EXECUTE 'SELECT COUNT(*)::int as anz_data, etlid as etl_id from ' || temp_table || ' group by etlid;' LOOP
	RAISE NOTICE '% FOR %', this_record.anz_data, this_record.etl_id;
	
    IF this_record.anz_data = 0 THEN
	  EXECUTE 'INSERT INTO ' || temp_table || ' SELECT metadata->>''etlid'', extract(epoch from to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp)::int, CAST(data->>''value'' AS FLOAT)::float, data->>''plugin_instance''::text, data->>''collectd_type''::text FROM ' || prefix || '.' || partition_start || ' WHERE metadata->>''etlid'' in (' || etlid || ') AND to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp <= ''' || format_start_time || '''::timestamp AND etlid = ''' || this_record.etl_id || ''' ORDER BY data->>''timestamp'' LIMIT 1;';
	  
	  RETURN QUERY
	  EXECUTE 'SELECT ''' || in_start_time || '''::int, out_value, out_plugin_instance, out_collectd_type FROM ' || temp_table || ';';
    ELSE
      RETURN QUERY
      EXECUTE 'SELECT out_timestamp, out_value, out_plugin_instance, out_collectd_type FROM ' || temp_table || ' WHERE etlid = ''' || this_record.etl_id || ''';';
    END IF;
  END LOOP;
exception when others then
  RAISE NOTICE 'Error select_host_cpu_option_value';
  raise notice '% %', SQLERRM, SQLSTATE;
  RETURN NEXT;
END;
$$;

to_timestamp(data->>'timestamp'::text, 'YYYY-MM-DD HH24:MI:SS')::timestamp
select select_host_cpu_option_value('ci-slave2', 'cpu', 'idle', 1487192700, 1487193000);
out_timestamp := in_start_time;
out_value := 100.20;
BEGIN;
CREATE FUNCTION check_password(uname TEXT, pass TEXT) ... SECURITY DEFINER;
REVOKE ALL ON FUNCTION check_password(uname TEXT, pass TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION check_password(uname TEXT, pass TEXT) TO admins;
COMMIT;

to_timestamp(1493641891)::timestamp
insert into log_backup SELECT * FROM log WHERE log_date_trunc_hour(timestamp) = '2017-02-15 19:00:00'::timestamp ORDER BY log.timestamp;