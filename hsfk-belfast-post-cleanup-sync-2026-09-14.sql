-- HSFK Belfast post-cleanup sync.
-- Purpose: keep only current route information for expired Belfast HSFK routes,
-- with no passed 2026 application dates retained in firm or public cycle rows.
-- Official pages checked: 14 September 2026.

begin;

-- Digital Legal Delivery Apprentice: current route, next dates unpublished.
update public.firm_programmes programme
set status = 'current',
    current_status = 'current',
    active = true,
    published = true,
    application_date_summary = 'Next application dates have not yet been published.',
    programme_date_summary = 'Four-year apprenticeship; successful applicants usually join in September. The next exact intake date has not yet been published.',
    date_status_note = 'Official page checked 14 September 2026. Past application dates were deleted rather than archived.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice',
    application_url = 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice',
    research_checked_on = date '2026-09-14',
    updated_at = now()
from public.firms firm
where programme.firm_id = firm.id
  and firm.slug = 'herbert-smith-freehills'
  and programme.slug = 'belfast-digital-legal-delivery-apprenticeship';

with programme as (
  select programme.id as programme_id
  from public.firm_programmes programme
  join public.firms firm on firm.id = programme.firm_id
  where firm.slug = 'herbert-smith-freehills'
    and programme.slug = 'belfast-digital-legal-delivery-apprenticeship'
)
insert into public.firm_programme_cycles (
  programme_id,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  programme_dates_text,
  application_status,
  application_status_note,
  duration_text,
  eligibility,
  application_process,
  programme_structure,
  funding,
  visa_sponsorship,
  active,
  research_checked_on,
  current_status,
  source_freshness,
  date_precision,
  source_url,
  application_url,
  full_application_stages,
  assessments,
  updated_at
)
select
  programme_id,
  'Current route — next dates unpublished',
  'windowed',
  null,
  null,
  'Four-year apprenticeship; successful applicants usually join in September. The next exact intake date has not yet been published.',
  'current',
  'Next application dates have not yet been published.',
  'Four years',
  jsonb_build_object('summary', 'For students interested in legal operations, technology and alternative legal services delivery. Official page gives GCSE and A-level/BTEC requirements and states applicants need right to work in the United Kingdom.'),
  jsonb_build_array('Online application route via HSFK early careers page when applications are open.'),
  jsonb_build_array('Apprentices combine work in the Belfast Digital Legal Delivery team with study towards a BSc in Digital Legal Technologies at Ulster University.'),
  jsonb_build_object('summary', 'HSFK funds tuition fees and pays salary while studying.'),
  jsonb_build_object('summary', 'The official page says applicants need right to work in the United Kingdom.'),
  true,
  date '2026-09-14',
  'current',
  'verified',
  'tbc',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice',
  'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice',
  '[]'::jsonb,
  '[]'::jsonb,
  now()
from programme
where not exists (
  select 1
  from public.firm_programme_cycles existing
  where existing.programme_id = programme.programme_id
    and existing.cycle_label = 'Current route — next dates unpublished'
);

-- Public canonical shells: keep URLs current and add date-free current-route cycles.
update public.career_opportunities opportunity
set official_url = case
      when opportunity.slug = 'belfast-digital-legal-delivery-vacation-scheme' then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes'
      when opportunity.slug = 'belfast-digital-legal-delivery-apprenticeship' then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice'
      else opportunity.official_url
    end,
    application_url = case
      when opportunity.slug = 'belfast-digital-legal-delivery-vacation-scheme' then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes'
      when opportunity.slug = 'belfast-digital-legal-delivery-apprenticeship' then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice'
      else opportunity.application_url
    end,
    active = true,
    published = true,
    research_checked_on = date '2026-09-14',
    updated_at = now()
from public.legal_organisations organisation
where organisation.id = opportunity.organisation_id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug in (
    'belfast-digital-legal-delivery-vacation-scheme',
    'belfast-digital-legal-delivery-apprenticeship'
  );

