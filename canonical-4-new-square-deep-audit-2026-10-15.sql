begin;

update public.legal_organisations
set overview = '4 New Square Chambers is a London barristers’ chambers specialising in commercial litigation and arbitration in the UK and internationally. Its student routes comprise annual pupillage, four assessed mini-pupillage days each year and access activity through organisations including Bridging the Bar and the Social Mobility Foundation.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-10-22',
    updated_at = now()
where id = 'ccad711f-b640-4009-8ad3-55c1ebb11e76';

update public.chambers
set pupillage_overview = '4 New Square normally selects an average of four pupils for a 12-month pupillage and aims to recruit four new tenants each year. Pupils are not streamed and each has an equal prospect of tenancy if the objective standard is met. Applications for the October 2028 intake follow the Pupillage Gateway timetable from 4 to 28 January 2027. The latest award published by chambers is £90,000 for pupillage commencing in 2026.',
    mini_pupillage_overview = 'Four one-day assessed mini-pupillages are normally offered each year, with up to 20 participants per day. Winter 2026/27 applications close at midday on 21 October 2026. The day includes Q&A sessions, lunch at Lincoln’s Inn, one-to-one supervision and a written exercise. Applicants outside London may claim reasonable domestic travel and accommodation expenses up to £350.',
    tenancy_overview = 'Vacatory excludes second-six, probationary-tenancy, ordinary-tenancy, lateral-barrister, staff and other employment recruitment. The student-facing profile records tenancy only as the possible progression from 4 New Square’s standard 12-month pupillage.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-10-22',
    updated_at = now()
where organisation_id = 'ccad711f-b640-4009-8ad3-55c1ebb11e76';

-- Permanently remove the duplicate January mini-pupillage, the non-current
-- second-six vacancy and the undated partner-managed mentoring placeholder.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_identity_stage where career_opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_compensation where opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_cycle_routes where opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_locations where opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_routes where opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_scope_assignments where opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunity_cycles where opportunity_id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');
delete from public.career_opportunities where id in ('b9af4d24-0f47-4c8f-b093-4841d9076c62','799c8f15-9f25-4fbb-90d5-24138d88ebca','4c453440-4f64-4856-ab9e-04f39b0d8a75');

update public.career_opportunities
set slug = '4-new-square-pupillage-october-2028',
    official_name = '4 New Square Pupillage — October 2028 Intake',
    public_name = '4 New Square Pupillage — October 2028 Intake',
    english_name = '4 New Square Pupillage — October 2028 Intake',
    public_summary = 'Four twelve-month commercial pupillages beginning in October 2028, with applications through the Pupillage Gateway from 4 to 28 January 2027.',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-29',
    updated_at = now()
where id = 'b4b1a7bc-5707-4cd9-bc10-52e0cc331e50';

update public.career_opportunity_cycles
set cycle_key = '4-new-square-pupillage:october-2028',
    cycle_label = '4 New Square Pupillage — October 2028 Intake',
    application_year = 2027,
    programme_year = 2028,
    intake_year = 2028,
    opens_on = date '2027-01-04',
    closes_on = date '2027-01-28',
    closes_at = time '23:59',
    closes_timezone = 'Europe/London',
    programme_starts_on = date '2028-10-01',
    programme_dates_text = 'Twelve-month pupillage beginning in October 2028. Gateway offers are made on 7 May 2027 at 09:30 and must be accepted by 14 May 2027 at 09:30.',
    application_dates_text = 'Vacancies may be browsed from 23 November 2026. Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
    date_precision = 'month',
    places_text = 'Four pupillages',
    source_status = 'official_dates_published',
    study_stage_text = 'Applicants must be able to complete the professional requirements for pupillage before commencement.',
    application_process_text = 'Apply through the Pupillage Gateway during the published January 2027 window.',
    assessments_text = 'Selection assesses intellectual ability, oral and written advocacy potential, personal qualities and motivation. Chambers may require written work during selection.',
    funding_text = 'The latest award published by chambers is £90,000 for pupillage commencing in 2026: £10,000 paid on acceptance, up to £20,000 available during the Bar course year, with pupils retaining second-six earnings.',
    expenses_text = null,
    right_to_work_text = null,
    source_status_note = null,
    official_url = 'https://www.4newsquare.com/recruitment/pupillage/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'd9ac145d-afa9-44aa-9993-de9f27529797';

update public.career_opportunities
set public_summary = 'One-day assessed mini-pupillages in December 2026 and January 2027, with applications closing at 12:00 on 21 October 2026.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-10-22',
    updated_at = now()
where id = 'b735e923-2089-4016-b173-21906216880e';

