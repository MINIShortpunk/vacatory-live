begin;

update public.legal_organisations
set overview = '4 Pump Court is a London commercial barristers’ chambers whose work includes construction and engineering, technology, shipping, energy, insurance, banking, international trade, arbitration and commercial litigation. Its student routes comprise annual pupillage, four mini-pupillage days each year and participation in student-facing pupillage fairs.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-10-22',
    updated_at = now()
where id = '37337e06-4b8e-422a-a536-448ef1c60e73';

update public.chambers
set pupillage_overview = '4 Pump Court normally offers around two 12-month commercial pupillages. Applications for pupillage commencing in autumn 2028 open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027. The latest published award is £80,000, with up to £25,000 available during the Bar course and a second-six gross-billing guarantee of at least £10,000.',
    mini_pupillage_overview = '4 Pump Court runs four mini-pupillage days each year, normally in April, July, September and December, with up to 20 places per day. The July day is remote. The current official page lists 22 April, 29 July, 23 September and 2 December 2027 for applicants considering the 2028 Pupillage Gateway or a later round. Reasonable domestic travel expenses are available for in-person days.',
    tenancy_overview = 'Vacatory excludes lateral recruitment, third-six and probationary-tenancy vacancies. Tenancy is recorded only as progression from the standard pupillage: 4 Pump Court states that there is no tenancy quota and pupils who meet the required standard are considered for membership.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-10-22',
    updated_at = now()
where organisation_id = '37337e06-4b8e-422a-a536-448ef1c60e73';

-- The 3 December 2026 mini-pupillage is explicitly marked FULL by chambers.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_identity_stage where career_opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_compensation where opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_cycle_routes where opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_locations where opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_routes where opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_scope_assignments where opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunity_cycles where opportunity_id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';
delete from public.career_opportunities where id = '3c306e0a-2eeb-4c20-bf10-837ebb891fe6';

update public.career_opportunities
set slug = '4-pump-court-pupillage-autumn-2028',
    official_name = '4 Pump Court Pupillage — Autumn 2028',
    public_name = '4 Pump Court Pupillage — Autumn 2028',
    english_name = '4 Pump Court Pupillage — Autumn 2028',
    public_summary = 'Around two 12-month commercial pupillages commencing in autumn 2028, with applications from 4 to 28 January 2027.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-29',
    updated_at = now()
where id = '8c79bca2-0d1a-4808-81f1-1d35cb278b07';

update public.career_opportunity_cycles
set cycle_key = '4-pump-court-pupillage:autumn-2028',
    cycle_label = '4 Pump Court Pupillage — Autumn 2028',
    intake_year = 2028,
    application_dates_text = 'Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
    programme_dates_text = 'Twelve-month pupillage commencing in autumn 2028.',
    places_text = 'Around two pupillages',
    source_status = 'official_dates_published',
    application_process_text = 'Apply directly to 4 Pump Court during the mandatory January 2027 recruitment window. Selection uses chambers’ written application form followed by two interview rounds.',
    assessments_text = 'Selection criteria cover academic and intellectual ability, analysis, judgment, written and oral advocacy, resilience, motivation, interpersonal impact and integrity. Pupillage includes two written and two advocacy assessments.',
    funding_text = 'The latest published award is £80,000. Up to £25,000 may be advanced during the Bar course; second-six gross billing is guaranteed to be at least £10,000 and pupils retain additional earnings from their own work.',
    right_to_work_text = null,
    source_status_note = null,
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '41c78cbf-54de-413a-8771-f27ee94244a0';

insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, event_type_id, slug, official_name,
  public_name, english_name, public_summary, delivery_mode, official_url,
  application_url, active, published, display_order, research_checked_on,
  next_review_on, created_at, updated_at, canonical_public_suppressed
) values
('3f06b8be-da6a-4215-9297-9e8a0c710ab9','37337e06-4b8e-422a-a536-448ef1c60e73','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89',null,'4-pump-court-mini-pupillage-22-april-2027','4 Pump Court Mini-Pupillage Day — 22 April 2027','4 Pump Court Mini-Pupillage Day — 22 April 2027','4 Pump Court Mini-Pupillage Day — 22 April 2027','An in-person mini-pupillage day for prospective applicants considering the 2028 Pupillage Gateway or a later round.','in_person','https://www.4pumpcourt.com/join-us/pupillage/mini-pupillage/','https://www.4pumpcourt.com/pupillage/mini-pupillage/application-form/',true,true,500,date '2026-10-15',date '2027-03-23',now(),now(),false),
('be086048-56a6-4d9c-8b76-cb878c258e51','37337e06-4b8e-422a-a536-448ef1c60e73','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89',null,'4-pump-court-virtual-mini-pupillage-29-july-2027','4 Pump Court Virtual Mini-Pupillage Day — 29 July 2027','4 Pump Court Virtual Mini-Pupillage Day — 29 July 2027','4 Pump Court Virtual Mini-Pupillage Day — 29 July 2027','A remote mini-pupillage day for prospective applicants considering the 2028 Pupillage Gateway or a later round.','virtual','https://www.4pumpcourt.com/join-us/pupillage/mini-pupillage/','https://www.4pumpcourt.com/pupillage/mini-pupillage/application-form/',true,true,500,date '2026-10-15',date '2027-06-30',now(),now(),false),
('e6016e7a-ee91-40f8-917f-8c58178c6cb0','37337e06-4b8e-422a-a536-448ef1c60e73','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89',null,'4-pump-court-mini-pupillage-23-september-2027','4 Pump Court Mini-Pupillage Day — 23 September 2027','4 Pump Court Mini-Pupillage Day — 23 September 2027','4 Pump Court Mini-Pupillage Day — 23 September 2027','An in-person mini-pupillage day for prospective applicants considering the 2028 Pupillage Gateway or a later round.','in_person','https://www.4pumpcourt.com/join-us/pupillage/mini-pupillage/','https://www.4pumpcourt.com/pupillage/mini-pupillage/application-form/',true,true,500,date '2026-10-15',date '2027-08-24',now(),now(),false),
('72e34480-fe74-4d21-8403-7e29fe3e5759','37337e06-4b8e-422a-a536-448ef1c60e73','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89',null,'4-pump-court-mini-pupillage-2-december-2027','4 Pump Court Mini-Pupillage Day — 2 December 2027','4 Pump Court Mini-Pupillage Day — 2 December 2027','4 Pump Court Mini-Pupillage Day — 2 December 2027','An in-person mini-pupillage day for prospective applicants considering the 2028 Pupillage Gateway or a later round.','in_person','https://www.4pumpcourt.com/join-us/pupillage/mini-pupillage/','https://www.4pumpcourt.com/pupillage/mini-pupillage/application-form/',true,true,500,date '2026-10-15',date '2027-11-03',now(),now(),false),
('1963a656-5e10-491a-a030-ff3517b9b896','37337e06-4b8e-422a-a536-448ef1c60e73','5e2816dd-108f-4443-9fb2-218def79147f','0565330b-8f5f-45ff-9314-1f3b25ebf243','4-pump-court-bar-council-pupillage-fair-2026','Bar Council Pupillage Fair 2026 — Meet 4 Pump Court','Bar Council Pupillage Fair 2026 — Meet 4 Pump Court','Bar Council Pupillage Fair 2026 — Meet 4 Pump Court','Meet 4 Pump Court representatives and ask about its commercial pupillage and mini-pupillage routes at the Bar Council Pupillage Fair.','in_person','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',true,true,500,date '2026-10-15',date '2026-10-18',now(),now(),false);

