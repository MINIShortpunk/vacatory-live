begin;

update public.legal_organisations
set overview = 'Fountain Court Chambers is a commercial set with offices in London and Singapore. Its current official homepage lists 116 barristers, comprising 48 silks and 68 juniors. Members practise across banking and finance, civil fraud, commercial disputes and crime, aviation, insurance and reinsurance, professional discipline and negligence, financial services, competition, company and insolvency, technology, sanctions, sport, tax and international arbitration.',
    careers_url = 'https://fountaincourt.uk/join-us/',
    research_status = 'verified',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-14',
    updated_at = now()
where id = '5dbd3808-2889-416c-9eb6-ad69ec9023d5';

update public.chambers
set member_count = 116,
    pupillage_overview = 'Fountain Court normally recruits around four pupils for a 12-month pupillage beginning in October. The 2027 Pupillage Gateway application window opens at 11:00 on 4 January and closes at 23:59 on 28 January 2027 for the October 2028 intake. The award is £90,000, split £55,000 in first six and £35,000 in second six, paid monthly in advance, with up to £35,000 available before starting. Pupils rotate through four three-month seats, are not assessed during their first two months, work on live matters and do not compete against one another.',
    mini_pupillage_overview = 'Fountain Court offers a two-day assessed mini-pupillage that is normally required before a pupillage application. Applications for winter placements in December 2026 or January 2027 close on 23 October 2026. Applicants must have begun legal study, shortlisted candidates attend a short interview and every mini-pupil receives £150 towards reasonable travel and out-of-pocket costs, with further support available in exceptional circumstances.',
    tenancy_overview = 'Fountain Court has no pupil quota and offers tenancy to every pupil who meets the required standard. Decisions are usually made in June or July. New tenants receive mentoring and early-practice support.',
    pupillage_gateway_member = true,
    pupillage_gateway_url = 'https://www.pupillagegateway.com/for-applicants.html',
    research_status = 'verified',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-14',
    updated_at = now()
where organisation_id = '5dbd3808-2889-416c-9eb6-ad69ec9023d5';

update public.career_opportunities
set public_summary = 'Apply by 23 October 2026 for a two-day assessed mini-pupillage taking place in December 2026 or January 2027. Every mini-pupil receives £150 towards reasonable expenses.',
    official_url = 'https://fountaincourt.uk/join-us/pupillage-and-mini-pupillage/mini-pupillage/',
    application_url = 'https://apply.fountaincourt.uk/minipupillage',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-10-24',
    updated_at = now()
where id = '7050a41b-41fa-4b07-8778-9c92664ed171';

update public.career_opportunity_cycles
set cycle_label = 'Fountain Court Winter Assessed Mini-Pupillage 2026–27',
    application_year = 2026,
    programme_year = 2026,
    intake_year = 2026,
    application_model = 'fixed_deadline',
    closes_on = date '2026-10-23',
    closes_timezone = 'Europe/London',
    programme_dates_text = 'Two-day placements normally take place in December 2026 or January 2027.',
    application_dates_text = 'Applications close on 23 October 2026.',
    date_precision = 'exact',
    duration_text = 'Two days',
    source_status = 'open',
    audience_text = 'Law students in their second or third year and non-law candidates who have begun legal studies.',
    study_stage_text = 'Legal study must have begun. Law students are encouraged to apply in their second or third year; non-law candidates should apply after starting their conversion course or other legal studies.',
    academic_criteria = 'Candidates are assessed against Fountain Court’s published pupillage and tenancy criteria.',
    eligibility_text = 'Applicants must have begun legal study. Winter places are prioritised where possible for students on law-conversion courses.',
    application_process_text = 'Apply through Fountain Court’s mini-pupillage portal by 23 October 2026. Shortlisted candidates attend a short interview.',
    assessments_text = 'Written application, short interview and a written exercise completed during the placement.',
    programme_structure_text = 'Two days meeting members, learning about commercial practice and completing a written exercise. The assessed mini-pupillage is normally required before applying for Fountain Court pupillage.',
    progression_route_text = 'Successful completion normally satisfies the assessed mini-pupillage stage required for a later Fountain Court pupillage application.',
    expenses_text = 'Every mini-pupil receives £150 towards reasonable travel and out-of-pocket costs. Additional support may be available in exceptional circumstances.',
    right_to_work_text = null,
    official_url = 'https://fountaincourt.uk/join-us/pupillage-and-mini-pupillage/mini-pupillage/',
    application_url = 'https://apply.fountaincourt.uk/minipupillage',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where opportunity_id = '7050a41b-41fa-4b07-8778-9c92664ed171';

