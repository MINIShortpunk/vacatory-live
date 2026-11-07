-- Canonical G-H law-student opportunity corrections, verified 7 November 2026.
-- Official sources only. Excludes ordinary employment vacancies and paid/non-student events.

begin;

-- Harbottle & Lewis: publish the official 2029 training-contract deadline.
update career_opportunities
set official_url='https://gradhub.harbottle.com/grad-hub/faqs/',
    application_url='https://gradhub.harbottle.com/grad-hub/your-application/',
    research_checked_on=date '2026-11-07',
    next_review_on=date '2027-02-01',
    updated_at=now()
where organisation_id='f6097783-a65c-47ea-b39c-c9a0821bebc4'
  and slug='london-training-contract-2029';

update career_opportunity_cycles c
set application_model='fixed_deadline',
    closes_on=date '2027-01-31',
    application_dates_text='Applications for the 2029 training contract are open from 1 November 2026 to 31 January 2027. No closing time is published.',
    source_status='open',
    source_status_note='Opening and closing dates verified against the official Harbottle & Lewis Grad Hub.',
    official_url='https://gradhub.harbottle.com/grad-hub/faqs/',
    application_url='https://gradhub.harbottle.com/grad-hub/your-application/',
    research_checked_on=date '2026-11-07',
    updated_at=now()
from career_opportunities o
where c.opportunity_id=o.id
  and o.organisation_id='f6097783-a65c-47ea-b39c-c9a0821bebc4'
  and o.slug='london-training-contract-2029';

-- The Deadlines projection also reads the canonical firm-programme record.
update firm_programmes
set application_closes_on=date '2027-01-31',
    application_date_summary='Applications for the 2029 training contract are open from 1 November 2026 to 31 January 2027. No closing time is published.',
    status='open',
    current_status='open',
    status_note='Applications are open and close on 31 January 2027; no closing time is published.',
    primary_source_url='https://gradhub.harbottle.com/grad-hub/faqs/',
    application_url='https://gradhub.harbottle.com/grad-hub/your-application/',
    research_checked_on=date '2026-11-07',
    next_review_on=date '2027-02-01',
    updated_at=now()
where (firm_id='f6097783-a65c-47ea-b39c-c9a0821bebc4'
       or organisation_id='f6097783-a65c-47ea-b39c-c9a0821bebc4')
  and slug='london-training-contract-2029';

-- Permanently remove Gateley's non-law structural-engineering employment vacancy.
create temporary table _g_h_delete(id uuid primary key) on commit drop;
insert into _g_h_delete(id)
select id from career_opportunities
where organisation_id='ff6d8505-ba8a-4b7d-9980-ad54286872c9'
  and slug='gateley-graduate-structural-engineer-manchester-2026';

delete from career_opportunity_compensation_identity_stage s using _g_h_delete d where s.career_opportunity_id=d.id;
delete from career_opportunity_cycle_identity_stage s using _g_h_delete d where s.career_opportunity_id=d.id;
delete from career_opportunity_identity_stage s using _g_h_delete d where s.career_opportunity_id=d.id;
delete from career_opportunity_location_candidate_stage s using _g_h_delete d where s.career_opportunity_id=d.id;
delete from career_opportunity_location_migration_stage s using _g_h_delete d where s.career_opportunity_id=d.id;
delete from career_opportunity_routes s using _g_h_delete d where s.opportunity_id=d.id;
delete from career_opportunity_scope_assignments s using _g_h_delete d where s.opportunity_id=d.id;
delete from career_opportunity_locations s using _g_h_delete d where s.opportunity_id=d.id;
delete from career_opportunity_compensation s using _g_h_delete d where s.opportunity_id=d.id;
delete from career_opportunity_cycles s using _g_h_delete d where s.opportunity_id=d.id;
delete from career_opportunities s using _g_h_delete d where s.id=d.id;

-- Restore the two verified HFW student events to the Events feed.
create temporary table _g_h_events(
  slug text primary key, name text, summary text, event_date date,
  date_text text, city_id bigint, location_note text
) on commit drop;

insert into _g_h_events values
 ('south-yorkshire-solicitor-apprenticeship-showcase-2026',
  'South Yorkshire Solicitor Apprenticeship Showcase 2026',
  'An in-person insight and networking event for students and sixth formers exploring solicitor apprenticeships.',
  date '2026-11-27','27 November 2026, 14:00–17:00, Sheffield.',156,
  'Sheffield; the official HFW page does not publish a more specific venue.'),
 ('hfw-solicitor-apprenticeship-open-day-2026',
  'HFW Solicitor Apprenticeship Open Day 2026',
  'An HFW open day for Year 13 and gap-year students considering its Solicitor Apprenticeship.',
  date '2026-12-09','9 December 2026, London; no event time is published.',139,
  'HFW London; the official page does not publish an event time.');

