-- CMS Scotland programmes — official-source refresh
-- Checked 13 September 2026.
--
-- Official source hub:
-- https://cmsemergingtalent.com/programmes/scotland/
--
-- Detailed official pages checked:
-- - Training Contract:
--   https://cmsemergingtalent.com/programmes/scotland/training-contract/
-- - Insight Programme:
--   https://cmsemergingtalent.com/programmes/scotland/insight-programme/
-- - Law Scholarships:
--   https://cmsemergingtalent.com/programmes/scotland/law-scholarships/
-- - Work Experience / CMS Connect:
--   https://cmsemergingtalent.com/programmes/scotland/work-experience/
-- - Business Services Apprenticeships:
--   https://cmsemergingtalent.com/programmes/scotland/business-services-apprenticeships/
--
-- Policy: any closed/past dated cycles are deleted. For CMS Scotland, no such
-- dated stale cycle existed when this update was run; existing current/upcoming
-- rows were refreshed and past 2026 dates were not stored as current cycles.

delete from firm_programme_cycles
where programme_id in (
    'c2ee281e-4200-4043-90e8-38766d9a5d4a',
    'd3a759e3-3138-4467-8650-e85c2f6779e7',
    '2eda6b17-d7a4-478c-b763-0b94b529ad64',
    'c346d3b1-9ac7-41bd-99d7-87a42884f60c',
    'd00f5230-a04b-45b6-b6bb-27c0810e7c21'
  )
  and (
    application_status = 'closed'
    or current_status = 'closed'
    or (closes_on is not null and closes_on < date '2026-09-13')
    or (programme_ends_on is not null and programme_ends_on < date '2026-09-13')
  );

-- Scotland Training Contract
update firm_programmes
set status = 'upcoming',
    current_status = 'upcoming',
    application_opens_on = date '2026-09-24',
    application_closes_on = null,
    application_date_summary = 'Applications open on Thursday 24 September 2026. CMS has not yet published the closing date.',
    programme_date_summary = 'Two-year Scottish training contract with four six-month seats across different practice groups, preceded by the two-week CMS Academy.',
    date_status_note = 'Opening date and programme details checked against the official CMS Scotland Training Contract page on 13 September 2026; closing date not yet published.',
    description = 'Direct two-year Scottish training contract preceded by the two-week CMS Academy. Trainees usually complete four six-month seats across different practice groups and at least three distinct areas of law, with support from a seat supervisor, the Emerging Talent team and trainee representatives. Client, international and UK-office secondments may be available, and trainees can contribute to pro bono and responsible business work.',
    duration_text = '2 years',
    location_text = 'Aberdeen; Glasgow; Edinburgh',
    audience_text = 'Graduates, undergraduates or postgraduates studying an LLB accredited by the Law Society of Scotland.',
    eligible_study_stage = 'Current Scottish LLB students in penultimate or final year, or current accelerated LLB students in first or second year.',
    qualification_or_outcome = 'Scottish Training Contract leading towards qualification, subject to the applicable Diploma/DPLP and regulatory requirements.',
    route_to_next_stage = 'Online application form, critical-thinking test, 15-minute pre-recorded video interview and assessment day.',
    primary_source_url = 'https://cmsemergingtalent.com/programmes/scotland/training-contract/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/training-contract/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = 'd00f5230-a04b-45b6-b6bb-27c0810e7c21';

