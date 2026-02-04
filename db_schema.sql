-- Create the table
create table trip_events (
  id text primary key,
  title text not null,
  description text,
  time text,
  icon text,
  status text default 'pending', -- pending, active, completed
  count_check boolean default false,
  head_count_verified boolean default false,
  warning boolean default false,
  sort_order serial
);

-- Turn on security
alter table trip_events enable row level security;

-- Allow public access (for demo simplicity)
create policy "Public Read" on trip_events for select using (true);
create policy "Public Update" on trip_events for update using (true);
create policy "Public Insert" on trip_events for insert with check (true);

-- Insert Default Data (8-Day Itinerary)
insert into trip_events (id, title, description, time, icon, status, count_check, head_count_verified, warning, sort_order) values
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
('departure', 'Departure', 'Drop at Railway Station / Airport', 'Feb 14', '👋', 'pending', false, false, false, 13);

-- Enable Realtime
begin;
  drop publication if exists supabase_realtime;
  create publication supabase_realtime for table trip_events;
commit;