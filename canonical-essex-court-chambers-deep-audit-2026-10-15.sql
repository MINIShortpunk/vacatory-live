begin;

update public.legal_organisations set
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-27',updated_at=now()
where id='f695eeed-4b22-4a4b-9b1e-9f19cab07d17';

update public.chambers set
 pupillage_overview='Essex Court offers up to six funded, twelve-month, tenancy-seeking pupillages each year. Applications are made through the Pupillage Gateway and candidates must also email their examination transcripts to the Pupillage Committee. The 2027 application window runs from 4 to 28 January 2027.',
 mini_pupillage_overview='Essex Court no longer accepts direct applications for ordinary mini-pupillages. It provides placements through the Bridging the Bar Academy and offers mini-pupillages to the four finalists of the ESU–Essex Court Chambers National Mooting Competition.',
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-27',updated_at=now()
where organisation_id='f695eeed-4b22-4a4b-9b1e-9f19cab07d17';

update public.career_opportunities set
 slug='essex-court-chambers-pupillage-2027-application-cycle',
 official_name='Essex Court Chambers Pupillage — 2027 Application Cycle',
 public_name='Essex Court Chambers Pupillage — 2027 Application Cycle',
 public_summary='Apply through the Pupillage Gateway from 4 to 28 January 2027 for a funded, twelve-month, tenancy-seeking pupillage.',
 active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2027-01-29',updated_at=now()
where id='b7f09033-c3be-4982-9e56-2b8680230b4a';

update public.career_opportunity_cycles set
 cycle_key='essex-court-pupillage-2027-application-cycle',
 cycle_label='Essex Court Chambers Pupillage — 2027 Application Cycle',application_year=2027,
 application_model='fixed_deadline',opens_on=date '2027-01-04',opens_at=time '11:00',opens_timezone='Europe/London',
 closes_on=date '2027-01-28',closes_at=time '23:59',closes_timezone='Europe/London',date_precision='exact',source_status='upcoming',source_status_note=null,
 application_dates_text='Applications may be submitted through the Pupillage Gateway from 11:00 on 4 January until 23:59 on 28 January 2027. Offers are made on 7 May 2027 and initial offers must be accepted by 14 May 2027.',
 programme_dates_text='Essex Court offers funded, twelve-month, tenancy-seeking pupillages.',
 application_process_text='Apply through the Pupillage Gateway and email examination transcripts separately to the Secretary to the Pupillage Committee. Referee details are requested after the Gateway application window closes.',
 assessments_text='Gateway application assessment, a timed written exercise and one interview round for a limited number of candidates. Interview candidates receive a problem in advance and answer questions testing the published objective criteria.',
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='b7f09033-c3be-4982-9e56-2b8680230b4a';

update public.career_opportunities set
 official_url='https://bridgingthebar.org/academy-applications/',application_url='https://bridgingthebar.org/academy-applications/',
 public_summary='Apply by 17:00 on 5 November 2026 for the 2027/28 Bridging the Bar Academy, through which Essex Court provides mini-pupillage places.',
 active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2026-11-06',updated_at=now()
where id='c01e3b40-bffc-4808-b4cb-3e15cabde4bf';

update public.career_opportunity_cycles set
 application_model='fixed_deadline',opens_on=date '2026-10-02',closes_on=date '2026-11-05',closes_at=time '17:00',closes_timezone='Europe/London',
 programme_starts_on=date '2027-08-01',programme_ends_on=date '2028-06-30',date_precision='month',source_status='open',source_status_note=null,
 application_dates_text='Applications for the 2027/28 Academy close at 17:00 on 5 November 2026.',
 programme_dates_text='The Academy programme runs from August 2027 to June 2028.',
 official_url='https://bridgingthebar.org/academy-applications/',application_url='https://bridgingthebar.org/academy-applications/',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='c01e3b40-bffc-4808-b4cb-3e15cabde4bf';

update public.career_opportunities set
 official_name='Essex Court Chambers Pupillage Open Evening 2026',public_name='Essex Court Chambers Pupillage Open Evening 2026',
 public_summary='An in-person evening for prospective pupillage applicants on 26 November 2026, with presentations and an opportunity to meet members of chambers.',
 active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2026-11-27',updated_at=now()
where id='5eca5c83-1b93-4cf9-bce7-c6439874d7a1';

update public.career_opportunity_cycles set
 application_model='rolling',opens_on=null,closes_on=null,opens_at=null,closes_at=null,opens_timezone=null,closes_timezone=null,
 application_dates_text='Email a CV by 16:00 on 19 October 2026 to request a place. This is event registration rather than an opportunity application deadline.',
 programme_starts_on=date '2026-11-26',programme_ends_on=date '2026-11-26',programme_dates_text='26 November 2026, approximately 18:30–20:30, in person.',
 date_precision='exact',source_status='open',source_status_note=null,research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='5eca5c83-1b93-4cf9-bce7-c6439874d7a1';

-- Permanently remove two duplicate open-evening records and the non-current third-six vacancy record.
create temporary table deleted_essex_court_opportunities(id uuid primary key) on commit drop;
insert into deleted_essex_court_opportunities(id) values
 ('2f19f640-604e-4cd8-9429-abfe04b4da9f'),
 ('68c04acf-7462-40c5-9c80-25d30d076c8a'),
 ('d6be79a4-8950-4043-956d-b778cbba15f1');

delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in (select id from deleted_essex_court_opportunities) or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id in (select id from deleted_essex_court_opportunities));
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunity_cycle_routes where opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunity_compensation where opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunity_locations where opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunity_routes where opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunity_scope_assignments where opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunity_identity_stage where career_opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunity_cycles where opportunity_id in (select id from deleted_essex_court_opportunities);
delete from public.career_opportunities where id in (select id from deleted_essex_court_opportunities);

commit;
