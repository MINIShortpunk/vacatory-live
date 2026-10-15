begin;

update public.legal_organisations
set overview = '5 Stone Buildings is a specialist Chancery chambers in Lincoln''s Inn, London. Its work includes trusts, inheritance, probate and estate administration, Court of Protection, pensions, taxation, real property, art and cultural property, partnership, charities and professional negligence.',
    careers_url = 'https://www.5sblaw.com/recruitment/',
    research_status = 'verified',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-04',
    updated_at = now()
where id = 'c0af527e-bfa5-4d7f-8595-22aba86b99de';

update public.chambers
set pupillage_overview = '5 Stone Buildings recruits through the Pupillage Gateway. The confirmed 2027 application window opens on 4 January 2027 and closes on 28 January 2027. Pupillage lasts 12 months and pupils normally sit with four supervisors. The award is up to £75,000, up to 25% may be drawn down before pupillage, and chambers pays for compulsory courses.',
    mini_pupillage_overview = '5 Stone Buildings offers normally two-day, unassessed mini-pupillages in March, June, October and December. Annual application deadlines are 15 January, 15 April, 15 August and 15 October respectively. Applicants must already have begun studying law; law students are advised to apply in their second or third year, preferably after land law and equity and trusts, while conversion students should wait until they have started the GDL or equivalent course. In suitable cases chambers may cover reasonable travel, accommodation, childcare or lost-earnings costs.',
    tenancy_overview = 'The tenancy decision is normally taken about nine months into pupillage. Chambers recruits pupils with the hope that they will become tenants and states that almost all recent pupils have been retained. New tenants receive ongoing support from former supervisors and clerks, together with staged concessions on rent and chambers expenses.',
    pupillage_gateway_member = true,
    pupillage_gateway_url = 'https://www.pupillagegateway.com/',
    research_status = 'verified',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-04',
    updated_at = now()
where organisation_id = 'c0af527e-bfa5-4d7f-8595-22aba86b99de';

-- A third-six is a post-pupillage employment route, not a law-student opportunity.
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id = 'cc790fdd-e031-4b6c-b815-cba4d9fb692b'
   or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunity_cycle_routes where opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunity_compensation where opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunity_locations where opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunity_routes where opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunity_scope_assignments where opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunity_identity_stage where career_opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunity_cycles where opportunity_id='cc790fdd-e031-4b6c-b815-cba4d9fb692b';
delete from public.career_opportunities
where id = 'cc790fdd-e031-4b6c-b815-cba4d9fb692b';

update public.career_opportunities
set official_name = '5 Stone Buildings Pupillage — 2027 Application Window',
    public_name = '5 Stone Buildings Pupillage — 2027 Application Window',
    public_summary = 'Apply through the Pupillage Gateway from 4 to 28 January 2027 for a 12-month specialist Chancery pupillage carrying an award of up to £75,000.',
    official_url = 'https://www.5sblaw.com/recruitment/pupillage-application/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-29',
    updated_at = now()
where id = '5f06f531-4b22-4105-9752-ef7e88f8db88';

update public.career_opportunity_cycles
set cycle_label = '2027 Pupillage Gateway application window',
    application_year = 2027,
    opens_on = date '2027-01-04',
    opens_at = time '11:00',
    opens_timezone = 'Europe/London',
    closes_on = date '2027-01-28',
    closes_at = time '23:59',
    closes_timezone = 'Europe/London',
    date_precision = 'exact',
    source_status = 'upcoming',
    application_dates_text = 'Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027 through the Pupillage Gateway.',
    funding_text = 'Award of up to £75,000; up to 25% may be drawn down before pupillage and chambers pays for compulsory courses.',
    expenses_text = 'Chambers pays for compulsory pupillage courses.',
    right_to_work_text = null,
    disability_support_text = null,
    official_url = 'https://www.5sblaw.com/recruitment/pupillage-application/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where opportunity_id = '5f06f531-4b22-4105-9752-ef7e88f8db88';

update public.career_opportunities
set public_summary = case slug
      when '5-stone-buildings-mini-pupillage-december-2026' then 'Two-day specialist Chancery mini-pupillage in December 2026; applications close 15 October 2026.'
      when '5-stone-buildings-mini-pupillage-march-2027' then 'Two-day specialist Chancery mini-pupillage in March 2027; applications close 15 January 2027.'
      when '5-stone-buildings-mini-pupillage-june-2027' then 'Two-day specialist Chancery mini-pupillage in June 2027; applications close 15 April 2027.'
    end,
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-16',
    updated_at = now()
where organisation_id = 'c0af527e-bfa5-4d7f-8595-22aba86b99de'
  and slug in ('5-stone-buildings-mini-pupillage-december-2026','5-stone-buildings-mini-pupillage-march-2027','5-stone-buildings-mini-pupillage-june-2027');

update public.career_opportunity_cycles c
set date_precision = 'exact',
    closes_timezone = 'Europe/London',
    assessments_text = 'Written application. The mini-pupillage itself is not formally assessed.',
    right_to_work_text = null,
    disability_support_text = null,
    source_status = case when c.closes_on = date '2026-10-15' then 'open' else 'upcoming' end,
    research_checked_on = date '2026-10-15',
    updated_at = now()
