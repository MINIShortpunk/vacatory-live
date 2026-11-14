begin;

-- Permanently remove an obsolete duplicate webinar shell and two undated direct-mini placeholders.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in
 ('9f4a3090-d3b7-4ced-b566-762e07b4087e','c6bda33f-bba0-4585-a980-569f16b5a188','cbdc20c5-1d70-49ae-bba3-ad30542fe6cc');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in
 ('9f4a3090-d3b7-4ced-b566-762e07b4087e','c6bda33f-bba0-4585-a980-569f16b5a188','cbdc20c5-1d70-49ae-bba3-ad30542fe6cc');
delete from public.career_opportunity_identity_stage where career_opportunity_id in
 ('9f4a3090-d3b7-4ced-b566-762e07b4087e','c6bda33f-bba0-4585-a980-569f16b5a188','cbdc20c5-1d70-49ae-bba3-ad30542fe6cc');
delete from public.career_opportunities where id in
 ('9f4a3090-d3b7-4ced-b566-762e07b4087e','c6bda33f-bba0-4585-a980-569f16b5a188','cbdc20c5-1d70-49ae-bba3-ad30542fe6cc');

update public.career_opportunities set
 official_name='Twenty Essex × 10,000 Black Interns — Summer 2027',
 public_name='Twenty Essex × 10,000 Black Interns — Summer 2027',
 public_summary='Paid summer internship programme for eligible Black students and recent graduates. Candidates apply centrally and may be allocated to a participating Bar organisation; a Twenty Essex placement is not guaranteed.',
 official_url='https://www.twentyessex.com/recruitment/pupillage/',
 application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='cae3ce43-2efd-4d4a-9f7f-997022d6e916';

update public.career_opportunity_cycles set
 cycle_key='twenty-essex-10000-black-interns-summer-2027',
 cycle_label='Twenty Essex × 10,000 Black Interns — Summer 2027',
 application_year=2026,programme_year=2027,intake_year=2027,application_model='fixed_deadline',
 opens_on=date '2026-10-05',closes_on=date '2026-11-01',
 application_dates_text='Applications open 5 October and close 1 November 2026.',
 programme_dates_text='Paid internships take place between May and September 2027, with timing determined by the allocated host.',
 date_precision='exact',duration_text='At least six weeks',source_status='open',
 audience_text='Eligible Black students and recent graduates seeking paid professional experience at the Bar.',
 study_stage_text='UK university students, gap-year students with a confirmed UK university place, and eligible recent UK university graduates.',
 academic_criteria=null,
 eligibility_text='Applicants must be aged 18 or over; be Black African, Black Caribbean, Black British or of mixed Black heritage; meet the programme’s UK university or recent-graduate criteria; not previously have secured a placement through the programme; and already hold an unrestricted right to work full-time in the UK.',
 application_process_text='Apply centrally to the Foundation, selecting relevant workstreams and a location. The Foundation allocates candidates to participating organisations, which conduct their own selection.',
 assessments_text='Central application followed by host-organisation selection for allocated candidates.',
 progression_route_text='Paid professional experience that can support later applications to the Bar.',
 funding_text='Each internship is paid at no less than the applicable Real Living Wage.',expenses_text=null,
 right_to_work_text='An unrestricted right to work full-time in the UK must already be in place when applying.',
 disability_support_text='Applicants can request reasonable adjustments through the programme application process.',
 programme_structure_text='A paid internship of at least six weeks with training, mentoring and host-organisation experience.',
 source_status_note=null,
 additional_details_text='Twenty Essex confirms participation. Allocation is managed centrally and a placement with Twenty Essex is not guaranteed.',
 official_url='https://www.twentyessex.com/recruitment/pupillage/',
 application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='cae3ce43-2efd-4d4a-9f7f-997022d6e916';

update public.career_opportunities set
 official_name='Bridging the Bar Academy 2027/28 — Twenty Essex Partner',
 public_name='Bridging the Bar Academy 2027/28 — Twenty Essex Partner',
 public_summary='Access programme providing mentoring, advocacy and application training and mini-pupillage opportunities through partner chambers. Twenty Essex provides nine Academy mini-pupillages each year; allocation to a particular chambers is not guaranteed.',
 official_url='https://www.twentyessex.com/recruitment/mini-pupillage/',
 application_url='https://bridgingthebar.org/academy-applications/',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-06',updated_at=now()
where id='076af755-a6b4-4039-9d79-f2085ba0e339';

update public.career_opportunity_cycles set
 cycle_key='bridging-the-bar-academy-2027-28-twenty-essex-partner',
 cycle_label='Bridging the Bar Academy 2027/28 — Twenty Essex Partner',
 application_year=2026,programme_year=2027,intake_year=2027,application_model='fixed_deadline',
 opens_on=date '2026-10-02',closes_on=date '2026-11-05',closes_at=time '17:00',closes_timezone='Europe/London',
 application_dates_text='Applications close at 17:00 on 5 November 2026.',
 programme_dates_text='The Academy runs from August 2027 to June 2028.',
 date_precision='exact',duration_text='August 2027 to June 2028',places_text='Twenty Essex provides nine mini-pupillage opportunities to Academy participants each year.',
 source_status='open',
 audience_text='Aspiring barristers eligible for the 2027/28 Bridging the Bar Academy.',
 study_stage_text='Applicants must be studying the Bar course during 2027/28 or have previously completed it, and intend to apply for pupillage in 2028.',
 academic_criteria='Selection considers academic achievement in context, understanding of a career at the Bar and commitment to the Academy.',
 eligibility_text='Applicants must meet the Academy’s published education, financial-support, UK-availability and programme-attendance requirements.',
 application_process_text='Apply through Bridging the Bar for the Academy. Mini-pupillage allocation is managed through the programme.',
 assessments_text='Written and video application assessed against the Academy’s published criteria.',
 progression_route_text='Academy participation includes mentoring, advocacy and application training and access to partner mini-pupillages.',
 expenses_text='Twenty Essex’s general mini-pupillage scheme provides a £120 contribution towards travel for in-chambers attendance.',
 right_to_work_text=null,source_status_note=null,
 additional_details_text='Twenty Essex is a partner set and supplies nine Academy mini-pupillages annually. Placement with a particular partner chambers is not guaranteed.',
 official_url='https://www.twentyessex.com/recruitment/mini-pupillage/',
 application_url='https://bridgingthebar.org/academy-applications/',
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='076af755-a6b4-4039-9d79-f2085ba0e339';

