-- HSFK UK Vacation Schemes refresh.
-- Official source checked: 14 September 2026.
-- Source: https://careers.hsfkramer.com/global/en/uk/early-careers/vacation-schemes
-- The official page says applications reopen in September 2026 but does not publish
-- exact opening or closing dates. It does publish the 2027 scheme dates.

begin;

with updates(slug, app_summary, programme_summary, description) as (
  values
  (
    'spring-vacation-scheme',
    'Applications reopen in September 2026. Exact opening and closing dates have not yet been published.',
    'Spring Vacation Scheme dates: 12–23 April 2027.',
    'Two-to-three-week London vacation scheme for penultimate-year students, final-year students and graduates. Participants work on real client matters, choose two practice areas, share an office with a supervisor, receive trainee-buddy support, and are considered for the Trainee Associate Programme.'
  ),
  (
    'summer-vacation-schemes',
    'Applications reopen in September 2026. Exact opening and closing dates have not yet been published.',
    'Summer Vacation Scheme dates: 7–25 June 2027 and 5–23 July 2027.',
    'London summer vacation schemes for penultimate-year students, final-year students and graduates. Participants work on real client matters, choose two practice areas, receive supervisor and trainee-buddy support, and are considered for the Trainee Associate Programme.'
  )
)
update public.firm_programmes programme
set current_status = 'upcoming',
    status = 'current',
    active = true,
    published = true,
    description = updates.description,
    application_date_summary = updates.app_summary,
    programme_date_summary = updates.programme_summary,
    date_precision = 'exact_scheme_dates_application_month',
    date_status_note = 'Official HSFK page checked 14 September 2026. Page says applications reopen in September 2026 but does not publish exact opening or closing dates. Scheme dates are published.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/vacation-schemes',
    application_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/vacation-schemes',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-09-30',
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
  and programme.slug in ('spring-vacation-scheme', 'summer-vacation-schemes')
order by programme.slug;
