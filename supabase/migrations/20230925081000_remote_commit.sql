alter table "public"."users" add column "created_at" timestamp with time zone not null default now();

alter table "public"."users" add column "is_withdrawal" boolean default false;

alter table "public"."users" add column "withdrawal_at" timestamp with time zone;

create policy "Enable delete for users based on user_id"
on "public"."users"
as permissive
for delete
to authenticated
using (true);



