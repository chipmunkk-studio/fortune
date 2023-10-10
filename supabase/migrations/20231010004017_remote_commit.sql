drop policy "앱의 키를 갖고 있거나 인증받은 사용자라면 조" on "public"."users";

drop policy "인증되지 않은 사용자라도 가입되게 함." on "public"."users";

drop policy "앱을 사용하는 모든 유저는 읽을 수 있음." on "public"."terms";

alter table "public"."users" drop constraint "user_phone_key";

alter table "public"."users" drop constraint "users_country_info_fkey";

drop index if exists "public"."user_phone_key";

alter table "public"."users" drop column "country_info";

alter table "public"."users" drop column "phone";

alter table "public"."users" add column "email" text not null default ''::text;

create policy "인증된 사용자만 가입. "
on "public"."users"
as permissive
for insert
to authenticated
with check (true);


create policy "조회"
on "public"."users"
as permissive
for select
to anon, authenticated
using (true);


create policy "앱을 사용하는 모든 유저는 읽을 수 있음."
on "public"."terms"
as permissive
for select
to anon, authenticated
using (true);



