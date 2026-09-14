-- Herbert Smith Freehills Kramer — Belfast expired-date cleanup
-- Checked 14 September 2026.
--
-- Official sources:
-- - Belfast Vacation Schemes:
--   https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes
-- - Belfast Digital Legal Delivery Apprentice:
--   https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice
--
-- Both pages currently publish application dates that have already passed:
-- - Vacation Scheme: opened 4 December 2025; closed 12pm GMT 16 January 2026.
-- - Digital Legal Delivery Apprentice: opened 2 February 2026; closed 27 February 2026.
--
-- Per Vacatory cleanup policy, passed one-off dates are deleted completely, not
-- hidden or archived. Current rows keep only student-facing route information
-- and "next dates unpublished" status.

begin;

-- Delete old/past Belfast cycle rows that preserve expired application dates
-- or stale closed-cycle text.
delete from public.career_opportunity_locations location
using public.career_opportunity_cycles cycle
join public.career_opportunities opportunity
  on opportunity.id = cycle.opportunity_id
where location.cycle_id = cycle.id
  and opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug in (
    'belfast-digital-legal-delivery-vacation-scheme',
    'belfast-digital-legal-delivery-apprenticeship'
  )
  and (
    cycle.closes_on < date '2026-09-14'
    or cycle.opens_on < date '2026-09-14'
    or cycle.programme_ends_on < date '2026-09-14'
    or cycle.application_dates_text ilike '%16 January 2026%'
    or cycle.application_dates_text ilike '%27 February 2026%'
    or cycle.programme_dates_text ilike '%March 2026%'
    or cycle.programme_dates_text ilike '%April 2026%'
  );

delete from public.career_opportunity_cycles cycle
using public.career_opportunities opportunity
where cycle.opportunity_id = opportunity.id
  and opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug in (
    'belfast-digital-legal-delivery-vacation-scheme',
    'belfast-digital-legal-delivery-apprenticeship'
  )
  and (
    cycle.closes_on < date '2026-09-14'
    or cycle.opens_on < date '2026-09-14'
    or cycle.programme_ends_on < date '2026-09-14'
    or cycle.application_dates_text ilike '%16 January 2026%'
    or cycle.application_dates_text ilike '%27 February 2026%'
    or cycle.programme_dates_text ilike '%March 2026%'
    or cycle.programme_dates_text ilike '%April 2026%'
    or cycle.cycle_key = '2026-applications-closed-next-dates-unpublished'
  );

delete from public.firm_programme_cycles cycle
using public.firm_programmes programme
where cycle.programme_id = programme.id
  and programme.firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and programme.slug in (
    'belfast-digital-legal-delivery-vacation-scheme',
    'belfast-digital-legal-delivery-apprenticeship'
  )
  and (
    cycle.closes_on < date '2026-09-14'
    or cycle.opens_on < date '2026-09-14'
    or cycle.programme_ends_on < date '2026-09-14'
    or cycle.application_status_note ilike '%16 January 2026%'
    or cycle.application_status_note ilike '%27 February 2026%'
    or cycle.programme_dates_text ilike '%March 2026%'
    or cycle.programme_dates_text ilike '%April 2026%'
    or cycle.cycle_label ilike '%2026 applications closed%'
  );

-- Remove duplicated older trainee-solicitor route cycle, keeping the cleaner
-- current route status row.
delete from public.firm_programme_cycles cycle
using public.firm_programmes programme
where cycle.programme_id = programme.id
  and programme.firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and programme.slug = 'belfast-trainee-solicitor-programme'
  and cycle.cycle_label = 'Current audited route status';

