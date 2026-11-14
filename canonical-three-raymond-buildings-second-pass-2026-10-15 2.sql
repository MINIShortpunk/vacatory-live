begin;

-- The official page gives a month-range for this placement, not exact first/last days.
update public.career_opportunity_cycles set
 programme_starts_on=null,
 programme_ends_on=null,
 programme_dates_text='Placements run from April to mid-July 2027.',
 date_precision='text_only',
 research_checked_on=date '2026-10-15',
 updated_at=now()
where opportunity_id='d296926e-450f-4728-b21e-9e1dc0d986e2';

-- The official page confirms an October 2028 start and 12-month duration, but no exact start/end days.
update public.career_opportunity_cycles set
 programme_starts_on=null,
 programme_ends_on=null,
 programme_dates_text='Twelve-month pupillage commencing in October 2028.',
 date_precision='month',
 research_checked_on=date '2026-10-15',
 updated_at=now()
where opportunity_id='178f22a4-e126-4536-9657-c6e7d4394b64';

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select
 '57726bc1-ae8e-4d75-a8fd-182e43268528',
 '5e2816dd-108f-4443-9fb2-218def79147f',
 'bfc52358-2f8d-4b3d-b5b0-92b80ad1101d',
 'three-raymond-buildings-pupillage-qa-12-november-2026',
 '3RB Pupillage Q&A — 12 November 2026',
 'Three Raymond Buildings Pupillage Q&A — 12 November 2026',
 'Hybrid pupillage information and Q&A session for prospective applicants, followed by a drinks reception for in-person attendees.',
 'hybrid',
 'https://3rblaw.com/2026/10/3rb-to-host-pupillage-qa-on-12-november-2026/',
 'mailto:pupillage@3rblaw.com',
 true,true,date '2026-10-15',date '2026-11-13'
where not exists (
 select 1 from public.career_opportunities
 where slug='three-raymond-buildings-pupillage-qa-12-november-2026'
);

insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,places_text,source_status,audience_text,eligibility_text,application_process_text,assessments_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select
 id,
 'three-raymond-buildings-pupillage-qa-12-november-2026',
 official_name,
 2026,2026,2026,
 'rolling',
 date '2026-11-12',date '2026-11-12',
 '12 November 2026, 17:30–19:30.',
 'RSVP by email. In-person places are limited and allocated first come, first served.',
 'exact','Two hours','In-person capacity is limited; remote attendance is available by Microsoft Teams.','open',
 'Prospective pupillage applicants and aspiring barristers.',
 'Open to anyone considering applying for pupillage; applicants from underrepresented backgrounds are particularly encouraged.',
 'Email pupillage@3rblaw.com and state whether you prefer to attend in Chambers or by Microsoft Teams.',
 'Registration only; this is an information event rather than a selection exercise.',
 'Pupillage presentation and Q&A, followed by a drinks reception with members of Chambers and current and recent pupils.',
 'https://3rblaw.com/2026/10/3rb-to-host-pupillage-qa-on-12-november-2026/',
 'mailto:pupillage@3rblaw.com',true,date '2026-10-15'
from public.career_opportunities
where slug='three-raymond-buildings-pupillage-qa-12-november-2026'
and not exists (
 select 1 from public.career_opportunity_cycles c where c.opportunity_id=career_opportunities.id
);

delete from public.career_opportunity_routes
where route_kind='unresolved'
and opportunity_id=(select id from public.career_opportunities where slug='three-raymond-buildings-pupillage-qa-12-november-2026');

insert into public.career_opportunity_routes
 (opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select id,'physical_city',47,139,'London and Microsoft Teams','confirmed',10,true
from public.career_opportunities o
where slug='three-raymond-buildings-pupillage-qa-12-november-2026'
and not exists (
 select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.city_id=139
);

update public.chambers set
 pupillage_overview='Three Raymond Buildings recruits up to three 12-month pupils through the Pupillage Gateway. Applications for the October 2028 intake open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027. The latest published package is £55,000, comprising a £30,000 grant and £25,000 guaranteed second-six earnings, plus eligible travel and compulsory-training support. A hybrid pupillage Q&A for prospective applicants takes place on 12 November 2026.',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-13',updated_at=now()
where organisation_id='57726bc1-ae8e-4d75-a8fd-182e43268528';

commit;