from public.career_opportunities o
where o.id = c.opportunity_id
  and o.organisation_id = 'c0af527e-bfa5-4d7f-8595-22aba86b99de'
  and o.slug in ('5-stone-buildings-mini-pupillage-december-2026','5-stone-buildings-mini-pupillage-march-2027','5-stone-buildings-mini-pupillage-june-2027');

with additions(slug, name, summary, close_date, session_month) as (
  values
    ('5-stone-buildings-mini-pupillage-october-2027', 'Mini-Pupillage — October 2027 Session', 'Two-day specialist Chancery mini-pupillage in October 2027; applications close 15 August 2027.', date '2027-08-15', 'October 2027'),
    ('5-stone-buildings-mini-pupillage-december-2027', 'Mini-Pupillage — December 2027 Session', 'Two-day specialist Chancery mini-pupillage in December 2027; applications close 15 October 2027.', date '2027-10-15', 'December 2027')
), inserted as (
  insert into public.career_opportunities
    (organisation_id, opportunity_type_id, slug, official_name, public_name, public_summary, delivery_mode, official_url, application_url, active, published, research_checked_on, next_review_on)
  select 'c0af527e-bfa5-4d7f-8595-22aba86b99de'::uuid,
         '45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89'::uuid,
         a.slug, a.name, a.name, a.summary, 'in_person',
         'https://www.5sblaw.com/recruitment/mini-pupillages/',
         'https://www.5sblaw.com/recruitment/mini-pupillages/',
         true, true, date '2026-10-15', date '2027-01-16'
  from additions a
  where not exists (select 1 from public.career_opportunities o where o.organisation_id='c0af527e-bfa5-4d7f-8595-22aba86b99de' and o.slug=a.slug)
  returning id,slug
)
insert into public.career_opportunity_cycles
  (opportunity_id, cycle_key, cycle_label, application_year, programme_year, intake_year, application_model, closes_on, closes_timezone, programme_dates_text, date_precision, duration_text, source_status, study_stage_text, academic_criteria, eligibility_text, application_process_text, assessments_text, progression_route_text, expenses_text, official_url, application_url, active, research_checked_on, application_dates_text, programme_structure_text)
select o.id, a.slug || ':2027', a.name, 2027, 2027, 2027, 'fixed_deadline', a.close_date, 'Europe/London',
       'Two-day mini-pupillage in ' || a.session_month || '.', 'exact', 'Two days', 'upcoming',
       'Law students: normally second or third year. Law-conversion students: only after starting the GDL or equivalent course.',
       'No minimum classification is specified. Prior legal study is required because of the specialist nature of chambers'' work.',
       'Applicants must already have begun studying law. Law students are advised to apply in their second or third year and preferably after studying land law and equity and trusts. Prospective conversion students should wait until they have started the GDL or equivalent law-conversion course.',
       'Download the official application form, complete it and email it in Word format to minipupillage@5sblaw.com. Applications are acknowledged by email and assessed together after the relevant session deadline.',
       'Written application. The mini-pupillage itself is not formally assessed.',
       'A mini-pupillage provides insight into chambers and the Chancery Bar but does not promise progression to pupillage or tenancy.',
       'In suitable cases chambers may cover reasonable travel, accommodation, childcare or lost-earnings costs. The official page also refers eligible applicants to Lincoln''s Inn''s grant scheme.',
       'https://www.5sblaw.com/recruitment/mini-pupillages/', 'https://www.5sblaw.com/recruitment/mini-pupillages/', true, date '2026-10-15',
       'Applications close on ' || to_char(a.close_date,'FMDD FMMonth YYYY') || '.',
       'Mini-pupils generally sit with junior members for two days, attend hearings and conferences where possible, and work on opinions or other accessible Chancery-law problems.'
from additions a
join inserted o on o.slug=a.slug;

-- Idempotent cycle fill for rows already present before this audit is replayed.
with additions(slug, name, close_date, session_month) as (
  values
    ('5-stone-buildings-mini-pupillage-october-2027', 'Mini-Pupillage — October 2027 Session', date '2027-08-15', 'October 2027'),
    ('5-stone-buildings-mini-pupillage-december-2027', 'Mini-Pupillage — December 2027 Session', date '2027-10-15', 'December 2027')
)
insert into public.career_opportunity_cycles
  (opportunity_id, cycle_key, cycle_label, application_year, programme_year, intake_year, application_model, closes_on, closes_timezone, programme_dates_text, date_precision, duration_text, source_status, study_stage_text, academic_criteria, eligibility_text, application_process_text, assessments_text, progression_route_text, expenses_text, official_url, application_url, active, research_checked_on, application_dates_text, programme_structure_text)
