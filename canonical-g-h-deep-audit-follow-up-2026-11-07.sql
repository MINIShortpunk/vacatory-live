-- Canonical G-H deep-audit follow-up, verified 7 November 2026.
-- Official sources only; no inferred dates.

begin;

-- HSF Kramer: publish the official Hong Kong First Year Workshop application window.
update career_opportunities
set official_url='https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    application_url='https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    research_checked_on=date '2026-11-07',
    next_review_on=date '2026-12-01',
    updated_at=now()
where organisation_id='460bf4d2-5594-4a84-958a-07748c328c74'
  and slug='hong-kong-first-year-workshop';

update career_opportunity_cycles c
set application_model='fixed_deadline',
    opens_on=date '2026-11-01',
    closes_on=date '2026-11-30',
    opens_at=null,
    closes_at=null,
    opens_timezone=null,
    closes_timezone=null,
    application_dates_text='Applications are open from 1 November to 30 November 2026. No opening or closing time is published.',
    programme_dates_text='Two-day workshop in January 2027; the official page does not publish the exact workshop dates.',
    date_precision='month',
    source_status='open',
    source_status_note='Application window verified against the official HSF Kramer Hong Kong first-year page. Exact workshop dates are not published.',
    official_url='https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    application_url='https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    research_checked_on=date '2026-11-07',
    updated_at=now()
from career_opportunities o
where c.opportunity_id=o.id
  and o.organisation_id='460bf4d2-5594-4a84-958a-07748c328c74'
  and o.slug='hong-kong-first-year-workshop';

-- HFW: add the standing London Solicitor Apprenticeship without inventing an application window.
with upserted as (
  insert into career_opportunities
    (organisation_id,opportunity_type_id,slug,official_name,public_name,english_name,language_code,
     public_summary,delivery_mode,official_url,application_url,active,published,display_order,
     research_checked_on,next_review_on,updated_at)
  values
    ('2ed317d0-79cb-40bb-8d1e-94f42eb0675b','a137274a-0cec-444b-8296-a6c16d30d116',
     'london-solicitor-apprenticeship','London Solicitor Apprenticeship','London Solicitor Apprenticeship',
     'London Solicitor Apprenticeship','en',
     'A six-year paid London apprenticeship combining work and study through the LLB and SQE to qualify as a solicitor.',
     'in_person','https://www.hfw.com/careers/early-careers/early-careers-london/early-careers-solicitor-apprenticeship/',
     'https://www.hfw.com/careers/early-careers/early-careers-london/early-careers-solicitor-apprenticeship/',
     true,true,40,date '2026-11-07',date '2026-12-01',now())
  on conflict(organisation_id,slug) do update set
    official_name=excluded.official_name,public_name=excluded.public_name,english_name=excluded.english_name,
    public_summary=excluded.public_summary,delivery_mode=excluded.delivery_mode,
    official_url=excluded.official_url,application_url=excluded.application_url,active=true,published=true,
    research_checked_on=excluded.research_checked_on,next_review_on=excluded.next_review_on,updated_at=now()
  returning id
)
insert into career_opportunity_cycles
  (opportunity_id,cycle_key,cycle_label,application_model,application_dates_text,programme_dates_text,
   date_precision,duration_text,places_text,source_status,source_status_note,audience_text,study_stage_text,
   academic_criteria,eligibility_text,programme_structure_text,progression_route_text,right_to_work_text,
   funding_text,official_url,application_url,active,research_checked_on,updated_at)
select id,'current-london-solicitor-apprenticeship','London Solicitor Apprenticeship','rolling',
       'The official programme page provides an application link but does not publish opening or closing dates.',
       'One intake starts in August or September each year; the official page does not publish an exact 2027 start date.',
       'month','Six years','HFW normally recruits two solicitor apprentices each year.','open',
       'The programme, eligibility and salary are confirmed on HFW’s official page; no application dates have been inferred.',
       'Year 13 students and eligible gap-year students who have not commenced the second year of an undergraduate degree.',
       'Year 13 or gap-year school leaver.',
       'Seven GCSEs including English and Maths at grade C/4 or above, plus BBB/120 UCAS points or 32 IB points; applications are considered holistically.',
       'Applicants must satisfy the academic criteria and the applicable UK apprenticeship funding and residence requirements.',
       'Four days working and one protected study day each week, completing an LLB and SQE Parts 1 and 2, with legal and business-services seats and an international secondment.',
       'Qualification as a solicitor after completing the six-year apprenticeship and SQE requirements.',
       'Applicants must hold the appropriate UK right to work and meet the UK apprenticeship residence and funding requirements; HFW does not offer visa sponsorship for this route.',
       'University tuition and SQE study are funded; published starting salary is £27,000.',
       'https://www.hfw.com/careers/early-careers/early-careers-london/early-careers-solicitor-apprenticeship/',
       'https://www.hfw.com/careers/early-careers/early-careers-london/early-careers-solicitor-apprenticeship/',
       true,date '2026-11-07',now()
from upserted
where not exists (select 1 from career_opportunity_cycles c where c.opportunity_id=upserted.id);

update career_opportunity_cycles c
set application_model='rolling',opens_on=null,closes_on=null,opens_at=null,closes_at=null,
    application_dates_text='The official programme page provides an application link but does not publish opening or closing dates.',
    programme_dates_text='One intake starts in August or September each year; the official page does not publish an exact 2027 start date.',
    date_precision='month',duration_text='Six years',places_text='HFW normally recruits two solicitor apprentices each year.',
    source_status='open',
    source_status_note='The programme, eligibility and salary are confirmed on HFW’s official page; no application dates have been inferred.',
    official_url=o.official_url,application_url=o.application_url,active=true,research_checked_on=date '2026-11-07',updated_at=now()
from career_opportunities o
where c.opportunity_id=o.id and o.organisation_id='2ed317d0-79cb-40bb-8d1e-94f42eb0675b'
  and o.slug='london-solicitor-apprenticeship';

insert into career_opportunity_locations
  (opportunity_id,cycle_id,city_id,country_id,location_note,display_order,location_role,location_status)
select o.id,c.id,139,47,'HFW London office.',10,'programme','confirmed'
from career_opportunities o join career_opportunity_cycles c on c.opportunity_id=o.id
where o.organisation_id='2ed317d0-79cb-40bb-8d1e-94f42eb0675b'
  and o.slug='london-solicitor-apprenticeship'
  and not exists (select 1 from career_opportunity_locations l where l.opportunity_id=o.id and l.cycle_id=c.id);

commit;
