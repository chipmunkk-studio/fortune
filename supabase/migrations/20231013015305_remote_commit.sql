drop policy "Enable read access for all users" on "public"."mission_reward_type";

alter table "public"."mission_reward_type" drop constraint "mission_reward_type_pkey";

drop index if exists "public"."mission_reward_type_pkey";

drop table "public"."mission_reward_type";


