alter table "public"."obtain_histories" drop column "ingredient_name";

alter table "public"."obtain_histories" add column "en_ingredient_name" text not null default ''::text;

alter table "public"."obtain_histories" add column "kr_ingredient_name" text not null default ''::text;


