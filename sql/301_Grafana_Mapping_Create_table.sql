--- Create Grafana Dashboard Mapping Table ---
drop table if exists public.grafana_dashboard_mapping;
create table public.grafana_dashboard_mapping
(
  org_id int not null,
  host_values TEXT[] not null
);

-- Sample insert
insert into public.grafana_dashboard_mapping
values (1, '{"ci-slave2", "swoarly"}');