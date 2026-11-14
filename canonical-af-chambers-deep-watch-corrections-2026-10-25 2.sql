begin;

-- A-F chambers deep opportunity-watch corrections verified on 25 October 2026.

-- Permanently remove the elapsed Blackstone Pupillage Fair event and the
-- closed Fountain Court winter assessed mini-pupillage application cycle.
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in (
  'e85aa575-749d-49ab-a635-71e06b87dd2c',
  '7050a41b-41fa-4b07-8778-9c92664ed171'
);

delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in (
  'e85aa575-749d-49ab-a635-71e06b87dd2c',
  '7050a41b-41fa-4b07-8778-9c92664ed171'
);

delete from public.career_opportunity_identity_stage
where career_opportunity_id in (
  'e85aa575-749d-49ab-a635-71e06b87dd2c',
  '7050a41b-41fa-4b07-8778-9c92664ed171'
);

delete from public.career_opportunities
where id in (
  'e85aa575-749d-49ab-a635-71e06b87dd2c',
  '7050a41b-41fa-4b07-8778-9c92664ed171'
);

-- Preserve only the standing Fountain Court programme description on the
-- chambers profile; do not retain the expired cycle as a public opportunity.
update public.chambers
set mini_pupillage_overview = 'Fountain Court offers a two-day assessed mini-pupillage that is normally required before a pupillage application. Applicants must have begun legal study, shortlisted candidates attend a short interview and every mini-pupil receives £150 towards reasonable travel and out-of-pocket costs, with further support available in exceptional circumstances. Current application dates should be checked on the official mini-pupillage page.',
    research_checked_on = date '2026-10-25',
    next_review_on = date '2026-11-14',
    updated_at = now()
where organisation_id = (
  select id from public.legal_organisations
  where slug = 'fountain-court-chambers'
);

-- Add the two current Blackstone student events missing from Vacatory.
with event_rows(slug, event_name, summary, event_type_slug, delivery_mode, event_date, programme_text) as (
  values
    ('blackstone-targetjobs-national-pupillage-fair-21-november-2026',
     'TargetJobs National Pupillage Fair — Meet Blackstone Chambers',
     'A student pupillage fair where prospective applicants can meet members of Blackstone Chambers.',
     'law_fair', 'in_person', date '2026-11-21',
     '21 November 2026 at the Honourable Society of Lincoln’s Inn; the official Blackstone page does not publish an event time.'),
    ('blackstone-women-at-the-commercial-bar-9-december-2026',
     'Women at the Commercial Bar — 9 December 2026',
     'A hybrid student-facing session with a panel of leading female barristers from Blackstone Chambers.',
     'insight_event', 'hybrid', date '2026-12-09',
     '9 December 2026, hybrid at Blackstone Chambers and online; the official page does not publish an event time.')
)
insert into public.career_opportunities (
  organisation_id, opportunity_type_id, event_type_id, slug,
  official_name, english_name, public_name, public_summary, delivery_mode,
  official_url, application_url, active, published, display_order,
  research_checked_on, next_review_on
)
select
  lo.id, ot.id, cet.id, er.slug,
  er.event_name, er.event_name, er.event_name, er.summary, er.delivery_mode,
  'https://pupillage.blackstonechambers.com/events-webinars/',
  'https://pupillage.blackstonechambers.com/events-webinars/',
  true, true, 500, date '2026-10-25', er.event_date + 1
from event_rows er
join public.legal_organisations lo on lo.slug = 'blackstone-chambers'
join public.opportunity_types ot on ot.slug = 'open_day'
join public.career_event_types cet on cet.slug = er.event_type_slug
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

