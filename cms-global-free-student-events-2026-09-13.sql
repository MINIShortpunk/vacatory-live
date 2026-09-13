-- CMS global free/student-suitable events refresh
-- Checked 13 September 2026.
--
-- Scope:
-- - Added CMS events that are suitable for law students/new graduates and
--   where the official CMS page shows public registration/event information
--   and does not state a fee.
-- - Excluded professional association/conference listings from the CMS global
--   events page, including IBA, ACC, AIPPI, PTMG and ITechLaw, because the
--   CMS listing does not present them as free student/new-graduate careers
--   events.
-- - For webinar series where the first session has already passed, the next
--   future session is used as the event start date while retaining the official
--   series context in programme_dates_text.
--
-- Official sources:
-- - CMS global events: https://cms.law/en/int/events
-- - CMS Disputes 101 Annual Webinar Series 2026:
--   https://cms.law/en/gbr/events/cms-disputes-101-annual-webinar-series-2026
-- - IP Insights Webinar Series 2026 - Autumn:
--   https://cms.law/en/prt/events/ip-insights-webinar-series-2026-autumn
-- - On the Pulse Webinar Series 2026 - Autumn:
--   https://cms.law/en/int/events/on-the-pulse-webinar-series-2026-autumn
-- - Competition Law in Focus:
--   https://cms.law/en/hun/events/competition-law-in-focus-latest-trends-and-updates3
-- - HSG Career Days:
--   https://cms.law/en/che/events/hsg-career-days
-- - Long Nights of Careers - UZH Zentrum:
--   https://cms.law/en/che/events/long-nights-of-careers-uzh-zentrum
-- - jussuccess 2026:
--   https://cms.law/en/aut/events/jussuccess-2026
-- - REWI-Praxistag:
--   https://cms.law/de/aut/events/rewi-praxistag2
-- - Career Calling 2026:
--   https://cms.law/en/aut/events/career-calling-2026