update public.career_opportunities
set official_name = 'Fountain Court Chambers Pupillage — October 2028 Intake',
    public_name = 'Fountain Court Chambers Pupillage — October 2028 Intake',
    public_summary = 'Apply through the Pupillage Gateway from 4 to 28 January 2027 for a 12-month commercial pupillage beginning in October 2028 with a £90,000 award.',
    official_url = 'https://fountaincourt.uk/join-us/pupillage-and-mini-pupillage/pupillage/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where id = '47e2670f-7379-4eb6-93fc-f02776ff366a';

update public.career_opportunity_cycles
set cycle_key = 'fountain-court-pupillage-october-2028',
    cycle_label = 'Fountain Court Pupillage — October 2028 Intake',
    application_year = 2027,
    programme_year = 2028,
    intake_year = 2028,
    application_model = 'fixed_deadline',
    opens_on = date '2027-01-04',
    opens_at = time '11:00',
    opens_timezone = 'Europe/London',
    closes_on = date '2027-01-28',
    closes_at = time '23:59',
    closes_timezone = 'Europe/London',
    programme_starts_on = date '2028-10-01',
    programme_ends_on = date '2029-09-30',
    programme_dates_text = '12-month pupillage beginning in October 2028.',
    application_dates_text = 'Pupillage Gateway vacancies may be browsed from 23 November 2026. Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
    date_precision = 'exact',
    duration_text = '12 months',
    places_text = 'Around four pupils',
    source_status = 'upcoming',
    audience_text = 'Aspiring barristers applying for an October 2028 pupillage.',
    study_stage_text = 'Applicants must complete the academic, vocational and regulatory requirements for practice before pupillage begins. Transferring solicitors may apply through the Gateway.',
    academic_criteria = 'Academic and intellectual ability form part of Fountain Court’s published selection criteria.',
    eligibility_text = 'Applicants are normally required to have completed Fountain Court’s assessed mini-pupillage before applying, save in exceptional circumstances. Selection considers advocacy and communication, clear thinking under pressure, understanding of chambers’ work, teamwork, resilience and integrity.',
    application_process_text = 'Apply through the Pupillage Gateway during the 4–28 January 2027 application window. Complete Fountain Court’s assessed mini-pupillage beforehand unless exceptional circumstances apply.',
    assessments_text = 'Pupillage Gateway application, prior assessed Fountain Court mini-pupillage in the usual case, interviews and assessment against Fountain Court’s published criteria.',
    programme_structure_text = 'Four three-month seats. The first and final seats are overseen by the same overall supervisor and the middle six months are spent with two further supervisors. The first two months are not assessed. Pupils work on live matters and do not compete against one another.',
    progression_route_text = 'Every pupil who meets the tenancy standard is offered tenancy; there is no quota. Decisions are usually made in June or July.',
    funding_text = '£90,000 award: £55,000 for first six and £35,000 for second six, paid monthly in advance. Up to £35,000 may be drawn down before pupillage begins.',
    expenses_text = null,
    right_to_work_text = null,
    source_status_note = null,
    official_url = 'https://fountaincourt.uk/join-us/pupillage-and-mini-pupillage/pupillage/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where opportunity_id = '47e2670f-7379-4eb6-93fc-f02776ff366a';

update public.career_opportunities
set public_summary = 'Year 12 and Year 13 students can apply from January 2027 for work experience with Fountain Court’s clerking and business-support teams.',
    official_url = 'https://fountaincourt.uk/join-us/clerks-and-business-support/',
    application_url = 'https://fountaincourt.uk/join-us/clerks-and-business-support/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-04',
    updated_at = now()
where id = '6e9e6257-e62f-4ca1-82e9-ccf64b2338c9';

update public.career_opportunity_cycles
set cycle_label = 'Fountain Court Year 12 and Year 13 Work Experience 2027',
    application_year = 2027,
    programme_year = 2027,
    intake_year = 2027,
    application_model = 'fixed_deadline',
    opens_on = date '2027-01-01',
    date_precision = 'month',
    source_status = 'upcoming',
    duration_text = null,
    audience_text = 'Year 12 and Year 13 students interested in clerking and business-support careers in chambers.',
    study_stage_text = 'Year 12 or Year 13.',
    academic_criteria = 'No academic threshold or prior legal knowledge requirement is stated.',
    eligibility_text = 'For students in Year 12 or Year 13. No prior legal knowledge is required.',
    application_dates_text = 'Applications open in January 2027 through the official Fountain Court page.',
    programme_dates_text = 'The 2027 placement schedule will be provided through the official application route.',
    application_process_text = 'Use the application route on Fountain Court’s clerks and business-support page when the 2027 cycle opens in January.',
    assessments_text = 'Application form.',
    programme_structure_text = 'Work experience with chambers’ clerking and administration functions, which may include business development and marketing, finance and IT.',
    progression_route_text = 'Student work experience introducing clerking and business-support careers in chambers.',
    expenses_text = null,
    right_to_work_text = null,
    source_status_note = null,
    official_url = 'https://fountaincourt.uk/join-us/clerks-and-business-support/',
    application_url = 'https://fountaincourt.uk/join-us/clerks-and-business-support/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where opportunity_id = '6e9e6257-e62f-4ca1-82e9-ccf64b2338c9';

