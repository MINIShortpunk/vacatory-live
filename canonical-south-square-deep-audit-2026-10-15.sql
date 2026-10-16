begin;

update public.legal_organisations
set careers_url='https://southsquare.com/join-us/pupillage/',research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-06',updated_at=now()
where id='e1dad1a3-efc8-4dbc-9879-b7b5566b5e85';

update public.chambers
set pupillage_overview='South Square recruits up to three 12-month pupils through the Pupillage Gateway. Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027 for the 2028 intake. The award is £90,000, with up to £20,000 available before pupillage for Bar-course living costs. Pupils rotate through six-to-eight-week supervisor seats, complete seven formal assessments and are considered individually for tenancy.',
    mini_pupillage_overview='South Square offers approximately 40 non-assessed two-day mini-pupillages each year. Applications are open for placements between April and July 2027, closing on 12 February 2027, and placements between September and November 2027, closing on 2 July 2027. Law students should normally apply in their final year and non-law applicants after beginning conversion study. Applications are by CV and covering letter, and reasonable public-transport expenses are reimbursed up to £100.',
    tenancy_overview='South Square aims to offer tenancy to every pupil who meets the required standard. Vacatory lists student and aspiring-barrister routes only; third-six, lateral and established-practitioner recruitment are excluded.',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-06',updated_at=now()
where organisation_id='e1dad1a3-efc8-4dbc-9879-b7b5566b5e85';

delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in ('533a60b5-3bbf-4469-86bc-bedd89c0ef81','58ab1514-5387-448e-ac4a-30aa00d0c9d0');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in ('533a60b5-3bbf-4469-86bc-bedd89c0ef81','58ab1514-5387-448e-ac4a-30aa00d0c9d0');
delete from public.career_opportunity_identity_stage where career_opportunity_id in ('533a60b5-3bbf-4469-86bc-bedd89c0ef81','58ab1514-5387-448e-ac4a-30aa00d0c9d0');
delete from public.career_opportunities where id in ('533a60b5-3bbf-4469-86bc-bedd89c0ef81','58ab1514-5387-448e-ac4a-30aa00d0c9d0');

update public.career_opportunities
set public_name='South Square Pupillage — 2028 Intake',official_name='South Square Pupillage — 2028 Intake',
    public_summary='Funded 12-month commercial pupillage at South Square commencing in 2028.',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',updated_at=now()
where id='85d1b6b5-09fe-476f-b3f2-e56d8b9ff61e';
update public.career_opportunity_cycles
set cycle_label='South Square Pupillage — 2028 Intake',application_year=2027,programme_year=2028,intake_year=2028,
    opens_timezone='Europe/London',closes_timezone='Europe/London',programme_dates_text='Twelve-month pupillage commencing in 2028.',
    funding_text='£90,000 pupillage award, with up to £20,000 available before pupillage for Bar-course living costs.',
    source_status='upcoming',source_status_note=null,right_to_work_text=null,research_checked_on=date '2026-10-15',updated_at=now()
where id='164be03b-d80a-4137-ad22-6a12307faef6';

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'e1dad1a3-efc8-4dbc-9879-b7b5566b5e85','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89','south-square-mini-pupillage-april-july-2027',
 'South Square Mini-Pupillage — April to July 2027','South Square Mini-Pupillage — April to July 2027','Two-day, non-assessed commercial mini-pupillage at South Square between April and July 2027.',
 'in_person','https://southsquare.com/join-us/pupillage/','https://southsquare.com/join-us/pupillage/',true,true,date '2026-10-15',date '2027-02-13'
where not exists(select 1 from public.career_opportunities where slug='south-square-mini-pupillage-april-july-2027');
insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,opens_timezone,closes_on,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,places_text,source_status,study_stage_text,academic_criteria,eligibility_text,application_process_text,assessments_text,progression_route_text,expenses_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select o.id,'south-square-mini-pupillage-april-july-2027','South Square Mini-Pupillage — April to July 2027',2026,2027,2027,'fixed_deadline',date '2026-09-01','Europe/London',date '2027-02-12','Europe/London',date '2027-04-01',date '2027-07-31',
 'Two-day placements between April and July 2027.','Applications opened on 1 September 2026 and close on 12 February 2027.','exact','Two days','Part of approximately 40 annual places','open',
 'Final-year law students and non-law applicants who have begun conversion study.','Minimum 2:1 degree or predicted degree.','Applicants should have a strong academic record and genuine interest in commercial practice at the Bar.',
 'Email a CV and covering letter identifying the mini-pupillage programme to pupillage@southsquare.com.','CV and covering-letter review; the placement is not assessed for pupillage recruitment.','No automatic progression and mini-pupillage is not required for pupillage.','Reasonable public-transport expenses are reimbursed up to £100.',
 'Two days shadowing a junior member of chambers and observing the range of South Square’s commercial work.','https://southsquare.com/join-us/pupillage/','https://southsquare.com/join-us/pupillage/',true,date '2026-10-15'