with targets as (
  select opportunity.id as opportunity_id,
         opportunity.slug
  from public.career_opportunities opportunity
  join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
  where organisation.slug = 'herbert-smith-freehills-kramer'
    and opportunity.slug in (
      'belfast-digital-legal-delivery-vacation-scheme',
      'belfast-digital-legal-delivery-apprenticeship'
    )
)
insert into public.career_opportunity_cycles (
  opportunity_id,
  cycle_key,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  source_status,
  active,
  research_checked_on,
  application_dates_text,
  programme_dates_text,
  date_precision,
  official_url,
  application_url,
  updated_at
)
select
  opportunity_id,
  'current-next-dates-unpublished',
  'Current route — next dates unpublished',
  'unknown',
  null,
  null,
  'current',
  true,
  date '2026-09-14',
  case
    when slug = 'belfast-digital-legal-delivery-vacation-scheme'
      then 'Applications for the last published cycle have closed. The next application dates have not yet been published.'
    else 'Next application dates have not yet been published.'
  end,
  case
    when slug = 'belfast-digital-legal-delivery-vacation-scheme'
      then 'The vacation scheme normally takes place over 4 weeks starting in June each year; next scheme dates have not yet been published.'
    else 'Four-year apprenticeship; successful applicants usually join in September. The next exact intake date has not yet been published.'
  end,
  'not_announced',
  case
    when slug = 'belfast-digital-legal-delivery-vacation-scheme'
      then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes'
    else 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice'
  end,
  case
    when slug = 'belfast-digital-legal-delivery-vacation-scheme'
      then 'https://careers.hsfkramer.com/global/en/belfast/early-careers/vacation-schemes'
    else 'https://careers.hsfkramer.com/global/en/belfast/early-careers/digital-legal-delivery-apprentice'
  end,
  now()
from targets
where not exists (
  select 1
  from public.career_opportunity_cycles cycle
  where cycle.opportunity_id = targets.opportunity_id
    and cycle.cycle_key = 'current-next-dates-unpublished'
);

update public.career_opportunity_cycles cycle
set cycle_key = 'current-route-status',
    cycle_label = 'Current route status',
    source_status = 'current',
    updated_at = now()
from public.career_opportunities opportunity
join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
where cycle.opportunity_id = opportunity.id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'belfast-trainee-solicitor-programme'
  and cycle.cycle_key = 'firm-cycle:439edfb1-4861-4f75-8fde-323cd9beabbf';

commit;

-- Verification: should return zero rows.
select 'firm_programme_cycles' as layer,
       programme.slug,
       cycle.cycle_label,
       cycle.opens_on,
       cycle.closes_on
from public.firm_programme_cycles cycle
join public.firm_programmes programme on programme.id = cycle.programme_id
join public.firms firm on firm.id = programme.firm_id
where firm.slug = 'herbert-smith-freehills'
  and programme.slug in (
    'belfast-digital-legal-delivery-vacation-scheme',
    'belfast-digital-legal-delivery-apprenticeship',
    'belfast-trainee-solicitor-programme'
  )
  and (
    cycle.closes_on < date '2026-09-14'
    or cycle.programme_ends_on < date '2026-09-14'
    or coalesce(cycle.application_status_note, '') ilike any (array['%16 Jan%', '%16 January 2026%', '%27 Feb%', '%27 February 2026%', '%2 February 2026%'])
    or coalesce(cycle.programme_dates_text, '') ilike any (array['%March 2026%', '%April 2026%', '%September 2026%'])
  )
union all
select 'career_opportunity_cycles' as layer,
       opportunity.slug,
       cycle.cycle_label,
       cycle.opens_on,
       cycle.closes_on
from public.career_opportunity_cycles cycle
join public.career_opportunities opportunity on opportunity.id = cycle.opportunity_id
join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
where organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug in (
    'belfast-digital-legal-delivery-vacation-scheme',
    'belfast-digital-legal-delivery-apprenticeship',
    'belfast-trainee-solicitor-programme'
  )
  and (
    cycle.closes_on < date '2026-09-14'
    or cycle.programme_ends_on < date '2026-09-14'
    or coalesce(cycle.application_dates_text, '') ilike any (array['%16 Jan%', '%16 January 2026%', '%27 Feb%', '%27 February 2026%', '%2 February 2026%'])
    or coalesce(cycle.programme_dates_text, '') ilike any (array['%March 2026%', '%April 2026%', '%September 2026%'])
  );
