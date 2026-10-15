begin;

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select
 '505df2f2-c4a6-491f-ad76-3c129d5c7dd5','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89',
 'twenty-essex-mini-pupillage-february-july-2027',
 'Twenty Essex Mini-Pupillage — February to July 2027',
 'Twenty Essex Mini-Pupillage — February to July 2027',
 'Assessed two-day commercial mini-pupillage. Applications are submitted through the live Twenty Essex form by the standing 8 December deadline.',
 'flexible','https://www.twentyessex.com/recruitment/mini-pupillage/','https://www.twentyessex.com/recruitment/mini-pupillage/',
 true,true,date '2026-10-15',date '2026-12-09'
where not exists(select 1 from public.career_opportunities where slug='twenty-essex-mini-pupillage-february-july-2027');

insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,closes_on,closes_at,closes_timezone,application_dates_text,programme_dates_text,date_precision,duration_text,places_text,source_status,audience_text,study_stage_text,eligibility_text,application_process_text,assessments_text,expenses_text,disability_support_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select id,'twenty-essex-mini-pupillage-february-july-2027',official_name,2026,2027,2027,'fixed_deadline',
 date '2026-12-08',time '23:59','Europe/London','Applications close at 23:59 on 8 December 2026.','Placements take place between 1 February and 31 July 2027.','text_only','Two days','Around 30 places are offered for this placement period.','open',
 'Prospective commercial and public-international-law barristers.','Law undergraduates should normally apply in their third year; non-law graduates should normally apply after studying contract law on a conversion course.',
 'Applicants must intend to practise as a barrister in England and Wales and demonstrate potential against Twenty Essex’s published selection criteria.',
 'Complete and submit the multi-page online application form on the official mini-pupillage page.',
 'Application review followed, for longlisted applicants, by a 15-minute online advocacy interview. Performance during the mini-pupillage is assessed for later pupillage applications.',
 'Twenty Essex contributes £120 towards travel expenses for an in-chambers mini-pupillage.',
 'Flexible dates, a shorter placement or a virtual mini-pupillage may be available where attendance presents difficulties.',
 'Two days observing and discussing commercial practice, potentially including court or arbitration, client conferences, papers and conversations with barristers, staff and pupils.',
 'https://www.twentyessex.com/recruitment/mini-pupillage/','https://www.twentyessex.com/recruitment/mini-pupillage/',true,date '2026-10-15'
from public.career_opportunities where slug='twenty-essex-mini-pupillage-february-july-2027'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=career_opportunities.id);

delete from public.career_opportunity_routes where route_kind='unresolved' and opportunity_id in
 (select id from public.career_opportunities where slug='twenty-essex-mini-pupillage-february-july-2027');
insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select id,'physical_city',47,139,'London, with flexible or virtual arrangements available where needed.','confirmed',10,true
from public.career_opportunities o where slug='twenty-essex-mini-pupillage-february-july-2027'
and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.city_id=139);

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select
 '505df2f2-c4a6-491f-ad76-3c129d5c7dd5','b29890c7-5f97-4d55-bbf8-9e7fda5e22b3',
 'twenty-essex-combar-mentoring-2026-27',
 'COMBAR Mentoring Scheme 2026–27 — Twenty Essex Participating Set',
 'COMBAR Mentoring Scheme 2026–27 — Twenty Essex Participating Set',
 'One-to-one Commercial Bar mentoring for eligible undergraduates and graduates from groups underrepresented at the Bar, with Twenty Essex among the participating sets.',
 'hybrid','https://www.twentyessex.com/recruitment/pupillage/','https://www.combar.com/news/deadline-extended-to-23-october-2026-combar-mentoring-scheme-for-under-represented-groups-2026-27-scheme/',
 true,true,date '2026-10-15',date '2026-10-24'
where not exists(select 1 from public.career_opportunities where slug='twenty-essex-combar-mentoring-2026-27');

insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,closes_on,closes_at,closes_timezone,application_dates_text,programme_dates_text,date_precision,duration_text,places_text,source_status,audience_text,eligibility_text,application_process_text,assessments_text,expenses_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select id,'twenty-essex-combar-mentoring-2026-27',official_name,2026,2026,2026,'fixed_deadline',
 date '2026-10-23',time '23:59','Europe/London','The extended application deadline is 23:59 on 23 October 2026.','The 2026–27 mentoring cycle includes a pupillage application and interview workshop and social event planned for 13 January 2027.','exact','2026–27 mentoring cycle','Around 250 places are available across 26 participating sets.','open',
 'Undergraduates and graduates from groups underrepresented at the Bar who do not already hold a pupillage offer and have realistic prospects of obtaining a Commercial Bar pupillage.',
 'COMBAR assesses applicants by giving equal weight to their need for mentoring and their potential to pursue a career at the Bar.',
 'Download and complete the COMBAR application form, save it as a PDF using the required naming convention and email it to MentoringURG@combar.com.',
 'COMBAR assesses the written application against mentoring need and potential for a Commercial Bar career.',
 'Participating sets cover reasonable travel expenses for mentees allocated to them.',
 'Successful applicants receive a series of one-to-one mentoring sessions with a practitioner from a participating set and access to the January workshop and social event.',
 'https://www.twentyessex.com/recruitment/pupillage/','https://www.combar.com/news/deadline-extended-to-23-october-2026-combar-mentoring-scheme-for-under-represented-groups-2026-27-scheme/',true,date '2026-10-15'
from public.career_opportunities where slug='twenty-essex-combar-mentoring-2026-27'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=career_opportunities.id);

delete from public.career_opportunity_routes where route_kind='unresolved' and opportunity_id in
 (select id from public.career_opportunities where slug='twenty-essex-combar-mentoring-2026-27');
insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select id,'physical_city',47,139,'Twenty Essex is based in London; mentor allocation across participating sets is managed by COMBAR.','confirmed',10,true
from public.career_opportunities o where slug='twenty-essex-combar-mentoring-2026-27'
and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.city_id=139);

update public.chambers set
 mini_pupillage_overview='Twenty Essex offers around 60 assessed two-day mini-pupillages annually, normally split between placements from mid-September to January and from February to July. Applications for placements from February to July 2027 close at 23:59 on 8 December 2026 through the live official application form. Twenty Essex also provides nine mini-pupillages annually through the Bridging the Bar Academy. In-person mini-pupils receive a £120 travel contribution, and flexible or virtual arrangements may be available.',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-21',updated_at=now()
where organisation_id='505df2f2-c4a6-491f-ad76-3c129d5c7dd5';

commit;
