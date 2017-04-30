-- Schema: partitions
 
-- DROP SCHEMA partitions;
 
CREATE SCHEMA partitions
  AUTHORIZATION metrics;

-- Function: create_partition_and_insert

-- DROP FUNCTION create_partition_and_insert();

CREATE OR REPLACE FUNCTION create_partition_and_insert() RETURNS trigger AS
  $BODY$
    DECLARE
      prefix text := 'partitions';
      partition_date TEXT;
    new_timestamp TEXT;
      partition TEXT;
    new_value TEXT;
    get_last_data return_type;
    BEGIN
    new_value := round(cast(NEW.data->>'value'::text as numeric),2)::text;
    IF new_value::numeric < 1 THEN --postgres crash if first char is 0 (0.53)
      new_value = '0';
    END IF;
    partition_date := NEW.data->'timestamp';
    partition_date := replace(partition_date,'+', '-');
    partition_date := to_char(partition_date::timestamptz at time zone 'UTC', 'YYYY-MM-DD HH24:MI:SS')::timestamp;
    NEW.data := jsonb_set(to_jsonb(NEW.data), '{timestamp}', to_jsonb(partition_date), false)::jsonb;
    NEW.data := jsonb_set(to_jsonb(NEW.data), '{value}', to_jsonb(new_value), false)::jsonb;
    new_timestamp := partition_date;
    partition_date := substring(partition_date from 1 for 13);
    partition_date := replace(partition_date,'-', '_');
    partition_date := replace(partition_date,' ', 't');
    partition := 'measurement_' || partition_date;
    
    RAISE NOTICE 'Working @ % % %', new_timestamp::timestamp, NEW.metadata->>'etlid', new_value::text;
    get_last_data := public.check_if_last_value_is_same(new_timestamp::timestamp, NEW.metadata->>'etlid', new_value::text);

    IF get_last_data.is_same IS TRUE THEN
      RETURN NULL;
    END IF;
    new_timestamp := substring(new_timestamp from 1 for 13);
    
    IF NOT EXISTS(
      SELECT b.nspname, a.relname
      FROM pg_class a, pg_catalog.pg_namespace b
      WHERE relname=partition
        and a.relnamespace = b.oid
        and b.nspname=prefix
    ) THEN
    
        EXECUTE 'CREATE TABLE ' || prefix || '.' || partition || ' (check (substring(data->>''timestamp''::text from 1 for 13) = ''' || new_timestamp || '''::text)) INHERITS (public.' || TG_RELNAME || ');';
    RAISE NOTICE 'A partition has been created % on %', prefix || '.' || partition, TG_RELNAME;

      END IF;
    
      EXECUTE 'INSERT INTO ' || prefix || '.' || partition || ' SELECT(public.' || TG_RELNAME || ' ' || quote_literal(NEW) || ').* RETURNING id;';
      RETURN NULL;
exception when others then
  RAISE NOTICE 'Error create_partition_and_insert';
  raise notice '% %', SQLERRM, SQLSTATE;
  RAISE NOTICE '@ Data: %', NEW.data;
  RETURN NULL;
    END;
  $BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- Create trigger
CREATE TRIGGER run_partition_insert_trigger BEFORE INSERT ON measurement_master FOR EACH ROW EXECUTE PROCEDURE create_partition_and_insert();

--Disable Trigger
-- DROP TRIGGER run_partition_insert_trigger ON measurement_master;

-- View: Showing all partitions for master table
CREATE VIEW show_master_partitions AS
SELECT nmsp_parent.nspname AS parent_schema,
       parent.relname AS parent,
       nmsp_child.nspname AS child_schema,
       child.relname AS child
FROM pg_inherits
JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
JOIN pg_class child ON pg_inherits.inhrelid = child.oid
JOIN pg_namespace nmsp_parent ON nmsp_parent.oid = parent.relnamespace
JOIN pg_namespace nmsp_child ON nmsp_child.oid = child.relnamespace
WHERE parent.relname='measurement_master' ;

select * from show_master_partitions;

-- DROP VIEW show_master_partitions;

-- Test
-- Import 001_JSON_Converter_Function_on_Table
select convert_input_data_to_json_cpu_table(10);


-- ETL Partition
CREATE OR REPLACE FUNCTION create_etl_partition_and_insert() RETURNS trigger AS
  $BODY$
    DECLARE
      prefix text := 'partitions';
    plugin TEXT;
    type_instance TEXT;
      partition TEXT;
    BEGIN
    -- Wenn Daten unvollständig abbrechen
    IF NEW.datacontent->>'collectd_type' IS null
      OR NEW.datacontent->>'plugin_instance' IS NULL
      OR NEW.datacontent->>'type' IS NULL then
      RETURN NULL;
    END IF;
    
    plugin := NEW.datacontent->>'plugin';
    type_instance := NEW.datacontent->>'type_instance';
    
    IF type_instance is null then
      type_instance := 'null';
    end if;
    
    partition := 'etl_' || plugin || '_' || type_instance;
    
    IF NOT EXISTS(
      SELECT b.nspname, a.relname
      FROM pg_class a, pg_catalog.pg_namespace b
      WHERE relname=partition
        and a.relnamespace = b.oid
        and b.nspname=prefix
    ) THEN
    
        EXECUTE 'CREATE TABLE ' || prefix || '.' || partition || ' (check (datacontent->>''plugin''::text = ''' || plugin ||
        '''::text AND datacontent->>''type_instance''::text = ''' || type_instance || '''::text)) INHERITS (public.' || TG_RELNAME || ');';
    RAISE NOTICE 'A partition has been created % on %', prefix || '.' || partition, TG_RELNAME;
      END IF;
    
      EXECUTE 'INSERT INTO ' || prefix || '.' || partition || ' SELECT(public.' || TG_RELNAME || ' ' || quote_literal(NEW) || ').* RETURNING id;';
    RETURN NULL;
exception when others then
  RAISE NOTICE 'Error ETL Partitionserstellung';
  raise notice '% %', SQLERRM, SQLSTATE;
  RETURN NULL;
    END;
  $BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- Create trigger
CREATE TRIGGER run_etl_partition_and_insert BEFORE INSERT ON public.etl_master FOR EACH ROW EXECUTE PROCEDURE create_etl_partition_and_insert();

--Disable Trigger
-- DROP TRIGGER testing_partition_insert_trigger ON measurement_master;

-- View: Showing all partitions for master table
CREATE VIEW show_etl_partitions AS
SELECT nmsp_parent.nspname AS parent_schema,
       parent.relname AS parent,
       nmsp_child.nspname AS child_schema,
       child.relname AS child
FROM pg_inherits
JOIN pg_class parent ON pg_inherits.inhparent = parent.oid
JOIN pg_class child ON pg_inherits.inhrelid = child.oid
JOIN pg_namespace nmsp_parent ON nmsp_parent.oid = parent.relnamespace
JOIN pg_namespace nmsp_child ON nmsp_child.oid = child.relnamespace
WHERE parent.relname='etl_master' ;

select * from show_etl_partitions;

-- DROP VIEW show_master_partitions;
