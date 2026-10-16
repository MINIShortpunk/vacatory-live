begin;

update public.legal_organisations
set overview = 'Exchange Chambers is a full-service barristers’ chambers with offices in Liverpool, Manchester and Leeds. Its members practise across business and property, crime, family, employment, pensions and tax, personal injury and clinical negligence, public law, Court of Protection, inquests, regulatory law and dispute resolution.',
    careers_url = 'https://www.exchangechambers.co.uk/pupillage/',
    research_status = 'verified',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where id = '08dd30c3-11b7-4513-a9a8-3d10db4175f0';

update public.chambers
set pupillage_overview = 'Exchange Chambers recruits up to six pupils for its current cycle and offers a £45,000 award. Vacancies for the September 2027 intake become available to browse on 23 November 2026; applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027 through the Pupillage Gateway. Applicants need at least a 2:1. The selection process includes two interview rounds with advocacy exercises.',
    mini_pupillage_overview = 'Exchange runs three direct mini-pupillage application windows each year. The current window is 1 to 30 October 2026 for two-day placements during January 2027 in Liverpool, Manchester or Leeds. Applicants must be in their second year of university or above and apply with a one-page CV and covering letter answering the two questions published by chambers.',
    tenancy_overview = 'Exchange recruits pupils with a view to tenancy following successful completion of pupillage and satisfaction of its tenancy standard. Established-practitioner vacancies are employment routes and are not included among Vacatory’s student opportunities.',
    pupillage_gateway_member = true,
    pupillage_gateway_url = 'https://www.pupillagegateway.com/',
    research_status = 'verified',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where organisation_id = '08dd30c3-11b7-4513-a9a8-3d10db4175f0';

-- This was a generic provider programme rather than a confirmed Exchange Chambers
-- application route. Its speculative 2026/27 timing has also passed without an
-- Exchange-specific opportunity being published, so remove it permanently.
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id = '8042394d-fca9-428c-b275-ee331e1f37b1'
   or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunity_cycle_routes where opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunity_compensation where opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunity_locations where opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunity_routes where opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunity_scope_assignments where opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunity_identity_stage where career_opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunity_cycles where opportunity_id='8042394d-fca9-428c-b275-ee331e1f37b1';
delete from public.career_opportunities where id='8042394d-fca9-428c-b275-ee331e1f37b1';

update public.career_opportunities
set official_name = 'Exchange Chambers Mini-Pupillage — January 2027 Placements',
    public_name = 'Exchange Chambers Mini-Pupillage — January 2027 Placements',
    public_summary = 'Apply from 1 to 30 October 2026 for a two-day mini-pupillage in Liverpool, Manchester or Leeds during January 2027.',
    official_url = 'https://www.exchangechambers.co.uk/pupillage/mini-pupillage/',
    application_url = 'https://www.exchangechambers.co.uk/pupillage/mini-pupillage/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-10-31',
    updated_at = now()
where id='bf68dc6f-9e3b-4d33-a3c1-228455181e38';

update public.career_opportunity_cycles
set opens_on = date '2026-10-01',
    closes_on = date '2026-10-30',
    closes_timezone = 'Europe/London',
    programme_dates_text = 'Successful applicants complete a two-day mini-pupillage during January 2027.',
    date_precision = 'exact',
    source_status = 'open',
    application_dates_text = 'Applications are open from 1 to 30 October 2026.',
    application_process_text = 'Email Colette Beasley a CV of no more than one side of A4 and a covering letter answering “Why Exchange Chambers?” and “Why the interest in law?”. State the preferred practice area and placement city.',
    assessments_text = 'Written review of the one-page CV and covering letter.',
    right_to_work_text = null,
    disability_support_text = 'Applicants who need reasonable adjustments may contact chambers before applying.',
    additional_details_text = 'Successful applicants are due to be notified by the end of November 2026.',
    official_url = 'https://www.exchangechambers.co.uk/pupillage/mini-pupillage/',
    application_url = 'https://www.exchangechambers.co.uk/pupillage/mini-pupillage/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where opportunity_id='bf68dc6f-9e3b-4d33-a3c1-228455181e38';

update public.career_opportunities
set official_name = 'Exchange Chambers Pupillage — September 2027 Intake',
    public_name = 'Exchange Chambers Pupillage — September 2027 Intake',
    public_summary = 'Apply through the Pupillage Gateway from 4 to 28 January 2027 for the September 2027 intake. Exchange offers up to six pupillages and a £45,000 award.',
    official_url = 'https://www.exchangechambers.co.uk/pupillage/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where id='bb7ff567-e8dc-4067-bc7a-95503a624be2';

