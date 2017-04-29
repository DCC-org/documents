-- 2017-04-29 13:25:58.159398
select *
from test_me
where zeit <= to_timestamp('2017-04-29 13:25:58.159', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp
order by zeit DESC
LIMIT 1;


CREATE OR REPLACE FUNCTION public.aggregate_data_in_etl
	(
	zeit_new timestamp,
	etlmetaid TEXT,
	value_new TEXT
	)
RETURNS boolean AS $BODY$
DECLARE
	prefix text := 'partitions';
	partition text;
	foundtimestamp timestamp;
	foundrowid bigint;
	foundvalue TEXT;
BEGIN
	partition := substring(zeit_new from 1 for 13);
	partition := replace(partition,'-', '_');
	partition := replace(partition,' ', 't');

	SELECT to_timestamp(data->>'timestamp'::text, 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp,
			id,
			data->>'value'::text
	INTO
			foundtimestamp, foundrowid, foundvalue
	FROM
		prefix.partition
	WHERE
		metadata->>'etlid'::text = ''etlmetaid''
	AND
		to_timestamp(data->>'timestamp'::text, 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp
		<=
		zeit_new::timestamp
	ORDER BY data->'timestamp' DESC
	LIMIT 1;
	
	IF value_new = foundvalue THEN
		return 'false';
	ELSE
		return 'true';
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
  	id bigint not null,
	metadata json not null,
	data json not null