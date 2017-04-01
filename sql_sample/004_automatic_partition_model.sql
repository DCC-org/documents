-- Master
drop table if exists measurement_master;
create table measurement_master
(
	id bigint not null,
	metadata json not null,
	data json not null
) WITH ( OIDS=FALSE);


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
	  new_timestamp	:= partition_date;
      partition_date := substring(partition_date from 2 for 10);
	  partition_date := replace(partition_date,'-', '_');
	  new_timestamp := replace(new_timestamp,'"', '');
	  new_timestamp := substring(new_timestamp from 1 for 10);
      partition := TG_RELNAME || '_' || partition_date;
	  
      IF NOT EXISTS(
			SELECT b.nspname, a.relname
			FROM pg_class a, pg_catalog.pg_namespace b
			WHERE relname=partition
				and a.relnamespace = b.oid
				and b.nspname=prefix
		) THEN
		
        RAISE NOTICE 'A partition has been created %', prefix || '.' || partition;
        EXECUTE 'CREATE TABLE ' || prefix || '.' || partition || ' (check (substring(data->>''timestamp''::text from 1 for 10) = ''' || new_timestamp || '''::text)) INHERITS (public.' || TG_RELNAME || ');';
		
      END IF;
      EXECUTE 'INSERT INTO ' || prefix || '.' || partition || ' SELECT(public.' || TG_RELNAME || ' ' || quote_literal(NEW) || ').* RETURNING id;';
      RETURN NULL;
    END;
  $BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- Create trigger
CREATE TRIGGER testing_partition_insert_trigger BEFORE INSERT ON measurement_master FOR EACH ROW EXECUTE PROCEDURE create_partition_and_insert();

--Disable Trigger
DROP TRIGGER testing_partition_insert_trigger ON measurement_master;

-- Test
select convert_input_data_to_json_cpu_table(1);