update public.career_opportunity_cycles
set cycle_label = 'September 2027 pupillage',
    application_year = 2027,
    programme_year = 2027,
    intake_year = 2027,
    application_model = 'fixed_deadline',
    opens_on = date '2027-01-04',
    opens_at = time '11:00',
    opens_timezone = 'Europe/London',
    closes_on = date '2027-01-28',
    closes_at = time '23:59',
    closes_timezone = 'Europe/London',
    programme_starts_on = date '2027-09-01',
    programme_ends_on = null,
    date_precision = 'exact',
    source_status = 'upcoming',
    application_dates_text = 'Vacancies are available to browse from 23 November 2026. Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
    programme_dates_text = 'Pupillage starts in September 2027 and lasts 12 months.',
    application_process_text = 'Apply through the Pupillage Gateway during the published application window.',
    assessments_text = 'Pupillage Gateway application followed by two interview rounds, each including an advocacy exercise.',
    funding_text = '£45,000 pupillage award, with monthly first-six payments and guaranteed monthly income during second six.',
    expenses_text = null,
    right_to_work_text = null,
    disability_support_text = 'Applicants who need reasonable adjustments may contact the Recruitment and Pupillage Manager before assessment.',
    source_status_note = null,
    additional_details_text = 'Exchange states that it offers up to six pupillages in the current recruitment cycle.',
    official_url = 'https://www.exchangechambers.co.uk/pupillage/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where opportunity_id='bb7ff567-e8dc-4067-bc7a-95503a624be2';

with inserted as (
  insert into public.career_opportunities
    (organisation_id, opportunity_type_id, event_type_id, slug, official_name, public_name, public_summary, delivery_mode, official_url, application_url, active, published, research_checked_on, next_review_on)
  select '08dd30c3-11b7-4513-a9a8-3d10db4175f0'::uuid,
         '5e2816dd-108f-4443-9fb2-218def79147f'::uuid,
         'f2ad34e9-2e06-4dd6-8c0e-a20ec0e597a3'::uuid,
         'exchange-chambers-pupillage-forum-2026',
         'Exchange Chambers Pupillage Forum 2026',
         'Exchange Chambers Pupillage Forum 2026',
         'A student-focused day in Liverpool on 10 December 2026 covering pupillage applications, advocacy, interviews and life at Exchange Chambers.',
         'in_person',
         'https://www.exchangechambers.co.uk/pupillage/upcoming-events-pupillage-forum/',
         'https://www.exchangechambers.co.uk/pupillage/upcoming-events-pupillage-forum/',
         true, true, date '2026-10-15', date '2026-11-10'
  where not exists (
    select 1 from public.career_opportunities
    where organisation_id='08dd30c3-11b7-4513-a9a8-3d10db4175f0'
      and slug='exchange-chambers-pupillage-forum-2026'
  )
  returning id
)
insert into public.career_opportunity_cycles
  (opportunity_id, cycle_key, cycle_label, application_year, programme_year, application_model,
   closes_on, closes_at, closes_timezone, programme_starts_on, programme_ends_on,
   programme_dates_text, date_precision, source_status, audience_text, study_stage_text,
   eligibility_text, application_process_text, assessments_text, progression_route_text,
   programme_structure_text, official_url, application_url, active, research_checked_on,
   application_dates_text)
select id, 'exchange-chambers-pupillage-forum-2026:2026', 'Pupillage Forum 2026', 2026, 2026, 'fixed_deadline',
       date '2026-11-09', time '17:00', 'Europe/London', date '2026-12-10', date '2026-12-10',
       '10 December 2026, 10:00–16:00, at Exchange Chambers, One Derby Square, Liverpool L2 9XX.',
       'exact', 'open', 'Third-year university students and above who are considering applying to Exchange Chambers in the 2027 pupillage round.',
       'Third year of university or above.',
       'Applicants must be in their third year of university or above and interested in the 2027 Exchange Chambers pupillage round.',
       'Email Chantal Core a CV and covering letter answering the three questions on the official event page, and state the preferred area of law and city.',
       'Written CV and covering-letter selection. Successful applicants are due to be notified on 16 November 2026.',
       'Attendance provides application and advocacy guidance but does not promise progression in the pupillage competition.',
       'Talks from pupils and new tenants, advocacy and interview guidance, application-form support, breakout rooms and a clerking talk.',
       'https://www.exchangechambers.co.uk/pupillage/upcoming-events-pupillage-forum/',
       'https://www.exchangechambers.co.uk/pupillage/upcoming-events-pupillage-forum/', true, date '2026-10-15',
       'Applications close at 17:00 on 9 November 2026.'
