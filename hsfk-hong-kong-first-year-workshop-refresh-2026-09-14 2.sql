-- HSFK Hong Kong First Year Workshop refresh.
-- Official source checked: 14 September 2026.
-- Source: https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year
-- The official page says applications open in November and the workshop runs across
-- two days in January. It does not publish an exact closing date, so no closing date
-- is stored.

begin;

update public.firm_programmes programme
set programme_name = 'Hong Kong - First Year Workshop',
    exact_official_name = 'First Year Workshop',
    status = 'current',
    current_status = 'current',
    active = true,
    published = true,
    application_date_summary = 'Applications open in November; exact dates have not yet been published.',
    programme_date_summary = 'Two-day workshop in January; exact dates have not yet been published.',
    date_status_note = 'Official page checked 14 September 2026. The page gives the opening month and workshop month only; no exact closing date is published.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    application_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-11-01',
    updated_at = now()
from public.firms firm
where programme.firm_id = firm.id
  and firm.slug = 'herbert-smith-freehills'
  and programme.slug = 'hong-kong-first-year-workshop';

update public.firm_programme_cycles cycle
set cycle_label = 'Next published cycle',
    application_model = 'fixed_or_recurring_window',
    opens_on = null,
    closes_on = null,
    application_status = 'upcoming',
    application_status_note = 'Applications open in November; exact dates have not yet been published.',
    programme_dates_text = 'Two-day workshop in January; exact dates have not yet been published.',
    date_precision = 'opening_month_event_month',
    duration_text = 'Two days',
    audience_text = 'First-year undergraduate law students interested in an international legal career.',
    study_stage_text = 'First-year undergraduate law students.',
    source_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    application_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    research_checked_on = date '2026-09-14',
    updated_at = now()
from public.firm_programmes programme
join public.firms firm on firm.id = programme.firm_id
where cycle.programme_id = programme.id
  and firm.slug = 'herbert-smith-freehills'
  and programme.slug = 'hong-kong-first-year-workshop';

update public.career_opportunities opportunity
set official_name = 'Hong Kong First Year Workshop',
    public_name = 'First Year Workshop',
    public_name_override = null,
    official_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    application_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    active = true,
    published = true,
    canonical_public_suppressed = false,
    canonical_public_suppression_reason = null,
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-11-01',
    updated_at = now()
from public.legal_organisations organisation
where opportunity.organisation_id = organisation.id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-first-year-workshop';

update public.career_opportunity_cycles cycle
set cycle_label = 'Next published cycle',
    application_model = 'unknown',
    opens_on = null,
    closes_on = null,
    date_precision = 'month',
    source_status = 'upcoming',
    application_dates_text = 'Applications open in November; exact dates have not yet been published.',
    programme_dates_text = 'Two-day workshop in January; exact dates have not yet been published.',
    duration_text = 'Two days',
    audience_text = 'First-year undergraduate law students interested in an international legal career.',
    study_stage_text = 'First-year undergraduate law students.',
    eligibility_text = 'HSFK welcomes applications from first-year undergraduate law students who can demonstrate strong academic performance and interpersonal skills.',
    official_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    application_url = 'https://careers.hsfkramer.com/global/en/hong-kong/early-careers/first-year',
    active = true,
    research_checked_on = date '2026-09-14',
    updated_at = now()
from public.career_opportunities opportunity
join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
where cycle.opportunity_id = opportunity.id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-first-year-workshop';

commit;

-- Verification.
select opportunity.slug,
       opportunity.published,
       opportunity.canonical_public_suppressed,
       cycle.application_dates_text,
       cycle.programme_dates_text,
       cycle.closes_on
from public.career_opportunities opportunity
join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
left join public.career_opportunity_cycles cycle on cycle.opportunity_id = opportunity.id
where organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'hong-kong-first-year-workshop';
