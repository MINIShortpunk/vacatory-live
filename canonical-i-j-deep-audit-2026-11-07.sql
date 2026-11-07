-- Canonical I-J deep audit, verified 7 November 2026.
-- Student programmes only; excludes ordinary vacancies, closed/capacity-full events and attendee-paid events.

begin;

-- Irwin Mitchell: 2027 legal apprenticeships.
create temporary table _ij_irwin_apprenticeships(slug text primary key,name text,summary text,duration text) on commit drop;
insert into _ij_irwin_apprenticeships values
 ('solicitor-apprenticeship-2027','Solicitor Apprenticeship 2027','A paid legal apprenticeship combining work and study to qualify as a solicitor.','Five to six years'),
 ('paralegal-apprenticeship-2027','Paralegal Apprenticeship 2027','A paid legal apprenticeship providing practical experience and a recognised paralegal qualification.','Twenty-four months');

with upserted as (
 insert into career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,english_name,language_code,public_summary,delivery_mode,
  official_url,application_url,active,published,display_order,research_checked_on,next_review_on,updated_at)
 select '8d38ef1e-a572-4e51-b2de-bbf9523d5b1d','a137274a-0cec-444b-8296-a6c16d30d116',a.slug,a.name,a.name,a.name,'en',a.summary,
 'in_person',case when a.slug='solicitor-apprenticeship-2027' then 'https://www.irwinmitchell.com/about-us/careers/apprenticeships/solicitor-apprenticeship'
 else 'https://www.irwinmitchell.com/about-us/careers/apprenticeships/paralegal-apprenticeship' end,
 'https://www.irwinmitchell.com/about-us/careers/early-careers/our-recruitment-process',true,true,40,date '2026-11-07',date '2027-01-25',now()
 from _ij_irwin_apprenticeships a
 on conflict(organisation_id,slug) do update set official_name=excluded.official_name,public_name=excluded.public_name,
 english_name=excluded.english_name,public_summary=excluded.public_summary,official_url=excluded.official_url,
 application_url=excluded.application_url,active=true,published=true,research_checked_on=excluded.research_checked_on,
 next_review_on=excluded.next_review_on,updated_at=now() returning id,slug,official_name,official_url,application_url)
insert into career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,closes_on,
  application_dates_text,programme_dates_text,date_precision,duration_text,source_status,source_status_note,audience_text,
  study_stage_text,eligibility_text,assessments_text,progression_route_text,official_url,application_url,active,research_checked_on,updated_at)
select u.id,'2027:'||u.slug,u.official_name,2027,2027,2027,'fixed_deadline',date '2027-01-25',date '2027-02-18',
 'Applications open 25 January 2027 and close 18 February 2027. No opening or closing time is published.',
 case when u.slug='solicitor-apprenticeship-2027' then 'Assessment centres take place in April or May 2027; successful apprentices start in September 2027.'
 else 'The 2027 intake follows the published apprenticeship recruitment process; an exact start date is not published.' end,
 'month',a.duration,'upcoming','Dates verified against Irwin Mitchell’s official recruitment-process page.',
 'School leavers who meet the programme and apprenticeship-funding requirements.','School or college leaver.',
 'Applicants must meet the official academic, right-to-work and apprenticeship-funding requirements.',
 case when u.slug='solicitor-apprenticeship-2027' then 'Online application and strengths-based assessment with video interview, followed by an assessment centre in April or May 2027.'
 else 'Application including CV, followed by telephone interview for most roles and the remaining published selection stages.' end,
 case when u.slug='solicitor-apprenticeship-2027' then 'Qualification as a solicitor after completing the apprenticeship and SQE requirements.'
 else 'Paralegal qualification, with the possibility of applying for the solicitor apprenticeship afterwards.' end,
 u.official_url,u.application_url,true,date '2026-11-07',now()
from upserted u join _ij_irwin_apprenticeships a using(slug)
where not exists(select 1 from career_opportunity_cycles c where c.opportunity_id=u.id);

-- Irwin Mitchell: Career Insights 2027, one opportunity with five official office cohorts.
with upserted as (
 insert into career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,english_name,language_code,public_summary,delivery_mode,
  official_url,application_url,active,published,display_order,research_checked_on,next_review_on,updated_at)
 values ('8d38ef1e-a572-4e51-b2de-bbf9523d5b1d','dc71e865-68ec-444b-837a-b3095bb852c6','career-insights-programme-2027',
 'Career Insights Programme 2027','Career Insights Programme 2027','Career Insights Programme 2027','en',
 'Free one-day law-firm insight programmes for eligible Year 12 and Year 13 students aged 16–18.','in_person',
 'https://www.irwinmitchell.com/about-us/careers/early-careers/work-experience',
 'https://www.irwinmitchell.com/about-us/careers/early-careers/work-experience',true,true,40,date '2026-11-07',date '2026-11-30',now())
 on conflict(organisation_id,slug) do update set public_summary=excluded.public_summary,official_url=excluded.official_url,
 application_url=excluded.application_url,active=true,published=true,research_checked_on=excluded.research_checked_on,
 next_review_on=excluded.next_review_on,updated_at=now() returning id)
