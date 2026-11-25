insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'couple-photos',
  'couple-photos',
  true,
  8388608,
  array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
on conflict (id) do update
set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create table if not exists public.photos (
  object_path text primary key
    check (object_path ~ '^[0-9a-f-]{36}\.(jpg|jpeg|png|webp|gif)$'),
  alt text not null check (char_length(alt) <= 80),
  label text not null check (char_length(label) <= 80),
  created_at timestamptz not null default now()
);

alter table public.photos enable row level security;
grant select, insert on public.photos to anon, authenticated;

drop policy if exists "Anyone can view couple photos" on public.photos;
create policy "Anyone can view couple photos"
on public.photos for select
to anon, authenticated
using (true);

drop policy if exists "Anyone can add couple photos" on public.photos;
create policy "Anyone can add couple photos"
on public.photos for insert
to anon, authenticated
with check (char_length(alt) <= 80 and char_length(label) <= 80);

drop policy if exists "Anyone can upload couple photo files" on storage.objects;
create policy "Anyone can upload couple photo files"
on storage.objects for insert
to anon, authenticated
with check (
  bucket_id = 'couple-photos'
  and name ~ '^[0-9a-f-]{36}\.(jpg|jpeg|png|webp|gif)$'
);
