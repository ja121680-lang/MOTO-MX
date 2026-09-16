-- MotoGo MX: esquema inicial PostgreSQL / Supabase
-- Starter: revisar y endurecer RLS antes de producción.

create extension if not exists "pgcrypto";

create type public.user_role as enum ('passenger','driver','admin');
create type public.account_status as enum ('pending','active','suspended','rejected');
create type public.trip_status as enum (
  'requested','accepted','driver_arriving','pin_required',
  'in_progress','completed','cancelled'
);
create type public.payment_method as enum ('cash','card','qr');
create type public.payment_status as enum ('pending','paid','failed','refunded');
create type public.document_status as enum ('pending','approved','rejected');

create table public.profiles (
  id uuid primary key,
  role public.user_role not null default 'passenger',
  full_name text not null,
  phone text unique not null,
  email text,
  photo_url text,
  status public.account_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.unions (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.driver_profiles (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  union_id uuid references public.unions(id),
  economic_number text,
  biometric_verified boolean not null default false,
  approved_at timestamptz,
  is_online boolean not null default false,
  diamond_enabled boolean not null default false,
  rating numeric(3,2) not null default 5.00,
  total_trips integer not null default 0
);

create table public.vehicles (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references public.driver_profiles(user_id) on delete cascade,
  make text,
  model text,
  year integer,
  color text,
  plate text not null unique,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.driver_documents (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references public.driver_profiles(user_id) on delete cascade,
  document_type text not null,
  storage_path text not null,
  status public.document_status not null default 'pending',
  rejection_reason text,
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.trips (
  id uuid primary key default gen_random_uuid(),
  passenger_id uuid not null references public.profiles(id),
  driver_id uuid references public.driver_profiles(user_id),
  vehicle_id uuid references public.vehicles(id),
  status public.trip_status not null default 'requested',

  origin_lat double precision not null,
  origin_lng double precision not null,
  origin_text text,
  destination_lat double precision not null,
  destination_lng double precision not null,
  destination_text text,

  quoted_fare numeric(12,2) not null check (quoted_fare >= 0),
  final_fare numeric(12,2),
  platform_fee_rate numeric(5,4) not null default 0.0800,
  platform_fee numeric(12,2),
  driver_net numeric(12,2),

  pin_hash text,
  requested_at timestamptz not null default now(),
  accepted_at timestamptz,
  started_at timestamptz,
  completed_at timestamptz,
  cancelled_at timestamptz
);

create table public.trip_locations (
  id bigint generated always as identity primary key,
  trip_id uuid not null references public.trips(id) on delete cascade,
  user_id uuid not null references public.profiles(id),
  lat double precision not null,
  lng double precision not null,
  heading double precision,
  speed double precision,
  recorded_at timestamptz not null default now()
);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null unique references public.trips(id),
  method public.payment_method not null,
  status public.payment_status not null default 'pending',
  amount numeric(12,2) not null,
  provider_reference text,
  created_at timestamptz not null default now(),
  paid_at timestamptz
);

create table public.wallets (
  user_id uuid primary key references public.driver_profiles(user_id) on delete cascade,
  available_balance numeric(12,2) not null default 0,
  pending_balance numeric(12,2) not null default 0,
  updated_at timestamptz not null default now()
);

create table public.wallet_transactions (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references public.driver_profiles(user_id),
  trip_id uuid references public.trips(id),
  kind text not null check (kind in ('trip_credit','platform_fee','withdrawal','adjustment')),
  amount numeric(12,2) not null,
  created_at timestamptz not null default now()
);

create table public.ratings (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.trips(id) on delete cascade,
  from_user_id uuid not null references public.profiles(id),
  to_user_id uuid not null references public.profiles(id),
  score integer not null check (score between 1 and 5),
  comment text,
  created_at timestamptz not null default now(),
  unique(trip_id, from_user_id)
);

create table public.sos_events (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references public.trips(id),
  triggered_by uuid not null references public.profiles(id),
  lat double precision,
  lng double precision,
  status text not null default 'open',
  created_at timestamptz not null default now(),
  resolved_at timestamptz
);

create table public.audit_log (
  id bigint generated always as identity primary key,
  actor_user_id uuid references public.profiles(id),
  action text not null,
  entity_type text,
  entity_id text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index trips_passenger_idx on public.trips(passenger_id, requested_at desc);
create index trips_driver_idx on public.trips(driver_id, requested_at desc);
create index trips_status_idx on public.trips(status);
create index trip_locations_trip_idx on public.trip_locations(trip_id, recorded_at desc);
create index driver_docs_driver_idx on public.driver_documents(driver_id, status);

-- Función inicial para calcular comisión y neto.
create or replace function public.compute_trip_financials()
returns trigger
language plpgsql
as $$
begin
  if new.final_fare is not null then
    new.platform_fee := round(new.final_fare * new.platform_fee_rate, 2);
    new.driver_net := new.final_fare - new.platform_fee;
  end if;
  return new;
end;
$$;

create trigger trg_trip_financials
before insert or update of final_fare, platform_fee_rate
on public.trips
for each row
execute function public.compute_trip_financials();

-- RLS se habilita como recordatorio; faltan políticas de producción.
alter table public.profiles enable row level security;
alter table public.driver_profiles enable row level security;
alter table public.vehicles enable row level security;
alter table public.driver_documents enable row level security;
alter table public.trips enable row level security;
alter table public.trip_locations enable row level security;
alter table public.payments enable row level security;
alter table public.wallets enable row level security;
alter table public.wallet_transactions enable row level security;
alter table public.ratings enable row level security;
alter table public.sos_events enable row level security;

-- Evita que dos conductores acepten el mismo viaje.
create or replace function public.accept_trip(
  p_trip_id uuid,
  p_driver_id uuid,
  p_vehicle_id uuid
)
returns public.trips
language plpgsql
security definer
as $$
declare
  v_trip public.trips;
begin
  select * into v_trip
  from public.trips
  where id = p_trip_id
  for update;

  if not found then
    raise exception 'Trip not found';
  end if;

  if v_trip.status <> 'requested' then
    raise exception 'Trip is no longer available';
  end if;

  if not exists (
    select 1
    from public.driver_profiles d
    join public.profiles p on p.id = d.user_id
    where d.user_id = p_driver_id
      and d.is_online = true
      and d.approved_at is not null
      and p.status = 'active'
  ) then
    raise exception 'Driver is not eligible';
  end if;

  update public.trips
  set driver_id = p_driver_id,
      vehicle_id = p_vehicle_id,
      status = 'accepted',
      accepted_at = now()
  where id = p_trip_id
  returning * into v_trip;

  return v_trip;
end;
$$;

create or replace function public.complete_trip(
  p_trip_id uuid,
  p_final_fare numeric
)
returns public.trips
language plpgsql
security definer
as $$
declare
  v_trip public.trips;
begin
  update public.trips
  set final_fare = p_final_fare,
      status = 'completed',
      completed_at = now()
  where id = p_trip_id
    and status = 'in_progress'
  returning * into v_trip;

  if not found then
    raise exception 'Trip cannot be completed from current state';
  end if;

  insert into public.wallet_transactions(driver_id, trip_id, kind, amount)
  values
    (v_trip.driver_id, v_trip.id, 'trip_credit', v_trip.final_fare),
    (v_trip.driver_id, v_trip.id, 'platform_fee', -v_trip.platform_fee);

  insert into public.wallets(user_id, available_balance)
  values (v_trip.driver_id, v_trip.driver_net)
  on conflict (user_id)
  do update set
    available_balance = public.wallets.available_balance + excluded.available_balance,
    updated_at = now();

  return v_trip;
end;
$$;
create table if not exists public.fare_rules (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  base_fare numeric(12,2) not null,
  per_km numeric(12,2) not null,
  per_minute numeric(12,2) not null,
  minimum_fare numeric(12,2) not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.driver_presence (
  driver_id uuid primary key references public.driver_profiles(user_id) on delete cascade,
  lat double precision not null,
  lng double precision not null,
  heading double precision,
  last_seen_at timestamptz not null default now()
);

alter table public.trips
  add column if not exists estimated_distance_km numeric(10,2),
  add column if not exists estimated_duration_min integer;

create index if not exists driver_presence_last_seen_idx
  on public.driver_presence(last_seen_at desc);

insert into public.fare_rules(name, base_fare, per_km, per_minute, minimum_fare)
select 'Tarifa MVP', 15, 7, 1.2, 25
where not exists (select 1 from public.fare_rules where name = 'Tarifa MVP');
create type if not exists public.withdrawal_status as enum (
  'requested','approved','processing','paid','rejected','cancelled'
);

create table if not exists public.withdrawal_requests (
  id uuid primary key default gen_random_uuid(),
  driver_id uuid not null references public.driver_profiles(user_id),
  amount numeric(12,2) not null check (amount > 0),
  status public.withdrawal_status not null default 'requested',
  destination_label text,
  requested_at timestamptz not null default now(),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  paid_at timestamptz
);

create table if not exists public.driver_levels (
  driver_id uuid primary key references public.driver_profiles(user_id) on delete cascade,
  level_name text not null default 'standard',
  completed_trips integer not null default 0,
  rating numeric(3,2) not null default 5.00,
  cancellation_rate numeric(5,4) not null default 0,
  qualified_at timestamptz,
  updated_at timestamptz not null default now()
);

create or replace function public.request_withdrawal(
  p_driver_id uuid,
  p_amount numeric
)
returns public.withdrawal_requests
language plpgsql
security definer
as $$
declare
  v_wallet public.wallets;
  v_driver public.driver_profiles;
  v_request public.withdrawal_requests;
begin
  select * into v_driver
  from public.driver_profiles
  where user_id = p_driver_id
  for update;

  if not found then
    raise exception 'Driver not found';
  end if;

  if v_driver.diamond_enabled is not true then
    raise exception 'Diamond membership required for withdrawals';
  end if;

  select * into v_wallet
  from public.wallets
  where user_id = p_driver_id
  for update;

  if not found or v_wallet.available_balance < p_amount then
    raise exception 'Insufficient available balance';
  end if;

  update public.wallets
  set available_balance = available_balance - p_amount,
      pending_balance = pending_balance + p_amount,
      updated_at = now()
  where user_id = p_driver_id;

  insert into public.wallet_transactions(driver_id, kind, amount)
  values (p_driver_id, 'withdrawal', -p_amount);

  insert into public.withdrawal_requests(driver_id, amount)
  values (p_driver_id, p_amount)
  returning * into v_request;

  return v_request;
end;
$$;

create or replace function public.recalculate_diamond(p_driver_id uuid)
returns boolean
language plpgsql
security definer
as $$
declare
  v_trips integer;
  v_rating numeric(3,2);
  v_cancel_rate numeric(5,4);
  v_qualifies boolean;
begin
  select
    count(*) filter (where status = 'completed'),
    coalesce(
      count(*) filter (where status = 'cancelled')::numeric /
      nullif(count(*)::numeric, 0),
      0
    )
  into v_trips, v_cancel_rate
  from public.trips
  where driver_id = p_driver_id;

  select coalesce(avg(score), 5.0)
  into v_rating
  from public.ratings
  where to_user_id = p_driver_id;

  v_qualifies :=
    v_trips >= 100
    and v_rating >= 4.8
    and v_cancel_rate <= 0.08;

  update public.driver_profiles
  set diamond_enabled = v_qualifies
  where user_id = p_driver_id;

  insert into public.driver_levels(
    driver_id, level_name, completed_trips, rating,
    cancellation_rate, qualified_at
  )
  values (
    p_driver_id,
    case when v_qualifies then 'diamond' else 'standard' end,
    v_trips,
    v_rating,
    v_cancel_rate,
    case when v_qualifies then now() else null end
  )
  on conflict (driver_id)
  do update set
    level_name = excluded.level_name,
    completed_trips = excluded.completed_trips,
    rating = excluded.rating,
    cancellation_rate = excluded.cancellation_rate,
    qualified_at = excluded.qualified_at,
    updated_at = now();

  return v_qualifies;
end;
$$;
