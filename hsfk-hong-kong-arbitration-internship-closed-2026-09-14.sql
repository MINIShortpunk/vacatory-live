-- HSFK Hong Kong International Arbitration Internship closed-route refresh.
-- Official source checked: 14 September 2026.
-- Source: https://careers.hsfkramer.com/global/en/hong-kong/early-careers/arbitration-internship
-- The official page says applications for the 2027 Hong Kong International Arbitration internship have now closed.
-- No future application deadline is published, so no active deadline is stored.

begin;

insert into public.firm_programmes (
  firm_id,
  organisation_id,
  slug,
  programme_name,
  programme_type,
  location_text,
  country_text,
  delivery_mode,
  career_stage,
  description,
  duration_text,
  active,
  published,
  status,
  status_note,
  application_url,
  primary_source_url,
  research_checked_on,
  next_review_on,
  display_order,
  exact_official_name,
  opportunity_level,
  audience_text,
  eligible_study_stage,
  student_priority,
  current_status,
  scope_status,
  application_date_summary,
  programme_date_summary,
  date_precision,
  date_status_note,
  updated_at
)
values (
  '460bf4d2-5594-4a84-958a-07748c328c74',
  '460bf4d2-5594-4a84-958a-07748c328c74',
  'hong-kong-international-arbitration-internship',
  'Hong Kong - International Arbitration Internship',
  'international_internship',
  'Hong Kong',
  'Hong Kong',
  'in_person',
  'Undergraduate and postgraduate students / graduates not yet admitted to practice',
  'Three-month, full-time arbitration internship in the Hong Kong office, offering grounding in the legal and commercial aspects of international arbitration with mentorship from arbitration lawyers.',
  'Three months',
  true,
  true,
  'current',
  'Applications for the 2027 Hong Kong International Arbitration internship have now closed.',
  'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/arbitration-internship',
  'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/arbitration-internship',
  date '2026-09-14',
  date '2026-11-01',
  500,
  'International arbitration internship',
  'internship',
  'Ambitious undergraduate and postgraduate students who have not yet been admitted to practice and are interested in an arbitration-focused career.',
  'Undergraduate and postgraduate students, or graduates who are not yet admitted to practice in a civil or common law jurisdiction.',
  true,
  'closed',
  'global',
  'Applications for the 2027 Hong Kong International Arbitration internship have now closed. Next dates have not yet been published.',
  'Three-month, full-time internship; applicants should state availability for the internship period on the application form.',
  'not_announced',
  'Official page checked 14 September 2026. The page says applications for the 2027 Hong Kong International Arbitration internship have now closed and does not publish the next application dates.',
  now()
)
on conflict (firm_id, slug) do update set
  programme_name = excluded.programme_name,
  programme_type = excluded.programme_type,
  location_text = excluded.location_text,
  country_text = excluded.country_text,
  delivery_mode = excluded.delivery_mode,
  career_stage = excluded.career_stage,
  description = excluded.description,
  duration_text = excluded.duration_text,
  active = true,
  published = true,
  status = excluded.status,
  status_note = excluded.status_note,
  application_url = excluded.application_url,
  primary_source_url = excluded.primary_source_url,
  research_checked_on = excluded.research_checked_on,
  next_review_on = excluded.next_review_on,
  exact_official_name = excluded.exact_official_name,
  opportunity_level = excluded.opportunity_level,
  audience_text = excluded.audience_text,
  eligible_study_stage = excluded.eligible_study_stage,
  student_priority = true,
  current_status = excluded.current_status,
  scope_status = excluded.scope_status,
  application_date_summary = excluded.application_date_summary,
  programme_date_summary = excluded.programme_date_summary,
  date_precision = excluded.date_precision,
  date_status_note = excluded.date_status_note,
  updated_at = now();

