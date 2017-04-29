current_setting(from_value)
CREATE TYPE return_type AS (is_same boolean, foundtimestamp timestamp, foundvalue text, foundrowid bigint );

DROP FUNCTION public.check_if_last_value_is_same(timestamp,TEXT,TEXT);

CREATE OR REPLACE FUNCTION public.check_if_last_value_is_same
	(
	zeit_new timestamp,
	etlmetaid TEXT,
	value_new TEXT
	)
RETURNS return_type AS $BODY$
DECLARE
	prefix text := 'partitions';
	partition text;
	from_value text;
	foundtimestamp timestamp;
	foundrowid bigint;
	foundvalue TEXT;
	
	result_record return_type;
BEGIN
	partition := substring(zeit_new::text from 1 for 13);
	partition := replace(partition,'-', '_');
	partition := replace(partition,' ', 't');
	
	from_value := prefix || '.measurement_' || partition;
	
	RAISE NOTICE '%', from_value;

	SELECT to_timestamp(data->>'timestamp'::text, 'YYYY-MM-DD HH24:MI:SS')::timestamp,
			id,
			data->>'value'::text
	INTO
			result_record.foundtimestamp, result_record.foundrowid, result_record.foundvalue
	FROM
		:from_value
	WHERE
		metadata->>'etlid'::text = "etlmetaid"
	AND
		to_timestamp(data->>'timestamp'::text, 'YYYY-MM-DD HH24:MI:SS')::timestamp
		<=
		zeit_new::timestamp
	ORDER BY data->>'timestamp' DESC
	LIMIT 1;
	
	IF value_new = foundvalue THEN
		result_record.is_same := true;
	ELSE
		result_record.is_same := false;
	END IF;
	
	return result_record;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
select public.check_if_last_value_is_same('2017-02-15 20:52:43'::timestamp, '13'::text, '0');