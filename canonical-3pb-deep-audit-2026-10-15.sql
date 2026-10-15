begin;

update public.chambers
set pupillage_overview = '3PB aims to recruit four pupils each year through the Pupillage Gateway. Its next intake begins in October 2028, with Gateway applications open from 4 to 28 January 2027. Pupillages may be based at any of 3PB''s seven centres. The latest official funding package is worth at least £77,000: a £60,000 award and guaranteed-earnings package plus benefits valued at about £17,000.',
    mini_pupillage_overview = '3PB normally provides around 45 selective, unassessed mini-pupillages each year in London, Birmingham, Bournemouth, Bristol, Oxford and Winchester. Placements last three or five days and applicants must be at least 18 and have reached the first year of an undergraduate degree. The 2026 allocation is full; 3PB says applications will reopen in the New Year.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where organisation_id = '48b45e29-c694-4948-84b0-8d092906c4c6';

update public.legal_organisations
set research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where id = '48b45e29-c694-4948-84b0-8d092906c4c6';

-- Remove professional-employment routes and the closed, undated mini-pupillage placeholder.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_identity_stage where career_opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_compensation where opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_cycle_routes where opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_locations where opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_routes where opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_scope_assignments where opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunity_cycles where opportunity_id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);
delete from public.career_opportunities where id in (
  'cb827086-b084-4bc2-8796-fcfc0c7757a0',
  '5df2a9bc-c4de-46bb-9a73-05831dff02cc',
  'c5a0a893-6a95-44b3-b31c-6c31d3758b49'
);

insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, event_type_id, slug, official_name,
  public_name, english_name, public_summary, delivery_mode, official_url,
  application_url, active, published, display_order, research_checked_on,
  next_review_on, created_at, updated_at, canonical_public_suppressed
) values (
  'f3b55360-68d9-462e-8f87-d90f13e64dcf',
  '48b45e29-c694-4948-84b0-8d092906c4c6',
  'e2b2bcbc-c3b0-4bee-b7d7-d2a0d1c3552b',
  null,
  '3pb-pupillage-october-2028',
  '3PB Pupillage — October 2028 Intake',
  '3PB Pupillage — October 2028 Intake',
  '3PB Pupillage — October 2028 Intake',
  'Four funded twelve-month pupillages beginning in October 2028, with applications through the Pupillage Gateway in January 2027.',
  'in_person',
  'https://www.3pb.co.uk/pupillage/',
  'https://www.pupillagegateway.com/',
  true, true, 100, date '2026-10-15', date '2027-01-29', now(), now(), false
);

insert into public.career_opportunity_cycles (
  id, opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, opens_on, closes_on, closes_at,
  closes_timezone, programme_starts_on, programme_dates_text,
  application_dates_text, date_precision, duration_text, places_text,
  source_status, audience_text, eligibility_text, application_process_text,
  programme_structure_text, funding_text, official_url, application_url,
  active, research_checked_on, created_at, updated_at
) values (
  'd29c2f15-ccfe-4b6b-ae12-6e15fb0d19f8',
  'f3b55360-68d9-462e-8f87-d90f13e64dcf',
  '3pb-pupillage:october-2028',
  '3PB Pupillage — October 2028 Intake',
  2027, 2028, 2028, 'fixed_deadline', date '2027-01-04',
  date '2027-01-28', time '23:59', 'Europe/London', date '2028-10-01',
  'Twelve-month pupillage beginning in October 2028. Gateway offers are made on 7 May 2027 at 09:30 and must be accepted by 14 May 2027 at 09:30.',
  'Vacancies may be browsed from 23 November 2026. Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
  'month', 'Twelve months', 'Four pupillages',
  'official_dates_published',
  'Prospective barristers seeking a specialist pupillage at a national multi-practice chambers.',
  'Applicants ordinarily need to have obtained their first degree before interview unless they can provide exceptional additional evidence.',
  'Apply through the Pupillage Gateway and state any location preferences. 3PB may place pupils at any of its seven centres.',
  'Specialist pupillage with on-the-job and advocacy training at one of 3PB''s seven centres.',
  'Package worth at least £77,000: £60,000 comprising a £30,000 award and £30,000 guaranteed second-six earnings, plus benefits valued at about £17,000.',
  'https://www.3pb.co.uk/pupillage/',
  'https://www.pupillagegateway.com/',
  true, date '2026-10-15', now(), now()
);

update public.career_opportunities
set public_summary = 'Access partnership supporting aspiring barristers from groups underrepresented at the Bar through mentoring, workshops, resources and work-experience opportunities.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-06',
    updated_at = now()
where id = '47aa15b8-6a0e-4463-add4-443d89e8cad3';

update public.career_opportunity_cycles
set programme_dates_text = 'Participation through the 2027/28 Bridging the Bar Academy.',
    duration_text = 'Academy programme with partner-delivered activities',
    application_process_text = 'Apply to the 2027/28 Bridging the Bar Academy through Bridging the Bar by 17:00 UK time on 5 November 2026.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '978ad973-4141-4828-9af9-26b864991c80';

