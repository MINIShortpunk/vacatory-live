begin;

update public.legal_organisations
set overview = '4PB is a specialist family-law barristers’ chambers in London. Its student routes include annual funded pupillage, three-day mini-pupillages, participation in the 10,000 Black Interns programme, support for the Bridging the Bar Academy and appearances at student-facing pupillage fairs.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-10-22',
    updated_at = now()
where id = 'eb12d28f-15d2-411c-a472-fda0c88f79db';

update public.chambers
set pupillage_overview = '4PB normally offers two or three funded 12-month family-law pupillages each year. Its current page still displays the closed 2025 application window; Vacatory will add the next deadline when 4PB releases its next application timetable. The latest award shown by chambers is £50,000, comprising a £40,000 grant and guaranteed minimum second-six earnings of £10,000.',
    mini_pupillage_overview = '4PB offers around 20 three-day mini-pupillages each year in March, April, June, July, November and December. Applications are accepted by email in January for March or April, May for June or July, and September for November or December. Applicants must be aged 18 or over and interested in family or Court of Protection work; previous legal experience is not required. Chambers pays £30 per day towards expenses.',
    tenancy_overview = 'Vacatory excludes lateral recruitment, third-six and probationary-tenancy vacancies. Tenancy is recorded only as progression from the standard pupillage route.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-10-22',
    updated_at = now()
where organisation_id = 'eb12d28f-15d2-411c-a472-fda0c88f79db';

-- The January and May mini-pupillage records contain no exact application dates.
-- Keep the verified recurring scheme in the chambers overview, not as invented deadline cards.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_identity_stage where career_opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_compensation where opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_cycle_routes where opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_locations where opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_routes where opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_scope_assignments where opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunity_cycles where opportunity_id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');
delete from public.career_opportunities where id in ('e20d46d3-92ec-40be-958c-d0b24435aeb0','1229e22d-6b09-4db8-9c6e-12d31dd9b935');

update public.career_opportunities
set public_summary = 'Apply through the 10,000 Black Interns programme for paid Summer 2027 work experience with participating employers, including 4PB.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-02',
    updated_at = now()
where id = 'ca355afc-e424-4fb8-90f2-ee11b3052e53';

update public.career_opportunity_cycles
set application_year = 2026,
    programme_year = 2027,
    intake_year = 2027,
    application_dates_text = 'Applications for Summer 2027 close on 1 November 2026.',
    programme_dates_text = 'Paid internship placements take place in summer 2027.',
    date_precision = 'exact',
    source_status = 'official_dates_published',
    source_status_note = null,
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '8364e296-9e2b-40e5-9962-afa73bd7964d';

update public.career_opportunities
set public_summary = 'Apply for the 2027/28 Bridging the Bar Academy, through which 4PB supports candidates with advocacy development.',
    application_url = 'https://bridgingthebar.org/academy-applications/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-06',
    updated_at = now()
where id = 'e031e8bc-a421-4dd2-a0a3-286b7ee1f338';

update public.career_opportunity_cycles
set programme_dates_text = 'Participation through the 2027/28 Bridging the Bar Academy.',
    source_status_note = null,
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'b7612308-bffc-466c-9b46-e9042771bbd7';

insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, event_type_id, slug, official_name,
  public_name, english_name, public_summary, delivery_mode, official_url,
  application_url, active, published, display_order, research_checked_on,
  next_review_on, created_at, updated_at, canonical_public_suppressed
) values (
  'bdbeca27-1ff0-47cf-9068-8ce6ba844dc8',
  'eb12d28f-15d2-411c-a472-fda0c88f79db',
  '5e2816dd-108f-4443-9fb2-218def79147f',
  '0565330b-8f5f-45ff-9314-1f3b25ebf243',
  '4pb-bar-council-pupillage-fair-2026',
  'Bar Council Pupillage Fair 2026 — Meet 4PB',
  'Bar Council Pupillage Fair 2026 — Meet 4PB',
  'Bar Council Pupillage Fair 2026 — Meet 4PB',
  'Meet 4PB representatives and ask about its family-law pupillage and mini-pupillage routes at the Bar Council Pupillage Fair.',
  'in_person',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',
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
  '673035ba-9c51-4e12-890a-54e1e74d963a',
  'bdbeca27-1ff0-47cf-9068-8ce6ba844dc8',
  '4pb-bar-council-pupillage-fair:2026',
  'Bar Council Pupillage Fair 2026 — Meet 4PB',
  2026, 2026, 2026, 'rolling', date '2026-10-17', date '2026-10-17',
  '17 October 2026, 10:00–15:00, at Convene, 133 Houndsditch, Liverpool Street, London EC3A 7DB.',
  'Book a free ticket through the Bar Council Pupillage Fair page.',
  'exact', 'One-day fair', 'upcoming',
  'Students, graduates and prospective barristers.',
  'Open to people exploring a career at the Bar or preparing a pupillage application.',
  'Register through the official Bar Council Pupillage Fair page.',
  'Meet chambers and Bar organisations, attend seminars and obtain careers guidance.',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair/exhibitors.html',
  'https://www.barcouncil.org.uk/training-events/conferences-and-seminars/pupillage-fair.html',
  true, date '2026-10-15', now(), now()
);

commit;
