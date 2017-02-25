CREATE FUNCTION dup(int) RETURNS TABLE(f1 int, f2 text)
    AS $$ SELECT $1, CAST($1 AS text) || ' is text' $$
    LANGUAGE SQL;

-- Security SELECT Functions
DROP function if exists select_newest_data_measurement(text);

CREATE OR REPLACE FUNCTION public.select_newest_data_measurement(text) 
  RETURNS TABLE(data JSON)
  AS $$ SELECT data from measurement_master where data->>'host' = $1 AND data->>'plugin' = 'cpu' LIMIT 1000 $$
  LANGUAGE SQL
  EXTERNAL SECURITY DEFINER;

 -- Create user api
 CREATE ROLE api LOGIN
  ENCRYPTED PASSWORD ''
  NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;


-- Grand permission
GRANT EXECUTE ON FUNCTION select_newest_data_measurement(text) TO api;