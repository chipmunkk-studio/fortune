drop policy "Enable read access for all users" on "public"."app_update";

alter table "public"."app_update" add column "android" boolean default true;

alter table "public"."app_update" add column "ios" boolean default true;

create policy "Enable read access for all users"
on "public"."app_update"
as permissive
for select
to authenticated
using (true);



