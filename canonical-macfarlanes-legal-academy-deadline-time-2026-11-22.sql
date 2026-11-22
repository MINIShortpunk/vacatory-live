-- Macfarlanes Legal Academy 2027: application platform confirms 27 November 2026 at 23:59 UTC.
-- Official application: https://apply.candidats.io/5bd9c439-abdc-4b71-b49d-edee8a1afc16
update public.career_opportunity_cycles as cycle
set closes_at = time '23:59:00',
    closes_timezone = 'Europe/London',
    application_url = 'https://apply.candidats.io/5bd9c439-abdc-4b71-b49d-edee8a1afc16',
    research_checked_on = date '2026-11-22',
    updated_at = now()
from public.career_opportunities as opportunity
where cycle.opportunity_id = opportunity.id
  and opportunity.slug = 'macfarlanes-legal-academy-2027'
  and cycle.closes_on = date '2026-11-27'
  and cycle.active = true;
