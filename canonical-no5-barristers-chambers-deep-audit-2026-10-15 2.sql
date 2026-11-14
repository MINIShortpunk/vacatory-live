begin;

update public.legal_organisations set
 research_status='verified',research_checked_on=date '2026-10-15',
 next_review_on=date '2026-11-24',
 uk_visa_summary='Applicants who require immigration permission should contact No5 directly before applying to confirm the right-to-work and sponsorship arrangements available for the relevant pupillage intake.',
 uk_visa_checked_on=date '2026-10-15',
 uk_visa_source_url='https://www.no5.com/recruitment/pupillage/',
 uk_visa_source_title='No5 Barristers’ Chambers — Pupillage',
 updated_at=now()
where id='e46c1cdc-d113-439e-a95c-37f6ea00c043';

update public.chambers set
 pupillage_overview='No5 offers 12-month pupillages across selected practice groups, with placements based in Birmingham and/or London according to the recruiting group. The most recently published recruitment round, for pupillages commencing in 2027, is closed. That round offered up to twelve places, a £30,000 first-six award, guaranteed second-six billings of at least £30,000 and funded compulsory training.',
 mini_pupillage_overview='No5 does not currently advertise a standalone mini-pupillage application route. In its most recently completed pupillage recruitment round, candidates progressing beyond the advocacy exercise attended a one-day assessed mini-pupillage before final interview.',
 tenancy_overview='Pupillages are offered with a view to tenancy where the published benchmark requirements are met. Staff, probationary-tenancy and established-practitioner recruitment are excluded from Vacatory.',
 research_status='verified',research_checked_on=date '2026-10-15',
 next_review_on=date '2026-11-24',updated_at=now()
where organisation_id='e46c1cdc-d113-439e-a95c-37f6ea00c043';

delete from public.career_opportunity_routes
where opportunity_id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';
delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';
delete from public.career_opportunity_identity_stage
where career_opportunity_id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';
delete from public.career_opportunities
where id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';

commit;

-- Second pass: the separate official mini-pupillage page confirms a May 2027
-- reopening and participation in Bridging the Bar.
begin;
update public.chambers set
 mini_pupillage_overview='No5 offers three-day mini-pupillages in Birmingham or London. The next application window opens in May 2027. No5 also allocates some placements through named access schemes and student moot prizes. Separately, candidates progressing through pupillage recruitment may attend a one-day assessed mini-pupillage before final interview.',
 research_checked_on=date '2026-10-15',next_review_on=date '2027-05-02',updated_at=now()
where organisation_id='e46c1cdc-d113-439e-a95c-37f6ea00c043';

insert into public.career_opportunities(organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'e46c1cdc-d113-439e-a95c-37f6ea00c043','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89','no5-three-day-mini-pupillage-may-2027','No5 Three-Day Mini-Pupillage — May 2027 Application Window','No5 Three-Day Mini-Pupillage — May 2027 Application Window','Three-day mini-pupillage in Birmingham or London for students who have commenced a degree course.','in_person','https://www.no5.com/recruitment/mini-pupillage/','https://www.no5.com/recruitment/mini-pupillage/',true,true,date '2026-10-15',date '2027-05-02'
where not exists(select 1 from public.career_opportunities where slug='no5-three-day-mini-pupillage-may-2027');
insert into public.career_opportunity_cycles(opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,application_dates_text,date_precision,duration_text,source_status,study_stage_text,academic_criteria,eligibility_text,official_url,application_url,active,research_checked_on,application_process_text,programme_structure_text,expenses_text)
select o.id,'no5-three-day-mini-pupillage-may-2027','No5 Three-Day Mini-Pupillage — May 2027 Application Window',2027,2027,'fixed_deadline','Applications reopen in May 2027; No5 has published the month but not the opening day or closing deadline.','text_only','Three days','upcoming','Students who have commenced a degree course.','Normally AAB at A-Level or equivalent and an actual or predicted 2:1 degree; mitigating circumstances are considered.','Applicants are assessed on intellectual ability, commitment and motivation, public-speaking experience and written presentation.','https://www.no5.com/recruitment/mini-pupillage/','https://www.no5.com/recruitment/mini-pupillage/',true,date '2026-10-15','Apply through the No5 mini-pupillage page when the May 2027 window opens.','Court or tribunal observation, conferences and legal research with one or more members of chambers.','Successful applicants may seek up to £500 from Lincoln’s Inn’s Mini-Pupillage Grant Scheme, subject to that scheme’s conditions.'
from public.career_opportunities o where o.slug='no5-three-day-mini-pupillage-may-2027' and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunities(organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'e46c1cdc-d113-439e-a95c-37f6ea00c043','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89','no5-bridging-the-bar-academy-2027-28','Bridging the Bar Academy 2027/28 — No5 Participating Chambers','Bridging the Bar Academy 2027/28 — No5 Participating Chambers','Access programme providing mentoring, advocacy and application training and at least one mini-pupillage through participating chambers, including No5.','hybrid','https://www.no5.com/recruitment/mini-pupillage/','https://bridgingthebar.org/academy-applications/',true,true,date '2026-10-15',date '2026-11-06'
where not exists(select 1 from public.career_opportunities where slug='no5-bridging-the-bar-academy-2027-28');
insert into public.career_opportunity_cycles(opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,closes_on,closes_at,closes_timezone,application_dates_text,programme_dates_text,date_precision,duration_text,source_status,study_stage_text,academic_criteria,eligibility_text,official_url,application_url,active,research_checked_on,application_process_text,programme_structure_text,expenses_text)
select o.id,'no5-bridging-the-bar-academy-2027-28','Bridging the Bar Academy 2027/28 — No5 Participating Chambers',2026,2027,2027,'fixed_deadline',date '2026-10-02',date '2026-11-05',time '17:00','Europe/London','Applications close at 17:00 on 5 November 2026.','The Academy runs from August 2027 to June 2028.','exact','August 2027 to June 2028','open','Bar Course student in 2027–28 or Bar Course graduate intending to apply for pupillage in 2028.','Selection considers academic excellence and understanding of a career at the Bar.','Applicants must meet the Academy’s published education and financial-support criteria, intend to apply for pupillage in 2028 and be available in the United Kingdom for programme activity.','https://www.no5.com/recruitment/mini-pupillage/','https://bridgingthebar.org/academy-applications/',true,date '2026-10-15','Apply once through the Bridging the Bar Academy process.','Mentoring, advocacy and application training, workshops and at least one mini-pupillage; placement at No5 is not guaranteed.','The Academy is free; placement support is determined by the relevant host.'
from public.career_opportunities o where o.slug='no5-bridging-the-bar-academy-2027-28' and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

delete from public.career_opportunity_routes where route_kind='unresolved' and opportunity_id in
 (select id from public.career_opportunities where slug in ('no5-three-day-mini-pupillage-may-2027','no5-bridging-the-bar-academy-2027-28'));
insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select o.id,'physical_city',47,113,'Birmingham','confirmed',10,true from public.career_opportunities o where o.slug='no5-three-day-mini-pupillage-may-2027' and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.city_id=113);
insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select o.id,'physical_city',47,139,'London','confirmed',20,true from public.career_opportunities o where o.slug='no5-three-day-mini-pupillage-may-2027' and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.city_id=139);
insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,route_note,route_status,display_order,active)
select o.id,'country_only',47,'United Kingdom / partner-managed','confirmed',10,true from public.career_opportunities o where o.slug='no5-bridging-the-bar-academy-2027-28' and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.route_kind='country_only');
commit;
