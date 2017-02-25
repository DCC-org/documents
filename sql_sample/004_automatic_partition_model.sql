-- https://www.zabbix.org/wiki/Docs/howto/zabbix2_postgresql_autopartitioning
-- https://p.bastelfreak.de/V9db2r/sql


-- Master
drop table if exists measurement_master;
create table measurement_master
(
	id bigint not null,
	metadata json not null,
	data json not null
);

--SCHEMA

-- DROP SCHEMA partitions;
CREATE SCHEMA partitions;