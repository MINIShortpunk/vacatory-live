begin;

update public.legal_organisations set research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',
 uk_visa_status=null,uk_visa_summary=null,uk_visa_source_url=null,uk_visa_source_title=null,uk_visa_checked_on=null,updated_at=now()
where id='15dc4e54-dd71-4768-923d-cf403c959d86';

update public.chambers set
 pupillage_overview='St Philips runs a direct annual specialist pupillage competition aligned with the Pupillage Gateway timetable but does not accept applications through the Gateway portal. Applications for pupillages commencing in 2028 open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027. The latest published package is £50,000: £25,000 paid over the first eight months and a £25,000 second-six billing guarantee. Pupillage lasts 12 months and is offered where a tenancy opportunity is available.',
 mini_pupillage_overview='St Philips offers three-day Birmingham mini-pupillages during 2027. Applications opened on 12 October 2026 and close at 17:00 on 6 November 2026. Applicants must be at least in their second undergraduate year; career changers may also apply. Mini-pupils shadow barristers and attend court, normally within a preferred specialist practice area where operationally possible.',
 tenancy_overview='St Philips offers specialist pupillages where a tenancy opportunity is available. Vacatory lists student and aspiring-barrister routes only; probationary tenancy and established-practitioner recruitment are excluded.',
 pupillage_gateway_member=false,pupillage_gateway_url=null,pupil_count=6,
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',updated_at=now()
where organisation_id='15dc4e54-dd71-4768-923d-cf403c959d86';

delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='259f2b59-fec2-4f3a-ba33-d3855d40d9fa';
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='259f2b59-fec2-4f3a-ba33-d3855d40d9fa';
delete from public.career_opportunity_identity_stage where career_opportunity_id='259f2b59-fec2-4f3a-ba33-d3855d40d9fa';
delete from public.career_opportunities where id='259f2b59-fec2-4f3a-ba33-d3855d40d9fa';

update public.career_opportunities set
 public_summary='Three-day Birmingham mini-pupillages during 2027; applications close at 17:00 on 6 November 2026.',
 application_url='mailto:hr@st-philips.com',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-07',updated_at=now()
where id='2722942f-346c-48d7-9538-134205257f5d';

update public.career_opportunity_cycles set cycle_key='st-philips-mini-pupillage-2027',cycle_label='St Philips Chambers Mini-Pupillage — 2027 Placements',
 opens_on=date '2026-10-12',opens_timezone='Europe/London',closes_on=date '2026-11-06',closes_at=time '17:00',closes_timezone='Europe/London',
 application_dates_text='Applications opened on 12 October 2026 and close at 17:00 on 6 November 2026.',date_precision='exact',source_status='open',
 audience_text='Applicants in at least the second year of an undergraduate degree and career changers.',
 study_stage_text='At least second-year undergraduate level; career changers may also apply.',
 eligibility_text='Applicants must be in at least the second year of an undergraduate degree or be able to explain how experience from another career transfers to the Bar. St Philips particularly welcomes applicants with limited previous mini-pupillage experience and a genuine commitment to practising in Birmingham.',
 application_process_text='Email the completed application form and Equal Opportunities Monitoring Form to hr@st-philips.com by the deadline, including availability for placements during 2027 in the email body.',
 assessments_text='Written application form.',progression_route_text='The placement provides insight into practice at the Bar and St Philips’ specialist groups.',
 expenses_text=null,right_to_work_text=null,source_status_note=null,application_url='mailto:hr@st-philips.com',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='2722942f-346c-48d7-9538-134205257f5d';

update public.career_opportunity_compensation set amount_text='Three-day work-experience placement.',details='No payment forms part of the placement.',compensation_status='unpaid',updated_at=now()
where opportunity_id='2722942f-346c-48d7-9538-134205257f5d';

update public.career_opportunities set
 public_summary='Specialist 12-month pupillage at St Philips Chambers commencing in 2028, offered where a tenancy opportunity is available.',
 application_url='https://st-philips.com/pupillage/',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',updated_at=now()
where id='910b228a-07c7-45e7-8cf4-9e701d25c6ea';

update public.career_opportunity_cycles set cycle_key='st-philips-pupillage-2028',cycle_label='St Philips Chambers Pupillage — 2028 Start',
 application_process_text='Apply directly through the official St Philips pupillage page during the application window. St Philips follows the Gateway timetable but does not use the Gateway portal.',
 assessments_text='Written application, first-round interview and final-round interview. Written applications are name-blinded.',
 funding_text='Latest published package: £50,000, comprising £25,000 paid over the first eight months and a £25,000 second-six billing guarantee. St Philips also pays compulsory pupillage-course costs and provides a substantial specialist practitioner text after satisfactory completion of the first six.',
 expenses_text='St Philips pays compulsory pupillage-course costs and provides one substantial specialist practitioner text after satisfactory completion of the first six.',
 disability_support_text='St Philips recruits on merit, promotes equality of opportunity and accepts requests for reasonable adjustments.',
 right_to_work_text=null,source_status_note=null,official_url='https://st-philips.com/pupillage/',application_url='https://st-philips.com/pupillage/',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='910b228a-07c7-45e7-8cf4-9e701d25c6ea';

commit;
