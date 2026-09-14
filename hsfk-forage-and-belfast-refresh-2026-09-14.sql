-- Herbert Smith Freehills Kramer — Forage job simulations and Belfast trainee solicitor route
-- Checked 14 September 2026.
--
-- Official/current sources:
-- - HSFK Forage company page:
--   https://www.theforage.com/company/herbert-smith-freehills-kramer
-- - HSFK Belfast Trainee Solicitor Programme:
--   https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme
--
-- Notes:
-- - The Forage page lists five flexible, self-paced HSFK job simulations, so
--   these remain ongoing / always available with no deadline.
-- - The Belfast trainee solicitor page says recruitment is only from the
--   Digital Legal Delivery Vacation Scheme. The published 2026 vacation-scheme
--   application deadline was 16 January 2026, which is past as of this check,
--   so it is not stored as an active upcoming deadline.

begin;

with forage_rows as (
  select * from (values
    ('forage-global-litigation', 'Global Litigation Job Simulation', 'Global Litigation', 'Introductory', '5-6 hours'),
    ('forage-emerging-technology-law', 'Digital Law Job Simulation', 'Digital Law', 'Intermediate', '5-6 hours'),
    ('forage-solicitor-apprentice', 'Solicitor Apprentice Job Simulation', 'Solicitor Apprentice', 'Introductory', '3-4 hours'),
    ('forage-international-mergers', 'International Mergers Job Simulation', 'International Mergers', 'Intermediate', '5-6 hours'),
    ('forage-financial-services-regulation', 'Financial Services Regulation Job Simulation', 'Financial Services Regulation', 'All levels', '5-6 hours')
  ) as v(slug, official_name, programme_name, level_text, duration_text)
), updated_opportunities as (
  update public.career_opportunities opportunity
  set official_name = forage_rows.official_name,
      english_name = forage_rows.official_name,
      public_summary = 'Flexible, self-paced HSFK job simulation on Forage. The Forage page says these simulations help students explore life at HSFK, build legal skills, boost commercial awareness and gain insight into trainee-associate work.',
      delivery_mode = 'online_self_paced',
      official_url = 'https://www.theforage.com/company/herbert-smith-freehills-kramer',
      application_url = 'https://www.theforage.com/company/herbert-smith-freehills-kramer',
      active = true,
      published = true,
      research_checked_on = date '2026-09-14',
      next_review_on = date '2026-12-14',
      updated_at = now()
  from forage_rows
  where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
    and opportunity.slug = forage_rows.slug
  returning opportunity.id, opportunity.slug
)
update public.career_opportunity_cycles cycle
set cycle_label = 'Ongoing',
    application_model = 'always_available',
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    programme_dates_text = 'Ongoing, flexible and self-paced on Forage.',
    application_dates_text = 'Ongoing — available on Forage with no fixed deadline.',
    date_precision = 'text_only',
    duration_text = forage_rows.duration_text,
    source_status = 'official_current',
    audience_text = 'Students exploring legal careers and HSFK trainee-associate style work.',
    official_url = 'https://www.theforage.com/company/herbert-smith-freehills-kramer',
    application_url = 'https://www.theforage.com/company/herbert-smith-freehills-kramer',
    active = true,
    research_checked_on = date '2026-09-14',
    updated_at = now(),
    additional_details_text = forage_rows.programme_name || ' — ' || forage_rows.level_text || '.'
from public.career_opportunities opportunity
join forage_rows on forage_rows.slug = opportunity.slug
where cycle.opportunity_id = opportunity.id
  and opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid;

