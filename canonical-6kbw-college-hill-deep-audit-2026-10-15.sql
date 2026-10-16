begin;

update public.legal_organisations
set overview='6KBW College Hill is a London barristers’ chambers specialising in crime and related public and civil law. Its work includes homicide, terrorism, sexual offences, cybercrime, private prosecutions, proceeds of crime, corporate and financial crime, sanctions, extradition, mutual legal assistance, international law, contempt, human rights, immigration, inquests and inquiries, judicial review, information law, and police and prison law.',
    careers_url='https://6kbw.com/recruitment/pupillage/',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='f01cefda-57b2-475d-9e0b-67eaa8ef00d7';

update public.chambers
set pupillage_overview='6KBW College Hill recruits through the Pupillage Gateway. The confirmed 2027 application cycle is advertised from 23 November 2026, opens on 4 January 2027 and closes on 28 January 2027. The award for the 2026/27 application round is £57,000: a £28,500 first-six grant and £28,500 guaranteed minimum income during second six. Chambers also funds compulsory courses, qualifying travel outside the M25 and a book grant.',
    mini_pupillage_overview='Applications for mini-pupillage are welcomed throughout the year. The programme is open to people over 18 who have left school or sixth-form college, with priority for final-year university students, GDL, LPC or Bar-course students and graduates interested in the criminal Bar who do not already hold pupillage or a training contract. Applicants submit a CV, one-page covering letter and availability. Travel and accommodation are not reimbursed.',
    tenancy_overview='6KBW selects pupils in the hope and expectation that they will become tenants. Tenancy decisions are made in early autumn following structured assessment. A published former-pupil account describes six tenancy assessments across the year: three written and three oral, with the final advocacy assessment at the tenancy interview.',
    pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where organisation_id='f01cefda-57b2-475d-9e0b-67eaa8ef00d7';

-- Remove the historical undated event placeholder and the partner cycle that does not confirm a current 6KBW course allocation.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946') or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946'));
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunity_cycle_routes where opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunity_compensation where opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunity_locations where opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunity_routes where opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunity_scope_assignments where opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunity_identity_stage where career_opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunity_cycles where opportunity_id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');
delete from public.career_opportunities where id in ('bda853d3-e61e-4527-9564-42f0f44cd36a','23c633f0-f383-4dd3-b3bd-6158c52c6946');

update public.career_opportunities
set slug='6kbw-college-hill-pupillage-2027-application-cycle',official_name='6KBW College Hill Pupillage — 2027 Application Cycle',public_name='6KBW College Hill Pupillage — 2027 Application Cycle',
    public_summary='Apply through the Pupillage Gateway from 4 to 28 January 2027 for a 12-month pupillage with a £57,000 award and guaranteed-income package.',
    official_url='https://6kbw.com/recruitment/pupillage-application-details/',application_url='https://www.pupillagegateway.com/',research_checked_on=date '2026-10-15',next_review_on=date '2027-01-29',updated_at=now()
where id='1e036f3e-ff63-42d7-a39a-a217bb236037';

update public.career_opportunity_cycles
set cycle_label='6KBW College Hill Pupillage — 2027 Application Cycle',application_year=2027,programme_year=null,intake_year=null,
    application_model='fixed_deadline',opens_on=date '2027-01-04',opens_at=time '11:00',opens_timezone='Europe/London',closes_on=date '2027-01-28',closes_at=time '23:59',closes_timezone='Europe/London',date_precision='exact',source_status='upcoming',
    application_dates_text='The vacancy is advertised from 23 November 2026. Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
    programme_dates_text='First-round interviews take place in the weeks commencing 8 and 15 March 2027. The second round is on 3 April 2027. Offers are made on 7 May and initial offers must be accepted by 14 May 2027.',
    funding_text='£57,000 package: £28,500 first-six grant plus £28,500 guaranteed minimum second-six income. Chambers also funds compulsory courses, qualifying travel outside the M25 and a book grant.',
    expenses_text='Chambers pays qualifying travel expenses outside the M25 and funds compulsory courses and a book grant.',
    disability_support_text='Chambers’ equality policy commits it to reasonable adjustments throughout recruitment and pupillage.',
    official_url='https://6kbw.com/recruitment/pupillage-application-details/',application_url='https://www.pupillagegateway.com/',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='1e036f3e-ff63-42d7-a39a-a217bb236037';

