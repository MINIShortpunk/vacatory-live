begin;

update public.legal_organisations
set overview='Atkin Chambers is a specialist commercial barristers’ set in Gray’s Inn, London. Its members practise in construction and engineering, energy, international arbitration, infrastructure and PFI, professional negligence, shipbuilding and offshore construction, technology and telecommunications, and alternative dispute resolution, acting in major UK and international disputes.',
    careers_url='https://www.atkinchambers.com/join/',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-01',updated_at=now()
where id='2e5eac0b-cb2d-446b-a007-715b2d18b67b';

update public.chambers
set pupillage_overview='Atkin Chambers offers two funded 12-month pupillages and recruits in accordance with the Pupillage Gateway timetable. For the 2027 application cycle, advertisements are available from 23 November 2026, applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027. Pupils receive structured training for commercial construction and related international work, and Chambers is committed to recruiting tenants from its pupils.',
    mini_pupillage_overview='Atkin Chambers runs at least two one-day group mini-pupillages each year. Applications for the 2027 dates open on 1 November 2026. Applicants should normally be at least second-year law or third-year non-law students; GDL and BPC students are also welcomed. The day is unassessed and is not a prerequisite for pupillage. Reasonable travel expenses are reimbursed, overnight accommodation is considered case by case and reasonable adjustments are available.',
    tenancy_overview='Atkin is committed to recruiting tenants from its pupils. Tenancy consideration is based on supervisor reports, ongoing assessment and formal written and advocacy exercises, with decisions normally made approximately ten months into pupillage.',
    pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-01',updated_at=now()
where organisation_id='2e5eac0b-cb2d-446b-a007-715b2d18b67b';

update public.career_opportunities
set slug='atkin-chambers-pupillage-2027-application-cycle',
    official_name='Atkin Chambers Pupillage — 2027 Application Cycle',
    public_name='Atkin Chambers Pupillage — 2027 Application Cycle',
    public_summary='Apply in accordance with the Pupillage Gateway timetable from 4 to 28 January 2027 for one of Atkin Chambers’ two funded 12-month pupillages.',
    official_url='https://www.atkinchambers.com/join/pupillage/',
    application_url='https://www.atkinchambers.com/join/pupillage/how-to-apply-for-pupillage-at-atkin-chambers/',
    active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='a25ae20e-3dcf-4837-92eb-6af29547f663';

update public.career_opportunity_cycles
set cycle_key='atkin-chambers-pupillage-2027-application-cycle',
    cycle_label='Atkin Chambers Pupillage — 2027 Application Cycle',
    application_year=2027,programme_year=null,intake_year=null,
    application_model='fixed_deadline',
    opens_on=date '2027-01-04',opens_at=time '11:00',opens_timezone='Europe/London',
    closes_on=date '2027-01-28',closes_at=time '23:59',closes_timezone='Europe/London',
    application_dates_text='Vacancies are available to browse from 23 November 2026. Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
    programme_dates_text='Two funded 12-month pupillages.',
    date_precision='exact',duration_text='12 months',places_text='Two',source_status='upcoming',
    audience_text='Aspiring barristers interested in commercial construction, engineering, energy, technology, infrastructure and international disputes.',
    study_stage_text='Applicants must be at least in the final year of a law degree or, for non-law graduates, undertaking the GDL.',
    academic_criteria='Normally a first-class degree or a good upper second-class degree. Postgraduate qualifications are viewed favourably but are not essential.',
    eligibility_text='Law and non-law graduates are welcomed. A science or technical background and prior construction-law knowledge are not required.',
    application_process_text='Follow Atkin Chambers’ current application instructions and the Pupillage Gateway timetable. The application is assessed against intellectual ability, communication and advocacy, motivation, judgment and the potential to build a successful self-employed practice at Atkin Chambers.',
    assessments_text='First-round interviews typically include questions on the written application and a short presentation on a topical issue. Around ten candidates are usually invited to a longer second-round interview involving a legal problem and advocacy on an unseen issue.',
    progression_route_text='Atkin Chambers is committed to recruiting tenants from its pupils.',
    funding_text='Atkin Chambers describes both places as funded and permits up to £25,000 of the pupillage award to be drawn down for the Bar course, with further advances considered case by case.',
    expenses_text='Reasonable travel expenses are reimbursed for interviewees.',
    right_to_work_text='Atkin supports international students and accepts overseas degrees, subject to applicable Bar Standards Board and immigration requirements.',
    disability_support_text='Applicants may request reasonable adjustments for the recruitment process.',
    official_url='https://www.atkinchambers.com/join/pupillage/',
    application_url='https://www.atkinchambers.com/join/pupillage/how-to-apply-for-pupillage-at-atkin-chambers/',
    active=true,research_checked_on=date '2026-10-15',source_status_note=null,additional_details_text=null,updated_at=now()