with upserted as (
  insert into career_opportunities
    (organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,english_name,language_code,
     public_summary,delivery_mode,official_url,application_url,active,published,display_order,research_checked_on,
     next_review_on,public_variant,public_variant_kind,updated_at)
  select '2ed317d0-79cb-40bb-8d1e-94f42eb0675b'::uuid,
         '5e2816dd-108f-4443-9fb2-218def79147f'::uuid,
         'f2ad34e9-2e06-4dd6-8c0e-a20ec0e597a3'::uuid,
         e.slug,e.name,e.name,e.name,'en',e.summary,'in_person',
         case when e.slug='south-yorkshire-solicitor-apprenticeship-showcase-2026'
              then 'https://www.hfw.com/careers/early-careers/early-careers-london/events/'
              else 'https://www.hfw.com/careers/early-careers/early-careers-london/open-days-insight-days/' end,
         case when e.slug='south-yorkshire-solicitor-apprenticeship-showcase-2026'
              then 'https://www.hfw.com/careers/early-careers/early-careers-london/events/'
              else 'https://www.hfw.com/careers/early-careers/early-careers-london/open-days-insight-days/' end,
         true,true,500,date '2026-11-07',e.event_date+1,'Event','other',now()
  from _g_h_events e
  on conflict(organisation_id,slug) do update set
    official_name=excluded.official_name,public_name=excluded.public_name,english_name=excluded.english_name,
    public_summary=excluded.public_summary,delivery_mode=excluded.delivery_mode,official_url=excluded.official_url,
    application_url=excluded.application_url,active=true,published=true,research_checked_on=excluded.research_checked_on,
    next_review_on=excluded.next_review_on,public_variant='Event',public_variant_kind='other',updated_at=now()
  returning id,slug,official_url,application_url
)
insert into career_opportunity_cycles
  (opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,
   application_dates_text,programme_starts_on,programme_ends_on,programme_dates_text,date_precision,
   source_status,source_status_note,audience_text,study_stage_text,eligibility_text,official_url,
   application_url,active,research_checked_on,updated_at)
select u.id,e.slug,e.name,2026,2026,'rolling',
       'Use the official event page to check registration availability; no separate application deadline is published.',
       e.event_date,e.event_date,e.date_text,'exact','confirmed',
       'Date and published time, where available, verified against HFW’s official early-careers pages.',
       case when e.slug='south-yorkshire-solicitor-apprenticeship-showcase-2026'
            then 'Students and sixth formers exploring solicitor apprenticeships.'
            else 'Year 13 and gap-year students considering a solicitor apprenticeship.' end,
       case when e.slug='south-yorkshire-solicitor-apprenticeship-showcase-2026'
            then 'Student or sixth-form student.' else 'Year 13 or gap-year student.' end,
       case when e.slug='south-yorkshire-solicitor-apprenticeship-showcase-2026'
            then 'For students and sixth formers interested in solicitor apprenticeships.'
            else 'For Year 13 students and gap-year students considering HFW’s Solicitor Apprenticeship.' end,
       u.official_url,u.application_url,true,date '2026-11-07',now()
from upserted u join _g_h_events e using(slug)
where not exists (select 1 from career_opportunity_cycles c where c.opportunity_id=u.id);

update career_opportunity_cycles c
set cycle_key=e.slug,cycle_label=e.name,application_year=2026,programme_year=2026,
    application_model='rolling',opens_on=null,closes_on=null,
    application_dates_text='Use the official event page to check registration availability; no separate application deadline is published.',
    programme_starts_on=e.event_date,programme_ends_on=e.event_date,programme_dates_text=e.date_text,
    date_precision='exact',source_status='confirmed',
    source_status_note='Date and published time, where available, verified against HFW’s official early-careers pages.',
    official_url=o.official_url,application_url=o.application_url,active=true,research_checked_on=date '2026-11-07',updated_at=now()
from career_opportunities o join _g_h_events e on e.slug=o.slug
where c.opportunity_id=o.id and o.organisation_id='2ed317d0-79cb-40bb-8d1e-94f42eb0675b';

insert into career_opportunity_locations
  (opportunity_id,cycle_id,city_id,country_id,location_note,display_order,location_role,location_status)
select o.id,c.id,e.city_id,47,e.location_note,10,'programme','confirmed'
from career_opportunities o join career_opportunity_cycles c on c.opportunity_id=o.id
join _g_h_events e on e.slug=o.slug
where o.organisation_id='2ed317d0-79cb-40bb-8d1e-94f42eb0675b'
and not exists (select 1 from career_opportunity_locations l where l.opportunity_id=o.id and l.cycle_id=c.id);