-- Refresh Belfast Vacation Scheme as a compact current route record without
-- retaining the expired 2026 dates.
update public.firm_programmes
set programme_name = 'United Kingdom - Belfast Vacation Scheme',
    programme_type = 'vacation_scheme',
    location_text = 'Belfast',
    country_text = 'United Kingdom',
    delivery_mode = 'in_person',
    career_stage = 'Graduates / penultimate or final-year qualifying law students',
    description = 'Belfast Vacation Scheme offering experience of life as a trainee solicitor, real client work and support to develop skills and career direction. It is the route for external candidates interested in the Belfast Trainee Solicitor Programme.',
    duration_text = '4 weeks',
    route_to_next_stage = 'At the end of the scheme, participants may be offered a trainee solicitor role.',
    active = true,
    published = true,
    status = 'current',
    current_status = 'current',
    application_opens_on = null,
    application_closes_on = null,
    application_closes_time = null,
    programme_starts_on = null,
    programme_ends_on = null,
    application_date_summary = 'Applications for the last published cycle have closed. The next application dates have not yet been published.',
    programme_date_summary = 'The vacation scheme normally takes place over 4 weeks starting in June each year; next scheme dates have not yet been published.',
    date_precision = 'Next dates unpublished; expired 2026 dates removed',
    date_status_note = 'Official page checked 14 September 2026. Past 2026 application and selection dates were deleted rather than archived.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes',
    application_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-14',
    exact_official_name = 'Vacation schemes',
    opportunity_level = 'vacation_scheme',
    audience_text = 'Penultimate-year law students, final-year law or LLM students with a qualifying law degree, or graduates who have completed a law degree.',
    eligible_study_stage = 'Penultimate-year law, final-year law or LLM with qualifying law degree, or completed law degree.',
    student_priority = true,
    scope_status = 'in_scope',
    updated_at = now()
where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and slug = 'belfast-digital-legal-delivery-vacation-scheme';

insert into public.firm_programme_cycles (
  programme_id,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  programme_dates_text,
  application_status,
  application_status_note,
  eligibility,
  application_process,
  active,
  research_checked_on,
  duration_text,
  audience_text,
  current_status,
  source_freshness,
  date_precision,
  source_url,
  application_url,
  updated_at
)
select
  programme.id,
  'Current route — next dates unpublished',
  'unknown',
  null,
  null,
  'The vacation scheme normally takes place over 4 weeks starting in June each year; next scheme dates have not yet been published.',
  'current',
  'Applications for the last published cycle have closed. The next application dates have not yet been published.',
  '{"study_stage":"Penultimate-year law students, final-year law or LLM students with a qualifying law degree, or graduates who have completed a law degree.","academics":"Consistent 2:1s throughout degree, with mitigating circumstances considered."}'::jsonb,
  '["Online application form","Technical test remote","Assessment centre in person"]'::jsonb,
  true,
  date '2026-09-14',
  '4 weeks',
  'Penultimate-year law students, final-year law or LLM students with a qualifying law degree, or graduates who have completed a law degree.',
  'current',
  'official_current',
  'Next dates unpublished; expired 2026 dates removed',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes',
  now()
from public.firm_programmes programme
where programme.firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and programme.slug = 'belfast-digital-legal-delivery-vacation-scheme'
on conflict (programme_id, cycle_label) do update set
  application_model = excluded.application_model,
  opens_on = null,
  closes_on = null,
  programme_dates_text = excluded.programme_dates_text,
  application_status = excluded.application_status,
  application_status_note = excluded.application_status_note,
  eligibility = excluded.eligibility,
  application_process = excluded.application_process,
  active = true,
  research_checked_on = excluded.research_checked_on,
  duration_text = excluded.duration_text,
  audience_text = excluded.audience_text,
  current_status = excluded.current_status,
  source_freshness = excluded.source_freshness,
  date_precision = excluded.date_precision,
  source_url = excluded.source_url,
  application_url = excluded.application_url,
  updated_at = now();

