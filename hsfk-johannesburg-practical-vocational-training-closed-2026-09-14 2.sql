-- HSFK Johannesburg Practical Vocational Training / Candidate Attorney Programme refresh.
-- Official source checked: 14 September 2026.
-- Source: https://careers.hsfkramer.com/global/en/johannesburg/early-careers/practical-vocational-training
-- The official page says applications for Candidate Attorneys commencing articles in January 2028
-- closed on 31 May 2026. No future application deadline is published, so no active deadline is stored.

begin;

update public.firm_programmes programme
set programme_name = 'South Africa - Practical Vocational Training / Candidate Attorney Programme',
    exact_official_name = 'Practical Vocational Training',
    status = 'current',
    current_status = 'closed',
    active = true,
    published = true,
    description = 'Practical Vocational Training / Candidate Attorney route in Johannesburg. HSFK says Candidate Legal Practitioners are recruited mainly from vacation schemes, with exceptional direct offers possible. Trainees rotate through practice areas including Dispute Resolution, Corporate, Competition, Regulation & Trade, and Projects, Energy & Infrastructure.',
    location_text = 'Johannesburg',
    country_text = 'South Africa',
    duration_text = 'Articles / Practical Vocational Training route',
    application_date_summary = 'Applications for Candidate Attorneys commencing articles in January 2028 closed on 31 May 2026. Next application dates have not yet been published.',
    programme_date_summary = 'Candidate Attorneys commence articles in January 2028 for the last published intake; next later intake dates have not yet been published.',
    date_status_note = 'Official page checked 14 September 2026. The published January 2028 application window closed on 31 May 2026, so no active deadline is stored.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/johannesburg/early-careers/practical-vocational-training',
    application_url = 'https://careers.hsfkramer.com/global/en/johannesburg/early-careers/practical-vocational-training',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-11-01',
    updated_at = now()
from public.firms firm
where programme.firm_id = firm.id
  and firm.slug = 'herbert-smith-freehills'
  and programme.slug = 'johannesburg-candidate-attorney-programme';

update public.career_opportunities opportunity
set official_name = 'Practical Vocational Training / Candidate Attorney Programme',
    public_name = 'Practical Vocational Training / Candidate Attorney Programme',
    official_url = 'https://careers.hsfkramer.com/global/en/johannesburg/early-careers/practical-vocational-training',
    application_url = 'https://careers.hsfkramer.com/global/en/johannesburg/early-careers/practical-vocational-training',
    active = true,
    published = true,
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-11-01',
    updated_at = now()
from public.legal_organisations organisation
where opportunity.organisation_id = organisation.id
  and organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'johannesburg-candidate-attorney-programme';

with opportunity as (
  select opportunity.id as opportunity_id
  from public.career_opportunities opportunity
  join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
  where organisation.slug = 'herbert-smith-freehills-kramer'
    and opportunity.slug = 'johannesburg-candidate-attorney-programme'
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
  duration_text,
  audience_text,
  study_stage_text,
  eligibility_text,
  application_process_text,
  programme_structure_text,
  official_url,
  application_url,
  updated_at
)
select
  opportunity_id,
  '2028-intake-closed-next-dates-unpublished',
  'January 2028 intake closed — next dates unpublished',
  'unknown',
  null,
  null,
  'closed',
  false,
  date '2026-09-14',
  'Applications for Candidate Attorneys commencing articles in January 2028 closed on 31 May 2026. Next application dates have not yet been published.',
  'Candidate Attorneys commence articles in January 2028 for the last published intake; next later intake dates have not yet been published.',
  'not_announced',
  'Articles / Practical Vocational Training route',
  'Students and graduates seeking a Candidate Attorney / Practical Vocational Training route in Johannesburg.',
  'Candidate Legal Practitioner / Candidate Attorney applicants.',
  'HSFK says it mainly recruits Candidate Legal Practitioners from its vacation schemes, with exceptional direct offers possible.',
  'Applications are processed through the online application portal when open. Shortlisted candidates may attend competency-based interviews, partner panel meetings and a written assessment.',
  'Rotations may include Dispute Resolution, Corporate, Competition, Regulation & Trade, and Projects, Energy & Infrastructure.',
  'https://careers.hsfkramer.com/global/en/johannesburg/early-careers/practical-vocational-training',
  'https://careers.hsfkramer.com/global/en/johannesburg/early-careers/practical-vocational-training',
  now()
from opportunity
where not exists (
  select 1
  from public.career_opportunity_cycles cycle
  where cycle.opportunity_id = opportunity.opportunity_id
    and cycle.cycle_key = '2028-intake-closed-next-dates-unpublished'
);

commit;

-- Verification.
select opportunity.slug,
       cycle.cycle_key,
       cycle.source_status,
       cycle.active,
       cycle.closes_on,
       cycle.application_dates_text
from public.career_opportunities opportunity
join public.legal_organisations organisation on organisation.id = opportunity.organisation_id
left join public.career_opportunity_cycles cycle on cycle.opportunity_id = opportunity.id
where organisation.slug = 'herbert-smith-freehills-kramer'
  and opportunity.slug = 'johannesburg-candidate-attorney-programme';
