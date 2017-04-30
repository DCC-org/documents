drop FUNCTION migrate_hour_etl(timestamp,timestamp);

CREATE OR REPLACE FUNCTION migrate_hour_etl(IN start timestamp, IN stop timestamp) 
RETURNS void 
LANGUAGE plpgsql
AS
$$
DECLARE
	akt_value text;
	year text;
	month text;
	day text;
	hour text;
	in_start timestamp := start;
	in_stop timestamp := stop;
BEGIN
	LOOP
		
		EXECUTE 'SELECT extract(year from timestamp ''' || in_start::text || '''::timestamp)::text;' INTO year;
		EXECUTE 'SELECT extract(month from timestamp ''' || in_start::text || '''::timestamp)::text;' INTO month;
		EXECUTE 'SELECT extract(day from timestamp ''' || in_start::text || '''::timestamp)::text;' INTO day;
		EXECUTE 'SELECT extract(hour from timestamp ''' || in_start::text || '''::timestamp)::text;' INTO hour;
		
		IF month::int < 10 then
			month := '0' || month;
		end if;
		IF day::int < 10 then
			day := '0' || day;
		end if;
		IF hour::int < 10 then
			hour := '0' || hour;
		end if;
		
		akt_value := year || '-' || month || '-' || day || ' ' || hour;
		
		RAISE NOTICE 'Starte Work @  %', akt_value;
		EXECUTE 'insert into log_backup select * from log where substring(log.timestamp::text from 1 for 13) = ''' || akt_value  || ''' order by log.timestamp;';
		
		in_start := in_start + '1 hour'::interval;
		
		RAISE NOTICE 'Datum %', in_start;
		
		IF in_start = in_stop THEN
			EXIT;
		END IF;
	END LOOP;
	
END;
$$;

SELECT migrate_hour_etl('2017-02-15 21:00:00'::timestamp, '2017-04-30 02:00:00'::timestamp);

drop FUNCTION get_text_insert(timestamp,timestamp);

CREATE OR REPLACE FUNCTION get_text_insert(IN start timestamp, IN stop timestamp) 
RETURNS void 
LANGUAGE plpgsql
AS
$$
DECLARE
	akt_value text;
	year text;
	month text;
	day text;
	hour text;
	in_start timestamp := start;
	in_stop timestamp := stop;
BEGIN
	LOOP
		
		EXECUTE 'SELECT extract(year from timestamp ''' || in_start::text || '''::timestamp)::text;' INTO year;
		EXECUTE 'SELECT extract(month from timestamp ''' || in_start::text || '''::timestamp)::text;' INTO month;
		EXECUTE 'SELECT extract(day from timestamp ''' || in_start::text || '''::timestamp)::text;' INTO day;
		EXECUTE 'SELECT extract(hour from timestamp ''' || in_start::text || '''::timestamp)::text;' INTO hour;
		
		IF month::int < 10 then
			month := '0' || month;
		end if;
		IF day::int < 10 then
			day := '0' || day;
		end if;
		IF hour::int < 10 then
			hour := '0' || hour;
		end if;
		
		akt_value := year || '-' || month || '-' || day || ' ' || hour || ':00:00';
		
		RAISE NOTICE '%', 'psql -U metrics -d metrics - c "insert into log_backup SELECT * FROM log WHERE log_date_trunc_hour(timestamp) = ''' || akt_value || '''::timestamp ORDER BY log.timestamp;"';
		
		in_start := in_start + '1 hour'::interval;
		
		IF in_start = in_stop THEN
			EXIT;
		END IF;
	END LOOP;
	
END;
$$;

SELECT get_text_insert('2017-02-15 19:00:00'::timestamp, '2017-05-01 00:00:00'::timestamp);