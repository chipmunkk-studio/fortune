alter table "public"."ingredient_image" add column "type" text default 'webp'::text;

create policy "Enable read access for all users"
on "public"."ingredient_image"
as permissive
for select
to authenticated
using (true);



