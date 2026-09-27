create extension if not exists "pgcrypto";
create table if not exists public.services(id uuid primary key default gen_random_uuid(),name text not null,description text,image_url text,active boolean default true,created_at timestamptz default now());
create table if not exists public.projects(id uuid primary key default gen_random_uuid(),name text not null,customer_name text,location text,work_type text,description text,cover_image text,status text not null default 'ongoing' check(status in ('ongoing','completed')),start_date date,completion_date date,total_amount numeric(12,2),created_at timestamptz default now());
create table if not exists public.media(id uuid primary key default gen_random_uuid(),project_id uuid references public.projects(id) on delete set null,type text not null check(type in ('photo','video')),title text,url text not null,thumbnail_url text,category text,created_at timestamptz default now());
create table if not exists public.workers(id uuid primary key default gen_random_uuid(),name text not null,phone text,role text,status text default 'active',joining_date date,notes text,created_at timestamptz default now());
create table if not exists public.worker_payments(id uuid primary key default gen_random_uuid(),worker_id uuid not null references public.workers(id) on delete cascade,project_id uuid references public.projects(id) on delete set null,amount numeric(12,2) not null check(amount>=0),payment_date date not null default current_date,payment_method text,notes text,created_at timestamptz default now());

alter table public.services enable row level security;
alter table public.projects enable row level security;
alter table public.media enable row level security;
alter table public.workers enable row level security;
alter table public.worker_payments enable row level security;

create policy "public read services" on public.services for select using(active=true);
create policy "public read projects" on public.projects for select using(true);
create policy "public read media" on public.media for select using(true);
create policy "manager services all" on public.services for all to authenticated using(true) with check(true);
create policy "manager projects all" on public.projects for all to authenticated using(true) with check(true);
create policy "manager media all" on public.media for all to authenticated using(true) with check(true);
create policy "manager workers all" on public.workers for all to authenticated using(true) with check(true);
create policy "manager payments all" on public.worker_payments for all to authenticated using(true) with check(true);

insert into storage.buckets(id,name,public) values('ak-media','ak-media',true) on conflict(id) do nothing;
create policy "public view ak media" on storage.objects for select using(bucket_id='ak-media');
create policy "authenticated upload ak media" on storage.objects for insert to authenticated with check(bucket_id='ak-media');
create policy "authenticated update ak media" on storage.objects for update to authenticated using(bucket_id='ak-media') with check(bucket_id='ak-media');
create policy "authenticated delete ak media" on storage.objects for delete to authenticated using(bucket_id='ak-media');

insert into public.services(name,description,image_url)
select * from (values
('Modular Kitchen','Custom kitchen carpentry and storage.','https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?auto=format&fit=crop&w=900&q=80'),
('Wardrobe','Built-to-fit wardrobes and storage.','https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=900&q=80'),
('Bedroom Interior','Comfortable bedroom spaces.','https://images.unsplash.com/photo-1616594039964-ae9021a400a0?auto=format&fit=crop&w=900&q=80'),
('TV Unit','Custom TV panels and furniture.','https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=900&q=80'),
('Wall Panel','Decorative wall panels.','https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=900&q=80'),
('Office Interior','Functional office interiors.','https://images.unsplash.com/photo-1497366811353-6870744d04b2?auto=format&fit=crop&w=900&q=80')
) v(name,description,image_url) where not exists(select 1 from public.services);
