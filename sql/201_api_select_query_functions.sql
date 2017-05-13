DROP FUNCTION api_select_query_with_value(int, TEXT, TEXT, int, int);

CREATE OR REPLACE FUNCTION api_select_query_with_value(IN in_orgID int, IN in_plugin TEXT, IN in_type_instance TEXT, IN in_start_time int, IN in_end_time int) 
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
  hostname TEXT[];
  hostname_anz int;
  hostname_format TEXT;
  this_record RECORD;
BEGIN
  EXECUTE 'SELECT Count(*)::int, host_values from public.grafana_dashboard_mapping WHERE org_id = ' || in_orgID || ' GROUP BY host_values;' INTO hostname_anz, hostname;
  hostname_format = hostname;
  hostname_format := replace(hostname_format, ',', '","');
  hostname_format := replace(hostname_format, '{', '"');
  hostname_format := replace(hostname_format, '}', '"');
  hostname_format := replace(hostname_format, '"', '''');
  RAISE NOTICE '% %', hostname_anz, hostname_format;
  IF NOT hostname_anz = 0 THEN
    EXECUTE 'SELECT string_agg(etldata->>''etlid'', ''", "'') FROM public.etl_master WHERE datacontent->>''host'' in (' || hostname_format || ') AND datacontent->>''plugin'' = ''' || in_plugin || ''' AND datacontent->>''type_instance'' = ''' || in_type_instance || ''' ;' into etlid;
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
    
    EXECUTE 'INSERT INTO ' || temp_table || ' SELECT metadata->>''etlid'', extract(epoch from to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp)::int, CAST(data->>''value'' AS FLOAT)::float, data->>''plugin_instance''::text, data->>''collectd_type''::text FROM public.measurement_master WHERE metadata->>''etlid'' in (' || etlid || ') AND date_trunc_hour_json(data->>''timestamp''::text) <= date_trunc_hour_json(''' || format_end_time || '''::text) AND date_trunc_hour_json(data->>''timestamp''::text) >= date_trunc_hour_json(''' || format_start_time || '''::text) ORDER BY data->>''timestamp'';';
    
    EXECUTE 'DELETE FROM ' || temp_table || ' WHERE out_timestamp > extract(epoch from to_timestamp(''' || format_end_time || '''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp)::int;';
    
    EXECUTE 'DELETE FROM ' || temp_table || ' WHERE out_timestamp < extract(epoch from to_timestamp(''' || format_start_time || '''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp)::int AND NOT etlid || ''_'' || out_timestamp in (SELECT etlid || ''_'' || max(out_timestamp) FROM ' || temp_table || ' WHERE out_timestamp < extract(epoch from to_timestamp(''' || format_start_time || '''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp)::int GROUP BY etlid);';
    
    RETURN QUERY
    EXECUTE 'SELECT out_timestamp, out_value, out_plugin_instance, out_collectd_type FROM ' || temp_table || ' ORDER BY etlid, out_timestamp;';
  ELSE
    RETURN NEXT;
  END IF;
exception when others then
  RAISE NOTICE 'Error api_select_query_with_value';
  raise notice '% %', SQLERRM, SQLSTATE;
  RETURN NEXT;
END;
$$
EXTERNAL SECURITY DEFINER;

ALTER FUNCTION api_select_query_with_value(int, TEXT, TEXT, int, int)
  OWNER TO metrics;

select api_select_query_with_value(1, 'cpu', 'idle', 1489745100, 1489746000); --03/17/2017 @ 10:20am (UTC)

 -- Create user api
CREATE ROLE api LOGIN
  ENCRYPTED PASSWORD ''
  NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;


-- Grand permission
GRANT EXECUTE ON FUNCTION api_select_query_with_value(TEXT, TEXT, TEXT, int, int) TO api;