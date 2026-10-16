begin;

update public.legal_organisations
set overview='39 Essex Chambers is an international multidisciplinary barristers’ set with offices in London, Singapore, Dubai and Kuala Lumpur. Its members practise across public and administrative law, civil liability, environment and planning, construction, commercial disputes, arbitration, costs, the Court of Protection, healthcare, information and media, property, regulation, inquiries and sport.',
    careers_url='https://www.39essex.com/careers/',research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='a86bc49d-6c67-46d1-a75c-48b79c2fe6c4';

update public.chambers
set pupillage_overview='39 Essex Chambers is offering up to four 12-month pupillages beginning in September 2028. Applications open through the Pupillage Gateway on 4 January 2027 at 11:00 and close on 28 January 2027 at 23:59. The award is £70,000, including £5,000 guaranteed second-six earnings, and up to £15,000 may be drawn down during the year before pupillage.',
    mini_pupillage_overview='The 2026–27 mini-pupillage scheme comprises one-day programmes on 9 and 30 November 2026 for up to 30 participants per day. Applications for those places are closed. The next scheme will be advertised in 2027. Selected mini-pupils may claim reasonable standard-class travel expenses up to £150 and, where required, hotel expenses up to £250.',
    pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where organisation_id='a86bc49d-6c67-46d1-a75c-48b79c2fe6c4';

update public.career_opportunities
set public_summary='Apply through the Pupillage Gateway from 4 to 28 January 2027 for one of up to four 12-month pupillages beginning in September 2028. The award is £70,000.',
    official_url='https://www.39essex.com/careers/pupillage-39-essex-chambers/',application_url='https://www.pupillagegateway.com/',active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2027-01-29',updated_at=now()
where id='0b5936b0-23b8-43da-90db-fb1cf3b8a1bd';

update public.career_opportunity_cycles
set cycle_key='39-essex-chambers-pupillage-september-2028',cycle_label='39 Essex Chambers Pupillage — September 2028 Intake',
    application_year=2027,programme_year=2028,intake_year=2028,application_model='fixed_deadline',
    opens_on=date '2027-01-04',opens_at=time '11:00',opens_timezone='Europe/London',closes_on=date '2027-01-28',closes_at=time '23:59',closes_timezone='Europe/London',
    programme_starts_on=date '2028-09-01',programme_ends_on=null,programme_dates_text='Pupillage begins in September 2028. First-round interviews take place from 15 to 25 March 2027, second-round interviews take place in mid-April, and offers are made on 7 May 2027 at 09:30.',
    date_precision='month',duration_text='12 months',places_text='Up to four pupillages',source_status='upcoming',
    application_dates_text='Applications open on 4 January 2027 at 11:00 and close on 28 January 2027 at 23:59 UK time.',
    application_process_text='Apply through the Pupillage Gateway. Shortlisted applicants attend two in-person interview rounds at chambers.',
    funding_text='£70,000, including £5,000 guaranteed earnings in the second six. Up to £15,000 may be drawn down during the year before pupillage.',
    official_url='https://www.39essex.com/careers/pupillage-39-essex-chambers/',application_url='https://www.pupillagegateway.com/',source_status_note=null,research_checked_on=date '2026-10-15',updated_at=now()
where id='3bd0b612-1905-45fb-92f4-c604a54b09f6';

update public.career_opportunities
set official_name='11KBW / 39 Essex Chambers Scholarship 2027',public_name='11KBW / 39 Essex Chambers Scholarship 2027',
    public_summary='Two £30,000 scholarships for eligible Black students on the Bar course, with mentoring and accelerated access to the recruitment process at 11KBW or 39 Essex Chambers. Applications open in January 2027.',
    official_url='https://barscholarship.com/',application_url='https://barscholarship.com/',active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2027-01-08',updated_at=now()
where id='1017b11e-9d9d-479b-9190-822726fce42b';

update public.career_opportunity_cycles
set cycle_key='11kbw-39-essex-scholarship-2027',cycle_label='11KBW / 39 Essex Chambers Scholarship 2027',
    application_year=2027,programme_year=2027,intake_year=2027,application_model='fixed_deadline',
    opens_on=null,opens_at=null,opens_timezone=null,closes_on=null,closes_at=null,closes_timezone=null,
    programme_dates_text='Applications open in January 2027. Further application details will be posted on the scholarship website nearer the opening.',date_precision='month',
    duration_text='Support during the Bar course and, where relevant, the pupillage years',places_text='Two scholarships',source_status='upcoming',
    application_dates_text='Applications open in January 2027.',
    application_process_text='Apply through the official scholarship website when the 2027 application form opens.',
    assessments_text='Application and selection by a panel including members of both chambers and external assessors.',
    expenses_text='Each scholarship provides £30,000 towards tuition fees and maintenance.',
    right_to_work_text=null,source_status_note=null,additional_details_text='The successful candidates choose between the 11KBW and 39 Essex Chambers benefit packages; if both choose the same chambers, allocation is determined randomly.',
    official_url='https://barscholarship.com/',application_url='https://barscholarship.com/',active=true,research_checked_on=date '2026-10-15',updated_at=now()
where id='de97d7bb-f713-445a-8418-873a3b729dfb';

-- Remove an indirect partner-wide matching programme that does not guarantee a 39 Essex placement.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba' or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunity_cycle_routes where opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunity_compensation where opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunity_locations where opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunity_routes where opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunity_scope_assignments where opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunity_identity_stage where career_opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunity_cycles where opportunity_id='69c451fb-df95-4483-bb87-54fcdd818bba';
delete from public.career_opportunities where id='69c451fb-df95-4483-bb87-54fcdd818bba';

commit;
