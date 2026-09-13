-- CMS Connect England & Wales Work Experience — official-source refresh
-- Checked 13 September 2026.
--
-- Official source:
-- https://cmsemergingtalent.com/programmes/england-wales-ni/work-experience/
--
-- CMS says applications for 2026 are now closed. The next application dates are
-- not yet published. Past 2026 application/programme dates are not stored as the
-- current cycle.

delete from firm_programme_cycles
where programme_id = '1c185f90-b084-48f8-86e9-7869365f6269'
  and id <> 'b51347f2-ef09-4b97-b43f-c84ca5402a98'
  and (
    application_status = 'closed'
    or current_status = 'closed'
    or (closes_on is not null and closes_on < date '2026-09-13')
    or (programme_ends_on is not null and programme_ends_on < date '2026-09-13')
  );

update firm_programmes
set status = 'current',
    current_status = 'current',
    application_opens_on = null,
    application_closes_on = null,
    application_date_summary = 'Applications for 2026 are now closed. CMS has not yet published the next application dates.',
    programme_date_summary = 'The next CMS Connect England & Wales programme dates have not yet been published.',
    date_status_note = 'The official CMS page says applications for 2026 are now closed. Past 2026 application and programme dates are not stored as the current cycle.',
    description = 'CMS Connect England & Wales is a one-week paid school work-experience programme in London, Bristol and Sheffield, followed by sustained mentoring, workshops, events, application advice and support for future CMS Solicitor Apprenticeship or Insight Programme applications.',
    duration_text = '1 week plus sustained support',
    location_text = 'London; Bristol; Sheffield',
    audience_text = 'Year 12 students in England and Wales who meet the published PRIME/social-mobility criteria and live within commuting distance of their chosen office.',
    eligible_study_stage = 'Year 12 in England and Wales.',
    qualification_or_outcome = 'Work experience, mentoring and sustained application support.',
    route_to_next_stage = 'Online application form with two motivational questions.',
    primary_source_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/work-experience/',
    application_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/work-experience/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = '1c185f90-b084-48f8-86e9-7869365f6269';

update firm_programme_cycles
set cycle_label = 'CMS Connect England & Wales — next cycle dates unpublished',
    application_year = null,
    programme_year = null,
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    application_status = 'current',
    current_status = 'current',
    application_status_note = 'Applications for 2026 are now closed. CMS has not yet published the next application dates. Past 2026 dates are not stored as the current cycle.',
    duration_text = '1 week plus sustained support',
    programme_dates_text = 'Next programme dates have not yet been published.',
    eligibility = '{"audience":"Year 12 students in England and Wales who meet the published PRIME/social-mobility criteria and live within commuting distance of their chosen office.","access_criteria":"State-funded/non-fee-paying school or college and at least one published social-mobility criterion; care-experienced applicants do not need to meet any other criterion."}'::jsonb,
    application_process = '["Online application form","Two motivational questions of up to 200 words each"]'::jsonb,
    programme_structure = '["One-week in-person work experience in London, Bristol or Sheffield","Business learning","Work shadowing","Skills development workshops and insight sessions","Ongoing mentoring","Application advice and guidance","Invitations to exclusive CMS events","Springboard support for future Solicitor Apprenticeship or Insight Programme applications"]'::jsonb,
    additional_compensation = '£350 on completion of the five-day work experience, plus reasonable travel expenses in line with the CMS Travel Policy.',
    progression_route = 'Ongoing support after completion; participants can later apply for CMS Solicitor Apprenticeship or Insight Programme routes where eligible.',
    date_precision = 'Next application dates not yet published; 2026 applications closed',
    conflict_flag = false,
    conflict_note = null,
    source_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/work-experience/',
    application_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/work-experience/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = 'b51347f2-ef09-4b97-b43f-c84ca5402a98';
