-- CMS England, Wales and Northern Ireland Law Scholarship — official-source refresh
-- Checked 13 September 2026.
--
-- Official source:
-- https://cmsemergingtalent.com/programmes/england-wales-ni/law-scholarships/
--
-- CMS says applications for 2026 are now closed. The next application dates are
-- not yet published. The record is kept as current scholarship information, not
-- an open deadline. Past 2026 dates are not stored as the current cycle.

delete from firm_programme_cycles
where programme_id = 'ed77e735-e6be-4310-bfad-8ee898e52c96'
  and id <> 'cc63e71f-0712-4e1f-ac3b-825bc5b88e67'
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
    programme_date_summary = 'Scholarship support continues throughout university study for successful recipients.',
    date_status_note = 'The official CMS page says applications for 2026 are now closed. Past 2026 dates are not stored as the current cycle; next dates are unpublished.',
    description = 'England, Wales and Northern Ireland social-mobility scholarship providing £3,000 per year for each year of the recipient’s degree to up to ten individuals, plus mentoring, UCAS/LNAT support, paid first-year university work experience and sustained support throughout undergraduate study.',
    duration_text = 'Throughout university study',
    location_text = 'England; Wales; Northern Ireland',
    audience_text = 'Year 12 students in England or Wales and Year 13 students in Northern Ireland who meet the published social-mobility and first-generation university criteria.',
    eligible_study_stage = 'Year 12 in England or Wales; Year 13 in Northern Ireland.',
    qualification_or_outcome = 'Financial support, mentoring, paid work experience and sustained support during university study.',
    route_to_next_stage = 'Application form with motivational questions and a short law-change answer, followed by an assessment day with interview and group exercise for selected applicants.',
    primary_source_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/law-scholarships/',
    application_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/law-scholarships/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = 'ed77e735-e6be-4310-bfad-8ee898e52c96';

update firm_programme_cycles
set cycle_label = 'Next England, Wales and Northern Ireland Law Scholarship cycle — dates unpublished',
    application_year = null,
    programme_year = null,
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    application_status = 'current',
    current_status = 'current',
    application_status_note = 'Applications for 2026 are now closed. CMS has not yet published the next application dates. Past 2026 dates are not stored as the current cycle.',
    duration_text = 'Throughout university study',
    programme_dates_text = 'Scholarship support continues throughout university study for successful recipients.',
    eligibility = '{"audience":"Year 12 students in England or Wales and Year 13 students in Northern Ireland who meet the published social-mobility and first-generation university criteria.","core_criteria":["Attend a state-funded school, sixth form or further education college","Parents and grandparents did not attend university","Intend to apply to university through the 2026/2027 UCAS process","Passionate about pursuing a career in law","No criminal conviction","Not related to a CMS partner"],"additional_criteria":"Applicants must also meet at least one published access criterion, such as free-school-meals eligibility, school-level free-meal threshold, care experience, or POLAR4 quintile 1 home postcode."}'::jsonb,
    application_process = '["Online application form","Two motivational questions","Short answer of up to 250 words on a law the applicant would change","Assessment day with interview and group exercise for selected applicants"]'::jsonb,
    programme_structure = '["£3,000 per year for each year of degree for up to ten recipients","Mentoring from a CMS lawyer and trainee buddy support","UCAS and LNAT support","Paid bespoke work experience in first year of university","Sustained support through undergraduate studies","Assessment-day travel and accommodation support where required"]'::jsonb,
    additional_compensation = 'Up to ten individuals receive £3,000 per year for each year of their degree. The first-year university work-experience element is paid £450. Assessment-day travel and, if required, one night of accommodation may be arranged for the applicant and one accompanying adult.',
    progression_route = 'Scholarship support, mentoring, paid work experience and possible future application support.',
    date_precision = 'Next application dates not yet published; 2026 applications closed',
    conflict_flag = false,
    conflict_note = null,
    source_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/law-scholarships/',
    application_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/law-scholarships/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = 'cc63e71f-0712-4e1f-ac3b-825bc5b88e67';
