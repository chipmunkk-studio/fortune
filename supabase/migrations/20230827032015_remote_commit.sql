drop trigger if exists "push_alarm" on "public"."push_alarm";

CREATE TRIGGER push_alarm AFTER INSERT ON public.push_alarm FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://rzbeolugtzzcjmrecqbn.functions.supabase.co/push_alarm', 'POST', '{"Content-type":"application/json"}', '{}', '1000');


