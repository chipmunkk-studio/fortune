drop policy "Enable read access for all users" on "public"."country_info";

create policy "Enable read access for all users"
on "public"."country_info"
as permissive
for select
to public
using (true);



