begin;

update public.legal_organisations set research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',updated_at=now() where id='9e099404-1d88-4311-bfc8-9894655aed6a';
update public.chambers set
 pupillage_overview='Doughty Street will recruit one General pupil, one Crime pupil and one Media and Information pupil for its October 2028 intake. The adverts become viewable on 23 November 2026; applications open on 4 January and close on 28 January 2027 through the Pupillage Gateway. First interviews run from 22 March to 9 April 2027 and final interviews take place on 24 April 2027. Pupillage lasts 12 months and successful pupils may apply for tenancy.',
 mini_pupillage_overview='Doughty Street provides one-week placements through widening-access partners. It offers multiple placements through the Bridging the Bar Academy and three placements each year through Inner Temple PASS. It also participates in the Bar Placement Scheme for school, sixth-form and first-year university students when a partner cycle is available.',
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',updated_at=now()
where organisation_id='9e099404-1d88-4311-bfc8-9894655aed6a';

update public.career_opportunities set
 slug='doughty-street-chambers-pupillage-2028-29',official_name='Doughty Street Chambers Pupillage 2028–29',public_name='Doughty Street Chambers Pupillage 2028–29',
 public_summary='Apply through the Pupillage Gateway from 4 to 28 January 2027 for General, Crime or Media and Information pupillage starting in October 2028.',
 active=true,published=true,canonical_public_suppressed=false,canonical_public_suppression_reason=null,research_checked_on=date '2026-10-15',next_review_on=date '2027-01-29',updated_at=now()
where id='3371af9c-1afc-4082-ac43-aab690681f19';
update public.career_opportunity_cycles set
 active=true,cycle_key='doughty-street-pupillage-2028-29',cycle_label='Doughty Street Chambers Pupillage 2028–29',application_year=2027,programme_year=2028,intake_year=2028,
 application_model='fixed_deadline',opens_on=date '2027-01-04',closes_on=date '2027-01-28',programme_starts_on=date '2028-10-01',programme_ends_on=date '2029-09-30',date_precision='exact',source_status='upcoming',
 application_dates_text='The adverts become viewable on 23 November 2026. Applications open on 4 January and close on 28 January 2027.',
 programme_dates_text='The 12-month pupillage begins in October 2028.',
 assessments_text='Applications are sifted on paper. First interviews take place between 22 March and 9 April 2027. Final interviews for all three places take place on 24 April 2027.',
 source_status_note=null,additional_details_text='The 2028–29 intake comprises one General pupil, one Crime pupil and one Media and Information pupil.',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='3371af9c-1afc-4082-ac43-aab690681f19';

update public.career_opportunity_cycles set opens_on=date '2026-10-05',application_model='fixed_deadline',source_status='open',source_status_note=null,
 programme_starts_on=date '2027-05-01',programme_ends_on=date '2027-09-30',date_precision='month',
 application_dates_text='Applications for the Summer 2027 programme opened on 5 October 2026 and close on 1 November 2026.',
 programme_dates_text='Paid internships commence between May and September 2027 and run for at least six weeks.',
 application_process_text='Apply through the 10,000 Interns Foundation by 1 November 2026, selecting the relevant workstream and location. The Foundation manages matching and participating hosts make selection decisions.',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='4b895ea2-8209-4470-9001-dbcc897e40b9';
update public.career_opportunities set public_name='10,000 Black Interns Summer 2027 — Doughty Street Participant',official_name='10,000 Black Interns Summer 2027 — Doughty Street Participant',
 public_summary='Apply by 1 November 2026 for the paid Summer 2027 programme. Doughty Street participates as a host organisation.',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='4b895ea2-8209-4470-9001-dbcc897e40b9';

update public.career_opportunity_cycles set application_model='rolling',source_status='open',source_status_note=null,
 programme_dates_text='Mentoring lasts approximately three months, with weekly online meetings arranged after matching.',
 application_process_text='Register through Urban Synergy’s mentee form. Urban Synergy reviews eligibility and matches successful applicants with trained professional mentors.',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='f4f0abc4-a05e-47de-b973-98c22086d802';

-- Permanently remove the PASS listing: the official 2026/27 application window ran from 13 April to 28 June 2026 and is closed.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='54098725-d895-4849-900f-cb0093f303a2' or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='54098725-d895-4849-900f-cb0093f303a2');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunity_cycle_routes where opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunity_compensation where opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunity_locations where opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunity_routes where opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunity_scope_assignments where opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunity_identity_stage where career_opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunity_cycles where opportunity_id='54098725-d895-4849-900f-cb0093f303a2';
delete from public.career_opportunities where id='54098725-d895-4849-900f-cb0093f303a2';

-- Permanently remove the speculative essay-competition future placeholder; the latest official round ended in 2024.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012' or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunity_cycle_routes where opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunity_compensation where opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunity_locations where opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunity_routes where opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunity_scope_assignments where opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunity_identity_stage where career_opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunity_cycles where opportunity_id='08b3e4bc-5c06-45ae-a285-6def3a22d012';
delete from public.career_opportunities where id='08b3e4bc-5c06-45ae-a285-6def3a22d012';

commit;
