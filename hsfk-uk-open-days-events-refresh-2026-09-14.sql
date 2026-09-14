-- HSFK UK Open Days event refresh.
-- Official source checked: 14 September 2026.
-- Source: https://careers.hsfkramer.com/global/en/uk/early-careers/open-days
-- Public event/deadline cycles were already present; this refreshes the HSFK firm-side
-- summaries from vague "opens September / exact date not published" text to the exact
-- published event dates and application deadlines.

begin;

with updates(slug, programme_name, app_summary, programme_summary, status, description) as (
  values
  (
    'ip-cyber-technology-open-day',
    'United Kingdom - Intellectual Property, Cyber and Technology Open Day',
    'Applications are open; deadline 1 October 2026.',
    'Event takes place on 15 October 2026.',
    'open',
    'Open day for students studying science, technology, medicine, electronics, maths, computer science or cyber subjects, with insight into IP, cyber and technology work.'
  ),
  (
    'social-mobility-open-day',
    'United Kingdom - Social Mobility Open Day',
    'Applications are open; deadline 1 October 2026.',
    'Event takes place on 20 October 2026.',
    'open',
    'Open day for socially mobile students and graduates to learn about the firm, meet the Social Mobility Network and hear from Early Careers.'
  ),
  (
    'myplus-open-day',
    'United Kingdom - MyPlus Open Day',
    'Applications are open; deadline 12 October 2026.',
    'Event takes place on 27 October 2026.',
    'open',
    'Open day for high-performing students with a disability and/or long-term health condition, run with MyPlus Students’ Club.'
  ),
  (
    'black-talent-open-day',
    'United Kingdom - Black Talent Open Day',
    'Applications are open; deadline 12 October 2026.',
    'Event takes place on 29 October 2026.',
    'open',
    'Open day for aspiring lawyers to explore careers at the firm, develop commercial awareness, learn about applications and meet the Black Employee network.'
  ),
  (
    'lgbt-open-day',
    'United Kingdom - LGBT+ (IRIS) Open Day',
    'Applications are open; deadline 12 October 2026.',
    'Event takes place on 3 November 2026.',
    'open',
    'Open day for LGBT+ students considering a legal career, with insight from the IRIS network and interactive commercial awareness exercises.'
  ),
  (
    'disputes-open-day',
    'United Kingdom - Disputes Open Day',
    'Applications are open; deadline 12 October 2026.',
    'Event takes place on 23 November 2026.',
    'open',
    'Open day focused on HSFK’s global dispute resolution practice, with interactive workshops and colleague insights.'
  )
)
update public.firm_programmes programme
set programme_name = updates.programme_name,
    current_status = updates.status,
    status = 'current',
    active = true,
    published = true,
    description = updates.description,
    application_date_summary = updates.app_summary,
    programme_date_summary = updates.programme_summary,
    date_precision = 'exact',
    date_status_note = 'Official HSFK open days page checked 14 September 2026. Exact event date and application deadline are published.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/open-days',
    application_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/open-days',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-10-02',
    updated_at = now()
from public.firms firm, updates
where programme.firm_id = firm.id
  and firm.slug = 'herbert-smith-freehills'
  and programme.slug = updates.slug;

commit;

-- Verification.
select programme.slug,
       programme.application_date_summary,
       programme.programme_date_summary
from public.firm_programmes programme
join public.firms firm on firm.id = programme.firm_id
where firm.slug = 'herbert-smith-freehills'
  and programme.slug in (
    'ip-cyber-technology-open-day',
    'social-mobility-open-day',
    'myplus-open-day',
    'black-talent-open-day',
    'lgbt-open-day',
    'disputes-open-day'
  )
order by programme.slug;
