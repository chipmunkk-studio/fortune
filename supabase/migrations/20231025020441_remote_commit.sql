drop policy "Enable update for users based on email" on "public"."users";

create policy "Enable update for users based on email"
on "public"."users"
as permissive
for update
to authenticated
using (((auth.jwt() ->> 'email'::text) = email))
with check (true);



