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
    BEGIN
	  partition_date := NEW.data->'timestamp';
	  partition_date := replace(partition_date,'+', '-');
	  partition_date := to_char(partition_date::timestamptz at time zone 'UTC', 'YYYY-MM-DD HH24:MI:SS')::timestamp;
	  NEW.data := replace(NEW.data::text, NEW.data->>'timestamp', partition_date)::json;
	  new_timestamp	:= partition_date;
      partition_date := substring(partition_date from 1 for 13);
	  partition_date := replace(partition_date,'-', '_');
	  partition_date := replace(partition_date,' ', 't');
	  new_timestamp := substring(new_timestamp from 1 for 13);
      partition := 'measurement_' || partition_date;
	  
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
	RAISE NOTICE 'Error';
	raise notice '% %', SQLERRM, SQLSTATE;
	RETURN NULL;
    END;
  $BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- Create trigger
CREATE TRIGGER testing_partition_insert_trigger BEFORE INSERT ON measurement_master FOR EACH ROW EXECUTE PROCEDURE create_partition_and_insert();

--Disable Trigger
-- DROP TRIGGER testing_partition_insert_trigger ON measurement_master;

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