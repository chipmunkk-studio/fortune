alter table "public"."alarm_feeds" drop constraint "alarm_feeds_alarm_reward_history_fkey";

alter table "public"."alarm_feeds" drop constraint "alarm_feeds_users_fkey";

alter table "public"."alarm_reward_history" drop constraint "alarm_reward_history_alarm_reward_info_fkey";

alter table "public"."alarm_reward_history" drop constraint "alarm_reward_history_ingredients_fkey";

alter table "public"."ingredients" drop constraint "ingredients_image_url_fkey";

alter table "public"."ingredients" drop constraint "ingredients_type_fkey";

alter table "public"."markers" drop constraint "markers_ingredients_fkey";

alter table "public"."mission_clear_conditions" drop constraint "mission_clear_conditions_ingredients_fkey";

alter table "public"."mission_clear_conditions" drop constraint "mission_clear_conditions_missions_fkey";

alter table "public"."mission_clear_user" drop constraint "mission_clear_user_missions_fkey";

alter table "public"."missions" drop constraint "missions_mission_reward_fkey";

alter table "public"."ingredients" alter column "type" drop default;

alter table "public"."alarm_feeds" add constraint "alarm_feeds_alarm_reward_history_fkey" FOREIGN KEY (alarm_reward_history) REFERENCES alarm_reward_history(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."alarm_feeds" validate constraint "alarm_feeds_alarm_reward_history_fkey";

alter table "public"."alarm_feeds" add constraint "alarm_feeds_users_fkey" FOREIGN KEY (users) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."alarm_feeds" validate constraint "alarm_feeds_users_fkey";

alter table "public"."alarm_reward_history" add constraint "alarm_reward_history_alarm_reward_info_fkey" FOREIGN KEY (alarm_reward_info) REFERENCES alarm_reward_info(id) ON UPDATE CASCADE not valid;

alter table "public"."alarm_reward_history" validate constraint "alarm_reward_history_alarm_reward_info_fkey";

alter table "public"."alarm_reward_history" add constraint "alarm_reward_history_ingredients_fkey" FOREIGN KEY (ingredients) REFERENCES ingredients(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."alarm_reward_history" validate constraint "alarm_reward_history_ingredients_fkey";

alter table "public"."ingredients" add constraint "ingredients_image_url_fkey" FOREIGN KEY (image_url) REFERENCES ingredient_image(image_url) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."ingredients" validate constraint "ingredients_image_url_fkey";

alter table "public"."ingredients" add constraint "ingredients_type_fkey" FOREIGN KEY (type) REFERENCES ingredient_type(name) ON UPDATE CASCADE not valid;

alter table "public"."ingredients" validate constraint "ingredients_type_fkey";

alter table "public"."markers" add constraint "markers_ingredients_fkey" FOREIGN KEY (ingredients) REFERENCES ingredients(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."markers" validate constraint "markers_ingredients_fkey";

alter table "public"."mission_clear_conditions" add constraint "mission_clear_conditions_ingredients_fkey" FOREIGN KEY (ingredients) REFERENCES ingredients(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."mission_clear_conditions" validate constraint "mission_clear_conditions_ingredients_fkey";

alter table "public"."mission_clear_conditions" add constraint "mission_clear_conditions_missions_fkey" FOREIGN KEY (missions) REFERENCES missions(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."mission_clear_conditions" validate constraint "mission_clear_conditions_missions_fkey";

alter table "public"."mission_clear_user" add constraint "mission_clear_user_missions_fkey" FOREIGN KEY (missions) REFERENCES missions(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."mission_clear_user" validate constraint "mission_clear_user_missions_fkey";

alter table "public"."missions" add constraint "missions_mission_reward_fkey" FOREIGN KEY (mission_reward) REFERENCES mission_reward(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."missions" validate constraint "missions_mission_reward_fkey";