insert into career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,opens_on,closes_on,application_dates_text,
  programme_starts_on,programme_ends_on,programme_dates_text,date_precision,duration_text,source_status,source_status_note,
  audience_text,study_stage_text,eligibility_text,official_url,application_url,active,research_checked_on,updated_at)
select u.id,'2027:'||v.city_slug,'Career Insights 2027 — '||v.city,2026,2027,'fixed_deadline',date '2026-11-30',date '2026-12-27',
 'Applications open 30 November and close 27 December 2026. No opening or closing time is published.',v.day,v.day,
 v.city||' — '||to_char(v.day,'FMDD FMMonth YYYY')||'; no programme time is published.','exact','One day','upcoming',
 'Application and programme dates verified against Irwin Mitchell’s official Work Experience page.',
 'Students aged 16–18 in Years 12 or 13 who are not attending university.','Year 12 or Year 13.',
 'Applicants must be aged 16–18, be in Year 12 or Year 13, not attend university and be able to commute reasonably to the selected office.',
 'https://www.irwinmitchell.com/about-us/careers/early-careers/work-experience',
 'https://www.irwinmitchell.com/about-us/careers/early-careers/work-experience',true,date '2026-11-07',now()
from upserted u cross join (values
 ('manchester','Manchester',date '2027-02-16'),('birmingham','Birmingham',date '2027-04-06'),
 ('leeds','Leeds',date '2027-04-13'),('sheffield','Sheffield',date '2027-08-17'),('london','London',date '2027-08-24')
) v(city_slug,city,day)
where not exists(select 1 from career_opportunity_cycles c where c.opportunity_id=u.id and c.cycle_key='2027:'||v.city_slug);

insert into career_opportunity_locations(opportunity_id,cycle_id,city_id,country_id,location_note,display_order,location_role,location_status)
select o.id,c.id,v.city_id,47,v.city||' office.',10,'programme','confirmed'
from career_opportunities o join career_opportunity_cycles c on c.opportunity_id=o.id
join (values ('2027:manchester',140,'Manchester'),('2027:birmingham',113,'Birmingham'),('2027:leeds',134,'Leeds'),
 ('2027:sheffield',156,'Sheffield'),('2027:london',139,'London')) v(cycle_key,city_id,city) on v.cycle_key=c.cycle_key
where o.organisation_id='8d38ef1e-a572-4e51-b2de-bbf9523d5b1d' and o.slug='career-insights-programme-2027'
and not exists(select 1 from career_opportunity_locations l where l.opportunity_id=o.id and l.cycle_id=c.id);

-- Jones Day: Hong Kong pre-university Summer Experience Scheme.
with upserted as (
 insert into career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,english_name,language_code,public_summary,delivery_mode,
  official_url,application_url,active,published,display_order,research_checked_on,next_review_on,updated_at)
 values ('f133ff9a-f1b5-497b-b497-c28e1bb44970','39240ee9-c525-4633-aa8f-fd81a8f53b29',
 'hong-kong-summer-experience-scheme-2027','Hong Kong Summer Experience Scheme 2027','Hong Kong Summer Experience Scheme 2027',
 'Hong Kong Summer Experience Scheme 2027','en','A two-week Hong Kong summer experience for pre-university students intending to study law.',
 'in_person','https://www.jonesday.com/en/careers/locations/hong-kong','https://www.jonesday.com/en/careers/locations/hong-kong',
 true,true,40,date '2026-11-07',date '2027-04-01',now())
 on conflict(organisation_id,slug) do update set public_summary=excluded.public_summary,official_url=excluded.official_url,
 application_url=excluded.application_url,active=true,published=true,research_checked_on=excluded.research_checked_on,
 next_review_on=excluded.next_review_on,updated_at=now() returning id)
insert into career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,closes_on,application_dates_text,
  programme_dates_text,date_precision,duration_text,source_status,source_status_note,audience_text,study_stage_text,eligibility_text,
  official_url,application_url,active,research_checked_on,updated_at)
select id,'2027-hong-kong-summer-experience','Hong Kong Summer Experience Scheme 2027',2027,2027,'fixed_deadline',date '2027-04-30',
 'Applications close 30 April 2027. No closing time is published.',
 'Two-week summer experience in Hong Kong; exact programme dates are not published.','season','Two weeks','open',
 'Deadline and duration verified against Jones Day’s official Hong Kong careers page.',
 'Pre-university students planning to pursue law studies.','Pre-university student.',
 'Intended mainly for pre-university students planning to study law and interested in early exposure to legal practice.',
 'https://www.jonesday.com/en/careers/locations/hong-kong','https://www.jonesday.com/en/careers/locations/hong-kong',true,date '2026-11-07',now()
from upserted where not exists(select 1 from career_opportunity_cycles c where c.opportunity_id=upserted.id);

insert into career_opportunity_locations(opportunity_id,cycle_id,city_id,country_id,location_note,display_order,location_role,location_status)
select o.id,c.id,49,17,'Jones Day Hong Kong office.',10,'programme','confirmed'
from career_opportunities o join career_opportunity_cycles c on c.opportunity_id=o.id
where o.organisation_id='f133ff9a-f1b5-497b-b497-c28e1bb44970' and o.slug='hong-kong-summer-experience-scheme-2027'
and not exists(select 1 from career_opportunity_locations l where l.opportunity_id=o.id and l.cycle_id=c.id);