with programme as (
  select id as programme_id
  from public.firm_programmes
  where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'
    and slug = 'hong-kong-international-arbitration-internship'
)
insert into public.firm_programme_cycles (
  programme_id,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  programme_dates_text,
  application_status,
  application_status_note,
  duration_text,
  eligibility,
  application_process,
  programme_structure,
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
  '2027 applications closed — next dates unpublished',
  'unknown',
  null,
  null,
  'Three-month, full-time internship; applicants should state availability for the internship period on the application form.',
  'closed',
  'Applications for the 2027 Hong Kong International Arbitration internship have now closed. Next dates have not yet been published.',
  'Three months',
  jsonb_build_object('summary', 'Ambitious undergraduate and postgraduate students, or graduates who are not yet admitted to practice in a civil or common law jurisdiction, and are interested in an arbitration-focused career.'),
  jsonb_build_array('The official page says applicants should state their availability for the three-month internship period on the application form. Interviews are rolling.'),
  jsonb_build_array('Three-month, full-time international arbitration internship based in the Hong Kong office.'),
  true,
  date '2026-09-14',
  'closed',
  'verified',
  'not_announced',
  'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/arbitration-internship',
  'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/arbitration-internship',
  '[]'::jsonb,
  '[]'::jsonb,
  now()
from programme
where not exists (
  select 1
  from public.firm_programme_cycles existing
  where existing.programme_id = programme.programme_id
    and existing.cycle_label = '2027 applications closed — next dates unpublished'
);

update public.career_opportunities opportunity
set official_name = 'International arbitration internship',
    public_name = 'International arbitration internship',
    official_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/arbitration-internship',
    application_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/arbitration-internship',
    active = true,
    published = true,
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-11-01',
    updated_at = now()
from public.legal_organisations organisation
where opportunity.organisation_id = organisation.id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-international-arbitration-internship';

with opportunity as (
  select opportunity.id as opportunity_id
  from public.career_opportunities opportunity
  join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
  where organisation.slug = 'herbert-smith-freehills-kramer'
    and opportunity.slug = 'hong-kong-international-arbitration-internship'
)
insert into public.career_opportunity_cycles (
  opportunity_id,
  cycle_key,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  source_status,
  active,
  research_checked_on,
  application_dates_text,
  programme_dates_text,
  date_precision,
  duration_text,
  audience_text,
  study_stage_text,
  eligibility_text,
  application_process_text,
  official_url,
  application_url,
  updated_at
)
select
  opportunity_id,
  '2027-closed-next-dates-unpublished',
  '2027 applications closed — next dates unpublished',
  'unknown',
  null,
  null,
  'closed',
  false,
  date '2026-09-14',
  'Applications for the 2027 Hong Kong International Arbitration internship have now closed. Next dates have not yet been published.',
  'Three-month, full-time internship; applicants should state availability for the internship period on the application form.',
  'not_announced',
  'Three months',
  'Ambitious undergraduate and postgraduate students, or graduates who are not yet admitted to practice, and are interested in an arbitration-focused career.',
  'Undergraduate and postgraduate students, or graduates not yet admitted to practice in a civil or common law jurisdiction.',
  'Applicants should be interested in an arbitration-focused career and not yet admitted to practice.',
  'The official page says applicants should state their availability for the three-month internship period on the application form. Interviews are rolling.',
  'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/arbitration-internship',
  'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/arbitration-internship',
  now()
from opportunity
where not exists (
  select 1
  from public.career_opportunity_cycles cycle
  where cycle.opportunity_id = opportunity.opportunity_id
    and cycle.cycle_key = '2027-closed-next-dates-unpublished'
);

commit;

-- Verification.
select opportunity.slug,
       cycle.cycle_key,
       cycle.source_status,
       cycle.active,
       cycle.closes_on,
       cycle.application_dates_text
from public.career_opportunities opportunity
join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
left join public.career_opportunity_cycles cycle on cycle.opportunity_id = opportunity.id
where organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-international-arbitration-internship';
