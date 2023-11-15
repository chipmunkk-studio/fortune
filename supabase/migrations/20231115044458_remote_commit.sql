alter table "public"."app_update" add column "min_version_code" bigint not null default '0'::bigint;

alter table "public"."app_update" add column "min_version" text default ''::text;