from public.career_opportunities o where o.slug='south-square-mini-pupillage-april-july-2027'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'e1dad1a3-efc8-4dbc-9879-b7b5566b5e85','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89','south-square-mini-pupillage-september-november-2027',
 'South Square Mini-Pupillage — September to November 2027','South Square Mini-Pupillage — September to November 2027','Two-day, non-assessed commercial mini-pupillage at South Square between September and November 2027.',
 'in_person','https://southsquare.com/join-us/pupillage/','https://southsquare.com/join-us/pupillage/',true,true,date '2026-10-15',date '2027-07-03'
where not exists(select 1 from public.career_opportunities where slug='south-square-mini-pupillage-september-november-2027');
insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,opens_timezone,closes_on,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,places_text,source_status,study_stage_text,academic_criteria,eligibility_text,application_process_text,assessments_text,progression_route_text,expenses_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select o.id,'south-square-mini-pupillage-september-november-2027','South Square Mini-Pupillage — September to November 2027',2026,2027,2027,'fixed_deadline',date '2026-09-01','Europe/London',date '2027-07-02','Europe/London',date '2027-09-01',date '2027-11-30',
 'Two-day placements between September and November 2027.','Applications opened on 1 September 2026 and close on 2 July 2027.','exact','Two days','Part of approximately 40 annual places','open',
 'Final-year law students and non-law applicants who have begun conversion study.','Minimum 2:1 degree or predicted degree.','Applicants should have a strong academic record and genuine interest in commercial practice at the Bar.',
 'Email a CV and covering letter identifying the mini-pupillage programme to pupillage@southsquare.com.','CV and covering-letter review; the placement is not assessed for pupillage recruitment.','No automatic progression and mini-pupillage is not required for pupillage.','Reasonable public-transport expenses are reimbursed up to £100.',
 'Two days shadowing a junior member of chambers and observing the range of South Square’s commercial work.','https://southsquare.com/join-us/pupillage/','https://southsquare.com/join-us/pupillage/',true,date '2026-10-15'
from public.career_opportunities o where o.slug='south-square-mini-pupillage-september-november-2027'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'e1dad1a3-efc8-4dbc-9879-b7b5566b5e85','b29890c7-5f97-4d55-bbf8-9e7fda5e22b3','south-square-combar-mentoring-2026-27','COMBAR Mentoring Scheme 2026–27 — South Square Participating Set','COMBAR Mentoring Scheme 2026–27 — South Square Participating Set','Commercial Bar mentoring scheme for applicants from groups underrepresented at the Bar, with South Square participating as a member set.','hybrid',
 'https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/','https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/',true,true,date '2026-10-15',date '2026-10-24'
where not exists(select 1 from public.career_opportunities where slug='south-square-combar-mentoring-2026-27');
insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,closes_on,closes_at,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,study_stage_text,eligibility_text,expenses_text,official_url,application_url,active,research_checked_on,application_process_text,programme_structure_text,assessments_text,additional_details_text)
select o.id,'south-square-combar-mentoring-2026-27','COMBAR Mentoring Scheme 2026–27 — South Square Participating Set',2026,2026,2026,'fixed_deadline',date '2026-10-23',time '23:59','Europe/London',date '2026-11-01',date '2027-06-30',
 'Mentoring takes place during the 2026–27 cycle. A pupillage application and interview workshop and social event is planned for 13 January 2027.','The extended application deadline is 23:59 on 23 October 2026.','exact','2026–27 mentoring cycle','open',
 'Undergraduates and graduates who do not hold a pupillage offer and have realistic prospects of obtaining a Commercial Bar pupillage.','Applicants must be from a group underrepresented at the Bar, demonstrate potential to pursue a career at the Commercial Bar and show that they would benefit from mentoring.','Participating sets cover reasonable travel expenses for mentees allocated to them.',
 'https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/','https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/',true,date '2026-10-15',
 'Download and complete the COMBAR application form, save it as a PDF using the required naming convention and email it to MentoringURG@combar.com by the deadline.','Successful applicants receive one-to-one mentoring from a practitioner at a participating set, plus access to a pupillage application and interview workshop and social event.','COMBAR gives equal weight to applicants’ need for mentoring and their potential to pursue a career at the Bar.','COMBAR expects about 250 places across 26 participating sets; mentor allocation is managed by COMBAR.'
