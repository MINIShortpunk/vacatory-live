begin;

update public.legal_organisations
set careers_url='https://www.kingschambers.com/recruitment/',research_status='verified',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='69e55f35-2586-42c4-8c3b-235fdfc812d9';

update public.chambers
set pupillage_overview='Kings Chambers is recruiting pupils to commence in September 2028 through the Pupillage Gateway. The published package totals £75,000: a £50,000 first-six award and guaranteed second-six earnings of up to £25,000. Up to £25,000 may be drawn down during Bar training. Recruitment normally includes an application review and two assessment rounds, and applicants would not normally be shortlisted below a 2:1 unless relevant circumstances are taken into account.',
    mini_pupillage_overview='Kings runs an annual two-day mini-pupillage programme in Manchester with 30 places. Applicants must be in at least the second year of a law degree or the third year of a non-law degree; graduates and career changers are also encouraged to apply. Each successful applicant receives £200, breakfast and lunch, with accommodation and exceptional travel-cost support available where appropriate. The programme is not part of pupillage selection.',
    research_status='verified',research_checked_on=date '2026-10-15',
    next_review_on=date '2026-11-23',updated_at=now()
where organisation_id='69e55f35-2586-42c4-8c3b-235fdfc812d9';

-- Remove a past professional event and three undated partner placeholders.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14') or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14'));
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunity_cycle_routes where opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunity_compensation where opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunity_locations where opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunity_routes where opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunity_scope_assignments where opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunity_identity_stage where career_opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunity_cycles where opportunity_id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');
delete from public.career_opportunities where id in ('5bbc5e4d-61d5-445f-a5a4-e29ff6a9eb2f','37b4f087-240a-4631-be05-669600cdadee','d10616a6-55b3-4a42-98e3-ad040f7d25fd','35e3a00d-ac1a-4009-87a5-a31f6fdafb14');

update public.career_opportunities
set public_name='10,000 Black Interns — The Bar 2027 — Kings Chambers Partner',
    official_name='10,000 Black Interns — The Bar 2027 — Kings Chambers Partner',
    public_summary='Paid six-week Bar internship programme for eligible Black students and recent graduates. Kings Chambers confirms its continuing participation in the programme.',
    official_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='3b1314e9-9146-4ba9-a76b-42b1dc62a3eb';

update public.career_opportunity_cycles
set cycle_label='10,000 Black Interns — The Bar 2027 — Kings Chambers Partner',
    application_year=2026,programme_year=2027,intake_year=2027,
    application_model='fixed_deadline',closes_on=date '2026-11-01',closes_at=null,
    closes_timezone='Europe/London',date_precision='exact',source_status='open',
    duration_text='Six weeks',funding_text='Paid internship at the programme’s applicable rate.',
    eligibility_text='Applicants must be aged 18 or over, be Black African, Black Caribbean, Black British or of mixed Black heritage, meet the programme’s UK study or recent-graduate criteria, and not previously have secured a 10,000 Black Interns placement.',
    study_stage_text='UK undergraduate or postgraduate student, confirmed university entrant on a gap year, or recent UK-university graduate from 2024 or later.',
    academic_criteria=null,
    right_to_work_text='Applicants must already have unrestricted permission to work full-time in the United Kingdom when applying.',
    programme_starts_on=date '2027-06-01',programme_ends_on=date '2027-09-30',
    programme_dates_text='Six-week internships take place between June and September 2027, with dates agreed through the programme.',
    application_dates_text='Applications for the Summer 2027 programme close on 1 November 2026.',
    application_process_text='Apply through the 10,000 Interns Foundation and select The Bar workstream. Candidates may choose a region but cannot select an individual chambers.',
    programme_structure_text='The Bar workstream rotates interns across chambers and other Bar organisations, providing experience of advocacy, case preparation and legal practice. Kings confirms continuing participation in the programme.',
    assessments_text='The programme and participating hosts manage application review and selection.',
    expenses_text=null,source_status_note=null,additional_details_text=null,
    official_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    research_checked_on=date '2026-10-15',updated_at=now()
where id='f0e1e65f-da82-451b-afc3-f3a404221963';

update public.career_opportunities
set opportunity_type_id='ef0a606d-a780-4fe9-a544-d0f82f9d2edd',
    public_name='Bridging the Bar Academy 2027–28 — Kings Chambers Partner',
    official_name='Bridging the Bar Academy 2027–28 — Kings Chambers Partner',
    public_summary='Widening-access Academy providing mentoring, skills development and an allocated mini-pupillage through participating organisations, including Kings Chambers.',
    official_url='https://bridgingthebar.org/academy-applications/',
    application_url='https://bridgingthebar.org/academy-applications/',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-06',updated_at=now()
where id='c85ca7d3-3da5-41b8-94eb-610bf34e3111';

update public.career_opportunity_cycles
set cycle_label='Bridging the Bar Academy 2027–28 — Kings Chambers Partner',
    application_year=2026,programme_year=2027,intake_year=2027,
    application_model='fixed_deadline',opens_on=null,closes_on=date '2026-11-05',
    closes_at=time '17:00',closes_timezone='Europe/London',date_precision='exact',
    source_status='open',duration_text='August 2027 to June 2028',
    eligibility_text='Applicants must be studying the Bar Course in 2027–28 or have completed it, intend to apply for pupillage in 2028, have attended a UK state school, not have attended Oxford or Cambridge as an undergraduate, meet the Academy’s financial-support criterion and be available in the United Kingdom for all programme activity.',
    study_stage_text='Bar Course student in 2027–28 or Bar Course graduate intending to apply for pupillage in 2028.',
    academic_criteria='Selection considers academic excellence and understanding of a career at the Bar.',
    right_to_work_text=null,expenses_text=null,
    programme_starts_on=date '2027-08-01',programme_ends_on=date '2028-06-30',
    programme_dates_text='The Academy runs from August 2027 to June 2028.',
    application_dates_text='Applications close at 5:00pm on 5 November 2026.',
    assessments_text='Bridging the Bar assesses written and video responses against its Academy criteria.',
    application_process_text='Apply through the official Bridging the Bar Academy application page.',
    programme_structure_text='The Academy supports 100 candidates through mentoring, application and interview training, advocacy preparation, workshops and at least one mini-pupillage allocated through a participating organisation.',
    source_status_note=null,additional_details_text='A place with Kings Chambers is not guaranteed because Bridging the Bar manages placement allocation.',
    official_url='https://bridgingthebar.org/academy-applications/',
    application_url='https://bridgingthebar.org/academy-applications/',
    research_checked_on=date '2026-10-15',updated_at=now()
where id='dac627f6-0c1a-466c-adca-aef268528999';

update public.career_opportunities
set public_summary='Funded 12-month Kings Chambers pupillage commencing in September 2028, with applications submitted through the Pupillage Gateway in January 2027.',
    application_url='https://www.pupillagegateway.com/',research_checked_on=date '2026-10-15',
    next_review_on=date '2027-01-29',updated_at=now()
where id='74d7c459-665a-45f3-9445-f83402a4a9e0';

update public.career_opportunity_cycles
set funding_text='£50,000 award during the first six months plus guaranteed second-six earnings of up to £25,000. Up to £25,000 of the first-six award may be drawn down during Bar training.',
    source_status='upcoming',date_precision='exact',research_checked_on=date '2026-10-15',updated_at=now()
where id='00959685-904a-4c22-856c-8e86e7e391bf';

commit;
