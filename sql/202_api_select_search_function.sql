DROP FUNCTION api_select_search();

CREATE OR REPLACE FUNCTION api_select_search() 
RETURNS table (existing_combinations TEXT)
LANGUAGE plpgsql
AS
$$
DECLARE
  this_record RECORD;
BEGIN
  FOR this_record IN
  EXECUTE 'select distinct datacontent->>''plugin'' as plugin, datacontent->>''type_instance'' as type_instance FROM etl_master group by datacontent->>''plugin'', datacontent->>''type_instance'';' LOOP
    existing_combinations := this_record.plugin || '_' || this_record.type_instance;
	RETURN NEXT;
  END LOOP;
exception when others then
  RAISE NOTICE 'Error api_select_search';
  raise notice '% %', SQLERRM, SQLSTATE;
  RETURN NEXT;
END;
$$
EXTERNAL SECURITY DEFINER;

-- Set Owner
ALTER FUNCTION api_select_query_with_value(TEXT, TEXT, TEXT, int, int)
  OWNER TO metrics;

-- Sample call
select api_select_search();

-- Grand permission
GRANT EXECUTE ON FUNCTION api_select_search() TO api;