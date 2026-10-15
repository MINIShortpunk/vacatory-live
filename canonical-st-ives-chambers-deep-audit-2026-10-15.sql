begin;

update public.legal_organisations
set careers_url='https://stiveschambers.co.uk/applications/pupillage/',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',
    uk_visa_status=null,uk_visa_summary=null,uk_visa_source_url=null,uk_visa_source_title=null,uk_visa_checked_on=null,
    updated_at=now()
where id='6a2c2db7-70f3-4fd3-896e-d213e463ccd6';

update public.chambers
set pupillage_overview='St Ives runs an annual 12-month pupillage competition in line with the Pupillage Gateway timetable and recruits with a view to tenancy. The 2027 application window opens at 11:00 on 4 January and closes at 23:59 on 28 January for the next intake. Pupils shadow and complete monthly advocacy training during the non-practising six, then undertake instructed court work during the practising six.',
    mini_pupillage_overview='St Ives offers three-day mini-pupillages in Birmingham throughout the year. Undergraduate and postgraduate applicants apply by hard-copy CV and covering letter; electronic applications are not accepted. Applications are assessed against published criteria including academic ability, resilience, motivation, public-speaking experience and written communication, and applicants receive a response within three months.',
    tenancy_overview='Pupillages are offered with a view to tenancy and pupils are assessed on merit rather than competing with one another. Vacatory lists student and aspiring-barrister opportunities only; lateral, probationary-tenancy and established-practitioner recruitment are excluded.',
    pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',updated_at=now()
where organisation_id='6a2c2db7-70f3-4fd3-896e-d213e463ccd6';

-- Permanently remove the unsupported host-placement placeholder, practitioner CPD
-- conference and undated open-evening placeholder, including dependent identity rows.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in
 ('cb55da23-d16a-4efa-a905-f68c2081d632','53768fa0-5f38-43ab-b48f-e673dfc5b832','5be015ad-e1b8-4afc-be2b-3a1c267ac7ba');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in
 ('cb55da23-d16a-4efa-a905-f68c2081d632','53768fa0-5f38-43ab-b48f-e673dfc5b832','5be015ad-e1b8-4afc-be2b-3a1c267ac7ba');
delete from public.career_opportunity_identity_stage where career_opportunity_id in
 ('cb55da23-d16a-4efa-a905-f68c2081d632','53768fa0-5f38-43ab-b48f-e673dfc5b832','5be015ad-e1b8-4afc-be2b-3a1c267ac7ba');
delete from public.career_opportunities where id in
 ('cb55da23-d16a-4efa-a905-f68c2081d632','53768fa0-5f38-43ab-b48f-e673dfc5b832','5be015ad-e1b8-4afc-be2b-3a1c267ac7ba');

update public.career_opportunities
set official_name='Cooper Lohmus Prize 2026–27',public_name='Cooper Lohmus Prize 2026–27',
    public_summary='Criminal advocacy competition for eligible aspiring barristers, culminating in an in-person final at Birmingham Crown Court; every finalist receives a St Ives mini-pupillage.',
    delivery_mode='hybrid',application_url='mailto:cooper-lohmus@stiveschambers.co.uk',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-07',updated_at=now()
where id='92a9f36e-e1e9-4d3b-9445-6c08f49c18ba';

update public.career_opportunity_cycles
set cycle_key='st-ives-cooper-lohmus-prize-2026-27',cycle_label='Cooper Lohmus Prize 2026–27',
    application_year=2026,programme_year=2026,intake_year=2026,application_model='fixed_deadline',
    opens_on=date '2026-10-26',opens_at=time '09:00',opens_timezone='Europe/London',
    closes_on=date '2026-11-06',closes_at=time '16:00',closes_timezone='Europe/London',
    programme_starts_on=date '2026-11-16',programme_ends_on=date '2027-01-21',
    programme_dates_text='The problem is released on 16 November 2026, round one runs from 30 November to 4 December 2026 and the final takes place on 21 January 2027 at Birmingham Crown Court.',
    application_dates_text='Applications open at 09:00 on 26 October 2026 and close at 16:00 on 6 November 2026.',
    date_precision='exact',duration_text='Two competition rounds from November 2026 to January 2027',places_text='Places are limited and processed first come, first served.',source_status='upcoming',
    audience_text='Final-year law students, PGDL students and BPC students or graduates who have not obtained a pupillage offer.',
    study_stage_text='Final-year law students, PGDL students and BPC students or graduates.',academic_criteria=null,
    eligibility_text='Applicants must not already hold a pupillage offer.',
    application_process_text='Email cooper-lohmus@stiveschambers.co.uk with your full name, contact details and current stage of academic attainment by the deadline.',
    assessments_text='Round one is a criminal plea-in-mitigation advocacy exercise. Finalists complete the in-person final before practising barristers and senior members of the judiciary.',
    progression_route_text='Every finalist receives a St Ives mini-pupillage. The winner receives the Cooper Lohmus Prize trophy and joins the Chambers roll of honour.',
    funding_text=null,expenses_text=null,travel_support_text=null,accommodation_support_text=null,right_to_work_text=null,
    disability_support_text='Applicants may contact Chambers when applying to request reasonable adjustments.',
    official_url='https://stiveschambers.co.uk/cooper-lohmus-prize/',application_url='mailto:cooper-lohmus@stiveschambers.co.uk',active=true,
    research_checked_on=date '2026-10-15',source_status_note=null,
    programme_structure_text='The competition develops criminal advocacy through a plea-in-mitigation exercise, with a first round followed by an in-person final at Birmingham Crown Court.',
    additional_details_text='Applications missing the applicant’s current stage of academic attainment are not considered.',updated_at=now()
