-- Table: Master
drop table if exists measurement_master;
create table measurement_master
(
	id bigint not null,
	metadata json not null,
	data json not null
) WITH ( OIDS=FALSE);

ALTER TABLE measurement_master OWNER TO metrics;

-- SEQUENCE measurement_master_metadata_id @ measurement_master

CREATE SEQUENCE measurement_master_metadata_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
-- ALTER SEQUENCE public.measurement_master_metadata_id RESTART WITH 1;
	
ALTER TABLE measurement_master_metadata_id OWNER TO metrics;

ALTER SEQUENCE measurement_master_metadata_id OWNED BY measurement_master.id;

-- Test SEQUENCE

SELECT nextval('public.measurement_master_metadata_id');

-- Reset SEQUENCE @ truncate on measurement_master

CREATE OR REPLACE FUNCTION reset_sequence_on_truncate() RETURNS trigger AS
  $BODY$
    BEGIN
	  ALTER SEQUENCE public.measurement_master_metadata_id RESTART WITH 1;
      RETURN NULL;
    END;
  $BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- Create trigger
CREATE TRIGGER trigger_reset_sequence_on_truncate AFTER TRUNCATE ON measurement_master EXECUTE PROCEDURE reset_sequence_on_truncate();

--Disable Trigger
-- DROP TRIGGER trigger_reset_sequence_on_truncate ON measurement_master;

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

-- Test
select convert_input_data_to_json_cpu_table(1);