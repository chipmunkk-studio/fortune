drop policy "인증받은 유저들만 읽기 가능." on "public"."obtain_histories";

create policy "인증받은 유저들만 읽기 가능."
on "public"."obtain_histories"
as permissive
for select
to authenticated
using (true);



