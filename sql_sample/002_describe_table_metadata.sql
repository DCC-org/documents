select column_name, data_type, character_maximum_length
from INFORMATION_SCHEMA.COLUMNS where table_name = 'log';
/*
"host";"character varying";
"timestamp";"timestamp with time zone";
"plugin";"character varying";
"type_instance";"character varying";
"collectd_type";"character varying";
"plugin_instance";"character varying";
"type";"character varying";
"value";"double precision";
"version";"character varying";
*/

select column_name, data_type, character_maximum_length
from INFORMATION_SCHEMA.COLUMNS where table_name LIKE 'measurement_master';
/*
"id";"bigint";
"metadata";"json";
"data";"json";
*/


select column_name, data_type, character_maximum_length
from INFORMATION_SCHEMA.COLUMNS where table_name LIKE 'anz';
/*
"count";"bigint";
*/