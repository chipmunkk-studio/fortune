alter table "public"."alarm_feeds" add constraint "alarm_feeds_users_fkey" FOREIGN KEY (users) REFERENCES users(id) not valid;

alter table "public"."alarm_feeds" validate constraint "alarm_feeds_users_fkey";


