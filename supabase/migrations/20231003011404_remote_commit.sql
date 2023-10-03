create table "public"."personal_info" (
    "id" bigint generated by default as identity not null,
    "kr_title" text,
    "kr_content" text,
    "en_title" text not null default ''::text,
    "en_content" text not null default ''::text,
    "created_at" timestamp with time zone default now()
);


alter table "public"."personal_info" enable row level security;

CREATE UNIQUE INDEX personal_info_pkey ON public.personal_info USING btree (id);

alter table "public"."personal_info" add constraint "personal_info_pkey" PRIMARY KEY using index "personal_info_pkey";


