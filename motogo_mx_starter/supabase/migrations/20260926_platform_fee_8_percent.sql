-- MotoGo MX — align database default with the agreed 8% platform commission.
-- Safe for a future Supabase deployment; no remote database is modified by this file alone.

alter table if exists public.trips
  alter column platform_fee_rate set default 0.0800;

-- Keep non-completed trips aligned with the current business rule while
-- preserving the historical rate on trips that have already been completed.
update public.trips
set platform_fee_rate = 0.0800
where status <> 'completed'
  and platform_fee_rate = 0.1000;
