create policy "Enable read access for all users"
on "public"."alarm_feed_type"
as permissive
for select
to authenticated
using (true);



