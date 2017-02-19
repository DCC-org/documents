-- Master
create table measurement_master
(
	id bigint not null,
	metadata json not null,
	data json not null
);

-- Children
CREATE TABLE measurement_xMINUS1Minute (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '1 minute')::timestamp AND current_timestamp::timestamp)
) INHERITS (measurement_master); -- Aggregation = Seconds

CREATE TABLE measurement_xMINUS1Hour (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '1 hour')::timestamp AND current_timestamp::timestamp)
) INHERITS (measurement_master); -- Aggregation = Minutes

CREATE TABLE measurement_xMINUS1Day (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '1 day')::timestamp AND current_timestamp::timestamp)
) INHERITS (measurement_master); -- Aggregation = Hours

CREATE TABLE measurement_xMINUS1Week (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '7 day')::timestamp AND current_timestamp::timestamp)
) INHERITS (measurement_master); -- Aggregation = Days

CREATE TABLE measurement_xMINUS1Month (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '1 month')::timestamp AND current_timestamp::timestamp)
) INHERITS (measurement_master); -- Aggregation = Weeks

CREATE TABLE measurement_xMINUS1Year (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '1 year')::timestamp AND current_timestamp::timestamp)
) INHERITS (measurement_master); -- Aggregation = Months

CREATE TABLE measurement_backup (
	CHECK (to_timestamp(data->>'timestamp', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp between (current_timestamp - INTERVAL '50 year')::timestamp AND current_timestamp::timestamp)
) INHERITS (measurement_master); -- Aggregation = Year


-- INDEX
CREATE INDEX measurement_xMINUS1Minute_timestamp ON measurement_xMINUS1Minute ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS1Hour_timestamp ON measurement_xMINUS1Hour ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS1Day_timestamp ON measurement_xMINUS1Day ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS1Week_timestamp ON measurement_xMINUS1Week ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS1Month_timestamp ON measurement_xMINUS1Month ((data->>'timestamp'));
CREATE INDEX measurement_xMINUS1Year_timestamp ON measurement_xMINUS1Year ((data->>'timestamp'));
CREATE INDEX measurement_backup_timestamp ON measurement_backup ((data->>'timestamp'));


-- Trigger - Function
CREATE OR REPLACE FUNCTION measurement_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO measurement_xMINUS1Minute_timestamp VALUES (NEW.*);
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

-- Trigger - Event
CREATE TRIGGER insert_measurement_trigger
    BEFORE INSERT ON measurement_master
    FOR EACH ROW EXECUTE PROCEDURE measurement_insert_trigger();

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