with forage_rows as (
  select * from (values
    ('forage-global-litigation', 'Global - Global Litigation Job Simulation', 'Global Litigation', 'Introductory', '5-6 hours'),
    ('forage-emerging-technology-law', 'Global - Digital Law Job Simulation', 'Digital Law', 'Intermediate', '5-6 hours'),
    ('forage-solicitor-apprentice', 'Global - Solicitor Apprentice Job Simulation', 'Solicitor Apprentice', 'Introductory', '3-4 hours'),
    ('forage-international-mergers', 'Global - International Mergers Job Simulation', 'International Mergers', 'Intermediate', '5-6 hours'),
    ('forage-financial-services-regulation', 'Global - Financial Services Regulation Job Simulation', 'Financial Services Regulation', 'All levels', '5-6 hours')
  ) as v(slug, programme_name, simulation_name, level_text, duration_text)
), updated_programmes as (
  update public.firm_programmes programme
  set programme_name = forage_rows.programme_name,
      programme_type = 'virtual_job_simulation',
      location_text = 'Online',
      country_text = 'Global',
      delivery_mode = 'online_self_paced',
      career_stage = 'Students and graduates',
      description = 'Flexible, self-paced HSFK job simulation on Forage. The Forage page says these simulations help students explore life at HSFK, build legal skills, boost commercial awareness and gain insight into trainee-associate work.',
      duration_text = forage_rows.duration_text,
      qualification_or_outcome = 'Forage job simulation completion.',
      active = true,
      published = true,
      status = 'current',
      current_status = 'open_ongoing',
      application_opens_on = null,
      application_closes_on = null,
      application_date_summary = 'Ongoing — available on Forage with no fixed deadline.',
      programme_date_summary = 'Ongoing, flexible and self-paced.',
      date_precision = 'text_only',
      date_status_note = 'Forage company page checked 14 September 2026.',
      application_url = 'https://www.theforage.com/company/herbert-smith-freehills-kramer',
      primary_source_url = 'https://www.theforage.com/company/herbert-smith-freehills-kramer',
      research_checked_on = date '2026-09-14',
      next_review_on = date '2026-12-14',
      exact_official_name = forage_rows.simulation_name,
      opportunity_level = 'virtual_experience',
      audience_text = 'Students exploring legal careers and HSFK trainee-associate style work.',
      eligible_study_stage = 'Not restricted by study stage on the Forage company page.',
      student_priority = true,
      scope_status = 'in_scope',
      updated_at = now()
  from forage_rows
  where programme.firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
    and programme.slug = forage_rows.slug
  returning programme.id, programme.slug
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
  'Ongoing',
  'always_available',
  null,
  null,
  'Ongoing, flexible and self-paced on Forage.',
  'open_ongoing',
  'Ongoing — available on Forage with no fixed deadline.',
  true,
  date '2026-09-14',
  forage_rows.duration_text,
  'Students exploring legal careers and HSFK trainee-associate style work.',
  'open_ongoing',
  'official_current',
  'text_only',
  'https://www.theforage.com/company/herbert-smith-freehills-kramer',
  'https://www.theforage.com/company/herbert-smith-freehills-kramer',
  now()
from updated_programmes programme
join forage_rows on forage_rows.slug = programme.slug
on conflict (programme_id, cycle_label) do update set
  application_model = excluded.application_model,
  opens_on = null,
  closes_on = null,
  programme_dates_text = excluded.programme_dates_text,
  application_status = excluded.application_status,
  application_status_note = excluded.application_status_note,
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

-- Belfast trainee solicitor route: no direct public application deadline; route
-- is through the Belfast Digital Legal Delivery Vacation Scheme.
update public.firm_programmes
set programme_name = 'United Kingdom - Belfast Trainee Solicitor Programme',
    programme_type = 'training_contract',
    location_text = 'Belfast',
    country_text = 'United Kingdom',
    delivery_mode = 'in_person',
    career_stage = 'Graduates / penultimate or final-year qualifying law students via Belfast Vacation Scheme',
    description = 'Belfast Trainee Solicitor Programme with five seats, including Disputes, Corporate, Funds, Finance & Banking, Real Estate & Construction, and Employment, Pensions & Incentives. Trainees complete all seats in Belfast or may choose London for the final seat.',
    duration_text = 'Training contract with SQE learning programme during the remaining 18 months.',
    qualification_or_outcome = 'Qualification as a solicitor route.',
    route_to_next_stage = 'HSFK says it only recruits trainee solicitors from the Belfast Vacation Scheme.',
    active = true,
    published = true,
    status = 'current',
    current_status = 'current',
    application_opens_on = null,
    application_closes_on = null,
    application_date_summary = 'No separate public direct application window; HSFK recruits Belfast trainee solicitors only from the Digital Legal Delivery Vacation Scheme.',
    programme_date_summary = 'Five-seat programme with SQE learning support through BPP during the remaining 18 months.',
    date_precision = 'text_only',
    date_status_note = 'Official page checked 14 September 2026. Direct trainee-solicitor applications are not advertised separately.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
    application_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-14',
    exact_official_name = 'Trainee solicitor programme',
    opportunity_level = 'training_contract',
    audience_text = 'Graduates, or penultimate/final-year university students completing a qualifying law degree, applying through the Belfast Vacation Scheme.',
    eligible_study_stage = 'Graduate, or penultimate/final-year at university, with a qualifying law degree.',
    student_priority = true,
    scope_status = 'in_scope',
    updated_at = now()
where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and slug = 'belfast-trainee-solicitor-programme';

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
  'Current route status',
  'no_application',
  null,
  null,
  'No separate direct trainee-solicitor application dates are published. Recruitment is through the Belfast Digital Legal Delivery Vacation Scheme.',
  'current',
  'No separate direct application route; HSFK recruits Belfast trainee solicitors only from the Digital Legal Delivery Vacation Scheme.',
  '{"degree":"Qualifying law degree","study_stage":"Graduate, or penultimate/final-year university student completing a qualifying law degree","academics":"Consistent 2:1s throughout degree, with mitigating circumstances considered."}'::jsonb,
  '["Apply via the Belfast Digital Legal Delivery Vacation Scheme"]'::jsonb,
  '["Five seats","Belfast seats with option to choose London for final seat","Accelerate programme in first year","SQE learning programme with BPP during remaining 18 months"]'::jsonb,
  true,
  date '2026-09-14',
  'Graduates, or penultimate/final-year qualifying law students, via Belfast Vacation Scheme.',
  'current',
  'official_current',
  'text_only',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
  now()
from public.firm_programmes programme
where programme.firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and programme.slug = 'belfast-trainee-solicitor-programme'
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
  audience_text = excluded.audience_text,
  current_status = excluded.current_status,
  source_freshness = excluded.source_freshness,
  date_precision = excluded.date_precision,
  source_url = excluded.source_url,
  application_url = excluded.application_url,
  updated_at = now();

update public.firm_programmes
set programme_name = 'United Kingdom - Belfast Digital Legal Delivery Vacation Scheme',
    programme_type = 'vacation_scheme',
    location_text = 'Belfast',
    country_text = 'United Kingdom',
    delivery_mode = 'in_person',
    career_stage = 'Graduates / penultimate or final-year qualifying law students',
    active = true,
    published = true,
    status = 'current',
    current_status = 'current',
    application_opens_on = null,
    application_closes_on = null,
    application_date_summary = 'The 2026 Digital Legal Delivery Vacation Scheme application window closed at 12pm GMT on 16 January 2026. The next application dates have not yet been published.',
    programme_date_summary = 'Technical test was listed for March 2026 and assessment centre for April 2026. Next scheme dates have not yet been published.',
    date_precision = 'Past 2026 deadline closed; next dates unpublished',
    date_status_note = 'Past 16 January 2026 deadline is not stored as an active deadline.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
    application_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-14',
    exact_official_name = 'Digital Legal Delivery Vacation Scheme',
    opportunity_level = 'vacation_scheme',
    audience_text = 'Graduates, or penultimate/final-year university students completing a qualifying law degree.',
    eligible_study_stage = 'Graduate, or penultimate/final-year at university, with a qualifying law degree.',
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
  '2026 applications closed — next dates unpublished',
  'unknown',
  null,
  null,
  'The official page listed technical test in March 2026 and assessment centre in April 2026. Next scheme dates have not yet been published.',
  'closed',
  'Applications for the 2026 Digital Legal Delivery Vacation Scheme closed at 12pm GMT on Friday 16 January 2026. The next application dates have not yet been published.',
  '{"degree":"Qualifying law degree","study_stage":"Graduate, or penultimate/final-year university student completing a qualifying law degree","academics":"Consistent 2:1s throughout degree, with mitigating circumstances considered."}'::jsonb,
  '["Online application form","Technical test remote","Assessment centre in person"]'::jsonb,
  true,
  date '2026-09-14',
  'Graduates, or penultimate/final-year qualifying law students.',
  'current',
  'official_current',
  'Past 2026 deadline closed; next dates unpublished',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
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
  audience_text = excluded.audience_text,
  current_status = excluded.current_status,
  source_freshness = excluded.source_freshness,
  date_precision = excluded.date_precision,
  source_url = excluded.source_url,
  application_url = excluded.application_url,
  updated_at = now();

-- Canonical route refreshes for Belfast rows.
update public.career_opportunities
set official_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
    application_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
    active = true,
    published = true,
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-14',
    updated_at = now()
where organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and slug in ('belfast-trainee-solicitor-programme', 'belfast-digital-legal-delivery-vacation-scheme');

update public.career_opportunity_cycles cycle
set application_model = 'no_application',
    opens_on = null,
    closes_on = null,
    programme_dates_text = 'No separate direct trainee-solicitor application dates are published. Recruitment is through the Belfast Digital Legal Delivery Vacation Scheme.',
    application_dates_text = 'No separate direct application route; HSFK recruits Belfast trainee solicitors only from the Digital Legal Delivery Vacation Scheme.',
    source_status = 'official_current',
    active = true,
    research_checked_on = date '2026-09-14',
    updated_at = now()
from public.career_opportunities opportunity
where cycle.opportunity_id = opportunity.id
  and opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug = 'belfast-trainee-solicitor-programme';

insert into public.career_opportunity_cycles (
  opportunity_id,
  cycle_key,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  programme_dates_text,
  date_precision,
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
  '2026-applications-closed-next-dates-unpublished',
  '2026 applications closed — next dates unpublished',
  'unknown',
  null,
  null,
  'The official page listed technical test in March 2026 and assessment centre in April 2026. Next scheme dates have not yet been published.',
  'text_only',
  'official_current',
  'Graduates, or penultimate/final-year qualifying law students.',
  'Applications for the 2026 Digital Legal Delivery Vacation Scheme closed at 12pm GMT on Friday 16 January 2026. The next application dates have not yet been published.',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/trainee-solicitor-scheme',
  true,
  date '2026-09-14',
  now()
from public.career_opportunities opportunity
where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug = 'belfast-digital-legal-delivery-vacation-scheme'
on conflict (opportunity_id, cycle_key) do update set
  cycle_label = excluded.cycle_label,
  application_model = excluded.application_model,
  opens_on = null,
  closes_on = null,
  programme_dates_text = excluded.programme_dates_text,
  date_precision = excluded.date_precision,
  source_status = excluded.source_status,
  audience_text = excluded.audience_text,
  application_dates_text = excluded.application_dates_text,
  official_url = excluded.official_url,
  application_url = excluded.application_url,
  active = true,
  research_checked_on = excluded.research_checked_on,
  updated_at = now();

commit;

-- Verification
select opportunity.slug,
       cycle.cycle_key,
       cycle.application_model,
       cycle.closes_on,
       cycle.application_dates_text
from public.career_opportunities opportunity
left join public.career_opportunity_cycles cycle
  on cycle.opportunity_id = opportunity.id
where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and (
    opportunity.slug like 'forage-%'
    or opportunity.slug in ('belfast-trainee-solicitor-programme', 'belfast-digital-legal-delivery-vacation-scheme')
  )
order by opportunity.slug, cycle.cycle_key;
