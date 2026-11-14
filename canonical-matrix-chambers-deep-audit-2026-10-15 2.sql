begin;

update public.legal_organisations set research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now() where id='df82df8d-9f97-409c-b401-9c1254a74850';
update public.chambers set
 pupillage_overview='Matrix calls pupillage traineeship. The next recruitment round opens in January 2027 for up to three 12-month traineeships beginning in October 2028. The published award is £65,000: £15,000 in the year before traineeship and £50,000 during the training year. Matrix recruits through its own anonymised process in accordance with the mandatory Pupillage Gateway timetable.',
 mini_pupillage_overview='Matrix does not accept direct mini-pupillage applications. Current student routes include placements through the Bridging the Bar Academy, a school and college work-experience programme, Future Lawyers mentoring and partner access schemes.',
 tenancy_overview='Vacatory lists student and aspiring-barrister routes only; staff vacancies and member recruitment are excluded.',
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where organisation_id='df82df8d-9f97-409c-b401-9c1254a74850';

delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='5fe1c1a8-bc44-4e04-a1f3-9ac225a6a55f';
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='5fe1c1a8-bc44-4e04-a1f3-9ac225a6a55f';
delete from public.career_opportunity_identity_stage where career_opportunity_id='5fe1c1a8-bc44-4e04-a1f3-9ac225a6a55f';
delete from public.career_opportunities where id='5fe1c1a8-bc44-4e04-a1f3-9ac225a6a55f';

update public.career_opportunities set
 public_summary='One-week London work experience for students undertaking GCSEs, A-Levels or equivalent, with half of places prioritised for applicants meeting Matrix’s access criteria.',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-10-20',updated_at=now()
where id='2de620cb-d3b9-4b45-b782-9f74c7bd8278';
update public.career_opportunity_cycles set
 opens_timezone='Europe/London',funding_text='Unpaid; Matrix reimburses limited expenses and invites applicants facing cost barriers to discuss further support in advance.',
 research_checked_on=date '2026-10-15',updated_at=now()
where id='02890e28-d075-4947-85ef-b6a91d8aa923';

update public.career_opportunities set
 official_name='10,000 Black Interns — The Bar 2027 — Matrix Participating Organisation',
 public_name='10,000 Black Interns — The Bar 2027 — Matrix Participating Organisation',
 public_summary='Paid six-week Bar internship programme for eligible Black students and recent graduates, with Matrix listed as a participating organisation.',
 official_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
 application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='7232947c-47b0-4a1f-8dec-fcc38f57c84b';
update public.career_opportunity_cycles set
 cycle_label='10,000 Black Interns — The Bar 2027 — Matrix Participating Organisation',
 application_year=2026,date_precision='exact',closes_timezone='Europe/London',
 assessments_text='The Foundation and participating hosts manage application review and selection.',
 right_to_work_text='Applicants must already have unrestricted permission to work full-time in the United Kingdom when applying.',
 research_checked_on=date '2026-10-15',updated_at=now()
where id='7cb11e11-db47-4e7b-b3d3-95f62e3d8d1f';
update public.career_opportunity_compensation set compensation_status='published_amount',updated_at=now() where id='71e01e02-7194-4151-ade2-7e6843e5ff41';

delete from public.career_opportunity_compensation_identity_stage where compensation_id='0fa142ad-6d83-4291-91bf-dc588f1faa26';
delete from public.career_opportunity_compensation where id='0fa142ad-6d83-4291-91bf-dc588f1faa26';
update public.career_opportunities set
 official_name='Bridging the Bar Academy 2027/28 — Matrix Participating Chambers',
 public_name='Bridging the Bar Academy 2027/28 — Matrix Participating Chambers',
 public_summary='Access programme providing mentoring, advocacy and application training and at least one mini-pupillage through participating organisations, including Matrix.',
 official_url='https://bridgingthebar.org/academy-applications/',application_url='https://bridgingthebar.org/academy-applications/',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-06',updated_at=now()
where id='93e6dfd6-5269-4ca5-8cd1-d29ca699923e';
update public.career_opportunity_cycles set
 cycle_label='Bridging the Bar Academy 2027/28 — Matrix Participating Chambers',
 application_model='fixed_deadline',source_status='open',opens_timezone='Europe/London',
 duration_text='August 2027 to June 2028',programme_starts_on=date '2027-08-01',programme_ends_on=date '2028-06-30',
 expenses_text='The Academy is free to participate in; support attached to any allocated placement is determined by the host.',
 assessments_text='Three written questions, one video presentation and two unseen timed video questions.',
 study_stage_text='Bar Course student in 2027–28 or Bar Course graduate intending to apply for pupillage in 2028.',
 academic_criteria='Selection considers academic excellence and understanding of a career at the Bar.',
 eligibility_text='Applicants must meet the Academy’s published education and financial-support criteria, intend to apply for pupillage in 2028 and be available in the United Kingdom for all programme activity.',
 right_to_work_text=null,source_status_note=null,
 programme_dates_text='The Academy runs from August 2027 to June 2028.',
 research_checked_on=date '2026-10-15',updated_at=now()
