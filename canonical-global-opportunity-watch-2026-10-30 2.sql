begin;

-- Canonical actions from the 30 October 2026 Global Opportunity Watch.
-- All records were rechecked against the organisations' live official pages
-- on 31 October 2026. Events are explicitly event-typed; opportunities are not.

-- Correct two existing current events.
update public.career_opportunity_cycles c
set programme_dates_text='11 November 2026, 11:15–12:00, online.',
    additional_details_text='A 45-minute virtual workshop covering the early-careers application process, practical application guidance and a live Q&A.',
    research_checked_on=date '2026-10-31', updated_at=now()
from public.career_opportunities co
join public.legal_organisations lo on lo.id=co.organisation_id
where c.opportunity_id=co.id and c.active and lo.slug='clyde-and-co'
  and co.slug='early-careers-applications-workshop-11-november-2026';

update public.career_opportunity_cycles c
set source_status='closed',
    source_status_note='Registration is treated as closed using the earlier date published by TLT. The event remains upcoming.',
    research_checked_on=date '2026-10-31', updated_at=now()
from public.career_opportunities co
join public.legal_organisations lo on lo.id=co.organisation_id
where c.opportunity_id=co.id and c.active and lo.slug='tlt'
  and co.slug='virtual-open-evening';

-- Current student-facing events.
with events(org_slug,slug,title,summary,event_type,delivery,url,apply_url,day,start_time,end_time,closes_on,closes_at,tz,city,country,audience,application_note) as (values
 ('trinity-chambers','pupillage-open-evening-9-december-2026','Pupillage Open Evening — 9 December 2026','An in-person pupillage open evening for undergraduate and graduate students at Trinity Chambers in Newcastle.','open_day','in_person','https://www.trinitychambers.co.uk/news-insights/trinity-chambers-pupillage-open-evening-2026-newcastle/','mailto:events@trinitychambers.co.uk',date '2026-12-09',time '18:00',time '20:00',date '2026-11-25',null::time,'Europe/London','Newcastle upon Tyne','United Kingdom','Undergraduate and graduate students interested in pupillage.','Register by email by 25 November 2026; no closing time is published.'),
 ('tlt','bristol-early-careers-open-evening-18-november-2026','Bristol Early Careers Open Evening — 18 November 2026','An in-person early-careers open evening with networking, FutureLaw, commercial-awareness and Q&A sessions.','open_day','in_person','https://apply.tlt.com/vacancies/6208/tlt_bristol_early_careers_open_evening/','https://apply.tlt.com/vacancies/6208/tlt_bristol_early_careers_open_evening/',date '2026-11-18',time '17:00',time '19:30',date '2026-11-11',null::time,'Europe/London','Bristol','United Kingdom','Students in any year, graduates and career changers interested in legal careers.','TLT pages displayed 11 and 16 November 2026; Vacatory uses the earlier date of 11 November. No closing time is published.'),
 ('clyde-and-co','vitamin-f-hhu-dusseldorf-19-november-2026','Vitamin F — HHU Düsseldorf Meets Clyde & Co','A Düsseldorf student event on data protection, cybersecurity, IT contract law and artificial intelligence in legal practice.','insight_event','in_person','https://careers.clydeco.com/en/events/','https://www.jura.hhu.de/freundeskreis/anmeldung',date '2026-11-19',time '16:30',time '19:30',date '2026-10-31',null::time,'Europe/Berlin','Düsseldorf','Germany','Law students interested in technology, cybersecurity and legal practice.','Applications close 31 October 2026; no closing time is published.')
)
insert into public.career_opportunities
(organisation_id,opportunity_type_id,event_type_id,slug,official_name,english_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select lo.id,ot.id,et.id,e.slug,e.title,e.title,e.title,e.summary,e.delivery,e.url,e.apply_url,true,true,date '2026-10-31',e.day+1
from events e join public.legal_organisations lo on lo.slug=e.org_slug
join public.opportunity_types ot on ot.slug='open_day'
join public.career_event_types et on et.slug=e.event_type
on conflict (organisation_id,slug) do update set
 opportunity_type_id=excluded.opportunity_type_id,event_type_id=excluded.event_type_id,
 official_name=excluded.official_name,english_name=excluded.english_name,public_name=excluded.public_name,
 public_summary=excluded.public_summary,delivery_mode=excluded.delivery_mode,official_url=excluded.official_url,
 application_url=excluded.application_url,active=true,published=true,research_checked_on=excluded.research_checked_on,
 next_review_on=excluded.next_review_on,updated_at=now();

with events(org_slug,slug,title,day,start_time,end_time,closes_on,closes_at,tz,audience,application_note) as (values
 ('trinity-chambers','pupillage-open-evening-9-december-2026','Pupillage Open Evening — 9 December 2026',date '2026-12-09',time '18:00',time '20:00',date '2026-11-25',null::time,'Europe/London','Undergraduate and graduate students interested in pupillage.','Register by email by 25 November 2026; no closing time is published.'),
 ('tlt','bristol-early-careers-open-evening-18-november-2026','Bristol Early Careers Open Evening — 18 November 2026',date '2026-11-18',time '17:00',time '19:30',date '2026-11-11',null::time,'Europe/London','Students in any year, graduates and career changers interested in legal careers.','TLT pages displayed 11 and 16 November 2026; Vacatory uses the earlier date of 11 November. No closing time is published.'),
 ('clyde-and-co','vitamin-f-hhu-dusseldorf-19-november-2026','Vitamin F — HHU Düsseldorf Meets Clyde & Co',date '2026-11-19',time '16:30',time '19:30',date '2026-10-31',null::time,'Europe/Berlin','Law students interested in technology, cybersecurity and legal practice.','Applications close 31 October 2026; no closing time is published.')
)
insert into public.career_opportunity_cycles
(opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,closes_on,closes_at,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,source_status,audience_text,official_url,application_url,active,research_checked_on)
select co.id,e.slug,e.title,2026,2026,'fixed_deadline',e.closes_on,e.closes_at,e.tz,e.day,e.day,
 to_char(e.day,'FMDD FMMonth YYYY')||', '||to_char(e.start_time,'HH24:MI')||'–'||to_char(e.end_time,'HH24:MI')||'.',
 e.application_note,'exact','open',e.audience,co.official_url,co.application_url,true,date '2026-10-31'
from events e join public.legal_organisations lo on lo.slug=e.org_slug
join public.career_opportunities co on co.organisation_id=lo.id and co.slug=e.slug
on conflict (opportunity_id,cycle_key) do update set
 closes_on=excluded.closes_on,closes_at=excluded.closes_at,closes_timezone=excluded.closes_timezone,
 programme_starts_on=excluded.programme_starts_on,programme_ends_on=excluded.programme_ends_on,
 programme_dates_text=excluded.programme_dates_text,application_dates_text=excluded.application_dates_text,
 source_status=excluded.source_status,audience_text=excluded.audience_text,official_url=excluded.official_url,
 application_url=excluded.application_url,active=true,research_checked_on=excluded.research_checked_on,updated_at=now();

-- Current student opportunities and funding programmes.
with opportunities(org_slug,type_slug,slug,title,summary,delivery,url,apply_url,next_review) as (values
 ('three-raymond-buildings','competition','robin-simpson-kc-advocacy-competition-2026','Robin Simpson KC Advocacy Competition 2026','An advocacy competition for aspiring barristers. Eight finalists receive a mini-pupillage and the winner receives a cash prize.','in_person','https://3rblaw.com/?p=3739','mailto:training@3rblaw.com',date '2026-12-12'),
 ('baker-mckenzie','clerkship','hong-kong-summer-clerkship-programme-2027','Hong Kong Summer Clerkship Programme 2027','Two paid four-week summer clerkship programmes in Baker McKenzie’s Hong Kong office.','in_person','https://hkg-graduates.bakermckenzie.com/programmes/summer-clerkship-programme/','https://hkg-graduates.bakermckenzie.com/programmes/summer-clerkship-programme/',date '2026-12-01'),
 ('baker-mckenzie','summer_associate','us-emerging-lawyers-academy-2027','US Emerging Lawyers Academy 2027','A ten-week US summer programme for 1L and 2L law students, with summer salary and an Academy stipend.','in_person','https://www.bakermckenzie.com/en/locations/north-america/united-states/emerging-lawyers-academy','https://www.bakermckenzie.com/en/locations/north-america/united-states/emerging-lawyers-academy',date '2027-03-02'),
 ('baker-mckenzie','fellowship','us-inclusion-diversity-equity-fellowship-2027','US Inclusion, Diversity & Equity Fellowship 2027','A separate $50,000 fellowship route linked to Baker McKenzie’s US summer programme.','in_person','https://www.bakermckenzie.com/en/locations/north-america/united-states/emerging-lawyers-academy','https://www.bakermckenzie.com/en/locations/north-america/united-states/emerging-lawyers-academy',date '2027-03-02'),
 ('baker-mckenzie','virtual_experience','virtual-experience-programme','Virtual Experience Programme','A free, self-paced virtual programme introducing Baker McKenzie work and skills through Forage.','virtual','https://hkg-graduates.bakermckenzie.com/programmes/virtual-experience-programme/','https://hkg-graduates.bakermckenzie.com/programmes/virtual-experience-programme/',date '2027-04-30'),
 ('ashurst-perkins-coie','summer_associate','us-summer-associate-programme-2027-2028','US Summer Associate Programme 2027–2028','A ten-week US summer associate programme with dual-summer and 2028-only application routes.','in_person','https://www.ashurstperkinscoie.com/en/careers/students-and-graduates/us-2l-summer-associate-program/','https://www.ashurstperkinscoie.com/en/careers/students-and-graduates/us-2l-summer-associate-program/',date '2027-02-01'),
 ('ashurst-perkins-coie','fellowship','us-inclusive-leaders-fellowship-2027','US Inclusive Leaders Fellowship 2027','A two-summer fellowship for first-year ABA law students, with summer salary and milestone payments.','in_person','https://www.ashurstperkinscoie.com/en/careers/students-and-graduates/us-inclusive-leaders-fellowship/','https://www.ashurstperkinscoie.com/en/careers/students-and-graduates/us-inclusive-leaders-fellowship/',date '2027-02-01'),
 ('ashurst-perkins-coie','fellowship','us-1l-patent-litigation-fellowships-2027','US 1L Patent Litigation Fellowships 2027','A two-summer patent-litigation fellowship for first-year law students with a technical or scientific background.','in_person','https://www.ashurstperkinscoie.com/en/careers/students-and-graduates/us-1l-patent-litigation-fellowships/','https://www.ashurstperkinscoie.com/en/careers/students-and-graduates/us-1l-patent-litigation-fellowships/',date '2027-02-01')
)
insert into public.career_opportunities
(organisation_id,opportunity_type_id,event_type_id,slug,official_name,english_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select lo.id,ot.id,null,o.slug,o.title,o.title,o.title,o.summary,o.delivery,o.url,o.apply_url,true,true,date '2026-10-31',o.next_review
from opportunities o join public.legal_organisations lo on lo.slug=o.org_slug
join public.opportunity_types ot on ot.slug=o.type_slug
on conflict (organisation_id,slug) do update set
 opportunity_type_id=excluded.opportunity_type_id,event_type_id=null,official_name=excluded.official_name,
 english_name=excluded.english_name,public_name=excluded.public_name,public_summary=excluded.public_summary,
 delivery_mode=excluded.delivery_mode,official_url=excluded.official_url,application_url=excluded.application_url,
 active=true,published=true,research_checked_on=excluded.research_checked_on,next_review_on=excluded.next_review_on,updated_at=now();

with cycles(org_slug,slug,title,app_year,prog_year,model,opens_on,closes_on,closes_at,tz,start_on,end_on,programme_text,application_text,status,audience,eligibility,process,funding,places,duration) as (values
 ('three-raymond-buildings','robin-simpson-kc-advocacy-competition-2026','Robin Simpson KC Advocacy Competition 2026',2026,2027,'fixed_deadline',null::date,date '2026-12-11',time '16:00','Europe/London',date '2027-01-14',date '2027-01-14','Final at Gray’s Inn on the evening of 14 January 2027.','Entries close at 16:00 on 11 December 2026.','open','Applicants to, current students on, or graduates of a Bar Practice or Bar Training Course who do not yet have pupillage.','Applicants must not yet have pupillage.','Request the materials by email, then submit a five-minute recorded defence closing speech.','Eight finalists receive a mini-pupillage; the overall winner receives a cash prize.','Eight finalists','Competition followed by an in-person final'),
 ('baker-mckenzie','hong-kong-summer-clerkship-programme-2027','Hong Kong Summer Clerkship Programme 2027',2026,2027,'fixed_deadline',date '2026-09-12',date '2026-11-30',null::time,'Asia/Hong_Kong',date '2027-06-01',date '2027-07-31','Two separate four-week paid programmes in June and July 2027; exact cohort dates are not published.','Applications opened 12 September and close 30 November 2026; no closing time is published.','open','Penultimate- and final-year law students and final-year students on a qualifying law programme.','Applicants should have or be predicted a 2:1 equivalent; contextual circumstances are considered.','Apply through the official programme page.','Paid clerkship.','Up to 20 clerks','Four weeks'),
 ('baker-mckenzie','us-emerging-lawyers-academy-2027','US Emerging Lawyers Academy 2027',2026,2027,'fixed_deadline',date '2026-11-01',date '2027-03-01',null::time,null::text,date '2027-05-01',date '2027-08-31','Ten-week summer programme in 2027; exact dates are not published.','Applications open 1 November 2026 and close 1 March 2027; applications are reviewed on a rolling basis.','upcoming','Students at ABA-accredited law schools applying for 2027 1L or 2028 2L positions.','Applicants must be enrolled at an ABA-accredited law school.','Apply directly through the official US programme page.','Weekly pay equivalent to the first-year associate market rate, plus a $10,000 Academy stipend on arrival and a further $10,000 for participants who return as associates.',null::text,'Ten weeks'),
 ('baker-mckenzie','us-inclusion-diversity-equity-fellowship-2027','US Inclusion, Diversity & Equity Fellowship 2027',2026,2027,'fixed_deadline',date '2026-11-01',date '2027-03-01',null::time,null::text,date '2027-05-01',date '2027-08-31','Fellowship consideration is linked to the 2027 US summer programme.','Apply through the Emerging Lawyers Academy route from 1 November 2026; the published window closes 1 March 2027 and is rolling.','upcoming','Eligible US law students applying to the Emerging Lawyers Academy.','Fellowship consideration follows the summer-programme callback process.','Apply to the Emerging Lawyers Academy and follow the official fellowship consideration process.','$50,000 fellowship funding paid at published summer and associate milestones.',null::text,null::text),
 ('baker-mckenzie','virtual-experience-programme','Virtual Experience Programme',2026,null::integer,'rolling',null::date,null::date,null::time,null::text,null::date,null::date,'Self-paced and available online.','Available on demand; no closing date is published.','open','Open to everyone regardless of degree, experience, location or year of study.','No stated academic or location restriction.','Start the programme through the official page and linked Forage platform.','Free.',null::text,'Self-paced'),
 ('ashurst-perkins-coie','us-summer-associate-programme-2027-2028','US Summer Associate Programme 2027–2028',2026,2027,'rolling',date '2026-11-02',null::date,null::time,null::text,date '2027-05-01',date '2028-08-31','Ten-week summer programmes, including a 2027/2028 dual-summer route and a 2028-only route; exact dates are not published.','Applications open 2 November 2026 and are considered on a rolling basis; no closing date is published.','upcoming','US law students seeking the dual-summer 2027/2028 or 2028-only route.','See the official programme page for route-specific year-of-study requirements.','Submit a resume, cover letter, transcripts and a legal writing sample of no more than ten pages.','Paid summer associate programme.',null::text,'Ten weeks per summer'),
 ('ashurst-perkins-coie','us-inclusive-leaders-fellowship-2027','US Inclusive Leaders Fellowship 2027',2026,2027,'rolling',date '2026-11-02',null::date,null::time,null::text,date '2027-05-01',date '2028-08-31','Two ten-week summer programmes in 2027 and 2028; exact dates are not published.','Applications open 2 November 2026 and are considered on a rolling basis; no closing date is published.','upcoming','First-year students in good standing at an ABA-accredited law school; open to applicants of all backgrounds.','Applicants must be first-year students at an ABA-accredited law school.','Apply through the dual-summer application and include the required one-page personal statement.','$20,000 after each completed summer, summer associate salary, and an additional $10,000 for fellows who return as associates.',null::text,'Two ten-week summers'),
 ('ashurst-perkins-coie','us-1l-patent-litigation-fellowships-2027','US 1L Patent Litigation Fellowships 2027',2026,2027,'rolling',date '2026-11-02',null::date,null::time,null::text,date '2027-05-01',date '2028-08-31','Two ten-week summer programmes in 2027 and 2028; exact dates are not published.','Applications open 2 November 2026 and are considered on a rolling basis; no closing date is published.','upcoming','First-year students in good standing at an ABA-accredited law school with a technical or scientific background.','A technical or scientific background is required; relevant experience is preferred.','Submit a resume, cover letter, transcripts and a legal writing sample of no more than ten pages.','Summer associate salary plus a $25,000 stipend after the second summer.',null::text,'Two ten-week summers')
)
insert into public.career_opportunity_cycles
(opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,opens_on,closes_on,closes_at,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,source_status,audience_text,eligibility_text,application_process_text,funding_text,places_text,duration_text,official_url,application_url,active,research_checked_on,may_close_early)
select co.id,c.slug,c.title,c.app_year,c.prog_year,c.model,c.opens_on,c.closes_on,c.closes_at,c.tz,c.start_on,c.end_on,
 c.programme_text,c.application_text,case when c.start_on is null then 'unknown' when c.slug='hong-kong-summer-clerkship-programme-2027' then 'month' else 'exact' end,
 c.status,c.audience,c.eligibility,c.process,c.funding,c.places,c.duration,co.official_url,co.application_url,true,date '2026-10-31',c.model='rolling'
from cycles c join public.legal_organisations lo on lo.slug=c.org_slug
join public.career_opportunities co on co.organisation_id=lo.id and co.slug=c.slug
on conflict (opportunity_id,cycle_key) do update set
 application_year=excluded.application_year,programme_year=excluded.programme_year,application_model=excluded.application_model,
 opens_on=excluded.opens_on,closes_on=excluded.closes_on,closes_at=excluded.closes_at,closes_timezone=excluded.closes_timezone,
 programme_starts_on=excluded.programme_starts_on,programme_ends_on=excluded.programme_ends_on,
 programme_dates_text=excluded.programme_dates_text,application_dates_text=excluded.application_dates_text,
 date_precision=excluded.date_precision,source_status=excluded.source_status,audience_text=excluded.audience_text,
 eligibility_text=excluded.eligibility_text,application_process_text=excluded.application_process_text,
 funding_text=excluded.funding_text,places_text=excluded.places_text,duration_text=excluded.duration_text,
 official_url=excluded.official_url,application_url=excluded.application_url,active=true,
 research_checked_on=excluded.research_checked_on,may_close_early=excluded.may_close_early,updated_at=now();

-- Canonical country/city metadata for flags and place filters.
with places(org_slug,slug,city,country,note) as (values
 ('three-raymond-buildings','robin-simpson-kc-advocacy-competition-2026','London','United Kingdom','Final at Gray’s Inn, London.'),
 ('trinity-chambers','pupillage-open-evening-9-december-2026','Newcastle upon Tyne','United Kingdom','Custom House, Quayside, Newcastle upon Tyne.'),
 ('tlt','bristol-early-careers-open-evening-18-november-2026','Bristol','United Kingdom','Bristol.'),
 ('clyde-and-co','vitamin-f-hhu-dusseldorf-19-november-2026','Düsseldorf','Germany','Dreischeibenhaus 1, 40211 Düsseldorf.'),
 ('baker-mckenzie','hong-kong-summer-clerkship-programme-2027','Hong Kong','Hong Kong','Hong Kong office.'),
 ('baker-mckenzie','us-emerging-lawyers-academy-2027',null::text,'United States','United States programme.'),
 ('baker-mckenzie','us-inclusion-diversity-equity-fellowship-2027',null::text,'United States','United States fellowship.'),
 ('ashurst-perkins-coie','us-summer-associate-programme-2027-2028',null::text,'United States','United States programme.'),
 ('ashurst-perkins-coie','us-inclusive-leaders-fellowship-2027',null::text,'United States','United States fellowship.'),
 ('ashurst-perkins-coie','us-1l-patent-litigation-fellowships-2027',null::text,'United States','United States fellowship.')
)
insert into public.career_opportunity_locations
(opportunity_id,country_id,city_id,location_note,location_role,location_status,display_order)
select co.id,gc.id,gci.id,p.note,'programme','confirmed',1
from places p join public.legal_organisations lo on lo.slug=p.org_slug
join public.career_opportunities co on co.organisation_id=lo.id and co.slug=p.slug
join public.geo_countries gc on gc.name=p.country
left join public.geo_cities gci on gci.country_id=gc.id and gci.name=p.city
where not exists (
 select 1 from public.career_opportunity_locations x where x.opportunity_id=co.id and x.cycle_id is null
   and x.country_id=gc.id and x.city_id is not distinct from gci.id and x.location_role='programme'
);

commit;
