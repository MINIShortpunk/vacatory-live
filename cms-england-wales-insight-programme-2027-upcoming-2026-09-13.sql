-- CMS England & Wales Insight Programme — 2027 upcoming refresh
-- Checked 13 September 2026.
--
-- Official source:
-- https://cmsemergingtalent.com/programmes/england-wales-ni/insight-programme/
--
-- CMS says applications are currently closed and will re-open in 2027.
-- The passed 2026 programme dates are not stored as the current cycle.
-- No stale closed/past CMS England & Wales Insight Programme cycles were present
-- in Vacatory at the time of this update.

delete from firm_programme_cycles
where programme_id = '3ec578d5-6fc3-422a-931b-8e1c8ddd13f0'
  and (
    application_status = 'closed'
    or current_status = 'closed'
    or (closes_on is not null and closes_on < date '2026-09-13')
    or (programme_ends_on is not null and programme_ends_on < date '2026-09-13')
  );

update firm_programmes
set status = 'upcoming',
    current_status = 'upcoming',
    application_opens_on = null,
    application_closes_on = null,
    application_date_summary = 'Applications open in 2027. Exact application dates have not yet been published.',
    programme_date_summary = 'The next Insight Programme dates have not yet been published. The programme is a one-week paid experience.',
    date_status_note = 'The official CMS page says applications are now closed and will re-open in 2027. Past 2026 dates are not stored as the current cycle.',
    description = 'Paid one-week insight programme combining practical work experience, skills sessions, trainee shadowing, mentoring, networking and social events. Successful completion may lead to fast-track consideration for a training-contract assessment day.',
    duration_text = '1 week',
    location_text = 'Bristol; London; Manchester; Sheffield',
    audience_text = 'First-year LLB law students and penultimate-year non-law students.',
    eligible_study_stage = 'First-year LLB law student or penultimate-year non-law student.',
    qualification_or_outcome = 'Insight programme with possible fast-track to a training-contract assessment day.',
    route_to_next_stage = 'Online application form, critical-thinking test, 15-minute pre-recorded video interview and 30-minute virtual interview.',
    primary_source_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/insight-programme/',
    application_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/insight-programme/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = '3ec578d5-6fc3-422a-931b-8e1c8ddd13f0';

update firm_programme_cycles
set cycle_label = '2027 applications — exact dates unpublished',
    application_year = 2027,
    programme_year = 2027,
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    application_status = 'upcoming',
    current_status = 'upcoming',
    application_status_note = 'Applications open in 2027. Exact application dates have not yet been published. Past 2026 dates are not stored as the current cycle.',
    duration_text = '1 week',
    programme_dates_text = 'Next programme dates have not yet been published. The programme is a one-week paid experience.',
    eligibility = '{"audience":"First-year LLB law students and penultimate-year non-law students.","study_stage":"First-year LLB law student or penultimate-year non-law student."}'::jsonb,
    application_process = '["Online application form","Critical-thinking test","15-minute pre-recorded video interview","30-minute virtual interview"]'::jsonb,
    programme_structure = '["Paid one-week insight programme","Practical work experience","Skills sessions including presentation, networking and introduction to the business of law","Trainee shadowing","Buddy and mentor support","Networking, lunches, coffee networking and social events","Possible fast-track to a training-contract assessment day after successful completion"]'::jsonb,
    additional_compensation = 'CMS states that all Insight Programme participants are paid £475 per week; confirm the next-cycle rate when applications reopen.',
    progression_route = 'Successful completion may lead to fast-track consideration for a training-contract assessment day.',
    date_precision = 'Applications reopen in 2027; exact dates not yet published',
    conflict_flag = false,
    conflict_note = null,
    source_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/insight-programme/',
    application_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/insight-programme/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = '9452c0ac-42c6-43d6-b700-b1d34aa482c2';
