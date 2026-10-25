begin;

-- N-S opportunity-watch corrections verified against live official sources
-- on 25 October 2026.

-- Penningtons Manches Cooper: correct the published Limitless dates.
update public.career_opportunities
set official_url = 'https://www.penningtonslaw.com/careers/early-careers/training-contract/early-careers-faqs/',
    application_url = 'https://www.penningtonslaw.com/careers/early-careers/training-contract/early-careers-faqs/',
    research_checked_on = date '2026-10-25',
    next_review_on = date '2027-02-12',
    updated_at = now()
where organisation_id = (
  select id from public.legal_organisations
  where slug = 'penningtons-manches-cooper'
)
and slug = 'limitless-2027';

update public.career_opportunity_cycles
set programme_starts_on = date '2027-07-12',
    programme_ends_on = date '2027-07-16',
    programme_dates_text = '12–16 July 2027.',
    application_dates_text = 'Applications close 12 February 2027; the exact opening date is not separately published.',
    official_url = 'https://www.penningtonslaw.com/careers/early-careers/training-contract/early-careers-faqs/',
    application_url = 'https://www.penningtonslaw.com/careers/early-careers/training-contract/early-careers-faqs/',
    research_checked_on = date '2026-10-25',
    updated_at = now()
where opportunity_id = (
  select co.id
  from public.career_opportunities co
  join public.legal_organisations lo on lo.id = co.organisation_id
  where lo.slug = 'penningtons-manches-cooper'
    and co.slug = 'limitless-2027'
);

-- Penningtons Manches Cooper: add the four current firm-hosted student events.
with event_rows(slug, event_name, summary, mode, event_date, event_time, place_text) as (
  values
    ('birmingham-open-day-17-november-2026', 'Birmingham Open Day — 17 November 2026', 'A firm-hosted open day for students interested in Penningtons Manches Cooper and its early-careers opportunities.', 'in_person', date '2026-11-17', null::time, 'Birmingham; the official page does not publish an event time.'),
    ('disability-open-day-24-november-2026', 'Disability Open Day — 24 November 2026', 'A student open day focused on disability inclusion and early careers at Penningtons Manches Cooper.', 'in_person', date '2026-11-24', time '16:00', 'London, 16:00–18:00.'),
    ('guildford-open-day-1-december-2026', 'Guildford Open Day — 1 December 2026', 'A firm-hosted open day for students interested in Penningtons Manches Cooper and its early-careers opportunities.', 'in_person', date '2026-12-01', time '16:00', 'Guildford, 16:00–18:00.'),
    ('virtual-open-evening-8-december-2026', 'Virtual Open Evening — 8 December 2026', 'An online student open evening introducing Penningtons Manches Cooper and its early-careers opportunities.', 'virtual', date '2026-12-08', time '16:00', 'Online, 16:00–18:00.')
)
insert into public.career_opportunities (
  organisation_id, opportunity_type_id, event_type_id, slug,
  official_name, english_name, public_name, public_summary, delivery_mode,
  official_url, application_url, active, published, display_order,
  research_checked_on, next_review_on
)
select
  lo.id, ot.id, cet.id, er.slug,
  er.event_name, er.event_name, er.event_name, er.summary, er.mode,
  'https://www.penningtonslaw.com/careers/early-careers/early-careers-events/',
  'https://www.penningtonslaw.com/careers/early-careers/early-careers-events/',
  true, true, 500, date '2026-10-25', er.event_date + 1
from event_rows er
cross join public.legal_organisations lo
cross join public.opportunity_types ot
cross join public.career_event_types cet
where lo.slug = 'penningtons-manches-cooper'
  and ot.slug = 'open_day'
  and cet.slug = 'open_day'
on conflict (organisation_id, slug) do update set
  opportunity_type_id = excluded.opportunity_type_id,
  event_type_id = excluded.event_type_id,
  official_name = excluded.official_name,
  english_name = excluded.english_name,
  public_name = excluded.public_name,
  public_summary = excluded.public_summary,
  delivery_mode = excluded.delivery_mode,
  official_url = excluded.official_url,
  application_url = excluded.application_url,
  active = true,
  published = true,
  research_checked_on = excluded.research_checked_on,
  next_review_on = excluded.next_review_on,
  updated_at = now();