-- Jones Day: correct the active 2027 US programme to New York and San Francisco only.
update career_opportunities set official_name='United States 2L Summer Associate Programme 2027',
 public_summary='The 2027 2L Summer Associate Programme currently accepts applications for New York and San Francisco only.',
 official_url='https://www.jonesday.com/en/summer-program',application_url='https://www.jonesday.com/en/summer-program',
 research_checked_on=date '2026-11-07',next_review_on=date '2026-12-01',updated_at=now()
where organisation_id='f133ff9a-f1b5-497b-b497-c28e1bb44970' and slug='jones-day-us-summer-associate-2027';
update career_opportunity_cycles c set application_model='rolling',source_status='open',
 application_dates_text='Applications are open for New York and San Francisco. No application deadline is published.',
 programme_dates_text='2027 summer programme in New York or San Francisco; exact dates are not published.',
 source_status_note='Current office restriction verified against Jones Day’s official Summer Program page.',
 official_url='https://www.jonesday.com/en/summer-program',application_url='https://www.jonesday.com/en/summer-program',
 research_checked_on=date '2026-11-07',updated_at=now()
from career_opportunities o where c.opportunity_id=o.id and o.organisation_id='f133ff9a-f1b5-497b-b497-c28e1bb44970'
and o.slug='jones-day-us-summer-associate-2027';
insert into career_opportunity_locations(opportunity_id,cycle_id,city_id,country_id,location_note,display_order,location_role,location_status)
select o.id,c.id,v.city_id,48,v.city,10,'programme','confirmed'
from career_opportunities o join career_opportunity_cycles c on c.opportunity_id=o.id
cross join (values (197,'New York'),(210,'San Francisco')) v(city_id,city)
where o.organisation_id='f133ff9a-f1b5-497b-b497-c28e1bb44970' and o.slug='jones-day-us-summer-associate-2027'
and not exists(select 1 from career_opportunity_locations l where l.opportunity_id=o.id and l.cycle_id=c.id and l.city_id=v.city_id);

-- Jones Day: current 2028 2L programme, including possible joint 2027 1L/2028 2L consideration in selected offices.
with upserted as (
 insert into career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,english_name,language_code,public_summary,delivery_mode,
 official_url,application_url,active,published,display_order,research_checked_on,next_review_on,updated_at)
 values ('f133ff9a-f1b5-497b-b497-c28e1bb44970','68a7f54d-c4da-433d-882f-c9d4a8bfb894','jones-day-us-summer-associate-2028',
 'United States 2L Summer Associate Programme 2028','United States 2L Summer Associate Programme 2028',
 'United States 2L Summer Associate Programme 2028','en',
 'Current US summer-associate applications for first-year law students in the Class of 2029, with limited joint 2027/2028 consideration in selected offices.',
 'in_person','https://www.jonesday.com/en/summer-program','https://www.jonesday.com/en/summer-program',true,true,40,
 date '2026-11-07',date '2026-12-01',now())
 on conflict(organisation_id,slug) do update set public_summary=excluded.public_summary,official_url=excluded.official_url,
 application_url=excluded.application_url,active=true,published=true,research_checked_on=excluded.research_checked_on,
 next_review_on=excluded.next_review_on,updated_at=now() returning id)
insert into career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,application_dates_text,programme_dates_text,
 date_precision,duration_text,source_status,source_status_note,audience_text,study_stage_text,eligibility_text,official_url,
 application_url,active,research_checked_on,updated_at)
select id,'2028-us-2l-summer-associate','United States 2L Summer Associate Programme 2028',2026,2028,'rolling',
 'Applications are open; Jones Day does not publish a deadline.',
 '2028 2L Summer Associate Programme; selected offices may also consider a joint 2027 1L and 2028 2L position. Exact dates are not published.',
 'season','Generally eight to ten weeks','open','Official page confirms that applications are currently being accepted.',
 'First-year law students in the Class of 2029.','First-year US law student.',
 'Open to first-year law students graduating in 2029. Applicants may indicate interest in the limited joint 2027 1L/2028 2L route.',
 'https://www.jonesday.com/en/summer-program','https://www.jonesday.com/en/summer-program',true,date '2026-11-07',now()
from upserted where not exists(select 1 from career_opportunity_cycles c where c.opportunity_id=upserted.id);
insert into career_opportunity_locations(opportunity_id,cycle_id,country_id,location_note,display_order,location_role,location_status)
select o.id,c.id,48,'United States; the official page does not publish the complete selected-office list.',10,'programme','confirmed'
from career_opportunities o join career_opportunity_cycles c on c.opportunity_id=o.id
where o.organisation_id='f133ff9a-f1b5-497b-b497-c28e1bb44970' and o.slug='jones-day-us-summer-associate-2028'
and not exists(select 1 from career_opportunity_locations l where l.opportunity_id=o.id and l.cycle_id=c.id);

commit;