-- Hill Dickinson: restore the official legal paralegal apprenticeship only.
with upserted as (
  insert into career_opportunities
    (organisation_id,opportunity_type_id,slug,official_name,public_name,english_name,language_code,public_summary,
     delivery_mode,official_url,application_url,active,published,display_order,research_checked_on,next_review_on,updated_at)
  values
    ('2aa6f3fb-9074-4b43-b1ce-c2ca709ce8b2','a137274a-0cec-444b-8296-a6c16d30d116',
     'paralegal-apprenticeship-2027','Paralegal Apprenticeship 2027','Paralegal Apprenticeship 2027',
     'Paralegal Apprenticeship 2027','en',
     'A two-year paid legal apprenticeship combining work with a Level 4 Certificate of Higher Education in Law and Legal Practice.',
     'in_person','https://careers.hilldickinson.com/early-careers/apprenticeships',
     'https://careers.hilldickinson.com/early-careers/apprenticeships',true,true,40,date '2026-11-07',date '2027-01-05',now())
  on conflict(organisation_id,slug) do update set official_name=excluded.official_name,public_name=excluded.public_name,
    english_name=excluded.english_name,public_summary=excluded.public_summary,official_url=excluded.official_url,
    application_url=excluded.application_url,active=true,published=true,research_checked_on=excluded.research_checked_on,
    next_review_on=excluded.next_review_on,updated_at=now()
  returning id
)
insert into career_opportunity_cycles
  (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,
   opens_on,closes_on,application_dates_text,programme_dates_text,date_precision,duration_text,source_status,
   source_status_note,audience_text,study_stage_text,academic_criteria,eligibility_text,programme_structure_text,
   progression_route_text,right_to_work_text,official_url,application_url,active,research_checked_on,updated_at)
select id,'2026-27:paralegal-apprenticeship-2027','Paralegal Apprenticeship 2027',2027,2027,2027,
       'fixed_deadline',date '2027-01-05',date '2027-02-28',
       'Applications open 5 January 2027 and close 28 February 2027; no closing time is published.',
       'Starts September 2027; locations will be announced before applications open.','month','Two years','upcoming',
       'Dates and programme details verified against Hill Dickinson’s official Early Careers and Apprenticeships pages.',
       'School leavers who satisfy the published apprenticeship-funding criteria.','School or college leaver.',
       'Five GCSEs at grade C/4 or above and 96 UCAS points.',
       'Applicants must meet the published academic, age or care/EHCP, residency and right-to-work conditions.',
       'Paid work combined with structured study leading to a Level 4 Certificate of Higher Education in Law and Legal Practice.',
       'Possible progression to a paralegal role, solicitor apprenticeship, CILEX qualification or further development.',
       'Applicants must have lived in the UK for the preceding three years and have permanent UK work rights for the programme.',
       'https://careers.hilldickinson.com/early-careers/apprenticeships',
       'https://careers.hilldickinson.com/early-careers/apprenticeships',true,date '2026-11-07',now()
from upserted u
where not exists (select 1 from career_opportunity_cycles c where c.opportunity_id=u.id);

update career_opportunity_cycles c
set application_year=2027,programme_year=2027,intake_year=2027,application_model='fixed_deadline',
    opens_on=date '2027-01-05',closes_on=date '2027-02-28',
    application_dates_text='Applications open 5 January 2027 and close 28 February 2027; no closing time is published.',
    programme_dates_text='Starts September 2027; locations will be announced before applications open.',date_precision='month',
    duration_text='Two years',source_status='upcoming',
    source_status_note='Dates and programme details verified against Hill Dickinson’s official Early Careers and Apprenticeships pages.',
    official_url=o.official_url,application_url=o.application_url,active=true,research_checked_on=date '2026-11-07',updated_at=now()
from career_opportunities o
where c.opportunity_id=o.id and o.organisation_id='2aa6f3fb-9074-4b43-b1ce-c2ca709ce8b2'
  and o.slug='paralegal-apprenticeship-2027';

insert into career_opportunity_locations
  (opportunity_id,cycle_id,city_id,country_id,location_note,display_order,location_role,location_status)
select o.id,c.id,null,47,'UK locations will be announced before applications open.',10,'programme','confirmed'
from career_opportunities o join career_opportunity_cycles c on c.opportunity_id=o.id
where o.organisation_id='2aa6f3fb-9074-4b43-b1ce-c2ca709ce8b2' and o.slug='paralegal-apprenticeship-2027'
and not exists (select 1 from career_opportunity_locations l where l.opportunity_id=o.id and l.cycle_id=c.id);

commit;
