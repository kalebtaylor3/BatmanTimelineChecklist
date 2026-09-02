-- Batman Life Story Timeline — Supabase cloud sync setup
-- Run ONCE in Supabase Dashboard > SQL Editor.

create table if not exists public.batman_timeline_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  progress jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.batman_timeline_progress enable row level security;

revoke all on table public.batman_timeline_progress from anon, authenticated;
grant select, insert, update on table public.batman_timeline_progress to authenticated;

drop policy if exists "Timeline select own" on public.batman_timeline_progress;
create policy "Timeline select own"
on public.batman_timeline_progress
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Timeline insert own" on public.batman_timeline_progress;
create policy "Timeline insert own"
on public.batman_timeline_progress
for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Timeline update own" on public.batman_timeline_progress;
create policy "Timeline update own"
on public.batman_timeline_progress
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
