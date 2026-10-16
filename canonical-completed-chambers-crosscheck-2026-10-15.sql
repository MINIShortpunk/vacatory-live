begin;

-- Correct 1 Hare Court to the commencement year and interview dates published
-- on its current official pupillage page.
update public.career_opportunities
set slug = '1-hare-court-pupillage-october-2027',
    official_name = '1 Hare Court Pupillage — October 2027',
    public_name = '1 Hare Court Pupillage — October 2027',
    english_name = '1 Hare Court Pupillage — October 2027',
    public_summary = 'Two twelve-month specialist financial-remedies pupillages beginning in October 2027, with applications closing on 28 January 2027.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-29',
    updated_at = now()
where id = '2f3832a9-cace-40ea-b4e9-8aa945c56928';

update public.career_opportunity_cycles
set cycle_key = '1-hare-court-pupillage:october-2027',
    cycle_label = '1 Hare Court Pupillage — October 2027',
    programme_year = 2027,
    intake_year = 2027,
    programme_starts_on = date '2027-10-01',
    programme_dates_text = 'Twelve-month pupillage beginning in October 2027. First-round interviews take place on 20 March 2027 and second-round interviews on 24 April 2027.',
    assessments_text = 'Written application; first-round interview on 20 March 2027; second-round interview on 24 April 2027. Selection assesses intellectual ability, communication, advocacy, interpersonal skills, analytical thinking and motivation for financial-remedies work.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '27bbbbde-695f-4e72-b5ad-1347dc055e8b';

update public.chambers
set pupillage_overview = replace(pupillage_overview, 'October 2028', 'October 2027'),
    research_checked_on = date '2026-10-15',
    updated_at = now()
where organisation_id = 'e69e8bab-0424-4da8-b413-3a1f718c1eab';

-- Remove standing initiatives that have no current application window.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_identity_stage where career_opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_compensation where opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_cycle_routes where opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_locations where opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_routes where opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_scope_assignments where opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunity_cycles where opportunity_id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');
delete from public.career_opportunities where id in ('80e24a11-e356-4f41-8b5a-10c0a1000004','3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e','ec67f93c-4dc5-44fe-92a0-609388d74253');

-- Keep the announced 2027 scholarship but express only its confirmed timing.
update public.career_opportunities
set public_summary = 'Two annual £30,000 scholarships for eligible Black students on the Bar Practice Course, with mentoring and recruitment support from 11KBW or 39 Essex Chambers.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-02',
    updated_at = now()
where id = '2c51df71-71d1-4c7e-81f3-9ce3c45ec3b2';

update public.career_opportunity_cycles
set opens_on = date '2027-01-01',
    date_precision = 'month',
    assessments_text = 'Application followed by selection by a panel comprising members of both chambers and external assessors.',
    expenses_text = 'The £30,000 award supports Bar course tuition fees and maintenance.',
    right_to_work_text = 'Applicants must have been assessed as home students for fees during their UK undergraduate degree.',
    source_status_note = 'The official scholarship site confirms that applications open in January 2027.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '579890cc-074f-4e62-812b-53a23f43624f';

-- Remove internal research wording from otherwise current records.
update public.career_opportunity_cycles
set academic_criteria = replace(academic_criteria, 'normally expected to have', 'normally require'),
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '0c74326c-9625-440d-91d8-d13c1575ce7c';

update public.career_opportunity_cycles
set assessments_text = 'Written application; assessed 3VB mini-pupillage; first interview; second interview with a legal problem and limited preparation; references; supervisor work and advocacy exercises during pupillage. First and second interviews are generally held in March and April.',
    source_status_note = 'Current annual standard pupillage route. Intermediate and established-practitioner routes are excluded.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'bee263e3-6fc4-4874-b2a7-1055a2ef1777';

update public.career_opportunity_cycles
set study_stage_text = 'Eligibility follows the published 2027/28 Bridging the Bar Academy criteria.',
    academic_criteria = 'Eligibility follows the published 2027/28 Bridging the Bar Academy criteria.',
    assessments_text = 'Selection is managed through the Bridging the Bar Academy.',
    expenses_text = null,
    right_to_work_text = null,
    source_status_note = '3VB is a founding Bridging the Bar partner and provides two-day mini-pupillages through the Academy.',
    additional_details_text = null,
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'e852ca78-b1e2-47c8-a788-2396ff86102c';

update public.career_opportunity_cycles
set study_stage_text = 'Eligibility follows the published 2027/28 Bridging the Bar Academy criteria.',
    academic_criteria = 'Eligibility follows the published 2027/28 Bridging the Bar Academy criteria.',
    assessments_text = 'Selection is managed through the Bridging the Bar Academy.',
    expenses_text = null,
    right_to_work_text = null,
    source_status_note = '3PB confirms its continuing Bridging the Bar partnership for 2026.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '978ad973-4141-4828-9af9-26b864991c80';

update public.career_opportunity_cycles
set closes_timezone = 'Europe/London',
    updated_at = now()
where opportunity_id in (
  select id from public.career_opportunities
  where organisation_id = '8e22970d-549a-413b-b3ba-961efe89ac1b'
    and opportunity_type_id = 'e2b2bcbc-c3b0-4bee-b7d7-d2a0d1c3552b'
);