update firm_programme_cycles
set cycle_label = 'Applications open 24 September 2026 — closing date unpublished',
    application_year = 2026,
    opens_on = date '2026-09-24',
    closes_on = null,
    application_status = 'upcoming',
    current_status = 'upcoming',
    application_status_note = 'Applications open on Thursday 24 September 2026. CMS has not yet published the closing date.',
    duration_text = '2 years',
    programme_dates_text = 'Two-year Scottish training contract with four six-month seats across different practice groups, preceded by the two-week CMS Academy.',
    eligibility = '{"audience":"Graduates, undergraduates or postgraduates studying an LLB accredited by the Law Society of Scotland.","published_rules":"Current LLB law students in their penultimate or final year; current accelerated LLB students in either their first or second year."}'::jsonb,
    application_process = '["Online application form","Critical-thinking test","15-minute pre-recorded video interview","Assessment day"]'::jsonb,
    programme_structure = '["Two-week CMS Academy before the training contract","Two-year direct training contract","Four six-month seats across different practice groups","Experience across at least three distinct areas of law","Support from a designated seat supervisor, Emerging Talent team and trainee representative committee","Possible client secondment, CMS international office secondment or another UK office secondment","Pro bono and responsible business opportunities"]'::jsonb,
    funding = '{"DPLP":"CMS says it will sponsor Diploma in Professional Legal Practice studies before the training contract.","maintenance_grant":"CMS says it will pay a maintenance grant while trainees complete the DPLP."}'::jsonb,
    additional_compensation = 'Published Scotland salary bands: £33,000 first-year trainee, £35,000 second-year trainee, £60,000 newly qualified.',
    funding_details = 'CMS says it will sponsor Diploma in Professional Legal Practice studies and pay a maintenance grant before the training contract.',
    progression_route = 'Direct training contract route. Successful assessment day candidates are offered a training contract and enrolled on the CMS Academy before starting.',
    date_precision = 'Exact opening date published; closing date not yet published',
    conflict_flag = false,
    conflict_note = null,
    source_url = 'https://cmsemergingtalent.com/programmes/scotland/training-contract/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/training-contract/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = '095335af-f938-402a-a9d2-4c554a21ff35';

-- Scotland Insight Programme
update firm_programmes
set status = 'upcoming',
    current_status = 'upcoming',
    application_opens_on = null,
    application_closes_on = null,
    application_date_summary = 'Applications open in 2027. Exact application dates have not yet been published.',
    programme_date_summary = 'The next Scotland Insight Programme dates have not yet been published. The programme is a one-week paid experience.',
    date_status_note = 'The official CMS page says applications are now closed and will open again in 2027. Past 2026 dates are not stored as the current cycle.',
    description = 'Paid one-week Scotland insight programme combining practical work experience, skills sessions, trainee shadowing, buddy and mentor support, networking and social events. Successful completion may lead to fast-track consideration for a training-contract assessment day.',
    duration_text = '1 week',
    location_text = 'Aberdeen; Edinburgh; Glasgow',
    audience_text = 'Second-year Scottish LLB students and first-year accelerated LLB students; penultimate-year non-law Scottish students may apply for the programme in an English location.',
    eligible_study_stage = 'Second-year LLB law student or first-year accelerated LLB law student.',
    qualification_or_outcome = 'Insight programme with possible fast-track to a training-contract assessment day.',
    route_to_next_stage = 'Online application form, critical-thinking test, 15-minute pre-recorded video interview and 30-minute virtual interview.',
    primary_source_url = 'https://cmsemergingtalent.com/programmes/scotland/insight-programme/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/insight-programme/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = 'c346d3b1-9ac7-41bd-99d7-87a42884f60c';

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
    programme_dates_text = 'Next Scotland Insight Programme dates have not yet been published. The programme is a one-week paid experience.',
    eligibility = '{"audience":"Second-year Scottish LLB students and first-year accelerated LLB students.","study_stage":"Second-year LLB law student or first-year accelerated LLB law student.","note":"Penultimate-year non-law Scottish students may apply for the programme in an English location."}'::jsonb,
    application_process = '["Online application form","Critical-thinking test","15-minute pre-recorded video interview","30-minute virtual interview"]'::jsonb,
    programme_structure = '["Paid one-week insight programme","Practical work experience","Skills sessions including presentation, networking and introduction to the business of law","Trainee shadowing","Buddy and mentor support","Networking, lunches, coffee networking and social events","Possible fast-track to a training-contract assessment day after successful completion"]'::jsonb,
    additional_compensation = 'CMS states that all Insight Programme participants are paid £475 per week; confirm the next-cycle rate when applications reopen.',
    progression_route = 'Successful completion may lead to fast-track consideration for a training-contract assessment day.',
    date_precision = 'Applications reopen in 2027; exact dates not yet published',
    conflict_flag = false,
    conflict_note = null,
    source_url = 'https://cmsemergingtalent.com/programmes/scotland/insight-programme/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/insight-programme/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = '40d7dd74-8e25-40f6-bd5f-e74567516d1c';