update public.career_opportunity_cycles
set application_dates_text = 'Applications close at 12:00 Europe/London on 21 October 2026.',
    places_text = 'Up to 20 mini-pupils on each day',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '262e0610-e0f4-4281-9a14-3930a0f6e4bc';

insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, event_type_id, slug, official_name,
  public_name, english_name, public_summary, delivery_mode, official_url,
  application_url, active, published, display_order, research_checked_on,
  next_review_on, created_at, updated_at, canonical_public_suppressed
) values
(
  '618258b1-4ef1-4a3f-b8cd-e6dc0a1b96ee',
  'ccad711f-b640-4009-8ad3-55c1ebb11e76',
  '45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89', null,
  '4-new-square-bridging-the-bar-academy-2027-28',
  '4 New Square Bridging the Bar Access Mini-Pupillage — Academy 2027/28',
  '4 New Square Bridging the Bar Access Mini-Pupillage — Academy 2027/28',
  '4 New Square Bridging the Bar Access Mini-Pupillage — Academy 2027/28',
  'Access route through the Bridging the Bar Academy, which can fast-track eligible participants to a mini-pupillage with 4 New Square or another partner set.',
  'in_person',
  'https://www.4newsquare.com/about-us/chambers-social-responsibility/',
  'https://bridgingthebar.org/academy-applications/',
  true, true, 500, date '2026-10-15', date '2026-11-06', now(), now(), false
),
(
  'f1104cdb-b790-4364-82ae-624b189b8f17',
  'ccad711f-b640-4009-8ad3-55c1ebb11e76',
  '5e2816dd-108f-4443-9fb2-218def79147f',
  '0565330b-8f5f-45ff-9314-1f3b25ebf243',
  '4-new-square-bar-council-pupillage-fair-2026',
  'Bar Council Pupillage Fair 2026 — Meet 4 New Square',
  'Bar Council Pupillage Fair 2026 — Meet 4 New Square',
  'Bar Council Pupillage Fair 2026 — Meet 4 New Square',
  'Meet 4 New Square representatives and ask about its commercial pupillage and mini-pupillage routes at the Bar Council Pupillage Fair.',
  'in_person',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',
  true, true, 500, date '2026-10-15', date '2026-10-18', now(), now(), false
);

insert into public.career_opportunity_cycles (
  id, opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, closes_on, closes_at, closes_timezone,
  programme_starts_on, programme_ends_on, programme_dates_text,
  application_dates_text, date_precision, duration_text, source_status,
  audience_text, eligibility_text, application_process_text,
  programme_structure_text, official_url, application_url, active,
  research_checked_on, created_at, updated_at
) values
(
  '6e63db11-a150-4e5c-ab54-61f80ccf672c',
  '618258b1-4ef1-4a3f-b8cd-e6dc0a1b96ee',
  '4-new-square-bridging-the-bar:academy-2027-28',
  '4 New Square Bridging the Bar Access Mini-Pupillage — Academy 2027/28',
  2026, 2027, 2027, 'fixed_deadline', date '2026-11-05', time '17:00',
  'Europe/London', null, null,
  'Participation through the 2027/28 Bridging the Bar Academy.',
  'Applications close at 17:00 on 5 November 2026.',
  'exact', 'Academy programme with partner-delivered activities', 'open',
  'Aspiring barristers from underrepresented groups who meet the Academy criteria.',
  'Applicants must be studying the Bar course in 2027/28 or have already completed it, together with the Academy’s published eligibility criteria.',
  'Apply to the 2027/28 Bridging the Bar Academy through Bridging the Bar.',
  'Academy support and partner activities, including access to mini-pupillage opportunities with partner chambers.',
  'https://www.4newsquare.com/about-us/chambers-social-responsibility/',
  'https://bridgingthebar.org/academy-applications/', true,
  date '2026-10-15', now(), now()
),
(
  'f9b0262e-6776-4a63-ac5e-502201d5b67b',
  'f1104cdb-b790-4364-82ae-624b189b8f17',
  '4-new-square-bar-council-pupillage-fair:2026',
  'Bar Council Pupillage Fair 2026 — Meet 4 New Square',
  2026, 2026, 2026, 'rolling', null, null, null,
  date '2026-10-17', date '2026-10-17',
  '17 October 2026 at 133 Houndsditch, Liverpool Street, London.',
  'Book a free ticket through the Bar Council Pupillage Fair page.',
  'exact', 'One-day fair', 'upcoming',
  'Students, graduates and other prospective barristers.',
  'Open to people exploring a career at the Bar or preparing a pupillage application.',
  'Register through the official Bar Council Pupillage Fair page.',
  'Meet chambers and Bar organisations, attend seminars and obtain guidance on applications, funding and careers at the Bar.',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html', true,
  date '2026-10-15', now(), now()
);

commit;