from inserted;

insert into public.career_opportunity_cycles
  (opportunity_id, cycle_key, cycle_label, application_year, programme_year, application_model,
   closes_on, closes_at, closes_timezone, programme_starts_on, programme_ends_on,
   programme_dates_text, date_precision, source_status, audience_text, study_stage_text,
   eligibility_text, application_process_text, assessments_text, progression_route_text,
   programme_structure_text, official_url, application_url, active, research_checked_on,
   application_dates_text)
select o.id, 'exchange-chambers-pupillage-forum-2026:2026', 'Pupillage Forum 2026', 2026, 2026, 'fixed_deadline',
       date '2026-11-09', time '17:00', 'Europe/London', date '2026-12-10', date '2026-12-10',
       '10 December 2026, 10:00–16:00, at Exchange Chambers, One Derby Square, Liverpool L2 9XX.',
       'exact', 'open', 'Third-year university students and above who are considering applying to Exchange Chambers in the 2027 pupillage round.',
       'Third year of university or above.',
       'Applicants must be in their third year of university or above and interested in the 2027 Exchange Chambers pupillage round.',
       'Email Chantal Core a CV and covering letter answering the three questions on the official event page, and state the preferred area of law and city.',
       'Written CV and covering-letter selection. Successful applicants are due to be notified on 16 November 2026.',
       'Attendance provides application and advocacy guidance but does not promise progression in the pupillage competition.',
       'Talks from pupils and new tenants, advocacy and interview guidance, application-form support, breakout rooms and a clerking talk.',
       'https://www.exchangechambers.co.uk/pupillage/upcoming-events-pupillage-forum/',
       'https://www.exchangechambers.co.uk/pupillage/upcoming-events-pupillage-forum/', true, date '2026-10-15',
       'Applications close at 17:00 on 9 November 2026.'
from public.career_opportunities o
where o.organisation_id='08dd30c3-11b7-4513-a9a8-3d10db4175f0'
  and o.slug='exchange-chambers-pupillage-forum-2026'
  and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

-- Keep public location copy factual and free of internal-status wording.
update public.career_opportunity_locations
set location_note = 'Pupillages are based across Leeds, Liverpool and Manchester.'
where opportunity_id='bb7ff567-e8dc-4067-bc7a-95503a624be2';

update public.career_opportunity_routes
set route_note = 'Pupillages are based across Leeds, Liverpool and Manchester.',
    route_status = 'confirmed'
where opportunity_id='bb7ff567-e8dc-4067-bc7a-95503a624be2';

insert into public.career_opportunity_locations
  (opportunity_id,city_id,country_id,location_note,display_order,location_role,location_status)
select o.id,136,47,'Exchange Chambers, One Derby Square, Liverpool L2 9XX',10,'programme','confirmed'
from public.career_opportunities o
where o.organisation_id='08dd30c3-11b7-4513-a9a8-3d10db4175f0'
  and o.slug='exchange-chambers-pupillage-forum-2026'
  and not exists (
    select 1 from public.career_opportunity_locations l
    where l.opportunity_id=o.id and l.city_id=136
  );

delete from public.career_opportunity_routes r
using public.career_opportunities o
where r.opportunity_id=o.id
  and o.organisation_id='08dd30c3-11b7-4513-a9a8-3d10db4175f0'
  and o.slug='exchange-chambers-pupillage-forum-2026'
  and r.route_kind='unresolved';

insert into public.career_opportunity_routes
  (opportunity_id,route_kind,country_id,city_id,display_order,active,route_status,route_note)
select o.id,'physical_city',47,136,10,true,'confirmed','Exchange Chambers, One Derby Square, Liverpool L2 9XX'
from public.career_opportunities o
where o.organisation_id='08dd30c3-11b7-4513-a9a8-3d10db4175f0'
  and o.slug='exchange-chambers-pupillage-forum-2026'
  and not exists (
    select 1 from public.career_opportunity_routes r
    where r.opportunity_id=o.id and r.route_kind='physical_city' and r.city_id=136
  );

commit;
