-- Generic top-level patch: merges only the provided keys into data,
-- leaving all other keys untouched.
-- Used for targeted saves (timer, config, leaderboard…) to prevent
-- one device overwriting another device's fields.

CREATE OR REPLACE FUNCTION public.save_state_patch(p_patch jsonb)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE public.event_state
  SET data       = data || p_patch,
      updated_at = now()
  WHERE id = 1;
END;
$$;

GRANT EXECUTE ON FUNCTION public.save_state_patch(jsonb) TO anon;
GRANT EXECUTE ON FUNCTION public.save_state_patch(jsonb) TO authenticated;
