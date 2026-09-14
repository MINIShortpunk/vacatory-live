-- Herbert Smith Freehills Kramer — Australia Vacation Clerkships
-- Checked 14 September 2026.
--
-- Official source:
-- https://careers.hsfkramer.com/global/en/australia/early-careers/vacation-clerkships
--
-- The official page publishes the 2026/2027 city-by-city clerkship dates for
-- Brisbane, Melbourne, Perth and Sydney. All listed application closing dates
-- have passed as of 14 September 2026, so this update does not store those
-- past dates as active upcoming deadlines. The rows are kept as current
-- programme information with the next application dates unpublished.

begin;

with city_rows as (
  select * from (values
    (
      'australia-brisbane-vacation-clerkships',
      'Australia - Brisbane Vacation Clerkships',
      'Brisbane',
      1::bigint,
      1::bigint,
      '30 - 35',
      '1 Summer & 1 Winter',
      'Summer 2026 Clerkship: 24 November - 18 December 2026. Winter 2027 Clerkship: 21 June - 16 July 2027.',
      '2026/27 Brisbane applications opened 13 July 2026 and closed 7 August 2026; offers made 7 October 2026. The next application dates have not yet been published.'
    ),
    (
      'australia-melbourne-vacation-clerkships',
      'Australia - Melbourne Vacation Clerkships',
      'Melbourne',
      3::bigint,
      1::bigint,
      '65 - 75',
      '1 Summer & 1 Winter',
      'Summer 2026 Clerkship: 24 November - 18 December 2026. Winter 2027 Clerkship: 21 June - 16 July 2027.',
      '2026/27 Melbourne applications opened 6 July 2026 and closed 9 August 2026; offers made 15 October 2026. The next application dates have not yet been published.'
    ),
    (
      'australia-perth-vacation-clerkships',
      'Australia - Perth Vacation Clerkships',
      'Perth',
      4::bigint,
      1::bigint,
      '30 - 35',
      '1 Summer & 1 Winter',
      'Summer 2026 Clerkship: 16 November - 11 December 2026. Winter 2027 Clerkship: 14 June - 8 July 2027.',
      '2026/27 Perth applications opened 22 June 2026 and closed 26 July 2026; offers made 11 September 2026. The next application dates have not yet been published.'
    ),
    (
      'australia-sydney-vacation-clerkship',
      'Australia - Sydney Vacation Clerkship',
      'Sydney',
      5::bigint,
      1::bigint,
      '35 - 40',
      '1 Summer',
      'Summer 2026 Clerkship: 23 November 2026 - 29 January 2027.',
      '2026/27 Sydney applications opened 10 June 2026 and closed 12 July 2026; offers made 9 September 2026. The next application dates have not yet been published.'
    )
  ) as v(slug, programme_name, city_name, city_id, country_id, places_text, clerkship_programmes, programme_dates_text, application_status_note)
), refreshed_programmes as (
  update public.firm_programmes programme
  set programme_name = city_rows.programme_name,
      programme_type = 'vacation_clerkship',
      location_text = city_rows.city_name,
      country_text = 'Australia',
      delivery_mode = 'in_person',
      career_stage = 'Penultimate-year and final-year law students',
      description = 'HSFK Australia vacation clerkships offer close mentorship, client experience and the chance to work on real projects, cases and deals. The official page says most graduate positions are filled by vacation clerkship students.',
      duration_text = city_rows.clerkship_programmes,
      qualification_or_outcome = 'Insight into commercial legal practice and potential pathway to the graduate programme.',
      route_to_next_stage = 'At the end of the clerkship, students may have a chance of being selected for a graduate programme position.',
      active = true,
      published = true,
      status = 'current',
      current_status = 'current',
      application_opens_on = null,
      application_closes_on = null,
      application_closes_time = null,
      application_date_summary = city_rows.application_status_note,
      programme_date_summary = city_rows.programme_dates_text,
      date_precision = 'Past 2026 application window closed; next application dates unpublished',
      date_status_note = 'Past 2026 application closing dates are not stored as active deadlines. Programme dates are retained because the clerkships are upcoming/current on the official HSFK page.',
      application_url = 'https://hsfkramer-au.app.candidats.io',
      primary_source_url = 'https://careers.hsfkramer.com/global/en/australia/early-careers/vacation-clerkships',
      research_checked_on = date '2026-09-14',
      next_review_on = date '2026-11-01',
      exact_official_name = 'Vacation Clerkships',
      opportunity_level = 'clerkship',
      audience_text = 'Penultimate-year or final-year law students. International students in their penultimate or final year of an Australian or New Zealand law degree may apply if they have unrestricted legal rights to work in Australia when commencing the clerkship.',
      eligible_study_stage = 'Penultimate-year or final-year law students.',
      student_priority = true,
      scope_status = 'in_scope',
      updated_at = now()
  from city_rows
  where programme.firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
    and programme.slug = city_rows.slug
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
  places_text,
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
  source_url,
  application_url,
  updated_at
)
select
  programme.id,
  '2026/27 applications closed — next dates unpublished',
  'unknown',
  null,
  null,
  city_rows.programme_dates_text,
  'closed',
  city_rows.application_status_note,
  city_rows.places_text,
  jsonb_build_object(
    'study_stage', 'Penultimate-year or final-year law students',
    'international_students', 'Accepted if in the penultimate or final year of an Australian or New Zealand law degree and with unrestricted legal rights to work in Australia when commencing the clerkship.',
    'office_choice', 'Apply only to the office where you intend to start your graduate career; multiple applications will not be considered.'
  ),
  '["Apply to the office where you intend to start your graduate career","Multiple applications are not considered"]'::jsonb,
  jsonb_build_array(
    city_rows.clerkship_programmes,
    'Hands-on experience in one of eight practice groups',
    'Pro bono practice',
    'Innovation and technology projects',
    'Graduate and partner mentoring',
    'Workshops and presentations covering practice areas',
    'Networking with people across the firm'
  ),
  true,
  date '2026-09-14',
  city_rows.clerkship_programmes,
  'Penultimate-year or final-year law students; see official page for international-student work-rights conditions.',
  'current',
  'official_current',
  'Past 2026 application window closed; next application dates unpublished',
  'https://careers.hsfkramer.com/global/en/australia/early-careers/vacation-clerkships',
  'https://hsfkramer-au.app.candidats.io',
  now()
