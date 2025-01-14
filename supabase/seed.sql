-- create the tables
create table theme (
    id bigint generated by default as identity primary key,
    updated_at timestamp with time zone,
    name text unique not null,
    description text
);

CREATE TYPE source_type_enum AS ENUM ('url', 'stored', 'flickr');
create table image (
    id bigint generated by default as identity primary key,
    theme_id bigint not null references public.theme,
    updated_at timestamp with time zone,
    source_type source_type_enum not null,
    source jsonb not null,
    location geography(POINT) not null,
    description text
);

-- add the spatial index
create index image_geo_index
  on public.images
  using GIST (location);

create or replace function images_in_theme(themeid bigint)
returns setof record
language sql
as $$
  select id, theme_id, source_type, source, st_astext(location) as location, description
  from public.image
  where theme_id = themeid;
$$;

-- RLS stuff
alter table theme enable row level security;
create policy "Profiles are viewable by everyone"
on theme for select
to authenticated, anon
using ( true );

alter table image enable row level security;
create policy "Profiles are viewable by everyone"
on image for select
to authenticated, anon
using ( true );