-- Add current fair participation confirmed by the Bar Council's official
-- 2026 exhibitor list.
insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, event_type_id, slug, official_name,
  public_name, english_name, public_summary, delivery_mode, official_url,
  application_url, active, published, display_order, research_checked_on,
  next_review_on, created_at, updated_at, canonical_public_suppressed
) values
('0505701d-86db-43c3-b3e5-8083667f60b2','125d93e7-38ae-4746-a866-8c428ca4196d','5e2816dd-108f-4443-9fb2-218def79147f','0565330b-8f5f-45ff-9314-1f3b25ebf243','1cor-bar-council-pupillage-fair-2026','Bar Council Pupillage Fair 2026 — Meet 1 Crown Office Row','Bar Council Pupillage Fair 2026 — Meet 1 Crown Office Row','Bar Council Pupillage Fair 2026 — Meet 1 Crown Office Row','Meet representatives from 1 Crown Office Row and ask about its London and Brighton pupillage and mini-pupillage routes.','in_person','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',true,true,500,date '2026-10-15',date '2026-10-18',now(),now(),false),
('59e870d0-f7e6-42da-9727-9e6c3013d05c','e69e8bab-0424-4da8-b413-3a1f718c1eab','5e2816dd-108f-4443-9fb2-218def79147f','0565330b-8f5f-45ff-9314-1f3b25ebf243','1-hare-court-bar-council-pupillage-fair-2026','Bar Council Pupillage Fair 2026 — Meet 1 Hare Court','Bar Council Pupillage Fair 2026 — Meet 1 Hare Court','Bar Council Pupillage Fair 2026 — Meet 1 Hare Court','Meet 1 Hare Court members and ask about its specialist financial-remedies pupillage and mini-pupillage routes.','in_person','https://www.1hc.com/latest-news/members-of-1-hare-court-attend-the-bar-council-pupillage-fair-this-weekend/','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',true,true,500,date '2026-10-15',date '2026-10-18',now(),now(),false),
('fb864ae3-ccfd-4cff-bb01-e8e34b11c82b','800d9dcd-8e79-4acc-b35d-83b0287cdaf0','5e2816dd-108f-4443-9fb2-218def79147f','0565330b-8f5f-45ff-9314-1f3b25ebf243','3vb-bar-council-pupillage-fair-2026','Bar Council Pupillage Fair 2026 — Meet 3VB','Bar Council Pupillage Fair 2026 — Meet 3VB','Bar Council Pupillage Fair 2026 — Meet 3VB','Meet 3VB representatives and ask about its commercial pupillage and assessed mini-pupillage process.','in_person','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',true,true,500,date '2026-10-15',date '2026-10-18',now(),now(),false);

insert into public.career_opportunity_cycles (
 id,opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,
 application_model,programme_starts_on,programme_ends_on,programme_dates_text,
 application_dates_text,date_precision,duration_text,source_status,audience_text,
 eligibility_text,application_process_text,programme_structure_text,official_url,
 application_url,active,research_checked_on,created_at,updated_at
) values
('a5710b8b-89c3-42b9-a775-512319dfe11f','0505701d-86db-43c3-b3e5-8083667f60b2','1cor-bar-council-pupillage-fair:2026','Bar Council Pupillage Fair 2026 — Meet 1 Crown Office Row',2026,2026,2026,'rolling',date '2026-10-17',date '2026-10-17','17 October 2026, 10:00–15:00, at Convene, 133 Houndsditch, Liverpool Street, London EC3A 7DB.','Book a free ticket through the Bar Council Pupillage Fair page.','exact','One-day fair','upcoming','Students, graduates and prospective barristers.','Open to people exploring a career at the Bar or preparing a pupillage application.','Register through the official Bar Council Pupillage Fair page.','Meet chambers and Bar organisations, attend seminars and obtain careers guidance.','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',true,date '2026-10-15',now(),now()),
('36b4db0c-113d-46f5-b256-9c56bb4b63c6','59e870d0-f7e6-42da-9727-9e6c3013d05c','1-hare-court-bar-council-pupillage-fair:2026','Bar Council Pupillage Fair 2026 — Meet 1 Hare Court',2026,2026,2026,'rolling',date '2026-10-17',date '2026-10-17','17 October 2026, 10:00–15:00, at Convene, 133 Houndsditch, Liverpool Street, London EC3A 7DB.','Book a free ticket through the Bar Council Pupillage Fair page.','exact','One-day fair','upcoming','Students, graduates and prospective barristers.','Open to people exploring a career at the Bar or preparing a pupillage application.','Register through the official Bar Council Pupillage Fair page.','Meet chambers and Bar organisations, attend seminars and obtain careers guidance.','https://www.1hc.com/latest-news/members-of-1-hare-court-attend-the-bar-council-pupillage-fair-this-weekend/','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',true,date '2026-10-15',now(),now()),
('5fa0e096-1f44-4bd6-977a-73bc690d8a66','fb864ae3-ccfd-4cff-bb01-e8e34b11c82b','3vb-bar-council-pupillage-fair:2026','Bar Council Pupillage Fair 2026 — Meet 3VB',2026,2026,2026,'rolling',date '2026-10-17',date '2026-10-17','17 October 2026, 10:00–15:00, at Convene, 133 Houndsditch, Liverpool Street, London EC3A 7DB.','Book a free ticket through the Bar Council Pupillage Fair page.','exact','One-day fair','upcoming','Students, graduates and prospective barristers.','Open to people exploring a career at the Bar or preparing a pupillage application.','Register through the official Bar Council Pupillage Fair page.','Meet chambers and Bar organisations, attend seminars and obtain careers guidance.','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',true,date '2026-10-15',now(),now());

commit;
