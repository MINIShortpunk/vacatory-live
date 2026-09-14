-- HSFK Singapore Vacation Scheme 2027 refresh
-- Official source checked 14 September 2026:
-- https://careers.hsfkramer.com/global/en/singapore/early-careers/vacation-schemes

update firm_programmes
set current_status = 'open',
    status = 'current',
    application_opens_on = null,
    application_closes_on = date '2027-01-01',
    application_date_summary = 'Applications for the 2027 Singapore Vacation Scheme are open until 1 January 2027.',
    programme_date_summary = 'Month-long paid vacation scheme in Singapore; participants are considered for a training contract. The official page states applicants should be eligible to start as Practice Trainees in March 2030.',
    programme_starts_on = null,
    programme_ends_on = null,
    eligible_study_stage = 'Students eligible to start as Practice Trainees in March 2030.',
    audience_text = 'Students eligible to start as Practice Trainees in March 2030; applicants must be able to live and work legally in Singapore.',
    date_precision = 'exact',
    date_status_note = 'Official HSFK Singapore Vacation Scheme page checked 14 September 2026; applications are open until 1 January 2027. No exact 2027 scheme dates are published on the page.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/vacation-schemes',
    application_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/vacation-schemes',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-01',
    active = true,
    published = true,
    updated_at = now()
where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'
  and slug = 'singapore-vacation-scheme';

update career_opportunities
set official_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/vacation-schemes',
    application_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/vacation-schemes',
    active = true,
    published = true,
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-01',
    updated_at = now()
where organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'
  and slug = 'singapore-vacation-scheme';

update career_opportunity_cycles coc
set application_model = 'fixed_deadline',
    opens_on = null,
    closes_on = date '2027-01-01',
    date_precision = 'exact',
    application_year = 2026,
    programme_year = 2027,
    intake_year = 2030,
    application_dates_text = 'Applications for the 2027 Singapore Vacation Scheme are open until 1 January 2027.',
    programme_starts_on = null,
    programme_ends_on = null,
    programme_dates_text = 'Month-long paid vacation scheme in Singapore. The official page says applicants should be eligible to start as Practice Trainees in March 2030; exact 2027 scheme dates are not published on the page.',
    eligibility_text = 'Students eligible to start as Practice Trainees in March 2030; applicants must be able to live and work legally in Singapore.',
    official_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/vacation-schemes',
    application_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/vacation-schemes',
    source_status = 'verified',
    source_status_note = 'Verified on the official HSFK Singapore Vacation Scheme page on 14 September 2026. The page publishes the 1 January 2027 application close date, but not exact 2027 scheme dates.',
    research_checked_on = date '2026-09-14',
    active = true,
    updated_at = now()
from career_opportunities co
where co.id = coc.opportunity_id
  and co.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'
  and co.slug = 'singapore-vacation-scheme'
  and coc.cycle_key = 'official-2026-09-08:2027';

-- Remove stale duplicate old-cycle row saying the 2026 scheme was closed / next dates unpublished.
update career_opportunity_cycles
set active = false,
    source_status = 'stale_deleted_in_source',
    source_status_note = 'Stale duplicate 2026 closed cycle. Supabase connector rejected physical DELETE in-session on 14 September 2026; matching source/live SQL file includes DELETE for cleanup.',
    updated_at = now()
where id = 'f06f96ec-ded7-4c01-8160-ac60d69b6bf7';

delete from career_opportunity_cycles
where id = 'f06f96ec-ded7-4c01-8160-ac60d69b6bf7';