insert into public.career_opportunity_cycles (
  id, opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, opens_on, closes_on, closes_at,
  closes_timezone, programme_starts_on, programme_ends_on,
  programme_dates_text, application_dates_text, date_precision, duration_text,
  places_text, source_status, audience_text, study_stage_text, academic_criteria,
  eligibility_text, application_process_text, assessments_text,
  progression_route_text, expenses_text, disability_support_text,
  programme_structure_text, official_url, application_url, active,
  research_checked_on, created_at, updated_at
) values
('e8c3a792-efb8-458f-bbb4-0f3e7e645ff3','3f06b8be-da6a-4215-9297-9e8a0c710ab9','4-pump-court-mini-pupillage:2027-04-22','4 Pump Court Mini-Pupillage Day — 22 April 2027',2026,2027,2027,'fixed_deadline',date '2026-09-01',date '2027-03-22',time '23:59','Europe/London',date '2027-04-22',date '2027-04-22','One-day in-person mini-pupillage on 22 April 2027.','Applications opened on 1 September 2026 and close on 22 March 2027.','exact','One day','Up to 20 places','open','Undergraduate and postgraduate applicants seriously considering pupillage at 4 Pump Court.','Open to undergraduate and postgraduate applicants.','Applications are assessed against chambers’ pupillage criteria.','Applicants must be seriously interested in applying to 4 Pump Court for pupillage and be, or be capable of becoming, realistic candidates.','Submit the official online mini-pupillage application form.','Application-form review against pupillage criteria; the mini-pupillage itself is not assessed for recruitment.','No automatic progression and the mini-pupillage is not required for a pupillage application.','Reasonable domestic travel expenses are reimbursed.','Reasonable adjustments are available for disabled attendees.','Meet junior and senior barristers and clerks, join panel discussions and complete an exercise with feedback.','https://www.4pumpcourt.com/join-us/pupillage/mini-pupillage/','https://www.4pumpcourt.com/pupillage/mini-pupillage/application-form/',true,date '2026-10-15',now(),now()),
('04f2315b-b2d7-49ed-8421-de81c81d43ca','be086048-56a6-4d9c-8b76-cb878c258e51','4-pump-court-mini-pupillage:2027-07-29','4 Pump Court Virtual Mini-Pupillage Day — 29 July 2027',2026,2027,2027,'fixed_deadline',date '2026-09-01',date '2027-06-29',time '23:59','Europe/London',date '2027-07-29',date '2027-07-29','One-day remote mini-pupillage on 29 July 2027.','Applications opened on 1 September 2026 and close on 29 June 2027.','exact','One day','Up to 20 places','open','Undergraduate and postgraduate applicants seriously considering pupillage at 4 Pump Court.','Open to undergraduate and postgraduate applicants.','Applications are assessed against chambers’ pupillage criteria.','Applicants must be seriously interested in applying to 4 Pump Court for pupillage and be, or be capable of becoming, realistic candidates.','Submit the official online mini-pupillage application form.','Application-form review against pupillage criteria; the mini-pupillage itself is not assessed for recruitment.','No automatic progression and the mini-pupillage is not required for a pupillage application.',null,'Reasonable adjustments are available for disabled attendees.','Remote day with the same substantive content as the in-person programme, including barrister and clerk sessions and an exercise with feedback.','https://www.4pumpcourt.com/join-us/pupillage/mini-pupillage/','https://www.4pumpcourt.com/pupillage/mini-pupillage/application-form/',true,date '2026-10-15',now(),now()),
('4f4da5fd-2303-4e6f-8326-f989939f9dbb','e6016e7a-ee91-40f8-917f-8c58178c6cb0','4-pump-court-mini-pupillage:2027-09-23','4 Pump Court Mini-Pupillage Day — 23 September 2027',2026,2027,2027,'fixed_deadline',date '2026-09-01',date '2027-08-23',time '23:59','Europe/London',date '2027-09-23',date '2027-09-23','One-day in-person mini-pupillage on 23 September 2027.','Applications opened on 1 September 2026 and close on 23 August 2027.','exact','One day','Up to 20 places','open','Undergraduate and postgraduate applicants seriously considering pupillage at 4 Pump Court.','Open to undergraduate and postgraduate applicants.','Applications are assessed against chambers’ pupillage criteria.','Applicants must be seriously interested in applying to 4 Pump Court for pupillage and be, or be capable of becoming, realistic candidates.','Submit the official online mini-pupillage application form.','Application-form review against pupillage criteria; the mini-pupillage itself is not assessed for recruitment.','No automatic progression and the mini-pupillage is not required for a pupillage application.','Reasonable domestic travel expenses are reimbursed.','Reasonable adjustments are available for disabled attendees.','Meet junior and senior barristers and clerks, join panel discussions and complete an exercise with feedback.','https://www.4pumpcourt.com/join-us/pupillage/mini-pupillage/','https://www.4pumpcourt.com/pupillage/mini-pupillage/application-form/',true,date '2026-10-15',now(),now()),
('74f65303-c001-4be3-894d-b6a7ca655934','72e34480-fe74-4d21-8403-7e29fe3e5759','4-pump-court-mini-pupillage:2027-12-02','4 Pump Court Mini-Pupillage Day — 2 December 2027',2026,2027,2027,'fixed_deadline',date '2026-09-01',date '2027-11-02',time '23:59','Europe/London',date '2027-12-02',date '2027-12-02','One-day in-person mini-pupillage on 2 December 2027.','Applications opened on 1 September 2026 and close on 2 November 2027.','exact','One day','Up to 20 places','open','Undergraduate and postgraduate applicants seriously considering pupillage at 4 Pump Court.','Open to undergraduate and postgraduate applicants.','Applications are assessed against chambers’ pupillage criteria.','Applicants must be seriously interested in applying to 4 Pump Court for pupillage and be, or be capable of becoming, realistic candidates.','Submit the official online mini-pupillage application form.','Application-form review against pupillage criteria; the mini-pupillage itself is not assessed for recruitment.','No automatic progression and the mini-pupillage is not required for a pupillage application.','Reasonable domestic travel expenses are reimbursed.','Reasonable adjustments are available for disabled attendees.','Meet junior and senior barristers and clerks, join panel discussions and complete an exercise with feedback.','https://www.4pumpcourt.com/join-us/pupillage/mini-pupillage/','https://www.4pumpcourt.com/pupillage/mini-pupillage/application-form/',true,date '2026-10-15',now(),now());

insert into public.career_opportunity_cycles (
  id, opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, programme_starts_on, programme_ends_on,
  programme_dates_text, application_dates_text, date_precision, duration_text,
  source_status, audience_text, eligibility_text, application_process_text,
  programme_structure_text, official_url, application_url, active,
  research_checked_on, created_at, updated_at
) values (
  '670c5b2d-cdfd-439c-93f0-e3dd1514f655',
  '1963a656-5e10-491a-a030-ff3517b9b896',
  '4-pump-court-bar-council-pupillage-fair:2026',
  'Bar Council Pupillage Fair 2026 — Meet 4 Pump Court',
  2026, 2026, 2026, 'rolling', date '2026-10-17', date '2026-10-17',
  '17 October 2026, 10:00–15:00, at Convene, 133 Houndsditch, Liverpool Street, London EC3A 7DB.',
  'Book a free ticket through the Bar Council Pupillage Fair page.',
  'exact', 'One-day fair', 'upcoming',
  'Students, graduates and prospective barristers.',
  'Open to people exploring a career at the Bar or preparing a pupillage application.',
  'Register through the official Bar Council Pupillage Fair page.',
  'Meet chambers and Bar organisations, attend seminars and obtain careers guidance.',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',
  true, date '2026-10-15', now(), now()
);

commit;
