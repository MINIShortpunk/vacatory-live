-- Vacatory canonical firm update
-- Date applied: 2026-09-14
-- Purpose: add three missing The Lawyer UK 200 firms and refresh the stored UK 200 rank order.
-- Sources checked:
-- - https://www.thelawyer.com/company/hogan-lovells-cadwalader/
-- - https://www.thelawyer.com/company/norton-rose-fulbright/
-- - https://www.thelawyer.com/company/shakespeare-martineau/

-- Added/updated firms:
-- Hogan Lovells Cadwalader — UK 200 rank #6
-- Norton Rose Fulbright — UK 200 rank #7
-- Shakespeare Martineau (Ampa) — UK 200 rank #47

-- Logo assets expected:
-- /assets/firms/hoganlovellscadwallader.png
-- /assets/firms/nortonrosefulbright.png
-- /assets/firms/shakespeare-martineau.jpg

-- The live Supabase update was applied directly in project vac-attack (qusyglgevgyjaoasmjhz).
-- This file records the canonical change for source-control backup.

with new_firms as (
  select * from (values
    ('Hogan Lovells Cadwalader','Hogan Lovells Cadwalader','hogan-lovells-cadwalader',6,'https://vacatory.com/assets/firms/hoganlovellscadwallader.png?v=20260914-official1','https://www.thelawyer.com/company/hogan-lovells-cadwalader/'),
    ('Norton Rose Fulbright','Norton Rose Fulbright','norton-rose-fulbright',7,'https://vacatory.com/assets/firms/nortonrosefulbright.png?v=20260914-official1','https://www.thelawyer.com/company/norton-rose-fulbright/'),
    ('Shakespeare Martineau (Ampa)','Shakespeare Martineau','shakespeare-martineau',47,'https://vacatory.com/assets/firms/shakespeare-martineau.jpg?v=20260914-official1','https://www.thelawyer.com/company/shakespeare-martineau/')
  ) as v(name, short_name, slug, uk_rank, logo_url, source_url)
)
select * from new_firms;

-- Stored UK 200 rank values were refreshed against the current 2026 The Lawyer UK 200 order
-- for the active Vacatory firm set, including retained out-of-top-50 firms:
-- Penningtons Manches Cooper #52, Stewarts #55, Foot Anstey #71.
