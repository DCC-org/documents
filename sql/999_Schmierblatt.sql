{"host" : "ci-slave2", "time
stamp" : "2017-04-28T18:27:13.035+02:00", "plugin" : "df", "type_instance" : "used", "collectd_type" : "df_inodes",
 "plugin_instance" : "var-lib-docker-devicemapper", "type" : "collectd", "value" : 81520, "version" : null}

EXPLAIN ANALYZE
select max(id)
from measurement_master
where substring(data->>'timestamp'::text from 1 for 13) = '2017-04-28 23'
  AND metadata->>'etlid' = '122'::text;


EXPLAIN ANALYZE
select substring(data->>'timestamp'::text from 1 for 13)
from public.measurement_master
where substring(data->>'timestamp'::text from 1 for 10) = '2017-04-28' AND
id = 26468797;


SELECT TIMESTAMP WITH TIME ZONE '2017-04-28T18:27:13.035+02:00' AT TIME ZONE 'UTC';

SELECT

EXPLAIN ANALYZE
insert into log_backup
select * from log LIMIT 1;

-- Hour Insert;
insert into log_backup
select * from log
where substring(log.timestamp::text from 1 for 13) = '2017-02-16 19'
order by log.timestamp;

insert into log_backup
select * from log
LIMIT 1;

EXPLAIN ANALYZE
insert into log_backup
select * from log
where substring(log.timestamp::text from 1 for 13) = '2017-02-15 19'
order by log.timestamp;

select * from log
where substring(log.timestamp::text from 1 for 13) = '2017-02-15 19'
order by log.timestamp;
LIMIT 50;

select min(log.timestamp)::timestamp, max(log.timestamp)::timestamp
from log;


EXPLAIN ANALYZE
select * from et into log_backup
select * from log LIMIT 10;

truncate table measurement_master;
truncate table etl_



SELECT b.nspname, a.relname
FROM pg_class a, pg_catalog.pg_namespace b
WHERE relname='partitions'::text
  and a.relnamespace = b.oid
  and b.nspname='etl_cpu_user';

'host' = NEW.host::text
    AND datacontent->>'collectd_type' = NEW.collectd_type::text
    AND datacontent->>'plugin_instance' = NEW.plugin_instance::text
    AND datacontent->>'type' = NEW.type::text;


select datacontent->>'plugin_instance'::text as name, count(*) from etl_master group by datacontent->>'plugin_instance';
select datacontent->>'plugin_instance'::text as name, count(*) from etl_master group by datacontent->>'plugin_instance';
select datacontent->>'plugin_instance'::text as name, count(*) from etl_master group by datacontent->>'plugin_instance';
select datacontent->>'plugin_instance'::text as name, count(*) from etl_master group by datacontent->>'plugin_instance';

SELECT b.nspname, a.relname
FROM pg_class a, pg_catalog.pg_namespace b
WHERE relname='partitions'
  and a.relnamespace = b.oid
  and b.nspname='etl_cpu_user';

  
-- Test Heatmap INDEX
EXPLAIN ANALYZE 
SELECT 
  metadata->>'etlid',
  extract(epoch from to_timestamp(data->>'timestamp'::text, 'YYYY-MM-DD HH24:MI:SS')::timestamp)::int,
  CAST(data->>'value' AS FLOAT)::float,
  data->>'plugin_instance'::text,
  data->>'collectd_type'::text
 FROM public.measurement_master
 WHERE
  metadata->>'etlid' in ('390', '423', '439') 
  AND date_trunc_hour_json(data->>'timestamp'::text) = '2017-05-02 14:00:00'::timestamp
 ORDER BY data->>'timestamp';