insert into public.career_opportunities
    (id,organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on,created_at,updated_at)
values
    ('a2fc6f5b-6787-4eca-a0db-a7193f9b3d4a','5dbd3808-2889-416c-9eb6-ad69ec9023d5','5e2816dd-108f-4443-9fb2-218def79147f','f2ad34e9-2e06-4dd6-8c0e-a20ec0e597a3',
     'fountain-court-life-at-the-commercial-bar-2026','Life at the Commercial Bar','Life at the Commercial Bar',
     'Hybrid insight event for aspiring barristers at 18:00 on 26 November 2026. Register by 13 November for an in-person or online place.',
     'hybrid','https://fountaincourt.uk/2026/10/life-at-the-commercial-bar/','https://forms.cloud.microsoft/e/dxVCQXd7sk',true,true,date '2026-10-15',date '2026-11-14',now(),now())
on conflict (id) do nothing;

insert into public.career_opportunity_cycles
    (id,opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,closes_on,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,audience_text,eligibility_text,application_process_text,programme_structure_text,progression_route_text,official_url,application_url,active,research_checked_on,created_at,updated_at)
values
    ('e39b13ef-2301-4b63-9840-56589631d59b','a2fc6f5b-6787-4eca-a0db-a7193f9b3d4a','fountain-court-life-at-the-commercial-bar-2026','Life at the Commercial Bar — 26 November 2026',
     2026,2026,'fixed_deadline',date '2026-11-13','Europe/London',date '2026-11-26',date '2026-11-26',
     '26 November 2026 at 18:00 GMT, hosted in person at Fountain Court in London and online.','Registration closes on 13 November 2026.','exact',null,'open',
     'Aspiring barristers interested in commercial practice.','For aspiring barristers. In-person capacity is limited and an online attendance option is available.',
     'Register through the official Microsoft form by 13 November 2026 and choose an in-person or online place.',
     'A hybrid evening introducing life and practice at the Commercial Bar, with Fountain Court members and opportunities to learn about the profession.',
     'Careers insight only; attendance does not promise progression in mini-pupillage or pupillage recruitment.',
     'https://fountaincourt.uk/2026/10/life-at-the-commercial-bar/','https://forms.cloud.microsoft/e/dxVCQXd7sk',true,date '2026-10-15',now(),now())
on conflict (id) do nothing;

insert into public.career_opportunity_routes
    (id,opportunity_id,route_kind,country_id,city_id,route_status,route_note,display_order,active,created_at,updated_at)
values
    ('42cf4248-cbfa-49ab-8058-953fc12908d5','a2fc6f5b-6787-4eca-a0db-a7193f9b3d4a','physical_city',47,139,'confirmed','Fountain Court, Temple, London EC4Y 9DH, with online attendance also available.',10,true,now(),now())
on conflict (id) do nothing;

insert into public.career_opportunity_cycle_routes (cycle_id,route_id,opportunity_id,mapping_basis,created_at)
values ('e39b13ef-2301-4b63-9840-56589631d59b','42cf4248-cbfa-49ab-8058-953fc12908d5','a2fc6f5b-6787-4eca-a0db-a7193f9b3d4a','single_route_default',now())
on conflict do nothing;

insert into public.career_opportunity_locations
    (id,opportunity_id,cycle_id,country_id,city_id,location_role,location_status,location_note,display_order,created_at)
values
    ('f3909018-4b37-4814-b843-e4799c289086','a2fc6f5b-6787-4eca-a0db-a7193f9b3d4a',null,47,139,'programme','confirmed','Fountain Court, Temple, London EC4Y 9DH; hybrid online attendance is also available.',10,now())
on conflict (id) do nothing;

delete from public.career_opportunity_routes
where opportunity_id = 'a2fc6f5b-6787-4eca-a0db-a7193f9b3d4a'
  and route_kind = 'unresolved';

commit;
