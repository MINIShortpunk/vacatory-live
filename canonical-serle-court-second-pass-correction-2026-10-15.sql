begin;

insert into public.career_opportunities
  (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select
  '8de3a4f5-f592-4cc7-b627-485e7f40acf2','e2b2bcbc-c3b0-4bee-b7d7-d2a0d1c3552b','serle-court-pupillage-2028',
  'Serle Court Pupillage — 2028 Intake','Serle Court Pupillage — 2028 Intake',
  'Funded 12-month commercial and chancery pupillage at Serle Court commencing in 2028.',
  'in_person','https://www.serlecourt.co.uk/join-us/pupillage/','https://www.pupillagegateway.com/',true,true,date '2026-10-15',date '2026-11-24'
where not exists (
  select 1 from public.career_opportunities
  where organisation_id='8de3a4f5-f592-4cc7-b627-485e7f40acf2' and slug='serle-court-pupillage-2028'
);

insert into public.career_opportunity_cycles
  (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,opens_at,opens_timezone,closes_on,closes_at,closes_timezone,programme_dates_text,application_dates_text,date_precision,duration_text,places_text,source_status,study_stage_text,academic_criteria,eligibility_text,application_process_text,assessments_text,progression_route_text,funding_text,expenses_text,right_to_work_text,disability_support_text,programme_structure_text,official_url,application_url,active,research_checked_on,additional_details_text)
select o.id,'serle-court-pupillage-2028','Serle Court Pupillage — 2028 Intake',2027,2028,2028,'fixed_deadline',
       date '2027-01-04',time '11:00','Europe/London',date '2027-01-28',time '23:59','Europe/London',
       'Twelve-month pupillage commencing in 2028.','Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.','exact','12 months','Up to four pupillages','upcoming',
       'Applicants who can complete the academic, vocational and regulatory requirements before pupillage begins.','Serle Court generally requires at least a 2:1 degree; the degree does not have to be in law.',
       'Applicants should demonstrate strong analytical ability, practical judgment, client skills and advocacy potential.',
       'Apply through the Pupillage Gateway. Applications are anonymised before review and include Serle Court’s narrative questions and a situational-judgment test. About 40 candidates are invited to a first interview and approximately 10 to 12 progress to a second-stage mock client conference.',
       'Anonymised application, narrative questions, situational-judgment test, first interview and second-stage mock client conference.',
       'Pupils are assessed individually. Serle Court aims to offer tenancy to every pupil who meets its assessment standard.',
       '£85,000 pupillage award, with up to £25,000 available as a drawdown during the year before pupillage.','No separate ordinary travel or relocation package is listed.',
       'Successful applicants must satisfy the regulatory and immigration requirements needed to undertake pupillage. Serle Court’s published policy provides assistance for successful applicants who require a visa and payment of any applicable Skills Charge.',
       'Serle Court says its selection and training processes are designed to be fair and accessible and that reasonable adjustments are available.',
       'Up to four pupils spend 12 months with four supervisors in different practice areas, working on live matters and completing advocacy and practical exercises with regular feedback.',
       'https://www.serlecourt.co.uk/join-us/pupillage/','https://www.pupillagegateway.com/',true,date '2026-10-15',
       'The £85,000 award, £25,000 drawdown and maximum of four places are published by Serle Court. The January 2027 dates are the confirmed Pupillage Gateway application timetable shown on Serle Court’s current recruitment profile.'
from public.career_opportunities o
where o.organisation_id='8de3a4f5-f592-4cc7-b627-485e7f40acf2' and o.slug='serle-court-pupillage-2028'
  and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunity_locations
  (opportunity_id,country_id,city_id,location_note,location_role,location_status,display_order)
select o.id,47,139,'Serle Court, 6 New Square, Lincoln’s Inn, London','programme','confirmed',10
from public.career_opportunities o
where o.slug='serle-court-pupillage-2028'
  and not exists (select 1 from public.career_opportunity_locations l where l.opportunity_id=o.id);

insert into public.career_opportunity_routes
  (opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select o.id,'physical_city',47,139,'Serle Court, London','confirmed',10,true
from public.career_opportunities o
where o.slug='serle-court-pupillage-2028'
  and not exists (select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id);

insert into public.career_opportunities
  (organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select '8de3a4f5-f592-4cc7-b627-485e7f40acf2','5e2816dd-108f-4443-9fb2-218def79147f','ab9949e8-a74c-43c3-a385-ded9be4fe8b5',
       'serle-court-open-day-in-person-17-november-2026','Serle Court Prospective Pupillage Open Day — In Person','Serle Court Prospective Pupillage Open Day — In Person',
       'In-person Open Day for prospective pupillage applicants to learn about Serle Court and its application process.',
       'in_person','https://www.legalcheek.com/chamber/serle-court/','https://www.legalcheek.com/chamber/serle-court/',true,true,date '2026-10-15',date '2026-11-18'
where not exists (select 1 from public.career_opportunities where slug='serle-court-open-day-in-person-17-november-2026');

insert into public.career_opportunity_cycles
  (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,closes_on,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,audience_text,study_stage_text,eligibility_text,application_process_text,assessments_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select o.id,'serle-court-open-day-in-person-2026','Serle Court Prospective Pupillage Open Day — In Person',2026,2026,2026,'fixed_deadline',
       date '2026-08-31',date '2026-11-17',date '2026-11-17',date '2026-11-17',
       'In-person Open Day on 17 November 2026.','Registration opened on 31 August 2026 and closes on 17 November 2026.','exact','One-day event','open',
       'Prospective pupillage applicants.','Law students, graduates and career changers considering the Commercial Chancery Bar.',
       'Open to prospective applicants interested in Serle Court pupillage.','Register through the application route linked from Serle Court’s current recruitment profile.','Information event; no assessment.',
       'An opportunity to learn about Serle Court, pupillage and the application process.','https://www.legalcheek.com/chamber/serle-court/','https://www.legalcheek.com/chamber/serle-court/',true,date '2026-10-15'
from public.career_opportunities o
where o.slug='serle-court-open-day-in-person-17-november-2026'
  and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunity_locations
  (opportunity_id,country_id,city_id,location_note,location_role,location_status,display_order)
select o.id,47,139,'Serle Court, 6 New Square, Lincoln’s Inn, London','programme','confirmed',10
from public.career_opportunities o
where o.slug='serle-court-open-day-in-person-17-november-2026'
  and not exists (select 1 from public.career_opportunity_locations l where l.opportunity_id=o.id);

insert into public.career_opportunity_routes
  (opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select o.id,'physical_city',47,139,'Serle Court, London','confirmed',10,true
from public.career_opportunities o
where o.slug='serle-court-open-day-in-person-17-november-2026'
  and not exists (select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id);

insert into public.career_opportunities
  (organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select '8de3a4f5-f592-4cc7-b627-485e7f40acf2','5e2816dd-108f-4443-9fb2-218def79147f','ab9949e8-a74c-43c3-a385-ded9be4fe8b5',
       'serle-court-open-day-virtual-18-november-2026','Serle Court Prospective Pupillage Open Day — Virtual','Serle Court Prospective Pupillage Open Day — Virtual',
       'Virtual Open Day for prospective pupillage applicants to learn about Serle Court and its application process.',
       'virtual','https://www.legalcheek.com/chamber/serle-court/','https://www.legalcheek.com/chamber/serle-court/',true,true,date '2026-10-15',date '2026-11-19'
where not exists (select 1 from public.career_opportunities where slug='serle-court-open-day-virtual-18-november-2026');

insert into public.career_opportunity_cycles
  (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,closes_on,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,audience_text,study_stage_text,eligibility_text,application_process_text,assessments_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select o.id,'serle-court-open-day-virtual-2026','Serle Court Prospective Pupillage Open Day — Virtual',2026,2026,2026,'fixed_deadline',
       date '2026-08-31',date '2026-11-18',date '2026-11-18',date '2026-11-18',
       'Virtual Open Day on 18 November 2026.','Registration opened on 31 August 2026 and closes on 18 November 2026.','exact','One-day event','open',
       'Prospective pupillage applicants.','Law students, graduates and career changers considering the Commercial Chancery Bar.',
       'Open to prospective applicants interested in Serle Court pupillage.','Register through the application route linked from Serle Court’s current recruitment profile.','Information event; no assessment.',
       'An online opportunity to learn about Serle Court, pupillage and the application process.','https://www.legalcheek.com/chamber/serle-court/','https://www.legalcheek.com/chamber/serle-court/',true,date '2026-10-15'
from public.career_opportunities o
where o.slug='serle-court-open-day-virtual-18-november-2026'
  and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunity_routes
  (opportunity_id,route_kind,route_note,route_status,display_order,active)
select o.id,'virtual','Online attendance','confirmed',10,true
from public.career_opportunities o
where o.slug='serle-court-open-day-virtual-18-november-2026'
  and not exists (select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id);

update public.chambers
set pupillage_overview='Serle Court recruits up to four 12-month pupils through the Pupillage Gateway. The next application window opens at 11:00 on 4 January 2027 and closes at 23:59 on 28 January 2027 for pupillage commencing in 2028. The award is £85,000, with up to £25,000 available as a pre-pupillage drawdown. Applications are anonymised and use published competencies, a situational-judgment test and two interview stages. Pupils sit with four supervisors and are assessed individually for tenancy.',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-19',updated_at=now()
where organisation_id='8de3a4f5-f592-4cc7-b627-485e7f40acf2';

commit;
