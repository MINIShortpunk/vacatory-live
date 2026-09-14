-- HSFK Roger Leyland Memorial Scholarship Programme correction.
-- Official source checked: 14 September 2026.
-- Source: https://careers.hsfkramer.com/global/en/uk/early-careers/first-year
-- Correction: official HSFK page says the scholarship provides £6,000 over three years,
-- not £9,000.

begin;

update public.firm_scholarships scholarship
set programme_name = 'Roger Leyland Memorial Scholarship Programme',
    programme_type = 'scholarship',
    amount = '£6,000 over three years',
    total_value = '£6,000 over three years of study, plus mentoring, personal study sessions, a guaranteed vacation scheme place in the second year of study, and access to exclusive networking events.',
    duration = 'Three years of study',
    eligibility = 'Black and minority ethnic first-year university students, or second-year students on a four-year course. Applicants must be Rare Recruitment candidates.',
    year_of_study_requirements = 'First-year university students, or second-year students on a four-year course.',
    application_open = date '2026-10-01',
    application_deadline = date '2027-01-28',
    application_process = 'Online application form with academic achievements, relevant work experience and three written questions, followed by an online test and assessment day.',
    funded_items = '£6,000 over three years of study.',
    mentoring_and_support = 'Mentor at the firm, personal study sessions with Rare’s Melissa Andrewes, guaranteed vacation scheme place in the second year of study, and exclusive networking events.',
    partner_organisations = 'Rare Recruitment',
    status = 'upcoming',
    application_link = 'https://careers.hsfkramer.com/global/en/uk/early-careers/first-year',
    source_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/first-year',
    research_checked_on = date '2026-09-14',
    updated_at = now()
from public.firms firm
where scholarship.firm_id = firm.id
  and firm.slug = 'herbert-smith-freehills'
  and scholarship.programme_name = 'Roger Leyland Memorial Scholarship Programme';

commit;

-- Verification.
select scholarship.programme_name,
       scholarship.amount,
       scholarship.application_open,
       scholarship.application_deadline,
       scholarship.status,
       scholarship.source_url
from public.firm_scholarships scholarship
join public.firms firm on firm.id = scholarship.firm_id
where firm.slug = 'herbert-smith-freehills'
  and scholarship.programme_name = 'Roger Leyland Memorial Scholarship Programme';
