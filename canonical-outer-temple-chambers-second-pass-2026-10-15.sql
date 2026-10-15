begin;

update public.career_opportunity_cycles set
 academic_criteria=null,
 assessments_text='Enquiry and chamber review.',
 progression_route_text=null,
 right_to_work_text=null,
 updated_at=now()
where opportunity_id='3c2c9104-34c1-4305-ba26-7e64b71a8dc9';

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'b42f1999-d811-4a3c-b624-44a342ede9ae','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89','outer-temple-bridging-the-bar-summer-mini-pupillage-2027',
 'Outer Temple Chambers and Bridging the Bar Summer Mini-Pupillage 2027',
 'Outer Temple Chambers and Bridging the Bar Summer Mini-Pupillage 2027',
 'Three-day, non-assessed summer mini-pupillage for aspiring barristers, delivered by Outer Temple Chambers with places allocated through Bridging the Bar.',
 'in_person','https://www.outertemple.com/recruitment/mini-pupillage/','https://www.outertemple.com/recruitment/mini-pupillage/',true,true,date '2026-10-15',date '2027-01-15'
where not exists(select 1 from public.career_opportunities where slug='outer-temple-bridging-the-bar-summer-mini-pupillage-2027');

insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,programme_year,intake_year,application_model,programme_dates_text,date_precision,duration_text,places_text,source_status,audience_text,study_stage_text,eligibility_text,application_process_text,assessments_text,expenses_text,travel_support_text,accommodation_support_text,official_url,application_url,active,research_checked_on)
select id,'outer-temple-bridging-the-bar-summer-mini-pupillage-2027',official_name,2027,2027,'no_application',
 'The mini-pupillage takes place in June 2027.','month','Three days','Outer Temple normally takes up to 12 candidates per course.','upcoming',
 'Aspiring barristers selected through Bridging the Bar.','Applicants must have completed at least one year of university education.',
 'Candidates must meet Bridging the Bar’s selection requirements. Outer Temple considers academic achievement, advocacy potential and motivation for the Bar.',
 'Bridging the Bar manages applications, eligibility and allocation of places.',
 'Bridging the Bar selection followed by allocation to the Outer Temple programme.',
 'Outer Temple reimburses approved reasonable travel costs and necessary overnight accommodation up to £150 per night.',
 'Approved advance standard-class travel costs may be reimbursed.','Approved necessary overnight accommodation may be reimbursed up to £150 per night.',
 'https://www.outertemple.com/recruitment/mini-pupillage/','https://www.outertemple.com/recruitment/mini-pupillage/',true,date '2026-10-15'
from public.career_opportunities
where slug='outer-temple-bridging-the-bar-summer-mini-pupillage-2027'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=career_opportunities.id);

delete from public.career_opportunity_routes
where route_kind='unresolved' and opportunity_id in
 (select id from public.career_opportunities where slug='outer-temple-bridging-the-bar-summer-mini-pupillage-2027');
insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select id,'physical_city',47,139,'London','confirmed',10,true
from public.career_opportunities o
where slug='outer-temple-bridging-the-bar-summer-mini-pupillage-2027'
and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.city_id=139);

update public.chambers set
 pupillage_overview='Outer Temple recruits through the Pupillage Gateway. Applications for its general and specialist Health pupillages commencing in September 2026 and September 2027 closed on 22 January 2026. Both carried a confirmed £80,000 award, with up to 25% available for drawdown during Bar training.',
 mini_pupillage_overview='Outer Temple runs two non-assessed three-day mini-pupillage courses each year, normally taking up to 12 candidates: a summer course delivered with Bridging the Bar and a winter course. The Winter 2026 course is closed. The next confirmed summer course takes place in June 2027, with applications and place allocation managed by Bridging the Bar.',
 research_checked_on=date '2026-10-15',next_review_on=date '2027-01-15',updated_at=now()
where organisation_id='b42f1999-d811-4a3c-b624-44a342ede9ae';

commit;
