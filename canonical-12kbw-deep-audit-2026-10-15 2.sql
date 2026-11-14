begin;

update public.chambers
set pupillage_overview = '12 King''s Bench Walk offers up to three twelve-month pupillages beginning in October 2028. Applications are accepted through the Pupillage Gateway from 4 to 28 January 2027, with offers made on 7 May 2027. The published award is £85,000, comprising a £45,000 first-six grant and £40,000 guaranteed earnings during second six.',
    mini_pupillage_overview = '12 King''s Bench Walk offers 12 unassessed general mini-pupillages each year across three sessions, with four candidates completing two days in each session. The official timetable publishes application windows through the December 2027 session. Reasonable travel and accommodation expenses are reimbursed up to £250. A separate three-day Frank Burton KC Social Mobility Mini-Pupillage offers up to three places, a £250 award and up to £250 travel and expenses support.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-30',
    updated_at = now()
where organisation_id = '8e22970d-549a-413b-b3ba-961efe89ac1b';

update public.legal_organisations
set research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-30',
    updated_at = now()
where id = '8e22970d-549a-413b-b3ba-961efe89ac1b';

update public.career_opportunities
set official_name = '12 King''s Bench Walk Pupillage — October 2028',
    public_name = '12 King''s Bench Walk Pupillage — October 2028',
    english_name = '12 King''s Bench Walk Pupillage — October 2028',
    public_summary = 'Up to three twelve-month pupillages beginning in October 2028, with an £85,000 award and applications through the Pupillage Gateway.',
    official_url = 'https://12kbw.co.uk/pupillage/pupillage/selection-process/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-29',
    updated_at = now()
where id = 'f9a8348c-8fff-4059-a07b-dd473b7c736a';

update public.career_opportunity_cycles
set cycle_key = '12kbw-pupillage:october-2028',
    cycle_label = '12 King''s Bench Walk Pupillage — October 2028',
    application_year = 2027,
    programme_year = 2028,
    intake_year = 2028,
    programme_starts_on = date '2028-10-01',
    programme_dates_text = 'Twelve-month pupillage beginning in October 2028.',
    date_precision = 'month',
    duration_text = 'Twelve months',
    places_text = 'Up to three pupillages',
    source_status = 'official_dates_published',
    application_process_text = 'Apply through the Pupillage Gateway. Shortlisted candidates normally complete two interview rounds.',
    funding_text = '£85,000: a £45,000 grant during first six, including up to £12,500 available for drawdown during Bar training, and £40,000 guaranteed earnings during second six.',
    official_url = 'https://12kbw.co.uk/pupillage/pupillage/selection-process/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'ae7e19df-e4dd-4225-ba07-964affc161bf';

update public.career_opportunities
set public_summary = 'Twelve two-day, unassessed mini-pupillages across the published April, July and December 2027 sessions, with up to £250 towards reasonable travel and accommodation expenses.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-09-04',
    updated_at = now()
where id = '468e1d08-49e5-4c42-9671-cd389bc755e2';

update public.career_opportunity_cycles
set funding_text = 'Unpaid. Reasonable travel and accommodation expenses are reimbursed up to £250 per session.',
    right_to_work_text = null,
    assessments_text = 'Selection is based on the written online application. The mini-pupillage itself is unassessed.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where opportunity_id = '468e1d08-49e5-4c42-9671-cd389bc755e2';

update public.career_opportunity_cycles
set programme_dates_text = 'Placement: two days during the week beginning 5 July 2027. Successful applicants will be notified by 28 May 2027.',
    updated_at = now()
where id = 'a670df95-0c7c-4f36-bad1-14baf459622e';

update public.career_opportunity_cycles
set programme_dates_text = 'Placement: two days during the week beginning 6 December 2027. Successful applicants will be notified by 15 October 2027.',
    updated_at = now()
where id = 'bd270c1e-4135-488e-967e-2939739f6b94';

update public.career_opportunity_cycles
set programme_dates_text = 'Two-day mini-pupillage during the week beginning 12 April 2027. Successful applicants will be notified by 12 February 2027.',
    updated_at = now()
where id = '644f1ea6-4272-4c88-9977-c230c975be20';

delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_identity_stage
where career_opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_location_candidate_stage
where career_opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_location_migration_stage
where career_opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_compensation
where opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_cycle_routes
where opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_locations
where opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_routes
where opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_scope_assignments
where opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunity_cycles
where opportunity_id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

delete from public.career_opportunities
where id in (
  '9e4acbd4-ab65-4890-aa89-5e2f5ca9e27e',
  'd4b3b776-3274-4810-8772-b22791de90ef',
  '3fd43356-49fc-4c0f-9f45-05b481e9a009'
);

update public.career_opportunities
set official_name = 'Frank Burton KC Social Mobility Mini-Pupillage',
    public_name = 'Frank Burton KC Social Mobility Mini-Pupillage',
    english_name = 'Frank Burton KC Social Mobility Mini-Pupillage',
    public_summary = 'A funded three-day mini-pupillage for university students from eligible social-mobility backgrounds, offering up to three places, a £250 award and travel support.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-30',
    updated_at = now()
where id = '3d57e3b0-9e99-4eda-b8e9-aa3dd01f113e';

update public.career_opportunity_cycles
set cycle_key = 'frank-burton-social-mobility-mini-pupillage:2026',
    cycle_label = 'Frank Burton KC Social Mobility Mini-Pupillage',
    application_model = 'unknown',
    programme_dates_text = 'Three-day mini-pupillage in chambers, with placement dates arranged through the official programme.',
    application_dates_text = 'Applications will reopen through the official 12KBW programme page later in 2026.',
    date_precision = 'text_only',
    duration_text = 'Three days',
    places_text = 'Up to three places',
    source_status = 'upcoming',
    academic_criteria = null,
    assessments_text = null,
    progression_route_text = null,
    funding_text = '£250 award plus a travel and expenses allowance of up to £250.',
    right_to_work_text = null,
    source_status_note = null,
    additional_details_text = 'The programme is named after Frank Burton KC and offers up to three funded places.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'a2939447-3a16-44d0-9968-3b3c5817c2f8';

insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, slug, official_name, public_name,
  english_name, public_summary, delivery_mode, official_url, application_url,
  active, published, display_order, research_checked_on, next_review_on,
  created_at, updated_at, canonical_public_suppressed
) values (
  'ee9426b8-db6d-498a-8d40-d6b0d9936803',
  '8e22970d-549a-413b-b3ba-961efe89ac1b',
  '19b7a063-52d2-49aa-a1db-83a6a7ca6f91',
  '12kbw-tort-law-awards-2026',
  '12KBW Tort Law Awards 2026',
  '12KBW Tort Law Awards 2026',
  '12KBW Tort Law Awards 2026',
  'A 1,000-word tort-law essay competition for students at UK higher-education institutions, with cash prizes and mini-pupillages for the three winners.',
  'online',
  'https://12kbw.co.uk/tort-law-awards-2026/',
  'https://12kbw.co.uk/tort-law-awards-2026/',
  true, true, 450, date '2026-10-15', date '2026-11-13', now(), now(), false
);

insert into public.career_opportunity_cycles (
  id, opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, closes_on, closes_at, closes_timezone,
  programme_dates_text, application_dates_text, date_precision, duration_text,
  places_text, source_status, audience_text, eligibility_text,
  application_process_text, funding_text, official_url, application_url,
  active, research_checked_on, created_at, updated_at
) values (
  'ded156b4-7cb3-4d25-ab25-7d3fc6fb5ef2',
  'ee9426b8-db6d-498a-8d40-d6b0d9936803',
  '12kbw-tort-law-awards:2026',
  '12KBW Tort Law Awards 2026',
  2026, 2026, 2026, 'fixed_deadline', date '2026-11-12', time '17:00', 'Europe/London',
  'Winners will be announced in early 2027 and offered mini-pupillages at 12KBW.',
  'Entries close at 17:00 on 12 November 2026.',
  'exact', '1,000-word essay', 'Three prize winners', 'open',
  'Students in any discipline registered with a UK higher-education institution.',
  'Open to students in any discipline registered with a UK higher-education institution when the essay is received.',
  'Submit one anonymised essay in Microsoft Word format through the official online form.',
  'First prize £2,000; second prize £1,250; third prize £750. Each winner is also offered a mini-pupillage.',
  'https://12kbw.co.uk/tort-law-awards-2026/',
  'https://12kbw.co.uk/tort-law-awards-2026/',
  true, date '2026-10-15', now(), now()
);

insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, event_type_id, slug, official_name,
  public_name, english_name, public_summary, delivery_mode, official_url,
  application_url, active, published, display_order, research_checked_on,
  next_review_on, created_at, updated_at, canonical_public_suppressed
) values (
  '8ba9b33d-88f3-49b1-9e19-9e7c65b707db',
  '8e22970d-549a-413b-b3ba-961efe89ac1b',
  '5e2816dd-108f-4443-9fb2-218def79147f',
  'ab9949e8-a74c-43c3-a385-ded9be4fe8b5',
  '12kbw-pupillage-open-evening-2027',
  '12KBW Pupillage Open Evening 2027',
  '12KBW Pupillage Open Evening 2027',
  '12KBW Pupillage Open Evening 2027',
  'An in-person evening for prospective applicants to learn about 12KBW''s pupillage process, meet members and hear about chambers'' practice areas.',
  'in_person',
  'https://12kbw.co.uk/events/12kbw-pupillage-open-evening-2027/',
  'https://docs.google.com/forms/d/e/1FAIpQLSc8xwt61yI4-wbzrC7DBitkvil0zre4gU-YmgSCjVbNp16euw/viewform?usp=publish-editor',
  true, true, 500, date '2026-10-15', date '2027-01-15', now(), now(), false
);

insert into public.career_opportunity_cycles (
  id, opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, programme_starts_on, programme_ends_on,
  programme_dates_text, application_dates_text, date_precision, duration_text,
  source_status, audience_text, eligibility_text, application_process_text,
  programme_structure_text, official_url, application_url, active,
  research_checked_on, created_at, updated_at
) values (
  '1fa541f8-817e-452a-b97c-ac39d58bdab2',
  '8ba9b33d-88f3-49b1-9e19-9e7c65b707db',
  '12kbw-pupillage-open-evening:2027',
  '12KBW Pupillage Open Evening — 14 January 2027',
  2026, 2027, 2027, 'rolling',
  date '2027-01-14', date '2027-01-14',
  '14 January 2027 from 16:45 at 12 King''s Bench Walk, Temple, London.',
  'Register through the official event form.',
  'exact', 'Evening event', 'upcoming',
  'Prospective pupillage applicants.',
  'For prospective applicants interested in pupillage at 12KBW.',
  'Register using the form linked from the official event page.',
  'An introduction to the pupillage application process, opportunities to meet members of chambers, and presentations about 12KBW''s practice areas.',
  'https://12kbw.co.uk/events/12kbw-pupillage-open-evening-2027/',
  'https://docs.google.com/forms/d/e/1FAIpQLSc8xwt61yI4-wbzrC7DBitkvil0zre4gU-YmgSCjVbNp16euw/viewform?usp=publish-editor',
  true, date '2026-10-15', now(), now()
);

commit;