with event_rows as (
  select * from (values
    (
      'cms-disputes-101-annual-webinar-series-2026',
      'CMS Disputes 101 Annual Webinar Series 2026',
      'CMS Disputes 101 Annual Webinar Series 2026',
      'Free public-registration webinar series covering the basics of dispute resolution, including litigation, arbitration, mediation, corporate crime, procurement disputes and reputation management. Useful for students and new graduates exploring contentious work.',
      'online',
      'https://cms.law/en/gbr/events/cms-disputes-101-annual-webinar-series-2026',
      'https://cms.law/en/gbr/events/cms-disputes-101-annual-webinar-series-2026',
      'en',
      '0300485e-aa81-437d-9318-57fbcba0eda5'::uuid,
      '2026-autumn-future-sessions',
      'Autumn 2026 future sessions',
      2026,
      2026,
      '2026-09-15'::date,
      '2026-12-01'::date,
      'Future sessions: 15 September, 22 September, 29 September, 6 October, 3 November, 10 November, 17 November, 24 November and 1 December 2026, 14:00-15:00 UK time. The official series began on 8 September 2026; that past session is not treated as a future event.',
      'Students and new graduates interested in dispute resolution basics; CMS states the series is also suitable for non-lawyers at all levels of experience.',
      'Registration is available via the official CMS event page. CMS does not state a fee on the official event page.',
      'Online / United Kingdom-hosted webinar series',
      47::bigint,
      null::bigint,
      'official_current'
    ),
    (
      'ip-insights-webinar-series-2026-autumn',
      'IP Insights Webinar Series 2026 - Autumn',
      'IP Insights Webinar Series 2026 - Autumn',
      'Public-registration CMS intellectual property webinar series with future sessions on social media IP risks and copyright basics. Useful for students and new graduates interested in IP, technology, media or brand protection work.',
      'online',
      'https://cms.law/en/prt/events/ip-insights-webinar-series-2026-autumn',
      'https://cms.law/en/prt/events/ip-insights-webinar-series-2026-autumn',
      'en',
      '0300485e-aa81-437d-9318-57fbcba0eda5'::uuid,
      '2026-autumn-future-sessions',
      'Autumn 2026 future sessions',
      2026,
      2026,
      '2026-10-20'::date,
      '2026-11-04'::date,
      'Future sessions: 20 October 2026, 14:00-15:00 CEST, Social Media: IP risks and enforcement strategies across the UK, EU, France and China; 4 November 2026, 14:00-15:00 CET, Copyright: Basics of Copyright for In-House Lawyers. The 10 September 2026 session is past and is not treated as a future event.',
      'Students and new graduates interested in intellectual property, technology, media, consumer or brand-protection work.',
      'Registration is available via the official CMS event page. CMS does not state a fee on the official event page.',
      'Online / international webinar series',
      null::bigint,
      null::bigint,
      'official_current'
    ),
    (
      'on-the-pulse-webinar-series-2026-autumn',
      'On the Pulse Webinar Series 2026 - Autumn',
      'On the Pulse Webinar Series 2026 - Autumn',
      'Public-registration CMS life sciences and healthcare webinar series covering legal and commercial developments from around the world. Useful for students and new graduates interested in life sciences, healthcare and regulated sectors.',
      'online',
      'https://cms.law/en/int/events/on-the-pulse-webinar-series-2026-autumn',
      'https://cms.law/en/int/events/on-the-pulse-webinar-series-2026-autumn',
      'en',
      '0300485e-aa81-437d-9318-57fbcba0eda5'::uuid,
      '2026-autumn',
      'Autumn 2026',
      2026,
      2026,
      '2026-09-30'::date,
      '2026-11-19'::date,
      '30 September 2026, 09:00-10:00 BST, EU Pharma Package; 19 November 2026, 09:00-12:00 BST, Healthcare Update.',
      'Students and new graduates interested in life sciences, healthcare, regulation and commercial legal work.',
      'Registration is available via the official CMS event page. CMS does not state a fee on the official event page.',
      'Online / international webinar series',
      null::bigint,
      null::bigint,
      'official_current'
    ),
    (
      'competition-law-in-focus-2026',
      'Competition Law in Focus: Latest Trends and Updates',
      'Competition Law in Focus: Latest Trends and Updates',
      'CMS Hungary webinar series on competition-law enforcement trends, restrictive agreements, abuse of dominance, merger control, consumer protection and related regulatory updates. Conducted in Hungarian.',
      'hybrid',
      'https://cms.law/en/hun/events/competition-law-in-focus-latest-trends-and-updates3',
      'https://cms.law/en/hun/events/competition-law-in-focus-latest-trends-and-updates3',
      'en',
      '0300485e-aa81-437d-9318-57fbcba0eda5'::uuid,
      '2026-autumn',
      'Autumn 2026',
      2026,
      2026,
      '2026-10-09'::date,
      '2026-12-11'::date,
      '9 October to 11 December 2026, Budapest and online. Other webinars in the series are listed for 30 October, 13 November, 27 November, 4 December and 11 December 2026. CMS states all webinars in the series are conducted in Hungarian.',
      'Law students and new graduates interested in competition, antitrust, consumer protection and regulatory work, especially Hungarian-speaking students.',
      'Registration is available via the official CMS event page. CMS does not state a fee on the official event page.',
      'Budapest, Hungary + online',
      18::bigint,
      50::bigint,
      'official_current'
    ),
    (
      'hsg-career-days-2026',
      'HSG Career Days',
      'HSG Career Days',
      'Legal Career Days at the University of St. Gallen, offering interviews and networking with potential employers before career entry.',
      'in_person',
      'https://cms.law/en/che/events/hsg-career-days',
      'https://cms.law/en/che/events/hsg-career-days',
      'en',
      '0565330b-8f5f-45ff-9314-1f3b25ebf243'::uuid,
      '2026',
      '2026',
      2026,
      2026,
      '2026-10-13'::date,
      '2026-10-13'::date,
      '13 October 2026, 16:15-18:00 CEST, Universität St. Gallen, Dufourstrasse 50, 9000 St. Gallen.',
      'Law students and graduates attending or interested in Swiss legal careers.',
      'The official CMS page links to event information and registration and does not state a fee.',
      'St. Gallen, Switzerland',
      42::bigint,
      276::bigint,
      'official_current'
    ),
    (
      'long-nights-of-careers-uzh-zentrum-2026',
      'Long Nights of Careers - UZH Zentrum',
      'Long Nights of Careers - UZH Zentrum',
      'University of Zurich law-student careers and networking fair with law firms, including opportunities to ask questions and make career contacts.',
      'in_person',
      'https://cms.law/en/che/events/long-nights-of-careers-uzh-zentrum',
      'https://cms.law/en/che/events/long-nights-of-careers-uzh-zentrum',
      'en',
      '0565330b-8f5f-45ff-9314-1f3b25ebf243'::uuid,
      '2026',
      '2026',
      2026,
      2026,
      '2026-11-11'::date,
      '2026-11-11'::date,
      '11 November 2026, 18:00-20:30 CEST, UZH Zentrum, Rämistrasse 71, 8006 Zürich.',
      'Law students and doctoral students interested in Swiss legal careers.',
      'The official CMS page links to event information and registration and does not state a fee.',
      'Zurich, Switzerland',
      42::bigint,
      105::bigint,
      'official_current'
    ),
    (
      'jussuccess-2026',
      'jussuccess 2026',
      'jussuccess 2026',
      'Austria law-student and graduate careers fair with HR managers, executives and trainees, plus information on internships and career opportunities.',
      'in_person',
      'https://cms.law/en/aut/events/jussuccess-2026',
      'https://cms.law/en/aut/events/jussuccess-2026',
      'en',
      '0565330b-8f5f-45ff-9314-1f3b25ebf243'::uuid,
      '2026',
      '2026',
      2026,
      2026,
      '2026-11-05'::date,
      '2026-11-05'::date,
      '5 November 2026, 09:30-16:30 CEST, Juridicum, Rechtswissenschaftliche Fakultät der Universität Wien.',
      'Law students and graduates in Austria.',
      'The official CMS page describes the fair for law students and graduates and mentions a free application photo shoot; event registration information is linked from CMS.',
      'Vienna, Austria',
      2::bigint,
      6::bigint,
      'official_current'
    ),
    (
      'rewi-praxistag-2026',
      'REWI-Praxistag',
      'REWI-Praxistag',
      'Austrian legal careers day with employers from different legal fields, career-entry tips, job and internship walls, CV checks and networking.',
      'in_person',
      'https://cms.law/de/aut/events/rewi-praxistag2',
      'https://cms.law/de/aut/events/rewi-praxistag2',
      'de',
      '0565330b-8f5f-45ff-9314-1f3b25ebf243'::uuid,
      '2026',
      '2026',
      2026,
      2026,
      '2026-10-08'::date,
      '2026-10-08'::date,
      '8 October 2026, 14:00-17:00 CEST. CMS links to REWI University of Graz for more information.',
      'Law students and new graduates interested in legal practice, internships and career-entry roles in Austria.',
      'The official CMS page links to event information and mentions free barista coffee, a free JUVE Karriere Österreich magazine and CV checks.',
      'Austria; CMS links to REWI University of Graz for more information',
      2::bigint,
      null::bigint,
      'official_current'
    ),
    (
      'career-calling-2026',
      'Career Calling 2026',
      'Career Calling 2026',
      'Austria careers event for students and graduates, with employers, application information, entry-level positions, internships and traineeships.',
      'in_person',
      'https://cms.law/en/aut/events/career-calling-2026',
      'https://cms.law/en/aut/events/career-calling-2026',
      'en',
      '0565330b-8f5f-45ff-9314-1f3b25ebf243'::uuid,
      '2026',
      '2026',
      2026,
      2026,
      '2026-10-14'::date,
      '2026-10-14'::date,
      '14 October 2026, 09:00-17:00 CEST, Messeplatz 1, 1020 Wien.',
      'Students and graduates interested in internships, traineeships and entry-level careers in Austria.',
      'The official CMS page describes the event as for students and graduates and does not state a fee.',
      'Vienna, Austria',
      2::bigint,
      6::bigint,
      'official_current'
    )
  ) as v(slug, official_name, english_name, public_summary, delivery_mode, official_url, application_url, language_code, event_type_id, cycle_key, cycle_label, application_year, programme_year, programme_starts_on, programme_ends_on, programme_dates_text, audience_text, application_dates_text, location_note, country_id, city_id, source_status)
), upsert_opps as (
  insert into career_opportunities (
    id,
    organisation_id,
    opportunity_type_id,
    slug,
    official_name,
    english_name,
    language_code,
    public_summary,
    delivery_mode,
    official_url,
    application_url,
    active,
    published,
    research_checked_on,
    event_type_id,
    updated_at
  )
  select
    gen_random_uuid(),
    'b821c821-cfbb-4cc1-80b9-71754ea10d2f'::uuid,
    '5e2816dd-108f-4443-9fb2-218def79147f'::uuid,
    slug,
    official_name,
    english_name,
    language_code,
    public_summary,
    delivery_mode,
    official_url,
    application_url,
    true,
    true,
    date '2026-09-13',
    event_type_id,
    now()
  from event_rows
  on conflict (organisation_id, slug) do update set
    opportunity_type_id = excluded.opportunity_type_id,
    official_name = excluded.official_name,
    english_name = excluded.english_name,
    language_code = excluded.language_code,
    public_summary = excluded.public_summary,
    delivery_mode = excluded.delivery_mode,
    official_url = excluded.official_url,
    application_url = excluded.application_url,
    active = true,
    published = true,
    research_checked_on = excluded.research_checked_on,
    event_type_id = excluded.event_type_id,
    updated_at = now()
  returning id, slug
), target_opps as (
  select o.id, o.slug
  from career_opportunities o
  join event_rows e on e.slug = o.slug
  where o.organisation_id = 'b821c821-cfbb-4cc1-80b9-71754ea10d2f'::uuid
), upsert_cycles as (
  insert into career_opportunity_cycles (
    id,
    opportunity_id,
    cycle_key,
    cycle_label,
    application_year,
    programme_year,
    application_model,
    programme_starts_on,
    programme_ends_on,
    programme_dates_text,
    date_precision,
    source_status,
    audience_text,
    application_dates_text,
    official_url,
    application_url,
    active,
    research_checked_on,
    updated_at,
    additional_details_text
  )
  select
    gen_random_uuid(),
    o.id,
    e.cycle_key,
    e.cycle_label,
    e.application_year,
    e.programme_year,
    'unknown',
    e.programme_starts_on,
    e.programme_ends_on,
    e.programme_dates_text,
    'exact',
    e.source_status,
    e.audience_text,
    e.application_dates_text,
    e.official_url,
    e.application_url,
    true,
    date '2026-09-13',
    now(),
    'Added from official CMS event pages after filtering for student/new-graduate suitability and excluding professional-only conference listings from the global CMS events page.'
  from event_rows e
  join target_opps o on o.slug = e.slug
  on conflict (opportunity_id, cycle_key) do update set
    cycle_label = excluded.cycle_label,
    application_year = excluded.application_year,
    programme_year = excluded.programme_year,
    application_model = excluded.application_model,
    programme_starts_on = excluded.programme_starts_on,
    programme_ends_on = excluded.programme_ends_on,
    programme_dates_text = excluded.programme_dates_text,
    date_precision = excluded.date_precision,
    source_status = excluded.source_status,
    audience_text = excluded.audience_text,
    application_dates_text = excluded.application_dates_text,
    official_url = excluded.official_url,
    application_url = excluded.application_url,
    active = true,
    research_checked_on = excluded.research_checked_on,
    updated_at = now(),
    additional_details_text = excluded.additional_details_text
  returning id, opportunity_id, cycle_key
), delete_old_locations as (
  delete from career_opportunity_locations l
  using target_opps o
  where l.opportunity_id = o.id
  returning l.id
)
insert into career_opportunity_locations (
  opportunity_id,
  cycle_id,
  city_id,
  country_id,
  location_note,
  display_order,
  location_role,
  location_status
)
select
  o.id,
  c.id,
  e.city_id,
  e.country_id,
  e.location_note,
  10,
  'programme',
  'confirmed'
from event_rows e
join target_opps o on o.slug = e.slug
join career_opportunity_cycles c on c.opportunity_id = o.id and c.cycle_key = e.cycle_key
where e.country_id is not null;