update public.career_opportunities
set public_summary = 'Free hybrid pupillage open evening for prospective applicants, held in Bristol and online on 17 November 2026 and in London and Birmingham on 19 November 2026.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-20',
    updated_at = now()
where id = '608bb0b4-5643-40d7-862a-8d94d7a1c65f';

insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, event_type_id, slug, official_name,
  public_name, english_name, public_summary, delivery_mode, official_url,
  application_url, active, published, display_order, research_checked_on,
  next_review_on, created_at, updated_at, canonical_public_suppressed
) values
(
  'a45d9dc4-8c2d-4a90-9411-f949b74ebe02',
  '48b45e29-c694-4948-84b0-8d092906c4c6',
  '5e2816dd-108f-4443-9fb2-218def79147f',
  '0565330b-8f5f-45ff-9314-1f3b25ebf243',
  '3pb-bar-council-pupillage-fair-2026',
  'Bar Council Pupillage Fair 2026 — Meet 3PB',
  'Bar Council Pupillage Fair 2026 — Meet 3PB',
  'Bar Council Pupillage Fair 2026 — Meet 3PB',
  'Meet 3PB representatives and ask about its national pupillage opportunities at the Bar Council Pupillage Fair.',
  'in_person',
  'https://www.3pb.co.uk/pupillage-2026-key-dates-to-know/',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',
  true, true, 500, date '2026-10-15', date '2026-10-18', now(), now(), false
),
(
  'b0895a8a-45f9-4cca-bb82-2b3a855af128',
  '48b45e29-c694-4948-84b0-8d092906c4c6',
  '5e2816dd-108f-4443-9fb2-218def79147f',
  '0565330b-8f5f-45ff-9314-1f3b25ebf243',
  '3pb-targetjobs-national-pupillage-fair-2026',
  'targetjobs National Pupillage Fair 2026 — Meet 3PB',
  'targetjobs National Pupillage Fair 2026 — Meet 3PB',
  'targetjobs National Pupillage Fair 2026 — Meet 3PB',
  'Meet 3PB representatives, learn about its pupillage routes and ask questions about life at the Bar at the targetjobs National Pupillage Fair.',
  'in_person',
  'https://www.3pb.co.uk/pupillage-2026-key-dates-to-know/',
  'https://targetjobs.co.uk/events/national-pupillage-fair-2026',
  true, true, 500, date '2026-10-15', date '2026-11-22', now(), now(), false
);

insert into public.career_opportunity_cycles (
  id, opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, programme_starts_on, programme_ends_on,
  programme_dates_text, application_dates_text, date_precision, duration_text,
  source_status, audience_text, eligibility_text, application_process_text,
  programme_structure_text, official_url, application_url, active,
  research_checked_on, created_at, updated_at
) values
(
  '88a8dba4-7895-4549-8419-b2af6f1fb4f1',
  'a45d9dc4-8c2d-4a90-9411-f949b74ebe02',
  '3pb-bar-council-pupillage-fair:2026',
  'Bar Council Pupillage Fair 2026 — Meet 3PB',
  2026, 2026, 2026, 'rolling', date '2026-10-17', date '2026-10-17',
  '17 October 2026 at 133 Houndsditch, Liverpool Street, London.',
  'Book a free ticket through the Bar Council Pupillage Fair page.',
  'exact', 'One-day fair', 'upcoming',
  'Students, graduates and other prospective barristers.',
  'Open to people exploring a career at the Bar or preparing a pupillage application.',
  'Register through the official Bar Council Pupillage Fair page.',
  'Meet chambers and Bar organisations, attend seminars, and obtain guidance on applications, funding and careers at the Bar.',
  'https://www.3pb.co.uk/pupillage-2026-key-dates-to-know/',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',
  true, date '2026-10-15', now(), now()
),
(
  '1566a957-1916-4545-968d-ca05f367d362',
  'b0895a8a-45f9-4cca-bb82-2b3a855af128',
  '3pb-targetjobs-national-pupillage-fair:2026',
  'targetjobs National Pupillage Fair 2026 — Meet 3PB',
  2026, 2026, 2026, 'rolling', date '2026-11-21', date '2026-11-21',
  '21 November 2026, 10:30–15:00, in central London.',
  'Register through the official targetjobs event page.',
  'exact', 'Four and a half hours', 'upcoming',
  'Students and graduates considering or actively pursuing a career as a barrister.',
  'Open to aspiring barristers.',
  'Register through the official targetjobs National Pupillage Fair page.',
  'Meet chambers and course providers, attend careers sessions, learn about funding and obtain practical pupillage-application guidance.',
  'https://www.3pb.co.uk/pupillage-2026-key-dates-to-know/',
  'https://targetjobs.co.uk/events/national-pupillage-fair-2026',
  true, date '2026-10-15', now(), now()
);

commit;
