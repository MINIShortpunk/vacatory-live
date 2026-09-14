-- Herbert Smith Freehills Kramer — Australia Virtual Internship
-- Checked 14 September 2026.
--
-- Official source:
-- https://careers.hsfkramer.com/global/en/australia/early-careers/virtual-internship
--
-- The official HSFK page says the virtual internship was created with Forage,
-- can be completed from home, recommends setting aside 7-9 hours, is completed
-- in the student's own time and at their own pace, and that the key date is:
-- "Our virtual internships can be taken at any time, at a pace that suits you."
-- It is therefore stored as ongoing / always available with no invented deadline.

begin;

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
    'ada445be-3234-468a-bcfe-34ce1a70f5bc'::uuid,
    'australia-virtual-internship',
    'Australia Virtual Internship',
    'Australia Virtual Internship',
    'en',
    'Self-paced virtual internship created with Forage. Students can build legal skills and explore emerging technologies, digital, AI, smart legal contracts and the impact of innovation on legal work.',
    'online_self_paced',
    'https://careers.hsfkramer.com/global/en/australia/early-careers/virtual-internship',
    'https://careers.hsfkramer.com/global/en/australia/early-careers/virtual-internship',
    true,
    true,
    date '2026-09-14',
    date '2026-12-14',
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
  select id
  from upsert_opportunity
  union
  select id
  from public.career_opportunities
  where organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
    and slug = 'australia-virtual-internship'
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
    source_status,
    audience_text,
    application_dates_text,
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
    'ongoing',
    'Ongoing',
    'always_available',
    'Ongoing and self-paced; HSFK says its virtual internships can be taken at any time, at a pace that suits you.',
    'text_only',
    '7-9 hours',
    'official_current',
    'Students and graduates interested in legal skills, emerging technologies, digital, AI and innovation in legal work.',
    'Ongoing — can be taken at any time. No fixed application deadline is published.',
    'https://careers.hsfkramer.com/global/en/australia/early-careers/virtual-internship',
    'https://careers.hsfkramer.com/global/en/australia/early-careers/virtual-internship',
    true,
    date '2026-09-14',
    now(),
    'Benefits listed by HSFK include completing the course in your own time, developing interview-relevant skills and knowledge, gaining real-world experience, and earning a certificate to enhance a CV.'
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
    source_status = excluded.source_status,
    audience_text = excluded.audience_text,
    application_dates_text = excluded.application_dates_text,
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
  null,
  1,
  'Australia / online self-paced',
  10,
  'programme',
  'confirmed'
from public.career_opportunity_cycles cycle
join public.career_opportunities opportunity
  on opportunity.id = cycle.opportunity_id
where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug = 'australia-virtual-internship'
  and cycle.cycle_key = 'ongoing';