where id='81fb5d41-12ef-44c5-941f-f1dab696944d';

update public.career_opportunities set research_checked_on=date '2026-10-15',next_review_on=date '2027-01-29',updated_at=now() where id='39d1d903-1579-4d5f-b865-594e968eecf7';
update public.career_opportunity_cycles set
 cycle_label='Matrix Chambers Traineeship — October 2028 Start',application_year=2027,
 funding_text='£65,000 total award: £15,000 paid in the year before traineeship and £50,000 during the 12-month traineeship.',
 programme_starts_on=date '2028-10-01',programme_dates_text='The 12-month traineeship begins in October 2028.',
 research_checked_on=date '2026-10-15',updated_at=now()
where id='e00457bf-1e04-4b9f-b20f-9f08b4b7e8f9';

update public.career_opportunities set research_checked_on=date '2026-10-15',next_review_on=date '2027-01-15',updated_at=now() where id='9c491dfb-d8bb-4436-93ce-ff4e648366c5';
update public.career_opportunity_cycles set
 assessments_text='Eligibility review and mentor matching by Lawyers Who Care.',
 academic_criteria=null,right_to_work_text=null,
 expenses_text='Mentoring is unpaid. Lawyers Who Care encourages partner organisations to offer paid work experience but does not provide placements itself.',
 funding_text=null,research_checked_on=date '2026-10-15',updated_at=now()
where id='45e43f29-6ff8-4e9a-9de5-aef354af0767';

