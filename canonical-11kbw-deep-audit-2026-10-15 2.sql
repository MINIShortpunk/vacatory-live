begin;

update public.chambers
set pupillage_overview = '11KBW offers up to five twelve-month pupillages each year. The 2027 Pupillage Gateway application window runs from 4 January to 28 January for pupillages beginning in October 2028. The award is £90,000, with up to £30,000 available as an advance during the Bar course year.',
    mini_pupillage_overview = '11KBW does not run a separate general mini-pupillage competition. An assessed mini-pupillage day forms Stage 3 of its pupillage selection process. The 11KBW / 39 Essex Chambers Scholarship includes a guaranteed assessed mini-pupillage at 11KBW, and chambers also participates in the Bridging the Bar Mini-Pupillage Programme, the Bar Council Bar Placement Scheme and the COMBAR mentoring scheme for under-represented groups.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-30',
    updated_at = now()
where organisation_id = '2eb1d292-ef5c-4373-8865-e2be32be1ceb';

update public.legal_organisations
set research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-30',
    updated_at = now()
where id = '2eb1d292-ef5c-4373-8865-e2be32be1ceb';

update public.career_opportunities
set official_name = '11KBW Pupillage — October 2028',
    public_name = '11KBW Pupillage — October 2028',
    english_name = '11KBW Pupillage — October 2028',
    public_summary = 'Up to five twelve-month pupillages beginning in October 2028, with a £90,000 award and a four-stage selection process.',
    official_url = 'https://www.11kbw.com/pupillage/what-we-are-looking-for/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-29',
    updated_at = now()
where id = 'a8871ee8-3f50-4937-b3e2-8c244f3f75f7';

update public.career_opportunity_cycles
set cycle_label = '11KBW Pupillage — October 2028',
    application_year = 2027,
    programme_year = 2028,
    intake_year = 2028,
    programme_starts_on = date '2028-10-01',
    programme_ends_on = null,
    programme_dates_text = 'Twelve-month pupillage beginning in October 2028.',
    application_dates_text = 'Applications open through the Pupillage Gateway at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
    date_precision = 'month',
    duration_text = 'Twelve months',
    places_text = 'Up to five pupillages',
    source_status = 'official_dates_published',
    eligibility_text = 'Applicants normally need a first-class or high upper-second-class degree in any subject. 11KBW considers mitigating circumstances and evidence of later high academic achievement.',
    application_process_text = 'Four stages: Pupillage Gateway application, remote assessed written work, an assessed mini-pupillage day with oral assessment, and a final interview.',
    funding_text = '£90,000 award for the full twelve-month pupillage. Up to £30,000 may be drawn down during the Bar course year.',
    travel_support_text = 'Reasonable travel or accommodation expenses are reimbursed for candidates living outside the M25 who attend the assessed mini-pupillage day or interview.',
    official_url = 'https://www.11kbw.com/pupillage/what-we-are-looking-for/',
    application_url = 'https://www.pupillagegateway.com/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '0c74326c-9625-440d-91d8-d13c1575ce7c';

update public.career_opportunities
set public_summary = 'Two annual £30,000 scholarships for eligible Black students on the Bar Practice Course, with mentoring and progression support from 11KBW or 39 Essex Chambers.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-31',
    updated_at = now()
where id = '2c51df71-71d1-4c7e-81f3-9ce3c45ec3b2';

update public.career_opportunity_cycles
set programme_dates_text = 'Two £30,000 scholarships for the 2027 award cycle, with mentoring and pupillage-application support.',
    application_dates_text = 'Applications open in January 2027 through the official scholarship website.',
    places_text = 'Two scholarships',
    source_status = 'upcoming',
    application_process_text = 'Apply through the official 11KBW / 39 Essex Chambers Scholarship website during the January 2027 application cycle.',
    funding_text = '£30,000 towards Bar Practice Course tuition fees and maintenance for each recipient.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '579890cc-074f-4e62-812b-53a23f43624f';

update public.career_opportunities
set official_name = 'Bridging the Bar Academy 2027/28 — 11KBW Partner Route',
    public_name = 'Bridging the Bar Academy 2027/28 — 11KBW Partner Route',
    english_name = 'Bridging the Bar Academy 2027/28 — 11KBW Partner Route',
    public_summary = 'A partner access programme for aspiring barristers from under-represented backgrounds, including mentoring, skills development and mini-pupillage opportunities with participating chambers.',
    official_url = 'https://bridgingthebar.org/academy-applications/',
    application_url = 'https://bridgingthebar.org/academy-applications/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-06',
    updated_at = now()
where id = 'bb7fed28-a266-4418-9b82-5bec2944cc0d';

update public.career_opportunity_cycles
set cycle_key = 'bridging-the-bar-academy:2027-28:11kbw',
    cycle_label = 'Bridging the Bar Academy 2027/28 — 11KBW Partner Route',
    application_year = 2026,
    programme_year = 2027,
    intake_year = 2027,
    programme_starts_on = date '2027-08-01',
    programme_ends_on = date '2028-06-30',
    programme_dates_text = 'The Academy programme runs from August 2027 to June 2028.',
    application_dates_text = 'Applications close at 17:00 on 5 November 2026.',
    date_precision = 'month',
    source_status = 'official_dates_published',
    audience_text = 'Aspiring barristers applying for pupillage in 2028 who meet the Bridging the Bar Academy access criteria.',
    eligibility_text = 'Applicants must be studying the Bar course in 2027/28 or have completed it, intend to apply for pupillage in 2028, have attended state school, not have attended Oxford or Cambridge as an undergraduate, have funded undergraduate study through student loans or employment, and be available in the UK for the full programme.',
    application_process_text = 'Complete the applicant-details stage and the online written and video assessment through Bridging the Bar.',
    official_url = 'https://bridgingthebar.org/academy-applications/',
    application_url = 'https://bridgingthebar.org/academy-applications/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '860eef7b-7dbf-4c9a-a97c-2495ebc191cb';

commit;
