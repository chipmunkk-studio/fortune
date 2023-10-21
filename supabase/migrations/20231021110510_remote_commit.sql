drop policy "Enable delete for users based on user_id" on "public"."alarm_feeds";

drop policy "Enable insert for authenticated users only" on "public"."alarm_feeds";

drop policy "Enable read access for all users" on "public"."alarm_feeds";

drop policy "Enable update for users based on email" on "public"."alarm_feeds";

drop policy "Enable insert for authenticated users only" on "public"."alarm_reward_history";

drop policy "Enable read access for all users" on "public"."alarm_reward_history";

drop policy "Enable update for users based on email" on "public"."alarm_reward_history";

drop policy "인증받은 유저들만 추가 가능." on "public"."ingredients";

drop policy "Enable read access for all users" on "public"."obtain_histories";

drop policy "인증받은 유저들만 insert" on "public"."markers";

drop policy "Enable update for users based on email" on "public"."missions";

drop policy "인증받은 유저들만 삽입 가능." on "public"."obtain_histories";

drop policy "인증받은 유저들만 읽기 가능." on "public"."obtain_histories";

drop policy "Enable delete for users based on user_id" on "public"."users";

drop policy "Enable update for users based on email" on "public"."users";

create policy "본인의 알람만 삭제 가능."
on "public"."alarm_feeds"
as permissive
for delete
to authenticated
using (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = alarm_feeds.users))));


create policy "본인의 알람만 업데이트 가능 "
on "public"."alarm_feeds"
as permissive
for update
to authenticated
using (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = alarm_feeds.users))))
with check (true);


create policy "본인의 알람만 조회 가능. "
on "public"."alarm_feeds"
as permissive
for select
to authenticated
using (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = alarm_feeds.users))));


create policy "본인의 알람만 추가 가능."
on "public"."alarm_feeds"
as permissive
for insert
to authenticated
with check (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = alarm_feeds.users))));


create policy "본인의 알람 히스토리만 수정 가능. "
on "public"."alarm_reward_history"
as permissive
for update
to authenticated
using (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = alarm_reward_history.users))))
with check (true);


create policy "본인의 알람 히스토리만 조회 가능. "
on "public"."alarm_reward_history"
as permissive
for select
to authenticated
using (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = alarm_reward_history.users))));


create policy "본인의 알람 히스토리만 추가 가능."
on "public"."alarm_reward_history"
as permissive
for insert
to authenticated
with check (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = alarm_reward_history.users))));


create policy "서버에서만 추가 가능. "
on "public"."ingredients"
as permissive
for insert
to service_role
with check (true);


create policy "본인의 히스토리만 삭제."
on "public"."obtain_histories"
as permissive
for delete
to authenticated
using (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = obtain_histories."user"))));


create policy "인증받은 유저들만 insert"
on "public"."markers"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable update for users based on email"
on "public"."missions"
as permissive
for update
to service_role
using (true)
with check (true);


create policy "인증받은 유저들만 삽입 가능."
on "public"."obtain_histories"
as permissive
for insert
to authenticated
with check (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = obtain_histories."user"))));


create policy "인증받은 유저들만 읽기 가능."
on "public"."obtain_histories"
as permissive
for select
to authenticated
using (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = obtain_histories."user"))));


create policy "Enable delete for users based on user_id"
on "public"."users"
as permissive
for delete
to service_role
using (true);


create policy "Enable update for users based on email"
on "public"."users"
as permissive
for update
to authenticated, anon
using (((auth.jwt() ->> 'email'::text) = email))
with check (true);



