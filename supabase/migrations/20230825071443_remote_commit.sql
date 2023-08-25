create extension if not exists "wrappers" with schema "extensions";


drop trigger if exists "push_alarm" on "public"."push_alarm";

alter table "public"."push_alarm" drop constraint "push_alaram_pkey";

drop index if exists "public"."push_alaram_pkey";

alter table "public"."push_alarm" alter column "landing_route" set default 'alarmFeed'::text;

alter table "public"."push_alarm" alter column "landing_route" drop not null;

CREATE UNIQUE INDEX push_alarm_pkey ON public.push_alarm USING btree (id);

alter table "public"."push_alarm" add constraint "push_alarm_pkey" PRIMARY KEY using index "push_alarm_pkey";

CREATE TRIGGER push_alarm AFTER INSERT ON public.push_alarm FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://zctjjaievaizbprjjrvp.functions.supabase.co/push_alarm', 'POST', '{"Content-type":"application/json"}', '{}', '1000');


