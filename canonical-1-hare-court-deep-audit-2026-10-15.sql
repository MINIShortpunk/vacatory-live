begin;

update public.chambers
set pupillage_overview = '1 Hare Court offers two specialist financial-remedies pupillages each year. Applications are made directly to chambers during the Pupillage Gateway timetable. The 2027 application window runs from 4 January at 11:00 to 28 January at 23:59. First-round interviews take place on 20 March 2027 and second-round interviews on 24 April 2027.',
    mini_pupillage_overview = 'Unassessed mini-pupillages are available to applicants at undergraduate level or above who are interested in family law and becoming family advocates. Applications are accepted from 1 to 31 January for placements between February and July, and from 1 to 31 July for placements between October and January. Travel expenses are available to applicants living outside London who need funding to attend.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where organisation_id = 'e69e8bab-0424-4da8-b413-3a1f718c1eab';

update public.legal_organisations
set research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where id = 'e69e8bab-0424-4da8-b413-3a1f718c1eab';

insert into public.career_opportunities (
  id, organisation_id, opportunity_type_id, event_type_id, slug,
  official_name, public_name, english_name, public_summary, delivery_mode,
  official_url, application_url, active, published, display_order,
  research_checked_on, next_review_on, created_at, updated_at,
  canonical_public_suppressed
) values (
  'b4e69830-04a1-43cd-96a6-5a139bbd9735',
  'e69e8bab-0424-4da8-b413-3a1f718c1eab',
  '5e2816dd-108f-4443-9fb2-218def79147f',
  '0300485e-aa81-437d-9318-57fbcba0eda5',
  '1-hare-court-life-at-the-junior-family-bar-webinar-2026',
  'Life at the Junior Family Bar Webinar',
  'Life at the Junior Family Bar Webinar',
  'Life at the Junior Family Bar Webinar',
  'An online session for aspiring barristers and students covering pupillage at 1 Hare Court, its application and selection process, life as a pupil and junior barrister, and application preparation.',
  'online',
  'https://www.1hc.com/latest-news/life-at-the-junior-family-bar-webinar/',
  'https://www.1hc.com/latest-news/life-at-the-junior-family-bar-webinar/',
  true, true, 500, date '2026-10-15', date '2026-10-28', now(), now(), false
);

insert into public.career_opportunity_cycles (
  id, opportunity_id, cycle_key, cycle_label, application_year,
  programme_year, intake_year, application_model, programme_starts_on,
  programme_ends_on, programme_dates_text, application_dates_text,
  date_precision, duration_text, source_status, audience_text,
  eligibility_text, application_process_text, programme_structure_text,
  official_url, application_url, active, research_checked_on,
  created_at, updated_at
) values (
  'efe47016-cc46-433a-8a3e-98ddb75dc0bc',
  'b4e69830-04a1-43cd-96a6-5a139bbd9735',
  'life-at-the-junior-family-bar-webinar:2026',
  'Life at the Junior Family Bar Webinar — 27 October 2026',
  2026, 2026, 2026, 'no_application',
  date '2026-10-27',
  date '2026-10-27',
  '27 October 2026, 17:30–18:30, online.',
  'Access is provided through the online joining link on the official event page.',
  'exact', 'One hour', 'upcoming',
  'Aspiring barristers and students exploring a career at the Bar.',
  'Open to aspiring barristers and students interested in pupillage and the junior family Bar.',
  'Use the online joining link published on the official event page.',
  'Junior members discuss pupillage at 1 Hare Court, the application and selection process, life as a pupil and junior barrister, and preparing a strong pupillage application, followed by questions.',
  'https://www.1hc.com/latest-news/life-at-the-junior-family-bar-webinar/',
  'https://www.1hc.com/latest-news/life-at-the-junior-family-bar-webinar/',
  true, date '2026-10-15', now(), now()
);

commit;
