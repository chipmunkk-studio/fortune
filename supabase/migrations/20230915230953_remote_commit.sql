create table "public"."faqs" (
    "id" bigint generated by default as identity not null,
    "title" text not null default ''::text,
    "content" text not null default ''::text,
    "created_at" timestamp with time zone not null default now()
);


alter table "public"."faqs" enable row level security;

create table "public"."notices" (
    "id" bigint generated by default as identity not null,
    "title" text not null default ''::text,
    "content" text not null default ''::text,
    "created_at" timestamp with time zone not null default now()
);


alter table "public"."notices" enable row level security;

CREATE UNIQUE INDEX faq_pkey ON public.faqs USING btree (id);

CREATE UNIQUE INDEX notices_pkey ON public.notices USING btree (id);

alter table "public"."faqs" add constraint "faq_pkey" PRIMARY KEY using index "faq_pkey";

alter table "public"."notices" add constraint "notices_pkey" PRIMARY KEY using index "notices_pkey";

create policy "Enable read access for all users"
on "public"."faqs"
as permissive
for select
to authenticated
using (true);


create policy "Enable read access for all users"
on "public"."notices"
as permissive
for select
to authenticated
using (true);