with upsert_programme as (
  insert into public.firm_programmes (
    id,
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
    qualification_or_outcome,
    active,
    published,
    status,
    current_status,
    application_url,
    primary_source_url,
    research_checked_on,
    next_review_on,
    exact_official_name,
    opportunity_level,
    audience_text,
    eligible_study_stage,
    student_priority,
    scope_status,
    application_date_summary,
    programme_date_summary,
    date_precision,
    date_status_note,
    updated_at
  )
  values (
    gen_random_uuid(),
    '460bf4d2-5594-4a84-958a-07748c328c74'::uuid,
    '460bf4d2-5594-4a84-958a-07748c328c74'::uuid,
    'australia-virtual-internship',
    'Australia Virtual Internship',
    'virtual_internship',
    'Online / Australia',
    'Australia',
    'online_self_paced',
    'Students and graduates',
    'Self-paced virtual internship created with Forage. HSFK says it helps students develop legal skills and knowledge, including emerging technologies and their impact on the law.',
    '7-9 hours',
    'Certificate to enhance a CV.',
    true,
    true,
    'current',
    'open_ongoing',
    'https://careers.hsfkramer.com/global/en/australia/early-careers/virtual-internship',
    'https://careers.hsfkramer.com/global/en/australia/early-careers/virtual-internship',
    date '2026-09-14',
    date '2026-12-14',
    'Australia Virtual Internship',
    'virtual_experience',
    'Students and graduates interested in legal skills, emerging technologies and innovation in legal work.',
    'Not restricted by study stage on the official page.',
    true,
    'in_scope',
    'Ongoing — HSFK says its virtual internships can be taken at any time, at a pace that suits you.',
    'Ongoing and self-paced.',
    'text_only',
    'Official page checked 14 September 2026; no fixed deadline is published.',
    now()
  )
  on conflict (firm_id, slug) do update set
    organisation_id = excluded.organisation_id,
    programme_name = excluded.programme_name,
    programme_type = excluded.programme_type,
    location_text = excluded.location_text,
    country_text = excluded.country_text,
    delivery_mode = excluded.delivery_mode,
    career_stage = excluded.career_stage,
    description = excluded.description,
    duration_text = excluded.duration_text,
    qualification_or_outcome = excluded.qualification_or_outcome,
    active = true,
    published = true,
    status = excluded.status,
    current_status = excluded.current_status,
    application_url = excluded.application_url,
    primary_source_url = excluded.primary_source_url,
    research_checked_on = excluded.research_checked_on,
    next_review_on = excluded.next_review_on,
    exact_official_name = excluded.exact_official_name,
    opportunity_level = excluded.opportunity_level,
    audience_text = excluded.audience_text,
    eligible_study_stage = excluded.eligible_study_stage,
    student_priority = excluded.student_priority,
    scope_status = excluded.scope_status,
    application_date_summary = excluded.application_date_summary,
    programme_date_summary = excluded.programme_date_summary,
    date_precision = excluded.date_precision,
    date_status_note = excluded.date_status_note,
    updated_at = now()
  returning id
), target_programme as (
  select id from upsert_programme
  union
  select id
  from public.firm_programmes
  where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
    and slug = 'australia-virtual-internship'
)
insert into public.firm_programme_cycles (
  id,
  programme_id,
  cycle_label,
  application_model,
  application_status,
  application_status_note,
  eligibility,
  application_process,
  programme_structure,
  active,
  research_checked_on,
  duration_text,
  programme_dates_text,
  audience_text,
  current_status,
  source_freshness,
  date_precision,
  source_url,
  application_url,
  updated_at
)
select
  gen_random_uuid(),
  target_programme.id,
  'Ongoing',
  'always_available',
  'open_ongoing',
  'Ongoing — the official page says HSFK virtual internships can be taken at any time, at a pace that suits you.',
  '{"study_stage":"Not restricted by study stage on the official page.","location":"Online; Australia early-careers page."}'::jsonb,
  '["Access the official HSFK virtual internship page","Complete the self-paced Forage programme online"]'::jsonb,
  '["Emerging technologies module","Connected autonomous vehicles","Smart legal contracts","Digital and AI implications for clients and legal work","Certificate on completion"]'::jsonb,
  true,
  date '2026-09-14',
  '7-9 hours',
  'Ongoing and self-paced; can be taken at any time.',
  'Students and graduates interested in legal skills, emerging technologies and innovation in legal work.',
  'open_ongoing',
  'official_current',
  'text_only',
  'https://careers.hsfkramer.com/global/en/australia/early-careers/virtual-internship',
  'https://careers.hsfkramer.com/global/en/australia/early-careers/virtual-internship',
  now()
from target_programme
on conflict (programme_id, cycle_label) do update set
  application_model = excluded.application_model,
  opens_on = null,
  closes_on = null,
  programme_starts_on = null,
  programme_ends_on = null,
  application_status = excluded.application_status,
  application_status_note = excluded.application_status_note,
  eligibility = excluded.eligibility,
  application_process = excluded.application_process,
  programme_structure = excluded.programme_structure,
  active = true,
  research_checked_on = excluded.research_checked_on,
  duration_text = excluded.duration_text,
  programme_dates_text = excluded.programme_dates_text,
  audience_text = excluded.audience_text,
  current_status = excluded.current_status,
  source_freshness = excluded.source_freshness,
  date_precision = excluded.date_precision,
  source_url = excluded.source_url,
  application_url = excluded.application_url,
  updated_at = now();

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
  and opportunity.slug = 'australia-virtual-internship';