update public.career_opportunities set
 official_name='Twenty Essex Pupillage — 2027 Gateway Competition',
 public_name='Twenty Essex Pupillage — 2027 Gateway Competition',
 public_summary='Twelve-month commercial and public-international-law pupillage recruited through the Pupillage Gateway. Applicants must previously have completed or been offered a Twenty Essex mini-pupillage.',
 application_url='https://www.pupillagegateway.com/',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-21',updated_at=now()
where id='4e951c58-1d21-4775-8503-595ddb093bdf';

update public.career_opportunity_cycles set
 cycle_key='twenty-essex-pupillage-2027-gateway-competition',
 cycle_label='Twenty Essex Pupillage — 2027 Gateway Competition',
 application_year=2027,programme_year=null,intake_year=null,application_model='fixed_deadline',
 programme_dates_text=null,source_status='upcoming',
 audience_text='Aspiring commercial and public-international-law barristers who have completed or been offered a Twenty Essex mini-pupillage.',
 eligibility_text='Candidates must have completed, or been offered, a mini-pupillage at Twenty Essex before they can be considered for pupillage.',
 application_process_text='Apply through the Pupillage Gateway during the 2027 submission window.',
 assessments_text='Application review, mini-pupillage assessment, contextual recruitment data, an assessed written exercise and interview.',
 funding_text='£90,000 award, with up to £25,000 available for drawdown during the year before pupillage.',
 expenses_text='Twenty Essex pays compulsory-course costs and travel expenses to court or arbitration during pupillage.',
 progression_route_text='There is no predetermined tenancy quota; every pupil who reaches the required standard is offered tenancy.',
 right_to_work_text=null,source_status_note=null,additional_details_text=null,
 official_url='https://www.twentyessex.com/recruitment/pupillage/',application_url='https://www.pupillagegateway.com/',
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='4e951c58-1d21-4775-8503-595ddb093bdf';

update public.career_opportunities set research_checked_on=date '2026-10-15',next_review_on=date '2026-11-12',updated_at=now()
where id='f0d65de5-21a7-4166-a190-996272d98fc4';
update public.career_opportunity_cycles set
 audience_text='Students and prospective pupils interested in commercial pupillage.',
 application_process_text='Register through the official event page and submit questions for the panel when registering.',
 assessments_text='Registration only; this is an information webinar rather than a selection exercise.',
 programme_structure_text='A one-hour panel webinar covering commercial-pupillage applications, the selection process and life as a new tenant.',
 source_status_note=null,additional_details_text=null,research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='f0d65de5-21a7-4166-a190-996272d98fc4';

update public.career_opportunities set research_checked_on=date '2026-10-15',next_review_on=date '2026-11-26',updated_at=now()
where id='ad536a18-22db-43f4-b361-1904173cbbdb';
update public.career_opportunity_cycles set
 audience_text='Students and prospective pupils seeking practical advocacy guidance.',
 application_process_text='Register through the official event page and submit questions for the panel when registering.',
 assessments_text='Registration only; this is an advocacy webinar rather than a selection exercise.',
 programme_structure_text='A live webinar covering advocacy in pupillage applications and interviews, moots, court and arbitration, and presentation skills.',
 source_status_note=null,additional_details_text=null,research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='ad536a18-22db-43f4-b361-1904173cbbdb';

update public.legal_organisations set
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-21',
 uk_visa_status=null,uk_visa_summary=null,uk_visa_source_url=null,uk_visa_source_title=null,uk_visa_checked_on=null,updated_at=now()
where id='505df2f2-c4a6-491f-ad76-3c129d5c7dd5';

update public.chambers set
 pupillage_overview='Twenty Essex offers a twelve-month commercial and public-international-law pupillage with a £90,000 award, including up to £25,000 drawdown before pupillage. Applications are made through the Pupillage Gateway. Candidates must previously have completed or been offered a Twenty Essex mini-pupillage. Selection combines the written application, mini-pupillage assessment, contextual recruitment data, an assessed written exercise and interview.',
 mini_pupillage_overview='Twenty Essex offers around 60 assessed two-day mini-pupillages annually, normally split between placements from mid-September to January and from February to July. Its direct application schedule uses 30 June and 8 December deadlines; the specific dates currently stated on the official page relate to the 2025/26 cycle. Twenty Essex also provides nine mini-pupillages annually through the Bridging the Bar Academy. In-person mini-pupils receive a £120 travel contribution, and flexible or virtual arrangements may be available.',
 tenancy_overview='There is no predetermined tenancy quota: every pupil who reaches the required standard is offered tenancy. Lateral and established-practitioner recruitment are excluded from Vacatory.',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-21',updated_at=now()
where organisation_id='505df2f2-c4a6-491f-ad76-3c129d5c7dd5';

commit;
