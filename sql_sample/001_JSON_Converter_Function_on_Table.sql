--- Create Table ---

DROP table if exists cpu;

create table cpu
(
	id integer not null,
	data json not null
);

--- Create Function ---

DROP function if exists convert_input_data_to_json_cpu_table(integer);

CREATE OR REPLACE FUNCTION public.convert_input_data_to_json_cpu_table(integer)
  RETURNS character AS $BODY$
DECLARE
	r log%ROWTYPE;

	id_count integer := 0;
 BEGIN
	truncate table cpu;

	FOR r IN
		SELECT *
		FROM log l
		ORDER BY l."timestamp"
		LIMIT $1
	LOOP
		INSERT INTO cpu VALUES (id_count, 
				json_build_object(
					'host',r.host,
					'timestamp',r."timestamp",
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
ALTER FUNCTION public.convert_input_data_to_json_cpu_table(integer)
  OWNER TO metrics;

--- Test Function ---

select convert_input_data_to_json_cpu_table(100000);


-- DO NOT RUN THIS WITHOUT LIMIT -> Y SOFTWARE WILL CRASH
select * from cpu LIMIT 10;
SELECT id, data->>'host' AS name FROM cpu LIMIT 10;