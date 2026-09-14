-- HSFK Hong Kong 2027 Vacation Scheme deadline refresh.
-- Official sources checked: 14 September 2026.
-- HSFK programme page: https://careers.hsfkramer.com/global/en/hong-kong/early-careers/vacation-schemes
-- Application page: https://apply.candidats.io/906775c0-8735-4381-bd57-95a74359098c
-- Candidats publishes the exact application deadline as Friday 1 January 2027 at 15:59 UTC.

begin;

update public.firm_programmes programme
set programme_name = 'Hong Kong - 2027 Hong Kong Vacation Scheme',
    exact_official_name = '2027 Hong Kong Vacation Scheme',
    status = 'current',
    current_status = 'open',
    active = true,
    published = true,
    application_date_summary = 'Applications are open and close on Friday 1 January 2027 at 15:59 UTC.',
    programme_date_summary = 'Two four-week summer schemes run in June and July 2027.',
    date_status_note = 'Official HSFK and Candidats application pages checked 14 September 2026. Candidats publishes the exact deadline as Friday 1 January 2027 at 15:59 UTC.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/vacation-schemes',
    application_url = 'https://apply.candidats.io/906775c0-8735-4381-bd57-95a74359098c',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-01',
    updated_at = now()
from public.firms firm
where programme.firm_id = firm.id
  and firm.slug = 'herbert-smith-freehills'
  and programme.slug = 'hong-kong-vacation-schemes';

with programme as (
  select fp.id as programme_id
  from public.firm_programmes fp
  join public.firms f on f.id = fp.firm_id
  where f.slug = 'herbert-smith-freehills'
    and fp.slug = 'hong-kong-vacation-schemes'
)
insert into public.firm_programme_cycles (
  programme_id,
  cycle_label,
  application_year,
  programme_year,
  application_model,
  opens_on,
  closes_on,
  closes_at,
  closes_timezone,
  programme_dates_text,
  application_status,
  application_status_note,
  duration_text,
  eligibility,
  application_process,
  programme_structure,
  visa_sponsorship,
  active,
  research_checked_on,
  current_status,
  source_freshness,
  date_precision,
  source_url,
  application_url,
  full_application_stages,
  assessments,
  updated_at
)
select
  programme_id,
  '2027 Hong Kong Vacation Scheme',
  2026,
  2027,
  'fixed_deadline',
  null,
  date '2027-01-01',
  time '15:59',
  'UTC',
  'Two four-week summer schemes run in June and July 2027.',
  'open',
  'Applications are open and close on Friday 1 January 2027 at 15:59 UTC.',
  'Four weeks',
  jsonb_build_object('summary', 'Penultimate- or final-year LLB, JD or common-law degree students. Strong academics, commercial law interest, English and Mandarin communication skills. HK Student Visa candidates will be considered.'),
  jsonb_build_array('Apply through the Candidats application page. Shortlisted candidates complete the HSFK Hong Kong selection process; interviews are rolling, so students should apply early.'),
  jsonb_build_array('Two summer vacation schemes in June and July, each four weeks long. Participants undertake real client work, workshops, presentations and social events, and are interviewed for a 2029 training contract at the end of the scheme.'),
  jsonb_build_object('summary', 'Candidats page states HK Student Visa candidates will be considered.'),
  true,
  date '2026-09-14',
  'open',
  'verified',
  'exact_deadline',
  'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/vacation-schemes',
  'https://apply.candidats.io/906775c0-8735-4381-bd57-95a74359098c',
  '[]'::jsonb,
  '[]'::jsonb,
  now()
from programme
where not exists (
  select 1
  from public.firm_programme_cycles existing
  where existing.programme_id = programme.programme_id
    and existing.cycle_label = '2027 Hong Kong Vacation Scheme'
);

update public.career_opportunities opportunity
set official_name = '2027 Hong Kong Vacation Scheme',
    public_name = 'Hong Kong Vacation Scheme',
    official_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/vacation-schemes',
    application_url = 'https://apply.candidats.io/906775c0-8735-4381-bd57-95a74359098c',
    active = true,
    published = true,
    canonical_public_suppressed = false,
    canonical_public_suppression_reason = null,
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-01',
    updated_at = now()
from public.legal_organisations organisation
where opportunity.organisation_id = organisation.id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-vacation-schemes';

update public.career_opportunity_cycles cycle
set cycle_key = '2027-hong-kong-vacation-scheme',
    cycle_label = '2027 Hong Kong Vacation Scheme',
    application_year = 2026,
    programme_year = 2027,
    application_model = 'fixed_deadline',
    opens_on = null,
    closes_on = date '2027-01-01',
    closes_at = time '15:59',
    closes_timezone = 'UTC',
    date_precision = 'exact',
    source_status = 'verified',
    application_dates_text = 'Applications are open and close on Friday 1 January 2027 at 15:59 UTC.',
    programme_dates_text = 'Two four-week summer schemes run in June and July 2027.',
    duration_text = 'Four weeks',
    audience_text = 'Penultimate- or final-year LLB, JD or common-law degree students interested in Hong Kong vacation scheme and 2029 training contract route.',
    study_stage_text = 'Penultimate- or final-year LLB, JD or common-law degree students.',
    eligibility_text = 'Penultimate- or final-year LLB, JD or common-law degree students. Strong academic performance, commercial law interest, legal research, analytical and problem-solving skills, English and Mandarin communication skills. HK Student Visa candidates will be considered.',
    application_process_text = 'Apply through the Candidats application page. HSFK says interviews are rolling, so students should apply early.',
    progression_route_text = 'Vacation scheme students are interviewed for a 2029 training contract at the end of the scheme; HSFK says most Hong Kong training contracts are issued via the vacation scheme route.',
    official_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/vacation-schemes',
    application_url = 'https://apply.candidats.io/906775c0-8735-4381-bd57-95a74359098c',
    active = true,
    research_checked_on = date '2026-09-14',
    updated_at = now()
from public.career_opportunities opportunity
join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
where cycle.opportunity_id = opportunity.id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-vacation-schemes'
  and cycle.cycle_key in ('official-2026-09-08:2027', '2027-hong-kong-vacation-scheme');

-- Delete stale inactive 2026 closed cycle material rather than archiving it.
delete from public.career_opportunity_cycle_identity_stage identity_stage
using public.career_opportunity_cycles cycle,
      public.career_opportunities opportunity,
      public.legal_organisations organisation
where identity_stage.career_opportunity_cycle_id = cycle.id
  and cycle.opportunity_id = opportunity.id
  and opportunity.organisation_id = organisation.id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-vacation-schemes'
  and cycle.source_status = 'closed'
  and cycle.active = false;

delete from public.career_opportunity_cycles cycle
using public.career_opportunities opportunity,
      public.legal_organisations organisation
where cycle.opportunity_id = opportunity.id
  and opportunity.organisation_id = organisation.id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-vacation-schemes'
  and cycle.source_status = 'closed'
  and cycle.active = false;

commit;

-- Verification.
select opportunity.slug,
       cycle.cycle_key,
       cycle.closes_on,
       cycle.closes_at,
       cycle.closes_timezone,
       cycle.application_dates_text,
       cycle.active
from public.career_opportunities opportunity
join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
join public.career_opportunity_cycles cycle on cycle.opportunity_id = opportunity.id
where organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-vacation-schemes'
order by cycle.active desc, cycle.updated_at desc;