from refreshed_programmes programme
join city_rows on city_rows.slug = programme.slug
on conflict (programme_id, cycle_label) do update set
  application_model = excluded.application_model,
  opens_on = null,
  closes_on = null,
  programme_dates_text = excluded.programme_dates_text,
  application_status = excluded.application_status,
  application_status_note = excluded.application_status_note,
  places_text = excluded.places_text,
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
  source_url = excluded.source_url,
  application_url = excluded.application_url,
  updated_at = now();

with upsert_opportunity as (
  insert into public.career_opportunities (
    id,
    organisation_id,
    opportunity_type_id,
    slug,
    official_name,
    english_name,
    language_code,
    public_summary,
    delivery_mode,
    official_url,
    application_url,
    active,
    published,
    research_checked_on,
    next_review_on,
    updated_at
  )
  values (
    gen_random_uuid(),
    '460bf4d2-5594-4a84-958a-07748c328c74'::uuid,
    '3d0dd030-53e9-45ee-a716-1783fd6a65d6'::uuid,
    'australia-vacation-clerkships',
    'Australia Vacation Clerkships',
    'Australia Vacation Clerkships',
    'en',
    'Australia vacation clerkships in Brisbane, Melbourne, Perth and Sydney. The 2026 application windows have closed; the official page currently lists the 2026/27 clerkship programme dates and eligibility details.',
    'in_person',
    'https://careers.hsfkramer.com/global/en/australia/early-careers/vacation-clerkships',
    'https://hsfkramer-au.app.candidats.io',
    true,
    true,
    date '2026-09-14',
    date '2026-11-01',
    now()
  )
  on conflict (organisation_id, slug) do update set
    opportunity_type_id = excluded.opportunity_type_id,
    official_name = excluded.official_name,
    english_name = excluded.english_name,
    language_code = excluded.language_code,
    public_summary = excluded.public_summary,
    delivery_mode = excluded.delivery_mode,
    official_url = excluded.official_url,
    application_url = excluded.application_url,
    active = true,
    published = true,
    research_checked_on = excluded.research_checked_on,
    next_review_on = excluded.next_review_on,
    updated_at = now()
  returning id
), target_opportunity as (
  select id from upsert_opportunity
  union
  select id
  from public.career_opportunities
  where organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
    and slug = 'australia-vacation-clerkships'
), upsert_cycle as (
  insert into public.career_opportunity_cycles (
    id,
    opportunity_id,
    cycle_key,
    cycle_label,
    application_model,
    programme_dates_text,
    date_precision,
    duration_text,
    places_text,
    source_status,
    audience_text,
    application_dates_text,
    programme_structure_text,
    progression_route_text,
    right_to_work_text,
    official_url,
    application_url,
    active,
    research_checked_on,
    updated_at,
    additional_details_text
  )
  select
    gen_random_uuid(),
    target_opportunity.id,
    '2026-27-applications-closed',
    '2026/27 applications closed — next dates unpublished',
    'unknown',
    'Brisbane: Summer 24 November - 18 December 2026; Winter 21 June - 16 July 2027. Melbourne: Summer 24 November - 18 December 2026; Winter 21 June - 16 July 2027. Perth: Summer 16 November - 11 December 2026; Winter 14 June - 8 July 2027. Sydney: Summer 23 November 2026 - 29 January 2027.',
    'text_only',
    'Summer and/or winter clerkship depending on office',
    'Brisbane 30-35; Melbourne 65-75; Perth 30-35; Sydney 35-40',
    'official_current',
    'Penultimate-year or final-year law students. International students in their penultimate or final year of an Australian or New Zealand law degree may apply if they have unrestricted legal rights to work in Australia when commencing the clerkship.',
    'The 2026/27 application windows have closed. Next application dates have not yet been published. Past 2026 closing dates are not stored as active deadlines.',
    'Hands-on experience in one of eight practice groups; pro bono practice; innovation and technology projects; graduate and partner mentoring; workshops; networking.',
    'At the end of the clerkship, students may have a chance of being selected for a graduate programme position.',
    'International students must have unrestricted legal rights to work in Australia when commencing the clerkship.',
    'https://careers.hsfkramer.com/global/en/australia/early-careers/vacation-clerkships',
    'https://hsfkramer-au.app.candidats.io',
    true,
    date '2026-09-14',
    now(),
    'Apply only to the office where you intend to start your graduate career; multiple applications will not be considered.'
  from target_opportunity
  on conflict (opportunity_id, cycle_key) do update set
    cycle_label = excluded.cycle_label,
    application_model = excluded.application_model,
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    programme_dates_text = excluded.programme_dates_text,
    date_precision = excluded.date_precision,
    duration_text = excluded.duration_text,
    places_text = excluded.places_text,
    source_status = excluded.source_status,
    audience_text = excluded.audience_text,
    application_dates_text = excluded.application_dates_text,
    programme_structure_text = excluded.programme_structure_text,
    progression_route_text = excluded.progression_route_text,
    right_to_work_text = excluded.right_to_work_text,
    official_url = excluded.official_url,
    application_url = excluded.application_url,
    active = true,
    research_checked_on = excluded.research_checked_on,
    updated_at = now(),
    additional_details_text = excluded.additional_details_text
  returning id, opportunity_id
)
delete from public.career_opportunity_locations location
using target_opportunity
where location.opportunity_id = target_opportunity.id;

