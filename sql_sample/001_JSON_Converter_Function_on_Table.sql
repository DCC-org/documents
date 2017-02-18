--- Create Table ---

DROP table if exists cpu;

create table cpu
(
	id integer not null,
	data json not null
);

--- Create Function ---

DROP function if exists convert_input_data_to_json_cpu_table();

create or replace function convert_input_data_to_json_cpu_table() returns character AS $json_cpu_table$
DECLARE
	c_host character varying;
	t_timestamp timestamp with time zone;
	c_plugin character varying;
	c_type_instance character varying;
	c_collectd_type character varying;
	c_plugin_instance character varying;
	c_type character varying;
	d_value double precision;
	c_version character varying;
	c_json character varying;
 BEGIN
	truncate table cpu;
	c_host := (SELECT host from log LIMIT 1);
	t_timestamp := (SELECT "timestamp" from log LIMIT 1);
	c_plugin := (SELECT plugin from log LIMIT 1);
	c_type_instance := (SELECT type_instance from log LIMIT 1);
	c_collectd_type := (SELECT collectd_type from log LIMIT 1);
	c_plugin_instance := (SELECT plugin_instance from log LIMIT 1);
	c_type := (SELECT type from log LIMIT 1);
	d_value := (SELECT value from log LIMIT 1);
	c_version := (SELECT version from log LIMIT 1);

	c_json := json_build_object('host',c_host,
				'timestamp',t_timestamp,
				'plugin',c_plugin,
				'type_instance',c_type_instance,
				'collectd_type',c_collectd_type,
				'plugin_instance',c_plugin_instance,
				'type',c_type,
				'value',d_value,
				'version',c_version);
	
	INSERT INTO cpu VALUES (1, 
				json_build_object(
					'host',c_host,
					'timestamp',t_timestamp,
					'plugin',c_plugin,
					'type_instance',c_type_instance,
					'collectd_type',c_collectd_type,
					'plugin_instance',c_plugin_instance,
					'type',c_type,
					'value',d_value,
					'version',c_version)
				);
	return c_json;
END;
$json_cpu_table$
LANGUAGE plpgsql;

--- Test Function ---

select convert_input_data_to_json_cpu_table();
select * from cpu;

SELECT id, data->>'host' AS name FROM cpu;