-- Scotland Law Scholarship
update firm_programmes
set status = 'current',
    current_status = 'current',
    application_opens_on = null,
    application_closes_on = null,
    application_date_summary = 'Applications for 2026 are now closed. CMS has not yet published the next application dates.',
    programme_date_summary = 'Scholarship support runs throughout the successful recipient’s university study.',
    date_status_note = 'Past 2026 application dates are not stored as the current cycle; next dates are unpublished.',
    description = 'Scottish social-mobility scholarship providing £3,000 per year for each year of an accredited LLB to up to ten recipients, with mentoring, UCAS/LNAT support, paid work experience, sustained support and possible fast-track support.',
    duration_text = 'Throughout university study',
    location_text = 'Scotland',
    audience_text = 'S5 students in Scotland progressing to S6 for the 2026/27 academic year and graduating high school in summer 2027, subject to the published social-mobility criteria.',
    eligible_study_stage = 'S5 progressing to S6; the scheme is also open to S6 students in Scotland who do not yet have a confirmed university place.',
    qualification_or_outcome = 'Financial support, mentoring, paid work experience and sustained support during university study.',
    route_to_next_stage = 'Application form with motivational questions; assessment-day support may include travel and accommodation where required.',
    primary_source_url = 'https://cmsemergingtalent.com/programmes/scotland/law-scholarships/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/law-scholarships/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = '2eda6b17-d7a4-478c-b763-0b94b529ad64';

update firm_programme_cycles
set cycle_label = 'Next Scotland Law Scholarship cycle — dates unpublished',
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    application_status = 'current',
    current_status = 'current',
    application_status_note = 'Applications for 2026 are now closed. CMS has not yet published the next application dates. Past 2026 dates are not stored as the current cycle.',
    duration_text = 'Throughout university study',
    programme_dates_text = 'Scholarship support runs throughout the successful recipient’s university study.',
    eligibility = '{"audience":"S5 students in Scotland progressing to S6 for the 2026/27 academic year and graduating high school in summer 2027, subject to published social-mobility criteria.","additional_note":"The scheme is also open to S6 students in Scotland who do not yet have a confirmed university place."}'::jsonb,
    programme_structure = '["£3,000 per year for each year of degree for up to ten recipients","Mentoring from a CMS lawyer and trainee buddy support","UCAS and LNAT support","Paid bespoke work experience in second year of university","Sustained support through undergraduate studies","Assessment-day travel and accommodation support where required"]'::jsonb,
    additional_compensation = 'Up to ten individuals receive £3,000 per year for each year of their degree. The work-experience element is paid £450. Assessment-day UCAS/LNAT expenses may be reimbursed and travel/accommodation support may be arranged where required.',
    progression_route = 'Scholarship support, mentoring, paid work experience and possible future application support.',
    date_precision = 'Next application dates not yet published; 2026 applications closed',
    conflict_flag = false,
    conflict_note = null,
    source_url = 'https://cmsemergingtalent.com/programmes/scotland/law-scholarships/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/law-scholarships/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = 'b5a35985-dc9c-44c9-8faf-63254a63c543';

-- CMS Connect Scotland Work Experience
update firm_programmes
set status = 'current',
    current_status = 'current',
    application_opens_on = null,
    application_closes_on = null,
    application_date_summary = 'Applications for 2026 are now closed. CMS has not yet published the next application dates.',
    programme_date_summary = 'The next CMS Connect Scotland programme dates have not yet been published.',
    date_status_note = 'Past 2026 application and programme dates are not stored as the current cycle; next dates are unpublished.',
    description = 'CMS Connect Scotland is a one-week paid school work-experience programme in Glasgow, followed by sustained mentoring, application advice, guidance and invitations to CMS events.',
    duration_text = '1 week plus sustained support',
    location_text = 'Glasgow',
    audience_text = 'Scottish S5 students progressing to S6 for the 2026/27 academic year and graduating high school in summer 2027, subject to access criteria and commuting distance.',
    eligible_study_stage = 'S5 progressing to S6.',
    qualification_or_outcome = 'Work experience, mentoring and sustained application support.',
    route_to_next_stage = 'Online application form with two motivational questions.',
    primary_source_url = 'https://cmsemergingtalent.com/programmes/scotland/work-experience/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/work-experience/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = 'd3a759e3-3138-4467-8650-e85c2f6779e7';