where opportunity_id='a25ae20e-3dcf-4837-92eb-6af29547f663';

-- Remove the stale compensation row: it incorrectly assigned historical terms to a later cycle.
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id='a25ae20e-3dcf-4837-92eb-6af29547f663'
   or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='a25ae20e-3dcf-4837-92eb-6af29547f663');
delete from public.career_opportunity_compensation
where opportunity_id='a25ae20e-3dcf-4837-92eb-6af29547f663';

update public.career_opportunities
set slug='atkin-chambers-mini-pupillage-2027-dates',
    official_name='Atkin Chambers Mini-Pupillage — 2027 Dates',
    public_name='Atkin Chambers Mini-Pupillage — 2027 Dates',
    public_summary='Applications for Atkin Chambers’ one-day group mini-pupillages in 2027 open on 1 November 2026.',
    official_url='https://www.atkinchambers.com/join/mini-pupillage/',
    application_url='https://www.atkinchambers.com/join/mini-pupillage/',
    active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2026-11-01',updated_at=now()
where id='d8385d07-9081-4b58-94f2-ee983bcd6ac9';

update public.career_opportunity_cycles
set cycle_key='atkin-chambers-mini-pupillage-2027-dates',
    cycle_label='Atkin Chambers Mini-Pupillage — 2027 Dates',
    application_year=2026,programme_year=2027,intake_year=2027,
    application_model='fixed_deadline',opens_on=date '2026-11-01',opens_at=null,opens_timezone='Europe/London',
    closes_on=null,closes_at=null,closes_timezone='Europe/London',
    application_dates_text='Applications for the 2027 dates open on 1 November 2026.',
    programme_dates_text='At least two one-day group mini-pupillages will take place during 2027; applicants state their preferred date when applying.',
    date_precision='exact',duration_text='One day',places_text=null,source_status='upcoming',
    audience_text='Prospective pupillage applicants seeking experience of commercial construction and related work at the Bar.',
    study_stage_text='Applicants should normally be at least second-year law or third-year non-law students. GDL and BPC students are welcomed.',academic_criteria=null,
    eligibility_text='Mini-pupillage is unassessed and is not a prerequisite for applying for pupillage.',
    application_process_text='Email a CV and covering letter of no more than two pages to the Pupillage Committee Administrator at pupillage@atkinchambers.com and state a preferred attendance date.',
    assessments_text='The mini-pupillage is not assessed.',progression_route_text=null,
    expenses_text='Reasonable travel expenses are reimbursed. Overnight accommodation is considered case by case; requests should be raised when arranging the placement.',
    travel_support_text='Reasonable travel expenses are reimbursed.',
    accommodation_support_text='Overnight accommodation is considered case by case.',right_to_work_text=null,
    disability_support_text='Applicants may request reasonable adjustments for the day.',
    official_url='https://www.atkinchambers.com/join/mini-pupillage/',
    application_url='https://www.atkinchambers.com/join/mini-pupillage/',
    active=true,research_checked_on=date '2026-10-15',source_status_note=null,additional_details_text=null,updated_at=now()
where opportunity_id='d8385d07-9081-4b58-94f2-ee983bcd6ac9';

commit;
