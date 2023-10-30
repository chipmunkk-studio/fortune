alter table "public"."alarm_feeds" drop constraint "alarm_feeds_alarm_reward_history_fkey";

alter table "public"."missions" add column "deadline" date;

alter table "public"."notices" add column "is_pin" boolean default false;

alter table "public"."alarm_feeds" add constraint "alarm_feeds_alarm_reward_history_fkey" FOREIGN KEY (alarm_reward_history) REFERENCES alarm_reward_history(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."alarm_feeds" validate constraint "alarm_feeds_alarm_reward_history_fkey";

create policy "Enable delete for users based on user_id"
on "public"."alarm_reward_history"
as permissive
for delete
to authenticated
using (((auth.jwt() ->> 'email'::text) = ( SELECT users.email
   FROM users
  WHERE (users.id = alarm_reward_history.users))));