with event_rows(slug, event_name, event_date, event_time, event_end_time, place_text) as (
  values
    ('birmingham-open-day-17-november-2026', 'Birmingham Open Day — 17 November 2026', date '2026-11-17', null::time, null::time, '17 November 2026 in Birmingham; the official page does not publish an event time.'),
    ('disability-open-day-24-november-2026', 'Disability Open Day — 24 November 2026', date '2026-11-24', time '16:00', time '18:00', '24 November 2026, 16:00–18:00, in London.'),
    ('guildford-open-day-1-december-2026', 'Guildford Open Day — 1 December 2026', date '2026-12-01', time '16:00', time '18:00', '1 December 2026, 16:00–18:00, in Guildford.'),
    ('virtual-open-evening-8-december-2026', 'Virtual Open Evening — 8 December 2026', date '2026-12-08', time '16:00', time '18:00', '8 December 2026, 16:00–18:00, online.')
)
insert into public.career_opportunity_cycles (
  opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  application_model, closes_on, closes_timezone, programme_starts_on,
  programme_ends_on, programme_dates_text, application_dates_text,
  date_precision, source_status, audience_text, eligibility_text,
  application_process_text, official_url, application_url, active,
  research_checked_on, additional_details_text
)
select
  co.id, er.slug, er.event_name, 2026, 2026,
  'fixed_deadline', date '2026-10-30', 'Europe/London', er.event_date,
  er.event_date, er.place_text, 'Applications close 30 October 2026; no closing time is published.',
  'exact', 'open', 'Students and graduates exploring the firm’s early-careers opportunities.',
  'The official event listing does not publish additional academic eligibility requirements.',
  'Apply or register through the link on the official early-careers events page.',
  'https://www.penningtonslaw.com/careers/early-careers/early-careers-events/',
  'https://www.penningtonslaw.com/careers/early-careers/early-careers-events/',
  true, date '2026-10-25',
  case when er.event_time is null then 'The official page does not publish an event time.'
       else 'Event time: ' || to_char(er.event_time, 'HH24:MI') || '–' || to_char(er.event_end_time, 'HH24:MI') || '.' end
from event_rows er
join public.legal_organisations lo on lo.slug = 'penningtons-manches-cooper'
join public.career_opportunities co on co.organisation_id = lo.id and co.slug = er.slug
on conflict (opportunity_id, cycle_key) do update set
  cycle_label = excluded.cycle_label,
  application_year = excluded.application_year,
  programme_year = excluded.programme_year,
  application_model = excluded.application_model,
  closes_on = excluded.closes_on,
  closes_timezone = excluded.closes_timezone,
  programme_starts_on = excluded.programme_starts_on,
  programme_ends_on = excluded.programme_ends_on,
  programme_dates_text = excluded.programme_dates_text,
  application_dates_text = excluded.application_dates_text,
  date_precision = excluded.date_precision,
  source_status = excluded.source_status,
  audience_text = excluded.audience_text,
  eligibility_text = excluded.eligibility_text,
  application_process_text = excluded.application_process_text,
  official_url = excluded.official_url,
  application_url = excluded.application_url,
  active = true,
  research_checked_on = excluded.research_checked_on,
  additional_details_text = excluded.additional_details_text,
  updated_at = now();

-- Norton Rose Fulbright: both current official pages give 1 January 2027.
update public.firm_programmes
set application_closes_on = date '2027-01-01',
    application_date_summary = 'Applications opened 14 September 2026 and close 1 January 2027.',
    next_review_on = date '2027-01-01',
    research_checked_on = date '2026-10-25',
    updated_at = now()
where organisation_id = (
  select id from public.legal_organisations
  where slug = 'norton-rose-fulbright'
)
and slug = 'business-and-legal-operations-graduate-scheme-2027';

insert into public.career_opportunities (
  organisation_id, opportunity_type_id, slug, official_name, english_name,
  public_name, public_summary, delivery_mode, official_url, application_url,
  active, published, display_order, research_checked_on, next_review_on
)
select
  lo.id, ot.id, 'business-and-legal-operations-graduate-scheme-2027',
  'Business and Legal Operations Graduate Scheme 2027',
  'Business and Legal Operations Graduate Scheme 2027',
  'Business and Legal Operations Graduate Scheme 2027',
  'A two-year London graduate scheme comprising four six-month rotations across business and legal operations.',
  'in_person',
  'https://www.nortonrosefulbright.com/en-gb/graduates/opportunities/business-and-legal-operations-graduate-scheme',
  'https://nrf.wd3.myworkdayjobs.com/Graduates/job/London-United-Kingdom/Business---Legal-Operations-Graduate-Scheme-2027_R-4334',
  true, true, 500, date '2026-10-25', date '2027-01-01'
