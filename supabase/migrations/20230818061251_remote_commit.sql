drop trigger if exists "push_alarm" on "public"."push_alarm";

CREATE TRIGGER push_alarm AFTER INSERT ON public.push_alarm FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://zctjjaievaizbprjjrvp.functions.supabase.co/push_notice', 'POST', '{"Content-type":"application/json"}', '{}', '1000');


