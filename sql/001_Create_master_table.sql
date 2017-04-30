--- Create Error Log Table ---
drop table if exists public.etl_error_log;
create table public.etl_error_log
(
  error_info TEXT not null,
  data TEXT not null
);

--- Create ETL Table - Last Objects ---
drop table if exists public.etl_master;
create table public.etl_master
(
  id bigint not null,
  etldata json not null,
  datacontent json not null
);

-- SEQUENCE etl_master_etl_id @ public.etl_master

CREATE SEQUENCE etl_master_etl_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
-- ALTER SEQUENCE public.etl_master_etl_id RESTART WITH 1;

--
-- Name: date_trunc_hour(timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION date_trunc_hour(dt timestamp with time zone) RETURNS timestamp with time zone
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
    BEGIN
        RETURN date_trunc('hour', dt);
    END;
$$;


ALTER FUNCTION public.date_trunc_hour(dt timestamp with time zone) OWNER TO metrics;


--
-- Name: date_trunc_hour_json(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION date_trunc_hour_json(dt text) RETURNS timestamp with time zone
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
    BEGIN
        RETURN date_trunc('hour', CAST(dt AS timestamptz));
    END;
$$;


ALTER FUNCTION public.date_trunc_hour_json(dt text) OWNER TO metrics;

-- Table: Master
drop table if exists measurement_master;
create table measurement_master
(
	id bigint not null,
	metadata jsonb not null,
	data jsonb not null
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

--
-- Name: measurement_master_timestamp_trunc_hour_idx; Type: INDEX; Schema: public; Owner: metrics
--

CREATE INDEX measurement_master_timestamp_trunc_hour_idx ON measurement_master USING btree (date_trunc_hour_json((data ->> 'timestamp'::text)));

-- Reset SEQUENCE @ truncate on measurement_master

CREATE OR REPLACE FUNCTION reset_sequence_on_truncate() RETURNS trigger AS
  $BODY$
  BEGIN
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

--
-- Name: log; Type: TABLE; Schema: public; Owner: metrics
--
CREATE TABLE log (
    host character varying,
    "timestamp" timestamp with time zone,
    plugin character varying,
    type_instance character varying,
    collectd_type character varying,
    plugin_instance character varying,
    type character varying,
    value double precision,
    version character varying
);


ALTER TABLE log OWNER TO metrics;

--
-- Name: log_timestamp_trunc_hour_index; Type: INDEX; Schema: public; Owner: metrics
--

CREATE INDEX log_timestamp_trunc_hour_index ON log USING btree (date_trunc_hour("timestamp"));
