begin;

update public.chambers
set pupillage_overview = '2 Hare Court offers up to two funded twelve-month pupillages beginning in September 2028. Applications are accepted through the Pupillage Gateway from 4 to 28 January 2027. Funding comprises a £30,000 award during first six and £30,000 guaranteed earnings during second six.',
    mini_pupillage_overview = '2 Hare Court ordinarily offers funded five-day mini-pupillages. Mini-pupils receive the cost of a one-week Zones 1–6 Travelcard and £10 per day subsistence. Applicants must be at least 18 when the placement begins, and the placement is not formally assessed. Applications are currently closed; the chambers will publish the next competition and application form on its official mini-pupillage page.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-20',
    updated_at = now()
where organisation_id = '1bf727f3-8bec-4a9c-91c3-c5627b4c8ce5';

update public.legal_organisations
set research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-20',
    updated_at = now()
where id = '1bf727f3-8bec-4a9c-91c3-c5627b4c8ce5';

update public.career_opportunities
set public_summary = 'Up to two funded twelve-month pupillages beginning in September 2028, with applications through the Pupillage Gateway.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-29',
    updated_at = now()
where id = '658d105a-8d9d-4c91-ac01-ecaa38c4e273';

update public.career_opportunity_cycles
set cycle_key = '2-hare-court-pupillage:september-2028',
    cycle_label = '2 Hare Court Pupillage — September 2028',
    application_year = 2027,
    programme_year = 2028,
    intake_year = 2028,
    opens_on = date '2027-01-04',
    closes_on = date '2027-01-28',
    closes_at = time '23:59',
    closes_timezone = 'Europe/London',
    programme_starts_on = date '2028-09-01',
    programme_dates_text = 'Twelve-month pupillage beginning in September 2028. Interviews take place between 29 January and 30 April 2027, and offers are made after 09:30 on 7 May 2027.',
    date_precision = 'month',
    duration_text = 'Twelve months, with a possible further six months before a renewed tenancy application',
    places_text = 'Up to two pupillages',
    source_status = 'official_dates_published',
    application_process_text = 'Apply through the Pupillage Gateway. The 2 Hare Court advertisement is available to view from 20 November 2026.',
    funding_text = '£30,000 award paid during first six and £30,000 guaranteed earnings during second six.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '22cc187e-c3e1-4bfb-803b-62012f886c60';

delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_identity_stage where career_opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_compensation where opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_cycle_routes where opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_locations where opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_routes where opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_scope_assignments where opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunity_cycles where opportunity_id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';
delete from public.career_opportunities where id = 'ee4e88ed-4895-45ea-990c-6eb6c3acc0a9';

insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, event_type_id, slug, official_name,
  public_name, english_name, public_summary, delivery_mode, official_url,
  application_url, active, published, display_order, research_checked_on,
  next_review_on, created_at, updated_at, canonical_public_suppressed
) values (
  '9182965f-6219-4c16-9bb7-dd7eb3344977',
  '1bf727f3-8bec-4a9c-91c3-c5627b4c8ce5',
  '5e2816dd-108f-4443-9fb2-218def79147f',
  '0565330b-8f5f-45ff-9314-1f3b25ebf243',
  '2-hare-court-bar-council-pupillage-fair-2026',
  'Bar Council Pupillage Fair 2026 — Meet 2 Hare Court',
  'Bar Council Pupillage Fair 2026 — Meet 2 Hare Court',
  'Bar Council Pupillage Fair 2026 — Meet 2 Hare Court',
  'Meet barristers from 2 Hare Court and ask about pupillage, careers at the Bar, funding and application preparation at the Bar Council Pupillage Fair.',
  'in_person',
  'https://www.2harecourt.com/2026/10/06/2-hare-court-looks-forward-to-exhibiting-at-the-bar-councils-pupillage-fair-2026/',
  'https://www.2harecourt.com/2026/10/06/2-hare-court-looks-forward-to-exhibiting-at-the-bar-councils-pupillage-fair-2026/',
  true, true, 500, date '2026-10-15', date '2026-10-18', now(), now(), false
);

insert into public.career_opportunity_cycles (
  id, opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, programme_starts_on, programme_ends_on,
  programme_dates_text, application_dates_text, date_precision, duration_text,
  source_status, audience_text, eligibility_text, application_process_text,
  programme_structure_text, official_url, application_url, active,
  research_checked_on, created_at, updated_at
) values (
  '9410eebf-a3c6-4f02-8c3d-eef10c66e4eb',
  '9182965f-6219-4c16-9bb7-dd7eb3344977',
  '2-hare-court-bar-council-pupillage-fair:2026',
  'Bar Council Pupillage Fair 2026 — Meet 2 Hare Court',
  2026, 2026, 2026, 'rolling', date '2026-10-17', date '2026-10-17',
  '17 October 2026, 10:00–15:00, at Convene, 133 Houndsditch, Liverpool Street, London EC3A 7DB.',
  'Book a free ticket through the Bar Council Pupillage Fair page linked from the official 2 Hare Court announcement.',
  'exact', 'Five hours', 'upcoming',
  'Aspiring barristers and prospective pupillage applicants.',
  'Open to people seeking information about accessing the Bar and applying for pupillage.',
  'Book a free ticket using the link on the official announcement.',
  'Meet representatives from 2 Hare Court and discuss pupillage prospects, careers at the Bar, CV preparation, funding and support.',
  'https://www.2harecourt.com/2026/10/06/2-hare-court-looks-forward-to-exhibiting-at-the-bar-councils-pupillage-fair-2026/',
  'https://www.2harecourt.com/2026/10/06/2-hare-court-looks-forward-to-exhibiting-at-the-bar-councils-pupillage-fair-2026/',
  true, date '2026-10-15', now(), now()
);

commit;
