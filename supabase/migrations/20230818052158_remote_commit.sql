alter table "public"."missions" drop constraint "missions_markers_fkey";

alter table "public"."mission_clear_conditions" add column "markers" bigint;

alter table "public"."missions" drop column "markers";

alter table "public"."mission_clear_conditions" add constraint "mission_clear_conditions_markers_fkey" FOREIGN KEY (markers) REFERENCES markers(id) ON DELETE SET NULL not valid;

alter table "public"."mission_clear_conditions" validate constraint "mission_clear_conditions_markers_fkey";