update firm_programme_cycles
set cycle_label = 'CMS Connect Scotland — next cycle dates unpublished',
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    application_status = 'current',
    current_status = 'current',
    application_status_note = 'Applications for 2026 are now closed. CMS has not yet published the next application dates. Past 2026 dates are not stored as the current cycle.',
    duration_text = '1 week plus sustained support',
    programme_dates_text = 'Next programme dates have not yet been published.',
    eligibility = '{"audience":"Scottish S5 students progressing to S6 for the 2026/27 academic year and graduating high school in summer 2027, subject to access criteria and commuting distance.","access_criteria":"State-funded/non-fee-paying school or college and at least one published social-mobility criterion; care-experienced applicants do not need to meet any other criterion."}'::jsonb,
    application_process = '["Online application form","Two motivational questions of up to 200 words each"]'::jsonb,
    programme_structure = '["One-week in-person work experience in Glasgow","Business learning","Work shadowing","Skills development","Ongoing mentoring","Application advice and guidance","Invitations to CMS events"]'::jsonb,
    additional_compensation = '£350 on completion of the five-day work experience, plus reasonable travel expenses in line with the CMS Travel Policy.',
    progression_route = 'Ongoing support after completion; participants can later apply for Insight Programme or Solicitor Apprenticeship routes where eligible.',
    date_precision = 'Next application dates not yet published; 2026 applications closed',
    conflict_flag = false,
    conflict_note = null,
    source_url = 'https://cmsemergingtalent.com/programmes/scotland/work-experience/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/work-experience/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = '12e3120c-36d1-4799-90fe-abbd1f2271d5';

-- Business Services Apprenticeships
update firm_programmes
set status = 'open',
    current_status = 'open',
    application_opens_on = null,
    application_closes_on = null,
    application_date_summary = 'Applications open on an ad-hoc basis. No single closing date is published.',
    programme_date_summary = 'Start date and duration depend on the apprenticeship role.',
    date_status_note = 'Ad-hoc business-services route checked against the official CMS Scotland programme page on 13 September 2026.',
    description = 'Ad-hoc non-legal/business-services apprenticeships across administration, IT, facilities, project management, finance, HR, digital technology, management and related functions.',
    duration_text = 'Role-specific',
    location_text = 'England and Scotland',
    audience_text = 'Applicants aged 16+ meeting the role-specific apprenticeship funding and work eligibility.',
    eligible_study_stage = 'School leaver / early-career applicant; role-specific eligibility applies.',
    qualification_or_outcome = 'Role-specific apprenticeship qualification and practical business-services experience.',
    primary_source_url = 'https://cmsemergingtalent.com/programmes/scotland/business-services-apprenticeships/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/business-services-apprenticeships/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = 'c2ee281e-4200-4043-90e8-38766d9a5d4a';

update firm_programme_cycles
set cycle_label = 'Business Services Apprenticeships — ad hoc vacancies',
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    application_status = 'open',
    current_status = 'open',
    application_status_note = 'Applications open on an ad-hoc basis. No single closing date is published.',
    duration_text = 'Role-specific',
    programme_dates_text = 'Start date and duration depend on the apprenticeship role.',
    eligibility = '{"audience":"Applicants aged 16+ meeting role-specific apprenticeship funding and work eligibility.","published_page_note":"The CMS page lists 16 or older, not in full-time education, and live in England; vacancies are described as available in England and Scotland, so students should check the specific vacancy requirements."}'::jsonb,
    programme_structure = '["Business Administration Apprenticeships – Level 3","Information Communications Technician – Level 3","Facilities Services Operative – Level 2","Project Management Apprenticeship – Level 4","Other listed business-services apprenticeships include finance, HR, digital technology, management and IT routes"]'::jsonb,
    funding_details = 'CMS describes these as earn-while-you-learn apprenticeships with high-quality training paid for by the firm and at least six hours of off-the-job training per week.',
    date_precision = 'Ad hoc vacancies; no single application window',
    conflict_flag = false,
    conflict_note = null,
    source_url = 'https://cmsemergingtalent.com/programmes/scotland/business-services-apprenticeships/',
    application_url = 'https://cmsemergingtalent.com/programmes/scotland/business-services-apprenticeships/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = '2bf04b6c-6afd-4034-9de2-9408869cfd60';
