-- Atomic score-merge RPC — avoids race conditions when several devices
-- save state simultaneously.  Instead of replacing the whole state blob,
-- this function merges ONLY the score keys that changed.
--
-- Called by saveScores() in index.html.

CREATE OR REPLACE FUNCTION public.merge_scores(
  p_scores     jsonb DEFAULT NULL,
  p_physical   jsonb DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  UPDATE public.event_state
  SET
    data =
      data
      || CASE WHEN p_scores IS NOT NULL
              THEN jsonb_build_object(
                     'scores',
                     COALESCE(data -> 'scores', '{}'::jsonb) || p_scores
                   )
              ELSE '{}'::jsonb
         END
      || CASE WHEN p_physical IS NOT NULL
              THEN jsonb_build_object(
                     'scoresPhysical',
                     COALESCE(data -> 'scoresPhysical', '{}'::jsonb) || p_physical
                   )
              ELSE '{}'::jsonb
         END,
    updated_at = now()
  WHERE id = 1;
END;
$$;

-- Grant execution to the anon / authenticated roles used by the JS client
GRANT EXECUTE ON FUNCTION public.merge_scores(jsonb, jsonb) TO anon;
GRANT EXECUTE ON FUNCTION public.merge_scores(jsonb, jsonb) TO authenticated;
