CREATE TYPE return_type AS (is_same boolean, foundtimestamp timestamp, foundvalue text, foundrowid bigint);

DROP FUNCTION public.check_if_last_value_is_same(timestamp,TEXT,TEXT);

CREATE OR REPLACE FUNCTION public.check_if_last_value_is_same
  (
  zeit_new timestamp,
  etlmetaid TEXT,
  value_new TEXT
  )
RETURNS return_type AS $BODY$
DECLARE
  prefix text := 'partitions';
  partition text;
  from_value text;
  foundtimestamp timestamp;
  foundrowid bigint;
  foundvalue TEXT;
  
  result_record return_type;
BEGIN
  partition := substring(zeit_new::text from 1 for 13);
  partition := replace(partition,'-', '_');
  partition := replace(partition,' ', 't');
  partition := 'measurement_' || partition;
  
  IF NOT EXISTS(
      SELECT b.nspname, a.relname
      FROM pg_class a, pg_catalog.pg_namespace b
      WHERE relname=partition
        and a.relnamespace = b.oid
        and b.nspname=prefix
    ) THEN
    result_record.is_same = false;
    return result_record;
  ELSE
    from_value := prefix || '.' || partition;
  END IF;
  
  EXECUTE 'SELECT to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp, id, data->>''value''::text ' ||
  'FROM ' || from_value || ' WHERE metadata->>''etlid''::text = ''' || etlmetaid || ''' AND ' ||
  'to_timestamp(data->>''timestamp''::text, ''YYYY-MM-DD HH24:MI:SS'')::timestamp <= ''' || zeit_new || '''::timestamp ' ||
  'ORDER BY data->>''timestamp'' DESC LIMIT 1;' INTO result_record.foundtimestamp, result_record.foundrowid, result_record.foundvalue;
  
  IF result_record.foundvalue IS NULL THEN
    result_record.is_same = false;
  ELSE
    IF value_new = result_record.foundvalue THEN
      result_record.is_same := true;
    ELSE
      result_record.is_same := false;
    END IF;
  END IF;
  
  return result_record;
exception when others then
  RAISE NOTICE 'Error check_if_last_value_is_same';
  raise notice '% %', SQLERRM, SQLSTATE;
  RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
select public.check_if_last_value_is_same('2017-02-15 20:52:43'::timestamp, '13'::text, '0');