with event_rows(slug, event_name, event_date, programme_text) as (
  values
    ('blackstone-targetjobs-national-pupillage-fair-21-november-2026',
     'TargetJobs National Pupillage Fair — Meet Blackstone Chambers',
     date '2026-11-21',
     '21 November 2026 at the Honourable Society of Lincoln’s Inn; the official Blackstone page does not publish an event time.'),
    ('blackstone-women-at-the-commercial-bar-9-december-2026',
     'Women at the Commercial Bar — 9 December 2026',
     date '2026-12-09',
     '9 December 2026, hybrid at Blackstone Chambers and online; the official page does not publish an event time.')
)
insert into public.career_opportunity_cycles (
  opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  application_model, programme_starts_on, programme_ends_on,
  programme_dates_text, application_dates_text, date_precision,
  source_status, audience_text, eligibility_text, application_process_text,
  official_url, application_url, active, research_checked_on
)
select
  co.id, er.slug, er.event_name, 2026, 2026,
  'rolling', er.event_date, er.event_date,
  er.programme_text,
  'The official Blackstone page does not publish a registration deadline.',
  'exact', 'confirmed',
  'Prospective pupillage applicants and students considering a career at the Bar.',
  'No additional academic eligibility requirement is published on the official event listing.',
  'Use the registration information linked from Blackstone Chambers’ official events page.',
  co.official_url, co.application_url, true, date '2026-10-25'
from event_rows er
join public.legal_organisations lo on lo.slug = 'blackstone-chambers'
join public.career_opportunities co on co.organisation_id = lo.id and co.slug = er.slug
on conflict (opportunity_id, cycle_key) do update set
  cycle_label = excluded.cycle_label,
  application_year = excluded.application_year,
  programme_year = excluded.programme_year,
  application_model = excluded.application_model,
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
  updated_at = now();

-- Exchange Chambers corrected the Pupillage Forum application deadline.
update public.career_opportunities
set research_checked_on = date '2026-10-25',
    next_review_on = date '2026-11-28',
    updated_at = now()
where organisation_id = (
  select id from public.legal_organisations where slug = 'exchange-chambers'
)
and slug = 'exchange-chambers-pupillage-forum-2026';

update public.career_opportunity_cycles
set closes_on = date '2026-11-27',
    closes_at = time '17:00',
    closes_timezone = 'Europe/London',
    application_dates_text = 'Applications close at 17:00 on 27 November 2026.',
    source_status = 'open',
    official_url = 'https://www.exchangechambers.co.uk/pupillage/upcoming-events-pupillage-forum/',
    application_url = 'mailto:core@exchangechambers.co.uk',
    research_checked_on = date '2026-10-25',
    updated_at = now()
where opportunity_id = (
  select co.id from public.career_opportunities co
  join public.legal_organisations lo on lo.id = co.organisation_id
  where lo.slug = 'exchange-chambers'
    and co.slug = 'exchange-chambers-pupillage-forum-2026'
);

-- Crown Office publishes only “late May 2027”; remove the inferred exact day.
update public.career_opportunities
set research_checked_on = date '2026-10-25',
    next_review_on = date '2027-05-20',
    updated_at = now()
where organisation_id = (
  select id from public.legal_organisations where slug = 'crown-office-chambers'
)
and slug = 'crown-office-chambers-mini-pupillage-2027';

update public.career_opportunity_cycles
set opens_on = null,
    opens_at = null,
    opens_timezone = null,
    application_dates_text = 'Applications are closed and will reopen in late May 2027; the exact reopening day is not published.',
    programme_dates_text = 'Selected mini-pupils attend for two days. The next placement dates following the late-May 2027 reopening are not yet published.',
    date_precision = 'month',
    source_status = 'upcoming',
    source_status_note = null,
    official_url = 'https://www.crownofficechambers.com/careers/mini-pupillage/',
    application_url = 'https://www.crownofficechambers.com/careers/mini-pupillage/',
    research_checked_on = date '2026-10-25',
    updated_at = now()
where opportunity_id = (
  select co.id from public.career_opportunities co
  join public.legal_organisations lo on lo.id = co.organisation_id
  where lo.slug = 'crown-office-chambers'
    and co.slug = 'crown-office-chambers-mini-pupillage-2027'
);

commit;