from public.career_opportunities o where o.slug='south-square-combar-mentoring-2026-27'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'e1dad1a3-efc8-4dbc-9879-b7b5566b5e85','06f22221-7e57-4379-b2a1-fcbec5d4f4bb','south-square-10000-black-interns-legal-the-bar-2027','10,000 Black Interns — The Bar 2027 — South Square Participating Set','10,000 Black Interns — The Bar 2027 — South Square Participating Set','Paid Summer 2027 internship programme for Black students and recent graduates, with South Square participating in the Legal: The Bar workstream.','in_person',
 'https://southsquare.com/join-us/pupillage/','https://10000internsfoundation.com/students-graduates/10000-black-interns/',true,true,date '2026-10-15',date '2026-11-02'
where not exists(select 1 from public.career_opportunities where slug='south-square-10000-black-interns-legal-the-bar-2027');
insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,opens_timezone,closes_on,closes_at,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,study_stage_text,eligibility_text,application_process_text,assessments_text,progression_route_text,funding_text,right_to_work_text,official_url,application_url,active,research_checked_on,additional_details_text)
select o.id,'south-square-10000-black-interns-2027','10,000 Black Interns — The Bar 2027 — South Square Participating Set',2026,2027,2027,'fixed_deadline',date '2026-10-05','Europe/London',date '2026-11-01',time '23:59','Europe/London',date '2027-05-01',date '2027-09-30',
 'Paid internship of at least six weeks during Summer 2027.','Applications opened on 5 October 2026 and close at 23:59 on 1 November 2026.','exact','At least six weeks','open','Black students and recent graduates.',
 'Applicants must meet the 10,000 Interns Foundation eligibility rules for the Summer 2027 programme, including the programme’s Black heritage and UK work-permission requirements.','Apply centrally and select the Legal: The Bar workstream and preferred location. The Foundation manages matching; applicants cannot select a particular chambers.','The Foundation and participating organisations manage selection and matching.','Participation does not provide automatic progression to pupillage or tenancy.','Paid at no less than the real Living Wage for at least six weeks.','Applicants must have unrestricted permission to work full-time in the United Kingdom for the internship period.',
 'https://southsquare.com/join-us/pupillage/','https://10000internsfoundation.com/students-graduates/10000-black-interns/',true,date '2026-10-15','South Square identifies 10,000 Black Interns among the external organisations supporting its fair-recruitment and inclusion work. Allocation is managed centrally and is not guaranteed.'
from public.career_opportunities o where o.slug='south-square-10000-black-interns-legal-the-bar-2027'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'e1dad1a3-efc8-4dbc-9879-b7b5566b5e85','5e2816dd-108f-4443-9fb2-218def79147f','0565330b-8f5f-45ff-9314-1f3b25ebf243','south-square-bar-council-pupillage-fair-2026','Bar Council Pupillage Fair 2026 — Meet South Square','Bar Council Pupillage Fair 2026 — Meet South Square','Meet South Square representatives and learn about its commercial pupillage and mini-pupillage routes at the Bar Council Pupillage Fair.','in_person',
 'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',true,true,date '2026-10-15',date '2026-10-18'
where not exists(select 1 from public.career_opportunities where slug='south-square-bar-council-pupillage-fair-2026');
insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,audience_text,eligibility_text,application_process_text,assessments_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select o.id,'south-square-bar-council-pupillage-fair-2026','Bar Council Pupillage Fair 2026 — Meet South Square',2026,2026,2026,'rolling',date '2026-10-17',date '2026-10-17','17 October 2026, 10:00–15:00, at Convene, 133 Houndsditch, London EC3A 7DB.','Book a free ticket through the Bar Council Pupillage Fair page.','exact','One-day fair','upcoming','Students, graduates and prospective barristers.','Open to people exploring a career at the Bar or preparing a pupillage application.','Register through the official Bar Council page.','Information event; no assessment.','Meet chambers and Bar organisations, attend seminars and obtain careers guidance.',
 'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html','https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',true,date '2026-10-15'
from public.career_opportunities o where o.slug='south-square-bar-council-pupillage-fair-2026'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunity_routes(opportunity_id,route_kind,scope_key,route_note,route_status,display_order,active)
select o.id,'flexible_scope','partner-managed','COMBAR manages mentor allocation across participating member sets.','confirmed',100,true from public.career_opportunities o
where o.slug='south-square-combar-mentoring-2026-27' and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id);
insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select o.id,'physical_city',47,139,'London','confirmed',10,true from public.career_opportunities o
where o.slug in ('south-square-mini-pupillage-april-july-2027','south-square-mini-pupillage-september-november-2027','south-square-10000-black-interns-legal-the-bar-2027','south-square-bar-council-pupillage-fair-2026')
and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id);

commit;
