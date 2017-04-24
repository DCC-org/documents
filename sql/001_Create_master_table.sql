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
-- SELECT nextval('public.measurement_master_metadata_id');

-- Reset SEQUENCE @ truncate on measurement_master

CREATE OR REPLACE FUNCTION reset_sequence_on_truncate() RETURNS trigger AS
  $BODY$
  BEGIN
	-- https://github.com/DCC-org/documents/pull/190/commits/e1e6c552e6bd760981653ff820e4d81169c0acef
	ALTER SEQUENCE public.measurement_master_metadata_id RESTART WITH 1;
	RAISE NOTICE 'Reset SEQUENCE.';
    RETURN NULL;
    END;
  $BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

-- Create trigger
CREATE TRIGGER trigger_reset_sequence_on_truncate AFTER TRUNCATE ON measurement_master EXECUTE PROCEDURE reset_sequence_on_truncate();

--Disable Trigger
-- DROP TRIGGER trigger_reset_sequence_on_truncate ON measurement_master;