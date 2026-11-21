-- Ejecuta en Supabase > SQL Editor
create table visits(id bigint generated always as identity primary key, visitor_id uuid not null, is_returning boolean default false, source text default 'direct', user_agent text, created_at timestamptz default now());
create table intents(visitor_id uuid primary key, created_at timestamptz default now());  -- unicidad: 1 intención por navegador
create table attendance(id bigint generated always as identity primary key, event_date date not null, created_at timestamptz default now());
create table video_events(id bigint generated always as identity primary key, visitor_id uuid not null, event text not null check(event in('play','pause','ended')), created_at timestamptz default now());
alter table visits enable row level security; alter table intents enable row level security;
alter table attendance enable row level security; alter table video_events enable row level security;
-- El público SOLO puede insertar (nunca leer)
create policy p_ins on visits for insert to anon with check(true);
create policy p_ins on intents for insert to anon with check(true);
create policy p_ins on video_events for insert to anon with check(true);
-- Solo el admin autenticado lee y gestiona
create policy a_sel on visits for select to authenticated using(true);
create policy a_sel on intents for select to authenticated using(true);
create policy a_sel on video_events for select to authenticated using(true);
create policy a_all on attendance for all to authenticated using(true) with check(true);
-- IMPORTANTE: Authentication > Providers > Email: desactiva "Allow new users to sign up"
-- y crea manualmente tu usuario admin en Authentication > Users.
