--- Create Grafana Dashboard Mapping Table ---
drop table if exists public.grafana_dashboard_mapping;
create table public.grafana_dashboard_mapping
(
  org_id int unique not null,
  host_values TEXT[] not null
);
create unique index master_unique_org_id on public.grafana_dashboard_mapping (org_id);

CREATE SEQUENCE grafana_dashboard_mapping_org_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
-- ALTER SEQUENCE public.grafana_dashboard_mapping_org_id RESTART WITH 1;

-- Sample insert
insert into public.grafana_dashboard_mapping
values (1, '{"ci-slave2", "swoarly"}');