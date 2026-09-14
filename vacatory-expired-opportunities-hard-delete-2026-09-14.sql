-- Vacatory canonical cleanup applied to Supabase project vac-attack (qusyglgevgyjaoasmjhz).
-- Date applied: 14 September 2026.
--
-- Purpose:
--   Permanently remove expired events, expired application/deadline cycles,
--   expired scholarships and rows in the expired-opportunity archive.
--   Vacatory no longer keeps an archive of old opportunities.
--
-- Post-apply verification returned:
--   remaining_expired_career_cycles = 0
--   remaining_expired_firm_cycles = 0
--   remaining_expired_scholarships = 0
--   remaining_expired_archive_rows = 0

begin;

create temp table _expired_career_cycles on commit drop as
with params as (select date '2026-09-14' as today)
select c.id, c.opportunity_id
from career_opportunity_cycles c
join career_opportunities o on o.id = c.opportunity_id
join opportunity_types ot on ot.id = o.opportunity_type_id
cross join params p
where c.active is not false
  and (
    c.closes_on < p.today
    or (
      ot.slug in ('open_day', 'insight_programme', 'scholarship_bursary')
      and coalesce(c.programme_ends_on, c.programme_starts_on) < p.today
    )
    or lower(coalesce(c.source_status, '')) in ('archived', 'expired', 'historic')
    or (
      lower(coalesce(c.source_status, '')) = 'closed'
      and c.closes_on is null
      and coalesce(c.programme_ends_on, c.programme_starts_on) is null
    )
  );

create temp table _expired_firm_cycles on commit drop as
with params as (select date '2026-09-14' as today)
select c.id, c.programme_id
from firm_programme_cycles c
join firm_programmes fp on fp.id = c.programme_id
cross join params p
where c.active is not false
  and (
    c.closes_on < p.today
    or coalesce(c.programme_ends_on, c.programme_starts_on) < p.today
    or lower(coalesce(c.application_status, '')) in ('archived', 'expired', 'historic')
    or lower(coalesce(c.current_status, '')) in ('archived', 'expired', 'historic')
    or (
      (
        lower(coalesce(c.application_status, '')) = 'closed'
        or lower(coalesce(c.current_status, '')) = 'closed'
      )
      and c.closes_on is null
      and coalesce(c.programme_ends_on, c.programme_starts_on) is null
    )
  );

create temp table _expired_scholarships on commit drop as
with params as (select date '2026-09-14' as today)
select fs.id
from firm_scholarships fs
cross join params p
where fs.application_deadline < p.today
   or lower(coalesce(fs.status, '')) in ('archived', 'expired', 'historic')
   or (
     lower(coalesce(fs.status, '')) = 'closed'
     and fs.application_deadline is null
   );

create temp table _career_opportunities_to_delete on commit drop as
with params as (select date '2026-09-14' as today)
select o.id
from career_opportunities o
where (
  o.active is false
  or o.published is false
  or lower(coalesce(o.public_variant_kind, '')) = 'archived'
  or exists (select 1 from _expired_career_cycles ec where ec.opportunity_id = o.id)
)
and not exists (
  select 1
  from career_opportunity_cycles c
  cross join params p
  where c.opportunity_id = o.id
    and c.id not in (select id from _expired_career_cycles)
    and c.active is not false
    and (
      c.closes_on >= p.today
      or coalesce(c.programme_ends_on, c.programme_starts_on) >= p.today
      or c.closes_on is null
    )
);

create temp table _firm_programmes_to_delete on commit drop as
with params as (select date '2026-09-14' as today)
select fp.id
from firm_programmes fp
where (
  fp.active is false
  or lower(coalesce(fp.status, '')) in ('archived', 'expired', 'historic', 'completed')
  or exists (select 1 from _expired_firm_cycles ef where ef.programme_id = fp.id)
)
and not exists (
  select 1
  from firm_programme_cycles c
  cross join params p
  where c.programme_id = fp.id
    and c.id not in (select id from _expired_firm_cycles)
    and c.active is not false
    and (
      c.closes_on >= p.today
      or coalesce(c.programme_ends_on, c.programme_starts_on) >= p.today
      or c.closes_on is null
    )
);

delete from career_opportunity_compensation_identity_stage
where career_opportunity_id in (select id from _career_opportunities_to_delete)
   or career_opportunity_cycle_id in (select id from _expired_career_cycles);

delete from career_opportunity_cycle_identity_stage
where career_opportunity_id in (select id from _career_opportunities_to_delete)
   or career_opportunity_cycle_id in (select id from _expired_career_cycles);

delete from career_opportunity_identity_stage
where career_opportunity_id in (select id from _career_opportunities_to_delete);

delete from career_opportunity_cycles
where id in (select id from _expired_career_cycles);

delete from career_opportunities
where id in (select id from _career_opportunities_to_delete);

delete from firm_programme_cycles
where id in (select id from _expired_firm_cycles);

delete from firm_programmes
where id in (select id from _firm_programmes_to_delete);

delete from firm_scholarships
where id in (select id from _expired_scholarships);

delete from vacatory_expired_opportunity_archive;

commit;

