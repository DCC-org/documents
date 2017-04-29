-- 2017-04-29 13:25:58.159398
select *
from test_me
where zeit <= to_timestamp('2017-04-29 13:25:58', 'YYYY-MM-DD HH24:MI:SS')::timestamp
order by zeit DESC
LIMIT 1;


CREATE OR REPLACE FUNCTION public.check_if_last_value_is_same
	(
	zeit_new timestamp,
	etlmetaid TEXT,
	value_new TEXT
	)
RETURNS BOOLEAN AS $BODY$
DECLARE
	prefix text := 'partitions';
	partition text;
	from_value text;
	foundtimestamp timestamp;
	foundrowid bigint;
	foundvalue TEXT;
BEGIN
	partition := substring(zeit_new from 1 for 13);
	partition := replace(partition,'-', '_');
	partition := replace(partition,' ', 't');
	
	from_value := prefix || '.' || partition;

	SELECT to_timestamp(data->>'timestamp'::text, 'YYYY-MM-DD HH24:MI:SS')::timestamp,
			id,
			data->>'value'::text
	INTO
			foundtimestamp, foundrowid, foundvalue
	FROM
		from_value
	WHERE
		metadata->>'etlid'::text = "etlmetaid"
	AND
		to_timestamp(data->>'timestamp'::text, 'YYYY-MM-DD HH24:MI:SS')::timestamp
		<=
		zeit_new::timestamp
	ORDER BY data->>'timestamp' DESC
	LIMIT 1;
	
	IF value_new = foundvalue THEN
		return true;
	ELSE
		return false;
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
public.check_if_last_value_is_same('2017-02-15 20:52:43'::timestamp, '13'::text, '')