select o.id, a.slug || ':2027', a.name, 2027, 2027, 2027, 'fixed_deadline', a.close_date, 'Europe/London',
       'Two-day mini-pupillage in ' || a.session_month || '.', 'exact', 'Two days', 'upcoming',
       'Law students: normally second or third year. Law-conversion students: only after starting the GDL or equivalent course.',
       'No minimum classification is specified. Prior legal study is required because of the specialist nature of chambers'' work.',
       'Applicants must already have begun studying law. Law students are advised to apply in their second or third year and preferably after studying land law and equity and trusts. Prospective conversion students should wait until they have started the GDL or equivalent law-conversion course.',
       'Download the official application form, complete it and email it in Word format to minipupillage@5sblaw.com. Applications are acknowledged by email and assessed together after the relevant session deadline.',
       'Written application. The mini-pupillage itself is not formally assessed.',
       'A mini-pupillage provides insight into chambers and the Chancery Bar but does not promise progression to pupillage or tenancy.',
       'In suitable cases chambers may cover reasonable travel, accommodation, childcare or lost-earnings costs. The official page also refers eligible applicants to Lincoln''s Inn''s grant scheme.',
       'https://www.5sblaw.com/recruitment/mini-pupillages/', 'https://www.5sblaw.com/recruitment/mini-pupillages/', true, date '2026-10-15',
       'Applications close on ' || to_char(a.close_date,'FMDD FMMonth YYYY') || '.',
       'Mini-pupils generally sit with junior members for two days, attend hearings and conferences where possible, and work on opinions or other accessible Chancery-law problems.'
from additions a
join public.career_opportunities o on o.organisation_id='c0af527e-bfa5-4d7f-8595-22aba86b99de' and o.slug=a.slug
where not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

with inserted as (
  insert into public.career_opportunities
    (organisation_id, opportunity_type_id, event_type_id, slug, official_name, public_name, public_summary, delivery_mode, official_url, application_url, active, published, research_checked_on, next_review_on)
  select 'c0af527e-bfa5-4d7f-8595-22aba86b99de'::uuid,
         '5e2816dd-108f-4443-9fb2-218def79147f'::uuid,
         '0565330b-8f5f-45ff-9314-1f3b25ebf243'::uuid,
         'bar-council-pupillage-fair-2026-5-stone-buildings',
         'Bar Council Pupillage Fair 2026 — 5 Stone Buildings Exhibitor',
         'Bar Council Pupillage Fair 2026 — 5 Stone Buildings Exhibitor',
         'Meet 5 Stone Buildings at the Bar Council''s in-person Pupillage Fair for aspiring barristers in London on 17 October 2026.',
         'in_person',
         'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html',
         'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',
         true, true, date '2026-10-15', date '2026-10-18'
  where not exists (select 1 from public.career_opportunities where organisation_id='c0af527e-bfa5-4d7f-8595-22aba86b99de' and slug='bar-council-pupillage-fair-2026-5-stone-buildings')
  returning id
)
insert into public.career_opportunity_cycles
  (opportunity_id, cycle_key, cycle_label, programme_year, application_model, programme_starts_on, programme_ends_on, programme_dates_text, date_precision, source_status, audience_text, eligibility_text, programme_structure_text, official_url, application_url, active, research_checked_on)
select o.id, 'bar-council-pupillage-fair-2026-5-stone-buildings:2026', 'Pupillage Fair 2026', 2026, 'no_application', date '2026-10-17', date '2026-10-17',
       '17 October 2026, 10:00–15:00, at Convene, 133 Houndsditch, Liverpool Street, London EC3A 7DB.', 'exact', 'upcoming',
       'University students, graduates and other aspiring barristers.',
       'For aspiring barristers interested in learning about pupillage providers and the profession.',
       'In-person exhibition with chambers, professional bodies and legal-education organisations, plus seminars and application support. 5 Stone Buildings is a confirmed exhibitor.',
       'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html',
       'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html', true, date '2026-10-15'
from inserted o;

insert into public.career_opportunity_cycles
  (opportunity_id, cycle_key, cycle_label, programme_year, application_model, programme_starts_on, programme_ends_on, programme_dates_text, date_precision, source_status, audience_text, eligibility_text, programme_structure_text, official_url, application_url, active, research_checked_on)
select o.id, 'bar-council-pupillage-fair-2026-5-stone-buildings:2026', 'Pupillage Fair 2026', 2026, 'no_application', date '2026-10-17', date '2026-10-17',
       '17 October 2026, 10:00–15:00, at Convene, 133 Houndsditch, Liverpool Street, London EC3A 7DB.', 'exact', 'upcoming',
       'University students, graduates and other aspiring barristers.',
       'For aspiring barristers interested in learning about pupillage providers and the profession.',
       'In-person exhibition with chambers, professional bodies and legal-education organisations, plus seminars and application support. 5 Stone Buildings is a confirmed exhibitor.',
       'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html',
       'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html', true, date '2026-10-15'
from public.career_opportunities o
where o.organisation_id='c0af527e-bfa5-4d7f-8595-22aba86b99de'
  and o.slug='bar-council-pupillage-fair-2026-5-stone-buildings'
  and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

commit;
