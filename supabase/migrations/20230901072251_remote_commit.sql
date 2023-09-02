drop trigger if exists "push_alarm" on "public"."push_alarm";

alter table "public"."test_table" drop constraint "test_table_pkey";

drop index if exists "public"."test_table_pkey";

drop table "public"."test_table";

CREATE TRIGGER push_alarm AFTER INSERT ON public.push_alarm FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://vsxczbrqaodxzjsisivw.functions.supabase.co/push_alarm', 'POST', '{"Content-type":"application/json"}', '{}', '1000');


