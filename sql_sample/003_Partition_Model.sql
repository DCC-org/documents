-- Drops
DROP Table if exists measurement_xMINUS12Hour ;
DROP Table if exists measurement_xMINUS1Day ;
DROP Table if exists measurement_xMINUS3Day ;
DROP Table if exists measurement_xMINUS1Week ;
DROP Table if exists measurement_xMINUS2Week ;
DROP Table if exists measurement_xMINUS1Month ;
DROP Table if exists measurement_xMINUS3Month ;
DROP Table if exists measurement_backup ;
DROP Table if exists measurement_master;

-- Master
create table measurement_master
(
	id bigint not null,
	metadata json not null,
	data json not null
);

-- Children
CREATE TABLE measurement_xMINUS12Hour (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '12 hour')::timestamp AND (current_timestamp + INTERVAL '1 minute')::timestamp)
) INHERITS (measurement_master); 

CREATE TABLE measurement_xMINUS1Day (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '1 day')::timestamp AND (current_timestamp - INTERVAL '12 hour')::timestamp)
) INHERITS (measurement_master); 

CREATE TABLE measurement_xMINUS3Day (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '3 day')::timestamp AND (current_timestamp - INTERVAL '1 day')::timestamp)
) INHERITS (measurement_master);

CREATE TABLE measurement_xMINUS1Week (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '7 day')::timestamp AND (current_timestamp - INTERVAL '3 day')::timestamp)
) INHERITS (measurement_master);

CREATE TABLE measurement_xMINUS2Week (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '14 day')::timestamp AND (current_timestamp - INTERVAL '7 day')::timestamp)
) INHERITS (measurement_master);

CREATE TABLE measurement_xMINUS1Month (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '1 month')::timestamp AND (current_timestamp - INTERVAL '14 day')::timestamp)
) INHERITS (measurement_master);

CREATE TABLE measurement_xMINUS3Month (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '3 month')::timestamp AND (current_timestamp - INTERVAL '1 month')::timestamp)
) INHERITS (measurement_master);

CREATE TABLE measurement_backup (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '50 year')::timestamp AND (current_timestamp - INTERVAL '3 month')::timestamp)
) INHERITS (measurement_master);


-- INDEX
CREATE INDEX measurement_xMINUS12Hour_timestamp ON measurement_xMINUS12Hour ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS1Day_timestamp ON measurement_xMINUS1Day ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS3Day_timestamp ON measurement_xMINUS3Day ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS1Week_timestamp ON measurement_xMINUS1Week ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS2Week_timestamp ON measurement_xMINUS2Week ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS1Month_timestamp ON measurement_xMINUS1Month ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS3Month_timestamp ON measurement_xMINUS3Month ((data->>'timestamp'));
CREATE INDEX measurement_backup_timestamp ON measurement_backup ((data->>'timestamp'));

/*
CREATE INDEX measurement_xMINUS12Hour_id ON measurement_xMINUS12Hour (id);
CREATE INDEX measurement_xMINUS1Day_id ON measurement_xMINUS1Day (id);
CREATE INDEX measurement_xMINUS3Day_id ON measurement_xMINUS3Day (id);
CREATE INDEX measurement_xMINUS1Week_id ON measurement_xMINUS1Week (id);
CREATE INDEX measurement_xMINUS2Week_id ON measurement_xMINUS2Week (id);
CREATE INDEX measurement_xMINUS1Month_id ON measurement_xMINUS1Month (id);
CREATE INDEX measurement_xMINUS3Month_id ON measurement_xMINUS3Month (id);
CREATE INDEX measurement_backup_id ON measurement_backup (id);*/

-- Trigger - Function
CREATE OR REPLACE FUNCTION measurement_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO measurement_xMINUS12Hour VALUES (NEW.*);
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

-- Trigger - Event
Drop trigger if exists insert_measurement_trigger on measurement_master;

CREATE TRIGGER insert_measurement_trigger
    BEFORE INSERT ON measurement_master
    FOR EACH ROW EXECUTE PROCEDURE measurement_insert_trigger();

-- TEST - Function
DROP function if exists convert_input_data_to_json_measurement_table(integer);

CREATE OR REPLACE FUNCTION public.convert_input_data_to_json_measurement_table(integer)
  RETURNS character AS $BODY$
DECLARE
	r log%ROWTYPE;

	id_count integer := 0;
 BEGIN
	FOR r IN
		SELECT *
		FROM log l
		ORDER BY l."timestamp"
		LIMIT $1
	LOOP
		INSERT INTO measurement_master VALUES (id_count,
				json_build_object(
					'insert_at', current_timestamp::timestamp,
					'aggregation_type', 'seconds'),
				json_build_object(
					'host',r.host,
					'timestamp',current_timestamp::timestamp,
					'plugin',r.plugin,
					'type_instance',r.type_instance,
					'collectd_type',r.collectd_type,
					'plugin_instance',r.plugin_instance,
					'type',r.type,
					'value',r.value,
					'version',r.version)
				);
		id_count := id_count + 1;
	END LOOP;
	
	return 'Running ' || id_count || ' Times!';
	--- Do not user '. Times!' -> the point tells postgresSQL, that the string is a table-column
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.convert_input_data_to_json_measurement_table(integer)
  OWNER TO metrics;
-- 'timestamp',r."timestamp", --

-- START TEST
truncate table measurement_master;
select convert_input_data_to_json_measurement_table(50);

-- Run this 
insert into measurement_master VALUES (0,
json_build_object('timestamp', current_timestamp::timestamp),
json_build_object('timestamp', current_timestamp::timestamp));

--"{"timestamp" : "2017-02-19T14:56:56.252305"}"
-- NOTES
---- Building CHECK;
-- CHECK ( logdate >= DATE '2006-02-01' AND logdate < DATE '2006-03-01' )
-- add: measurement_master

select data->>'timestamp',
	to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS') as zeit,
	current_timestamp as jetzt,
	(current_timestamp - INTERVAL '1 month') as next
from cpu
where to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '1 month')::timestamp AND current_timestamp::timestamp
LIMIT 10;

/* FINAL CHECK */
CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '1 month')::timestamp AND current_timestamp::timestamp)

select (current_timestamp - INTERVAL '1 month')::timestamp as next, current_timestamp::timestamp as jetzt;

select current_timestamp;
-- "2017-02-19 13:38:57.591705+01"
-- "2017-02-15T19:31:23.034+01:00"