-- Refresh Belfast Digital Legal Delivery Apprentice as current route info only.
update public.firm_programmes
set programme_name = 'United Kingdom - Digital Legal Delivery Apprentice',
    programme_type = 'solicitor_apprenticeship',
    location_text = 'Belfast',
    country_text = 'United Kingdom',
    delivery_mode = 'work_and_study',
    career_stage = 'School leavers / apprentices',
    description = 'Four-year Belfast apprenticeship programme combining legal work, academic study and hands-on experience while working towards an LLB through Ulster University.',
    duration_text = '4 years',
    qualification_or_outcome = 'Law degree (LLB Hons) and four years of practical legal experience.',
    active = true,
    published = true,
    status = 'current',
    current_status = 'current',
    application_opens_on = null,
    application_closes_on = null,
    application_closes_time = null,
    programme_starts_on = null,
    programme_ends_on = null,
    application_date_summary = 'Applications for the last published cycle have closed. The next application dates have not yet been published.',
    programme_date_summary = 'Four-year programme with one paid university day each week at Ulster University; next start date has not yet been published.',
    date_precision = 'Next dates unpublished; expired 2026 dates removed',
    date_status_note = 'Official page checked 14 September 2026. Past 2026 application dates were deleted rather than archived.',
    application_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-14',
    exact_official_name = 'Digital Legal Delivery Apprentice',
    opportunity_level = 'apprenticeship',
    audience_text = 'Applicants aged 16 or over with UK citizenship or right of residency in the UK.',
    eligible_study_stage = '16+; GCSE English minimum Grade C; predicted or achieved AAB at A-Level or equivalent UCAS points.',
    student_priority = true,
    scope_status = 'in_scope',
    updated_at = now()
where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and slug = 'belfast-digital-legal-delivery-apprenticeship';

insert into public.firm_programme_cycles (
  programme_id,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  programme_dates_text,
  application_status,
  application_status_note,
  eligibility,
  application_process,
  programme_structure,
  active,
  research_checked_on,
  duration_text,
  audience_text,
  current_status,
  source_freshness,
  date_precision,
  salary_amount,
  salary_currency,
  salary_period,
  additional_compensation,
  right_to_work_text,
  source_url,
  application_url,
  updated_at
)
select
  programme.id,
  'Current route — next dates unpublished',
  'unknown',
  null,
  null,
  'Four-year programme with one paid university day each week at Ulster University; next start date has not yet been published.',
  'current',
  'Applications for the last published cycle have closed. The next application dates have not yet been published.',
  '{"age":"16 or over","right_to_work":"UK citizen or someone with right of residency in the UK","gcse":"GCSE English minimum Grade C","a_level":"Predicted or obtained minimum AAB at A-Level or equivalent UCAS points"}'::jsonb,
  '["Application form","Remote technical exercise","Assessment centre","Offer"]'::jsonb,
  '["Four-year programme","Rotations through practice groups and specialist teams","One paid university day each week at Ulster University","Law degree (LLB Hons)","Four years of practical legal experience"]'::jsonb,
  true,
  date '2026-09-14',
  '4 years',
  'Applicants aged 16 or over with UK citizenship or right of residency in the UK.',
  'current',
  'official_current',
  'Next dates unpublished; expired 2026 dates removed',
  24750,
  'GBP',
  'year',
  '£750 wellbeing fund per year; contribution towards course materials.',
  'To become an apprentice, applicants must be 16 or over and a UK citizen or someone with right of residency in the UK.',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice',
  now()
from public.firm_programmes programme
where programme.firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and programme.slug = 'belfast-digital-legal-delivery-apprenticeship'
on conflict (programme_id, cycle_label) do update set
  application_model = excluded.application_model,
  opens_on = null,
  closes_on = null,
  programme_dates_text = excluded.programme_dates_text,
  application_status = excluded.application_status,
  application_status_note = excluded.application_status_note,
  eligibility = excluded.eligibility,
  application_process = excluded.application_process,
  programme_structure = excluded.programme_structure,
  active = true,
  research_checked_on = excluded.research_checked_on,
  duration_text = excluded.duration_text,
  audience_text = excluded.audience_text,
  current_status = excluded.current_status,
  source_freshness = excluded.source_freshness,
  date_precision = excluded.date_precision,
  salary_amount = excluded.salary_amount,
  salary_currency = excluded.salary_currency,
  salary_period = excluded.salary_period,
  additional_compensation = excluded.additional_compensation,
  right_to_work_text = excluded.right_to_work_text,
  source_url = excluded.source_url,
  application_url = excluded.application_url,
  updated_at = now();

