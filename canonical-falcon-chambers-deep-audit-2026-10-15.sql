begin;

delete from public.vacation_schemes
where organisation_id='c871c677-79fd-4680-9b45-f3ecf30475fc'
   or firm_id='c871c677-79fd-4680-9b45-f3ecf30475fc';

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select 'c871c677-79fd-4680-9b45-f3ecf30475fc','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89',
 'falcon-chambers-mini-pupillage-2027',
 'Falcon Chambers Mini-Pupillage Programme 2027',
 'Falcon Chambers Mini-Pupillage Programme 2027',
 'Three-day, non-assessed property-law mini-pupillage in a small cohort, including court, conference and paperwork insight where available.',
 'in_person','https://www.falcon-chambers.com/join-us/mini-pupillage',
 'https://www.falcon-chambers.com/join-us/mini-pupillage/mini-pupillage-application',true,true,date '2026-10-15',date '2026-12-01'
where not exists(select 1 from public.career_opportunities where slug='falcon-chambers-mini-pupillage-2027');

insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,programme_year,intake_year,application_model,application_dates_text,programme_dates_text,date_precision,duration_text,places_text,source_status,audience_text,study_stage_text,eligibility_text,application_process_text,assessments_text,expenses_text,travel_support_text,official_url,application_url,active,research_checked_on)
select id,'falcon-chambers-mini-pupillage-2027',official_name,2027,2027,'fixed_deadline',
 'Applications open toward the end of 2026.','Falcon runs three mini-pupillage sessions during the year.','text_only','Three days','Four or five candidates per session.','upcoming',
 'Law and non-law students interested in property law and the Bar.','Preference is given to applicants who have completed their first year of university.',
 'Law and non-law students may apply. Non-law students may benefit most after beginning the PGDL.',
 'Apply through Falcon’s official online mini-pupillage form during the application window.',
 'Written application review; the mini-pupillage itself is non-assessed.',
 'Falcon’s current brochure provides £250 for participants based outside London and £50 for participants based in London.',
 'Location-based expenses contribution under Falcon’s current brochure.',
 'https://www.falcon-chambers.com/join-us/mini-pupillage',
 'https://www.falcon-chambers.com/join-us/mini-pupillage/mini-pupillage-application',true,date '2026-10-15'
from public.career_opportunities
where slug='falcon-chambers-mini-pupillage-2027'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=career_opportunities.id);

delete from public.career_opportunity_routes
where route_kind='unresolved' and opportunity_id in
 (select id from public.career_opportunities where slug='falcon-chambers-mini-pupillage-2027');
insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select id,'physical_city',47,139,'London','confirmed',10,true
from public.career_opportunities o
where slug='falcon-chambers-mini-pupillage-2027'
and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.city_id=139);

update public.chambers set
 pupillage_overview='Falcon normally offers up to two 12-month pupillages through the Pupillage Gateway, recruiting with a view to tenancy. The October 2027 application round closed on 22 January 2026. Its confirmed award is £85,000, with up to £30,000 available for drawdown. Pupils receive property-law induction, four supervisor seats, advocacy training and second-six court work.',
 mini_pupillage_overview='Falcon normally runs three non-assessed three-day mini-pupillage programmes each year for groups of four or five. The September 2026 programme is closed. Applications for the 2027 programme open toward the end of 2026. Law and non-law students may apply, with preference for applicants who have completed their first university year.',
 tenancy_overview='Falcon recruits pupils with a view to tenancy and normally makes tenancy decisions by the end of July. Experienced-practitioner and lateral recruitment are excluded from Vacatory’s student-opportunity listings.',
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-12-01',updated_at=now()
where organisation_id='c871c677-79fd-4680-9b45-f3ecf30475fc';

commit;
