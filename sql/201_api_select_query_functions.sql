DROP FUNCTION api_select_query_with_value(TEXT, TEXT, TEXT, int, int);

CREATE OR REPLACE FUNCTION api_select_query_with_value(IN in_hostname TEXT, IN in_plugin TEXT, IN in_type_instance TEXT, IN in_start_time int, IN in_end_time int) 
RETURNS table (out_timestamp int, out_value float, out_plugin_instance TEXT, out_collectd_type TEXT)
LANGUAGE plpgsql
AS
$$
DECLARE
  format_start_time timestamp;
  format_end_time timestamp;
  partition_start TEXT;
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
   
  EXECUTE 'create temporary table ' || temp_table || ' (etlid TEXT, out_timestamp int, out_value float, out_plugin_instance TEXT, out_collectd_type TEXT) on commit drop;';

  EXECUTE 'INSERT INTO ' || temp_table || ' SELECT metadata->>''etlid'', extract(epoch from to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp)::int, CAST(data->>''value'' AS FLOAT)::float, data->>''plugin_instance''::text, data->>''collectd_type''::text FROM public.measurement_master WHERE metadata->>''etlid'' in (' || etlid || ') AND to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp <= ''' || format_end_time || '''::timestamp AND to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp >= ''' || format_start_time || '''::timestamp ORDER BY data->>''timestamp'';'; 
  
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
  RAISE NOTICE 'Error api_select_query_with_value';
  raise notice '% %', SQLERRM, SQLSTATE;
  RETURN NEXT;
END;
$$;

ALTER FUNCTION api_select_query_with_value(TEXT, TEXT, TEXT, int, int)
  OWNER TO metrics;

select api_select_query_with_value('ci-slave2', 'cpu', 'idle', 1487192700, 1487451900);

 -- Create user api
CREATE ROLE api LOGIN
  ENCRYPTED PASSWORD ''
  NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;


-- Grand permission
GRANT EXECUTE ON FUNCTION api_select_query_with_value(TEXT, TEXT, TEXT, int, int) TO api;