-- Canonical opportunity rows: keep no expired dates and store route status only.
update public.career_opportunities
set official_url = case
      when slug = 'belfast-digital-legal-delivery-vacation-scheme'
        then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes'
      when slug = 'belfast-digital-legal-delivery-apprenticeship'
        then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice'
      else official_url
    end,
    application_url = case
      when slug = 'belfast-digital-legal-delivery-vacation-scheme'
        then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes'
      when slug = 'belfast-digital-legal-delivery-apprenticeship'
        then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice'
      else application_url
    end,
    active = true,
    published = true,
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-14',
    updated_at = now()
where organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and slug in (
    'belfast-digital-legal-delivery-vacation-scheme',
    'belfast-digital-legal-delivery-apprenticeship'
  );

insert into public.career_opportunity_cycles (
  opportunity_id,
  cycle_key,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  programme_dates_text,
  date_precision,
  duration_text,
  source_status,
  audience_text,
  application_dates_text,
  official_url,
  application_url,
  active,
  research_checked_on,
  updated_at
)
select
  opportunity.id,
  'current-next-dates-unpublished',
  'Current route — next dates unpublished',
  'unknown',
  null,
  null,
  case
    when opportunity.slug = 'belfast-digital-legal-delivery-vacation-scheme'
      then 'The vacation scheme normally takes place over 4 weeks starting in June each year; next scheme dates have not yet been published.'
    else 'Four-year programme with one paid university day each week at Ulster University; next start date has not yet been published.'
  end,
  'text_only',
  case
    when opportunity.slug = 'belfast-digital-legal-delivery-vacation-scheme' then '4 weeks'
    else '4 years'
  end,
  'official_current',
  case
    when opportunity.slug = 'belfast-digital-legal-delivery-vacation-scheme'
      then 'Penultimate-year law students, final-year law or LLM students with a qualifying law degree, or graduates who have completed a law degree.'
    else 'Applicants aged 16 or over with UK citizenship or right of residency in the UK.'
  end,
  'Applications for the last published cycle have closed. The next application dates have not yet been published.',
  opportunity.official_url,
  opportunity.application_url,
  true,
  date '2026-09-14',
  now()
from public.career_opportunities opportunity
where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug in (
    'belfast-digital-legal-delivery-vacation-scheme',
    'belfast-digital-legal-delivery-apprenticeship'
  )
on conflict (opportunity_id, cycle_key) do update set
  cycle_label = excluded.cycle_label,
  application_model = excluded.application_model,
  opens_on = null,
  closes_on = null,
  programme_dates_text = excluded.programme_dates_text,
  date_precision = excluded.date_precision,
  duration_text = excluded.duration_text,
  source_status = excluded.source_status,
  audience_text = excluded.audience_text,
  application_dates_text = excluded.application_dates_text,
  official_url = excluded.official_url,
  application_url = excluded.application_url,
  active = true,
  research_checked_on = excluded.research_checked_on,
  updated_at = now();

commit;

-- Verification: no HSFK Belfast rows should retain expired 2026 dates.
select opportunity.slug,
       cycle.cycle_key,
       cycle.opens_on,
       cycle.closes_on,
       cycle.programme_starts_on,
       cycle.programme_ends_on,
       cycle.application_dates_text
from public.career_opportunities opportunity
left join public.career_opportunity_cycles cycle
  on cycle.opportunity_id = opportunity.id
where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug in (
    'belfast-digital-legal-delivery-vacation-scheme',
    'belfast-digital-legal-delivery-apprenticeship',
    'belfast-trainee-solicitor-programme'
  )
order by opportunity.slug, cycle.cycle_key;
