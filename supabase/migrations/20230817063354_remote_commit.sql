alter table "public"."test_table" drop constraint "test_table_pkey";

drop index if exists "public"."test_table_pkey";

drop table "public"."test_table";


