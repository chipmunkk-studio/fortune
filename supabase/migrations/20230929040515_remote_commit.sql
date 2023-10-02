alter table "public"."mission_clear_user" drop constraint "mission_clear_user_users_fkey";

alter table "public"."missions" drop constraint "missions_title_key";

drop index if exists "public"."missions_title_key";

alter table "public"."faqs" drop column "content";

alter table "public"."faqs" drop column "title";

alter table "public"."faqs" add column "en_content" text not null default ''::text;

alter table "public"."faqs" add column "en_title" text not null default ''::text;

alter table "public"."faqs" add column "kr_content" text not null default ''::text;

alter table "public"."faqs" add column "kr_title" text not null default ''::text;

alter table "public"."ingredients" drop column "name";

alter table "public"."ingredients" add column "en_name" text not null default ''::text;

alter table "public"."ingredients" add column "kr_name" text not null;

alter table "public"."mission_clear_user" add column "note" text not null default ''::text;

alter table "public"."mission_reward" drop column "note";

alter table "public"."mission_reward" drop column "reward_name";

alter table "public"."mission_reward" add column "en_note" text not null default ''::text;

alter table "public"."mission_reward" add column "en_reward_name" text not null default ''::text;

alter table "public"."mission_reward" add column "kr_note" text default ''::text;

alter table "public"."mission_reward" add column "kr_reward_name" text default ''::text;

alter table "public"."missions" drop column "content";

alter table "public"."missions" drop column "note";

alter table "public"."missions" drop column "title";

alter table "public"."missions" add column "en_content" text not null default ''::text;

alter table "public"."missions" add column "en_note" text not null default ''::text;

alter table "public"."missions" add column "en_title" text not null default ''::text;

alter table "public"."missions" add column "kr_content" text not null default ''::text;

alter table "public"."missions" add column "kr_note" text default ''::text;

alter table "public"."missions" add column "kr_title" text not null default ''::text;

alter table "public"."notices" drop column "content";

alter table "public"."notices" drop column "title";

alter table "public"."notices" add column "en_content" text not null default ''::text;

alter table "public"."notices" add column "en_title" text not null default ''::text;

alter table "public"."notices" add column "kr_content" text not null default ''::text;

alter table "public"."notices" add column "kr_title" text not null default ''::text;

alter table "public"."terms" drop column "content";

alter table "public"."terms" drop column "title";

alter table "public"."terms" add column "en_content" text not null default ''::text;

alter table "public"."terms" add column "en_title" text not null default ''::text;

alter table "public"."terms" add column "kr_content" text;

alter table "public"."terms" add column "kr_title" text;

CREATE UNIQUE INDEX missions_title_key ON public.missions USING btree (kr_title);

alter table "public"."mission_clear_user" add constraint "mission_clear_user_users_fkey" FOREIGN KEY (users) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."mission_clear_user" validate constraint "mission_clear_user_users_fkey";

alter table "public"."missions" add constraint "missions_title_key" UNIQUE using index "missions_title_key";