insert into public.career_opportunity_locations (
  opportunity_id,
  cycle_id,
  city_id,
  country_id,
  location_note,
  display_order,
  location_role,
  location_status
)
select
  cycle.opportunity_id,
  cycle.id,
  city_rows.city_id,
  city_rows.country_id,
  city_rows.city_name,
  row_number() over (order by city_rows.city_name),
  'programme',
  'confirmed'
from public.career_opportunities opportunity
join public.career_opportunity_cycles cycle
  on cycle.opportunity_id = opportunity.id
join (
  values
    ('Brisbane', 1::bigint, 1::bigint),
    ('Melbourne', 3::bigint, 1::bigint),
    ('Perth', 4::bigint, 1::bigint),
    ('Sydney', 5::bigint, 1::bigint)
) as city_rows(city_name, city_id, country_id)
  on true
where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug = 'australia-vacation-clerkships'
  and cycle.cycle_key = '2026-27-applications-closed';

-- Safety refresh for the current canonical cycle locations. This keeps the
-- location summary deterministic even if an older imported cycle exists on the
-- same opportunity.
delete from public.career_opportunity_locations location
using public.career_opportunities opportunity
where location.opportunity_id = opportunity.id
  and opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug = 'australia-vacation-clerkships';

insert into public.career_opportunity_locations (
  opportunity_id,
  cycle_id,
  city_id,
  country_id,
  location_note,
  display_order,
  location_role,
  location_status
)
select
  opportunity.id,
  cycle.id,
  city_rows.city_id,
  city_rows.country_id,
  city_rows.city_name,
  city_rows.display_order,
  'programme',
  'confirmed'
from public.career_opportunities opportunity
join public.career_opportunity_cycles cycle
  on cycle.opportunity_id = opportunity.id
join (
  values
    ('Brisbane', 1::bigint, 1::bigint, 1),
    ('Melbourne', 3::bigint, 1::bigint, 2),
    ('Perth', 4::bigint, 1::bigint, 3),
    ('Sydney', 5::bigint, 1::bigint, 4)
) as city_rows(city_name, city_id, country_id, display_order)
  on true
where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug = 'australia-vacation-clerkships'
  and cycle.cycle_key = '2026-27-applications-closed';

commit;

-- Verification
select opportunity.slug,
       opportunity.official_name,
       cycle.cycle_label,
       cycle.application_model,
       cycle.closes_on,
       cycle.application_dates_text,
       cycle.programme_dates_text
from public.career_opportunities opportunity
join public.career_opportunity_cycles cycle
  on cycle.opportunity_id = opportunity.id
where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug = 'australia-vacation-clerkships';