where opportunity_id='92a9f36e-e1e9-4d3b-9445-6c08f49c18ba';

update public.career_opportunity_compensation
set amount_text='Every finalist receives a St Ives mini-pupillage; the winner receives the Cooper Lohmus Prize trophy.',
    details='Mini-pupillage for every finalist and trophy for the winner.',compensation_status='not_applicable',updated_at=now()
where opportunity_id='92a9f36e-e1e9-4d3b-9445-6c08f49c18ba';

update public.career_opportunities
set public_summary='Three-day Birmingham mini-pupillage offering insight into St Ives Chambers and its multidisciplinary practice.',
    research_checked_on=date '2026-10-15',next_review_on=date '2027-01-15',updated_at=now()
where id='ec0b5aa0-c4f9-45d5-b4cc-641746a88875';

update public.career_opportunity_cycles
set cycle_key='st-ives-rolling-mini-pupillage',cycle_label='St Ives Chambers Rolling Mini-Pupillage',
    application_model='rolling',programme_dates_text='Applications are accepted throughout the year. Successful applicants agree their three-day placement dates with Chambers.',
    application_dates_text='Applications are accepted throughout the year and applicants receive a response within three months.',
    date_precision='text_only',duration_text='Three days',source_status='rolling',
    audience_text='Undergraduate and postgraduate applicants interested in a career at the Bar.',
    study_stage_text='Undergraduate and postgraduate applicants.',
    academic_criteria='Applications are assessed for academic record and intellectual ability.',
    eligibility_text='Applicants should be interested in life at the Bar and St Ives’ multidisciplinary practice.',
    application_process_text='Post or hand-deliver a hard-copy CV and covering letter marked for Thomas Duggan, Mini-Pupillage Co-ordinator, to St Ives Chambers, 1–3 Whittall Street, Birmingham B4 6DH. Include an email address, telephone number and preferred practice areas. Electronic applications are not accepted.',
    assessments_text='Written applications are assessed for academic and intellectual ability, resilience, commitment, motivation, reasons for applying, public-speaking experience and written communication.',
    progression_route_text='The placement provides work experience and insight into practice at the Bar.',
    funding_text=null,expenses_text='The official page signposts the separate Lincoln’s Inn Mini-Pupillage Grant Scheme for applicants seeking financial support.',
    travel_support_text=null,accommodation_support_text=null,right_to_work_text=null,
    source_status_note=null,research_checked_on=date '2026-10-15',
    programme_structure_text='Three days in Birmingham spending time with members across St Ives’ practice areas. Chambers seeks to reflect applicants’ stated practice interests where possible.',
    additional_details_text='St Ives directs applicants seeking barrister work experience to its mini-pupillage scheme rather than offering general work-experience weeks.',updated_at=now()
where opportunity_id='ec0b5aa0-c4f9-45d5-b4cc-641746a88875';

update public.career_opportunity_compensation
set amount_text='Applicants may separately apply to the Lincoln’s Inn Mini-Pupillage Grant Scheme.',
    details='The official St Ives page signposts external grant support from Lincoln’s Inn.',compensation_status='not_applicable',updated_at=now()
where opportunity_id='ec0b5aa0-c4f9-45d5-b4cc-641746a88875';

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select '6a2c2db7-70f3-4fd3-896e-d213e463ccd6','e2b2bcbc-c3b0-4bee-b7d7-d2a0d1c3552b','st-ives-chambers-pupillage-2028-intake',
 'St Ives Chambers Pupillage — 2028 Intake','St Ives Chambers Pupillage — 2028 Intake','Twelve-month multidisciplinary pupillage at St Ives Chambers, recruited with a view to tenancy.','in_person',
 'https://stiveschambers.co.uk/applications/pupillage/','https://www.pupillagegateway.com/',true,true,date '2026-10-15',date '2026-11-24'
where not exists(select 1 from public.career_opportunities where slug='st-ives-chambers-pupillage-2028-intake');

insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,opens_at,opens_timezone,closes_on,closes_at,closes_timezone,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,audience_text,study_stage_text,eligibility_text,application_process_text,assessments_text,progression_route_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select o.id,'st-ives-pupillage-2028','St Ives Chambers Pupillage — 2028 Intake',2027,2028,2028,'fixed_deadline',
 date '2027-01-04',time '11:00','Europe/London',date '2027-01-28',time '23:59','Europe/London',
 'Twelve-month pupillage commencing in 2028.','Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.','exact','Twelve months','upcoming',
 'Aspiring barristers who will have completed the academic and vocational stages of Bar training before pupillage begins.',
 'Applicants preparing to complete Bar training before the 2028 start date.','Applicants must be eligible to begin pupillage by the advertised start date.',
 'Apply through the Pupillage Gateway during the published submissions window.','Written application followed by Chambers’ annual shortlisting and interview process.','Pupillages are offered with a view to tenancy and pupils are assessed on merit.',
 'The non-practising six combines supervisor shadowing with monthly advocacy exercises and training. During the practising six, pupils undertake instructed advocacy in court.',
 'https://stiveschambers.co.uk/applications/pupillage/','https://www.pupillagegateway.com/',true,date '2026-10-15'
from public.career_opportunities o where o.slug='st-ives-chambers-pupillage-2028-intake'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select o.id,'physical_city',47,113,'Birmingham','confirmed',10,true
from public.career_opportunities o where o.slug='st-ives-chambers-pupillage-2028-intake'
and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id);

commit;
