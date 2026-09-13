-- CMS Solicitor Apprenticeship — official-source refresh
-- Checked 13 September 2026.
--
-- Official source:
-- https://cmsemergingtalent.com/programmes/england-wales-ni/solicitor-apprenticeships/
--
-- CMS says applications open in 2027 and applications for 2026 are now closed.
-- Past 2026 dates are not stored as the current cycle.

delete from firm_programme_cycles
where programme_id = 'e01491f8-322f-44d2-bd30-ec3305353275'
  and id <> '39a79e7f-59fc-4a0a-9773-05c279d3b0e9'
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
    application_date_summary = 'Applications open in 2027. Exact application dates have not yet been published. Applications for 2026 are now closed.',
    programme_date_summary = 'Six-year earn-while-you-learn solicitor apprenticeship; next programme start date has not yet been published.',
    date_status_note = 'The official CMS page says applications open in 2027 and 2026 applications are now closed. Past 2026 dates are not stored as the current cycle.',
    description = 'Six-year earn-while-you-learn route with no university or SQE fees to pay. Apprentices work four days per week at CMS and spend one day per week studying with the University of Law for an LLB in Legal Practice and Skills, followed by SQE preparation, qualifying work experience and the route to solicitor qualification.',
    duration_text = '6 years',
    location_text = 'London; Sheffield in the 2026 cycle',
    audience_text = 'School/college leavers and eligible career changers meeting the published academic and funding criteria.',
    eligible_study_stage = 'School/college leaver or eligible career changer.',
    qualification_or_outcome = 'LLB in Legal Practice and Skills, SQE and qualifying work experience route towards admission as a solicitor, subject to SRA requirements.',
    route_to_next_stage = 'Online application form, critical-thinking test, 15-minute pre-recorded video interview and assessment day with case study, interview and presentation exercise.',
    primary_source_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/solicitor-apprenticeships/',
    application_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/solicitor-apprenticeships/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = 'e01491f8-322f-44d2-bd30-ec3305353275';

update firm_programme_cycles
set cycle_label = 'Solicitor Apprenticeship — applications open in 2027',
    application_year = 2027,
    programme_year = null,
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    application_status = 'upcoming',
    current_status = 'upcoming',
    application_status_note = 'Applications open in 2027. Exact application dates have not yet been published. Applications for 2026 are now closed; past 2026 dates are not stored as the current cycle.',
    duration_text = '6 years',
    programme_dates_text = 'Six-year earn-while-you-learn solicitor apprenticeship; next programme start date has not yet been published.',
    eligibility = '{"audience":"School/college leavers and eligible career changers meeting the published academic and funding criteria.","academic_requirements":"5 GCSEs, including Maths and English, at grade C / 4 or above, plus 3 A Levels at grade C or above; equivalent qualifications may be considered.","career_changers":"Career changers who meet the published criteria are encouraged to apply."}'::jsonb,
    application_process = '["Online application form","Critical-thinking test","15-minute pre-recorded video interview","Assessment day with case study, interview, presentation exercise and opportunity to meet CMS people"]'::jsonb,
    programme_structure = '["Six-year earn-while-you-learn programme","Pre-joining events and induction","Four days per week working at CMS","One day per week studying with the University of Law","LLB in Legal Practice and Skills","SQE and SQE+ study support with the University of Law","Practical experience across CMS practice groups","Dedicated supervisor, mentor, buddy and Emerging Talent support","25 days paid holiday and benefits package"]'::jsonb,
    funding = '{"tuition":"No university or SQE fees to pay; CMS states apprentices are supported through the University of Law study and SQE route.","study_time":"One day per week is dedicated to study."}'::jsonb,
    additional_compensation = 'Published starting salaries: London £30,000; Bristol £28,000; One North £26,000. The current page says 2026 roles were in London and Sheffield; confirm next-cycle locations/salaries when applications reopen.',
    funding_details = 'CMS states there are no university or SQE fees to pay. Apprentices study with the University of Law and receive support through LLB, SQE and qualifying work experience.',
    progression_route = 'Pass the SQE, complete the apprenticeship and qualifying work experience, then apply to the SRA for admission as a solicitor, subject to SRA requirements.',
    date_precision = 'Applications reopen in 2027; exact dates not yet published; 2026 applications closed',
    conflict_flag = false,
    conflict_note = null,
    source_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/solicitor-apprenticeships/',
    application_url = 'https://cmsemergingtalent.com/programmes/england-wales-ni/solicitor-apprenticeships/',
    research_checked_on = date '2026-09-13',
    updated_at = now()
where id = '39a79e7f-59fc-4a0a-9773-05c279d3b0e9';
