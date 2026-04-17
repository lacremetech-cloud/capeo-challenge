-- CAPEO Challenge — initial schema
-- Single-row event state table with Supabase Realtime enabled

create table if not exists public.event_state (
  id        integer     primary key default 1,
  data      jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Enforce single row
create unique index if not exists event_state_single_row on public.event_state (id);

-- Seed the single row
insert into public.event_state (id, data)
values (1, '{}'::jsonb)
on conflict (id) do nothing;

-- RLS: everyone can read, everyone can update (tighten with Auth later)
alter table public.event_state enable row level security;

create policy "public read"
  on public.event_state for select
  using (true);

create policy "public write"
  on public.event_state for update
  using (true);

-- Enable Supabase Realtime on this table
alter publication supabase_realtime add table public.event_state;