from public.legal_organisations lo
cross join public.opportunity_types ot
where lo.slug = 'norton-rose-fulbright'
  and ot.slug = 'graduate_programme'
on conflict (organisation_id, slug) do update set
  opportunity_type_id = excluded.opportunity_type_id,
  official_name = excluded.official_name,
  english_name = excluded.english_name,
  public_name = excluded.public_name,
  public_summary = excluded.public_summary,
  delivery_mode = excluded.delivery_mode,
  official_url = excluded.official_url,
  application_url = excluded.application_url,
  active = true,
  published = true,
  research_checked_on = excluded.research_checked_on,
  next_review_on = excluded.next_review_on,
  updated_at = now();

insert into public.career_opportunity_cycles (
  opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, opens_on, closes_on, closes_timezone,
  programme_starts_on, programme_dates_text, application_dates_text,
  date_precision, duration_text, source_status, audience_text,
  application_process_text, programme_structure_text, progression_route_text,
  official_url, application_url, active, research_checked_on
)
select
  co.id, 'business-and-legal-operations-graduate-scheme-2027',
  'Business and Legal Operations Graduate Scheme 2027', 2026, 2027, 2027,
  'fixed_deadline', date '2026-09-14', date '2027-01-01', 'Europe/London',
  date '2027-09-01', 'The two-year programme begins in September 2027.',
  'Applications opened 14 September 2026 and close 1 January 2027.',
  'exact', 'Two years', 'open', 'Final-year students and graduates of all subjects.',
  'Apply through the official Norton Rose Fulbright graduate vacancy.',
  'Four six-month rotations across business and legal operations teams.',
  'The programme provides a clear path towards a permanent role.',
  co.official_url, co.application_url, true, date '2026-10-25'
from public.career_opportunities co
join public.legal_organisations lo on lo.id = co.organisation_id
where lo.slug = 'norton-rose-fulbright'
  and co.slug = 'business-and-legal-operations-graduate-scheme-2027'
on conflict (opportunity_id, cycle_key) do update set
  cycle_label = excluded.cycle_label,
  application_year = excluded.application_year,
  programme_year = excluded.programme_year,
  intake_year = excluded.intake_year,
  application_model = excluded.application_model,
  opens_on = excluded.opens_on,
  closes_on = excluded.closes_on,
  closes_timezone = excluded.closes_timezone,
  programme_starts_on = excluded.programme_starts_on,
  programme_dates_text = excluded.programme_dates_text,
  application_dates_text = excluded.application_dates_text,
  date_precision = excluded.date_precision,
  duration_text = excluded.duration_text,
  source_status = excluded.source_status,
  audience_text = excluded.audience_text,
  application_process_text = excluded.application_process_text,
  programme_structure_text = excluded.programme_structure_text,
  progression_route_text = excluded.progression_route_text,
  official_url = excluded.official_url,
  application_url = excluded.application_url,
  active = true,
  research_checked_on = excluded.research_checked_on,
  updated_at = now();

-- Osborne Clarke: permanently remove the four elapsed October events and
-- their dependent records. Cascading foreign keys remove cycles and links;
-- identity-stage rows use restrictive keys and are deleted explicitly.
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in (
  'fa61fe48-85e9-4405-aefa-0bf21acbfe68',
  '5fb19f47-7eac-47f7-9d46-ae4a7556ada3',
  'b0c8f17b-866f-4585-b43e-ff27db0c994e',
  '51561a16-3656-4343-8f7f-03c15e00bd96'
);

delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in (
  'fa61fe48-85e9-4405-aefa-0bf21acbfe68',
  '5fb19f47-7eac-47f7-9d46-ae4a7556ada3',
  'b0c8f17b-866f-4585-b43e-ff27db0c994e',
  '51561a16-3656-4343-8f7f-03c15e00bd96'
);

delete from public.career_opportunity_identity_stage
where career_opportunity_id in (
  'fa61fe48-85e9-4405-aefa-0bf21acbfe68',
  '5fb19f47-7eac-47f7-9d46-ae4a7556ada3',
  'b0c8f17b-866f-4585-b43e-ff27db0c994e',
  '51561a16-3656-4343-8f7f-03c15e00bd96'
);

delete from public.career_opportunities
where id in (
  'fa61fe48-85e9-4405-aefa-0bf21acbfe68',
  '5fb19f47-7eac-47f7-9d46-ae4a7556ada3',
  'b0c8f17b-866f-4585-b43e-ff27db0c994e',
  '51561a16-3656-4343-8f7f-03c15e00bd96'
);

commit;
