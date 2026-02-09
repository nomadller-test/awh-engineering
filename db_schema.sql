-- 1. Create trip_events Table (if not exists)
create table if not exists trip_events (
  id text primary key,
  title text not null,
  description text,
  time text,
  icon text,
  status text default 'pending',
  count_check boolean default false,
  head_count_verified boolean default false,
  warning boolean default false,
  sort_order serial
);

-- 2. Create Students Table (if not exists)
create table if not exists students (
  id serial primary key,
  name text not null,
  is_checked_in boolean default false,
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- 3. Enable RLS and Policies for trip_events
alter table trip_events enable row level security;
drop policy if exists "Public Read" on trip_events;
drop policy if exists "Public Update" on trip_events;
drop policy if exists "Public Insert" on trip_events;
create policy "Public Read" on trip_events for select using (true);
create policy "Public Update" on trip_events for update using (true);
create policy "Public Insert" on trip_events for insert with check (true);

-- 4. Enable RLS and Policies for students
alter table students enable row level security;
drop policy if exists "Public Read Students" on students;
drop policy if exists "Public Update Students" on students;
drop policy if exists "Public Insert Students" on students;
create policy "Public Read Students" on students for select using (true);
create policy "Public Update Students" on students for update using (true);
create policy "Public Insert Students" on students for insert with check (true);

-- 5. Seed trip_events (Only if empty)
insert into trip_events (id, title, description, time, icon, status, count_check, head_count_verified, warning, sort_order)
select id, title, description, time, icon, status, count_check, head_count_verified, warning, sort_order
from (values
  ('trip_start', 'Trip Start: Agra', 'Taj Mahal & Agra Fort Visit', 'Feb 7', '🕌', 'pending', true, false, false, 1),
  ('agra_delhi', 'Transfer to Delhi', 'Evening transfer from Agra to Delhi', 'Feb 7', '🚌', 'pending', false, false, false, 2),
  ('delhi_sight_1', 'Delhi Sightseeing', 'Qutub Minar, India Gate, Jama Masjid', 'Feb 8', '🏛️', 'pending', false, false, false, 3),
  ('volvo_board', 'Boarding Volvo', 'Overnight journey to Manali', 'Feb 8', '🚌', 'pending', true, false, false, 4),
  ('manali_arrival', 'Reached Manali', 'Hotel Check-in & Relax', 'Feb 9', '🏨', 'pending', false, false, false, 5),
  ('manali_local', 'Manali Local', 'Hadimba Temple, Mall Road, Van Vihar', 'Feb 9', '🛍️', 'pending', false, false, false, 6),
  ('snow_point', 'Snow Adventure', 'Solang Valley, Atal Tunnel, Sissu', 'Feb 10', '❄️', 'pending', true, false, false, 7),
  ('kullu_rafting', 'Kullu Rafting', 'River Rafting in Kullu', 'Feb 11', '🌊', 'pending', false, false, false, 8),
  ('kasol_transfer', 'Grahan Trek Start', 'Move to Kasol & Trek to Grahan Village', 'Feb 11', '🥾', 'pending', true, false, false, 9),
  ('grahan_morning', 'Village Morning', 'Explore Grahan Village', 'Feb 12', '🌄', 'pending', false, false, false, 10),
  ('return_volvo', 'Return Journey', 'Trek down & Volvo to Delhi', 'Feb 12', '🚌', 'pending', true, false, false, 11),
  ('delhi_sight_2', 'Delhi Final Day', 'Akshardham, Lotus Temple, Shopping', 'Feb 13', '🕌', 'pending', false, false, false, 12),
  ('departure', 'Departure', 'Drop at Railway Station / Airport', 'Feb 14', '👋', 'pending', false, false, false, 13)
) as t(id, title, description, time, icon, status, count_check, head_count_verified, warning, sort_order)
where not exists (select 1 from trip_events limit 1);

-- 6. Seed Students (Only if empty)
insert into students (name)
select name from (values 
  ('Abdul Gafoor Nazem'), ('Ajnish P'), ('Aadith Kailas K'), ('Abhinav P'), 
  ('Adwaith Prasad'), ('Ashish A Jaison'), ('Diljith T'), ('Gayathry S'), 
  ('Hani Rafeeqi K. N'), ('Mohammed Hashil N. K'), ('Muhammed Inzamam C. P'), 
  ('Janeesh K. T'), ('Mariyam Hanan Javid'), ('Mishab V. N. K'), 
  ('Muhammed Nafid K. E'), ('Sabarish A. V'), ('Salman N. V'), 
  ('Shafah Muhammed Ummer'), ('Fathima Shifa'), ('Skandha Ramaswamy K. V'), 
  ('Abdul Vahid P. K'), ('Aysha Rana V. M'), ('Sreenandan K. M'), 
  ('Vishnupriya V. V'), ('Favas Moidutty C. K'), ('Mohammed Nabeel Najeeb'), 
  ('Nibin Nihad'), ('Shahna K'), ('Vaishnav V. K'), ('Arjun M'), 
  ('Abhishek M'), ('Nived T'), ('Fidha Fathima K'), ('Shameema Jaliyya V. P'), 
  ('Anamika S. R'), ('Asheekha Fathima E. K'), ('Saran S. P')
) as t(name)
where not exists (select 1 from students limit 1);

-- 7. Enable Realtime (Must be at the end so tables exist)
begin;
  drop publication if exists supabase_realtime;
  create publication supabase_realtime for table trip_events, students;
commit;