insert into public.career_opportunities (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'df82df8d-9f97-409c-b401-9c1254a74850','b29890c7-5f97-4d55-bbf8-9e7fda5e22b3','matrix-future-lawyers-mentoring-2027','Matrix Future Lawyers Mentoring 2027','Matrix Future Lawyers Mentoring 2027','Mentoring, advocacy and networking programme for A-Level-equivalent students selected through Matrix’s priority work-experience route.','hybrid','https://www.matrixlaw.co.uk/recruitment/future-lawyers-mentoring/','https://www.matrixlaw.co.uk/recruitment/work-experience/',true,true,date '2026-10-15',date '2026-10-20'
where not exists (select 1 from public.career_opportunities where organisation_id='df82df8d-9f97-409c-b401-9c1254a74850' and slug='matrix-future-lawyers-mentoring-2027');
insert into public.career_opportunity_cycles (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,closes_on,closes_at,closes_timezone,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,study_stage_text,eligibility_text,official_url,application_url,active,research_checked_on,application_process_text,programme_structure_text,assessments_text)
select o.id,'matrix-future-lawyers-mentoring-2027','Matrix Future Lawyers Mentoring 2027',2026,2027,2027,'fixed_deadline',date '2026-10-19',time '17:00','Europe/London','Mentoring and workshops take place after selection during the 2027 work-experience cycle.','Apply for January–June 2027 work experience by 17:00 on 19 October 2026 and select the Future Lawyers option.','exact','Mentoring during the year','open','A-Level or equivalent student completing a Matrix priority work-experience placement.','Applicants must seek a legal career, meet at least two published access criteria and be selected for a priority work-experience placement.','https://www.matrixlaw.co.uk/recruitment/future-lawyers-mentoring/','https://www.matrixlaw.co.uk/recruitment/work-experience/',true,date '2026-10-15','Apply for Matrix work experience and select the Future Lawyers option. The task and interview take place during the placement.','Participants are matched with a Matrix member for mentoring and invited to an advocacy and networking workshop.','A task and interview during the work-experience placement.'
from public.career_opportunities o where o.slug='matrix-future-lawyers-mentoring-2027' and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunities (organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,public_summary,public_variant,public_variant_kind,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'df82df8d-9f97-409c-b401-9c1254a74850','5e2816dd-108f-4443-9fb2-218def79147f','ab9949e8-a74c-43c3-a385-ded9be4fe8b5','matrix-student-open-day-diversity-open-evening-2026','Matrix Student Open Day and Diversity Open Evening 2026','Matrix Student Open Day and Diversity Open Evening 2026','Hybrid student open day and diversity evening for prospective applicants to Matrix’s October 2028 traineeship.','Event','other','hybrid','https://www.matrixlaw.co.uk/events/annual-student-open-day-and-diversity-open-evening-8-december-2026/','https://www.matrixlaw.co.uk/events/annual-student-open-day-and-diversity-open-evening-8-december-2026/',true,true,date '2026-10-15',date '2026-12-09'
where not exists (select 1 from public.career_opportunities where organisation_id='df82df8d-9f97-409c-b401-9c1254a74850' and slug='matrix-student-open-day-diversity-open-evening-2026');
insert into public.career_opportunity_cycles (opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,study_stage_text,eligibility_text,official_url,application_url,active,research_checked_on,application_process_text,programme_structure_text,disability_support_text)
select o.id,'matrix-student-open-day-diversity-open-evening-2026','Matrix Student Open Day and Diversity Open Evening 2026',2026,2026,'rolling',date '2026-12-08',date '2026-12-08','8 December 2026. Student Open Day: 13:00–15:00. Diversity Open Evening: 17:00–20:00.','Registration is available by email while places remain.','exact','Student Open Day approximately two hours; Diversity Open Evening begins at 17:00.','open','Prospective applicants considering Matrix’s January 2027 traineeship recruitment round.','The Student Open Day prioritises forthcoming-round applicants for limited in-person places. The Diversity Open Evening adds sessions for people from backgrounds underrepresented at the Bar.','https://www.matrixlaw.co.uk/events/annual-student-open-day-and-diversity-open-evening-8-december-2026/','https://www.matrixlaw.co.uk/events/annual-student-open-day-and-diversity-open-evening-8-december-2026/',true,date '2026-10-15','Email recruitment@matrixlaw.co.uk with your name, email address, preferred attendance mode, chosen session and whether you intend to apply in the forthcoming traineeship round.','Both sessions are available in person and online and cover Matrix, its application process and life as a trainee.','Applicants may request reasonable adjustments or accessibility support when registering.'
from public.career_opportunities o where o.slug='matrix-student-open-day-diversity-open-evening-2026' and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

commit;

-- Second-pass verification against Matrix's May 2026 traineeship brochure and
-- current recruitment/event pages. Keep month-only programme timing as text.
begin;
update public.chambers set
 pupillage_overview='Matrix calls pupillage traineeship. The next recruitment round opens in January 2027 for up to two 12-month traineeships beginning in October 2028. The published award is £65,000: £15,000 in the year before traineeship and £50,000 during the training year. Matrix recruits through its own anonymised process in accordance with the mandatory Pupillage Gateway timetable.',
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where organisation_id='df82df8d-9f97-409c-b401-9c1254a74850';

update public.career_opportunities set
 public_summary='Matrix’s 12-month pupillage-equivalent traineeship, with a £65,000 award and up to two places offered through a three-stage selection process.',
 research_checked_on=date '2026-10-15',next_review_on=date '2027-01-29',updated_at=now()
where id='39d1d903-1579-4d5f-b865-594e968eecf7';

update public.career_opportunity_cycles set
 places_text='Up to two traineeships',
 programme_starts_on=null,
 programme_dates_text='The 12-month traineeship begins in October 2028; Matrix does not publish an exact start day.',
 right_to_work_text='The Bar Council can provide Certificates of Sponsorship to suitably qualified non-UK nationals who secure traineeship. Matrix may advance the relevant sponsorship cost from the £15,000 pre-traineeship payment.',
 application_process_text='Apply on Matrix’s own application form. Applications are anonymised before sifting; Matrix follows the mandatory Pupillage Gateway timetable but does not use the Gateway application system.',
 assessments_text='Three stages: anonymised application sift to approximately 40 candidates; a roughly 20-minute first interview reducing the field to up to 10; then a roughly 45-minute final interview including a legal problem provided 45 minutes beforehand.',
 research_checked_on=date '2026-10-15',updated_at=now()
where id='e00457bf-1e04-4b9f-b20f-9f08b4b7e8f9';
commit;

begin;
update public.career_opportunity_cycles set academic_criteria=null,updated_at=now() where id='7cb11e11-db47-4e7b-b3d3-95f62e3d8d1f';
update public.career_opportunity_cycles set programme_dates_text='Registration remains open; mentoring lasts at least two years from matching.',updated_at=now() where id='45e43f29-6ff8-4e9a-9de5-aef354af0767';

update public.career_opportunity_routes
set route_kind='physical_city',country_id=47,city_id=139,scope_key=null,route_status='confirmed',route_note='London',display_order=10,updated_at=now()
where opportunity_id='2afffbbb-c478-4558-aff2-53ddd5ecdb84' and route_kind='unresolved';
update public.career_opportunity_routes
set route_kind='physical_city',country_id=47,city_id=139,scope_key=null,route_status='confirmed',route_note='Matrix Chambers, London',display_order=10,updated_at=now()
where opportunity_id='c547aee9-9eb9-4694-b3da-23951559a5cc' and route_kind='unresolved';
insert into public.career_opportunity_routes (opportunity_id,route_kind,route_note,route_status,display_order,active)
select 'c547aee9-9eb9-4694-b3da-23951559a5cc','virtual','Online attendance available','confirmed',20,true
where not exists (select 1 from public.career_opportunity_routes where opportunity_id='c547aee9-9eb9-4694-b3da-23951559a5cc' and route_kind='virtual');
commit;