update public.career_opportunity_compensation
set amount=57000,currency_code='GBP',frequency='total',amount_text='£57,000 pupillage funding package',
    details='£28,500 first-six grant plus £28,500 guaranteed minimum second-six income. Pupils keep earnings above the guarantee. Chambers also funds compulsory courses, qualifying travel outside the M25 and a book grant.',
    compensation_status='published_amount',source_status='current 2026/27 application round',updated_at=now()
where opportunity_id='1e036f3e-ff63-42d7-a39a-a217bb236037';

update public.career_opportunities
set official_name='6KBW College Hill Mini-Pupillage — Year-Round Applications',public_name='6KBW College Hill Mini-Pupillage — Year-Round Applications',
    public_summary='Apply throughout the year to shadow one or more members of 6KBW College Hill; placements are arranged according to availability.',research_checked_on=date '2026-10-15',next_review_on=date '2027-01-15',updated_at=now()
where id='3c430d05-36e6-46cf-aad1-4819257fe7ac';

update public.career_opportunity_cycles
set application_model='always_available',date_precision='text_only',duration_text='Shadowing placement arranged individually',source_status='open',
    programme_dates_text='Applications are accepted throughout the year and placement dates are arranged according to availability.',
    application_dates_text='Applications are accepted throughout the year.',
    assessments_text='Applications are double-marked by two members of chambers using the published selection criteria.',
    right_to_work_text=null,source_status_note=null,
    disability_support_text='Chambers particularly welcomes applicants from groups underrepresented at the criminal Bar and commits to reasonable adjustments.',
    application_process_text='Email Kir West-Hunter and Rachel Hughes, copying reception@6kbw.com, with a CV, one-page covering letter and dates of availability. Mitigating circumstances may be explained in the covering letter.',
    programme_structure_text='Mini-pupils shadow one or more members of chambers. Placement content and dates are arranged individually.',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='3c430d05-36e6-46cf-aad1-4819257fe7ac';

update public.career_opportunities
set official_name='6KBW College Hill Pupillage Open Evening 2026',public_name='6KBW College Hill Pupillage Open Evening 2026',
    public_summary='Free hybrid open evening for prospective barristers on 2 December 2026, with talks from current pupils and members, a Q&A and in-person networking.',
    delivery_mode='hybrid',official_url='https://6kbw.com/recruitment/pupillage-open-evening-2022/',application_url='https://6kbw.com/recruitment/pupillage-open-evening-2022/',active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2026-12-03',updated_at=now()
where id='c32e327e-f365-4dca-91ba-ea18719f80c6';

insert into public.career_opportunity_cycles
  (opportunity_id,cycle_key,cycle_label,programme_year,application_model,programme_starts_on,programme_ends_on,programme_dates_text,date_precision,duration_text,source_status,audience_text,eligibility_text,application_process_text,assessments_text,disability_support_text,official_url,application_url,active,research_checked_on,additional_details_text)
select 'c32e327e-f365-4dca-91ba-ea18719f80c6','6kbw-pupillage-open-evening-2026','6KBW College Hill Pupillage Open Evening 2026',2026,'rolling',date '2026-12-02',date '2026-12-02',
       '2 December 2026, 17:30–19:30, online and in person at 6KBW College Hill, 21 College Hill, London EC4R 2RP.','exact','Two hours','open',
       'People considering a career at the Bar, particularly those applying in the current or next pupillage application round.',
       'Open to people considering a career at the Bar. The event is free.',
       'Email events@6kbw.com and state whether you wish to attend in person or online. In-person places are limited and allocated first come, first served.',
       'Information event; no assessment.','Attendees may tell chambers about accessibility or other requirements when registering.',
       'https://6kbw.com/recruitment/pupillage-open-evening-2022/','https://6kbw.com/recruitment/pupillage-open-evening-2022/',true,date '2026-10-15',
       'The event includes talks from current pupils and members, an informal Q&A and in-person networking.'
where not exists(select 1 from public.career_opportunity_cycles where opportunity_id='c32e327e-f365-4dca-91ba-ea18719f80c6');

commit;
