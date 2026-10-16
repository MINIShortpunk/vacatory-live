-- Canonical audit of all 50 chambers names against their official websites.
-- Checked 2026-10-15. Official brand names (including 11KBW, 4PB and
-- 6KBW College Hill) are intentionally preserved where the chambers itself
-- uses that form. Correct the one definite spelling/punctuation discrepancy.

begin;

update public.legal_organisations
set name = '12 King''s Bench Walk',
    short_name = '12 King''s Bench Walk',
    updated_at = now()
where id = '8e22970d-549a-413b-b3ba-961efe89ac1b'
  and name = '12 Kings Bench Walk';

do $$
begin
  if not exists (
    select 1
    from public.legal_organisations
    where id = '8e22970d-549a-413b-b3ba-961efe89ac1b'
      and name = '12 King''s Bench Walk'
      and short_name = '12 King''s Bench Walk'
  ) then
    raise exception '12 King''s Bench Walk canonical-name correction failed';
  end if;
end
$$;

commit;
