begin;

-- Permanently remove practitioner CPD/conferences and the undated open-evening placeholder.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in
 ('6d1f3efd-a4ca-4045-b345-e5a33e4fa6ed','d8ae6d43-9318-4bbe-b522-40428621db20','08c6212f-dc9f-466c-baad-d60c9f9ea7a8','8e0e8d52-cc65-4c78-b3bb-02ec32113028');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in
 ('6d1f3efd-a4ca-4045-b345-e5a33e4fa6ed','d8ae6d43-9318-4bbe-b522-40428621db20','08c6212f-dc9f-466c-baad-d60c9f9ea7a8','8e0e8d52-cc65-4c78-b3bb-02ec32113028');
delete from public.career_opportunity_identity_stage where career_opportunity_id in
 ('6d1f3efd-a4ca-4045-b345-e5a33e4fa6ed','d8ae6d43-9318-4bbe-b522-40428621db20','08c6212f-dc9f-466c-baad-d60c9f9ea7a8','8e0e8d52-cc65-4c78-b3bb-02ec32113028');
delete from public.career_opportunities where id in
 ('6d1f3efd-a4ca-4045-b345-e5a33e4fa6ed','d8ae6d43-9318-4bbe-b522-40428621db20','08c6212f-dc9f-466c-baad-d60c9f9ea7a8','8e0e8d52-cc65-4c78-b3bb-02ec32113028');

update public.career_opportunities set
 official_name='10,000 Black Interns — Summer 2027 — Trinity Chambers Participant',
 public_name='10,000 Black Interns — Summer 2027 — Trinity Chambers Participant',
 public_summary='Paid summer internship programme for eligible Black students and recent graduates. Candidates apply centrally and may be allocated to a participating employer; a Trinity placement is not guaranteed.',
 official_url='https://www.trinitychambers.co.uk/about/',
 application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='12b397eb-d202-49a8-acd5-331a458ca782';

update public.career_opportunity_cycles set
 cycle_key='trinity-10000-black-interns-summer-2027',
 cycle_label='10,000 Black Interns — Summer 2027 — Trinity Chambers Participant',
 application_year=2026,programme_year=2027,intake_year=2027,
 application_model='fixed_deadline',opens_on=date '2026-10-05',closes_on=date '2026-11-01',
 application_dates_text='Applications open 5 October and close 1 November 2026.',
 programme_dates_text='Paid internships take place between May and September 2027, with timing determined by the allocated host.',
 date_precision='exact',duration_text='At least six weeks',source_status='open',
 audience_text='Eligible Black students and recent graduates seeking paid professional experience, including in law.',
 study_stage_text='UK university students, gap-year students with a confirmed UK university place, and eligible recent UK university graduates.',
 academic_criteria=null,
 eligibility_text='Applicants must be aged 18 or over; be Black African, Black Caribbean, Black British or of mixed Black heritage; meet the programme’s UK university or recent-graduate criteria; not previously have secured a placement through the programme; and already hold an unrestricted right to work full-time in the UK.',
 application_process_text='Apply centrally to the Foundation, selecting up to three workstreams and a location. The Foundation allocates candidates to participating employers, which conduct their own selection.',
 assessments_text='Central application followed by host-employer selection for allocated candidates.',
 funding_text='Each internship is paid at no less than the applicable Real Living Wage.',
 expenses_text=null,
 progression_route_text='Paid professional experience that can support later applications to the Bar.',
 disability_support_text='Applicants can request reasonable adjustments through the programme application process.',
 programme_structure_text='A paid internship of at least six weeks with training, mentoring and host-employer experience.',
 right_to_work_text='An unrestricted right to work full-time in the UK must already be in place when applying.',
 source_status_note=null,
 additional_details_text='Trinity confirms participation. Employer allocation is managed centrally and a placement with Trinity is not guaranteed.',
 official_url='https://www.trinitychambers.co.uk/about/',
 application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='12b397eb-d202-49a8-acd5-331a458ca782';

update public.career_opportunities set
 public_summary='Three-day assessed mini-pupillage based primarily in Newcastle, with Leeds preferences considered, for placements in March, April or August 2027.',
 application_url='mailto:mini.pupil@trinitychambers.co.uk',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-12-21',updated_at=now()
where id='c63b9dcd-a022-44dd-9c09-958701ac8930';

update public.career_opportunity_cycles set
 cycle_key='trinity-mini-pupillage-march-april-august-2027',
 application_year=2026,programme_year=2027,intake_year=2027,application_model='fixed_deadline',
 duration_text='Three days',places_text='Approximately 20–24 places are offered annually across both application windows.',
 audience_text='People aged 18 or over considering a career at the Bar, predominantly university students studying a legal discipline.',
 study_stage_text='Applicants must be aged 18 or over and must not be enrolled in secondary education.',
 eligibility_text='Selection considers academic achievement, commitment to a legal career and extracurricular achievement.',
 application_process_text='Email a cover letter of no more than one A4 page and a CV of no more than two A4 pages as PDF or Word attachments to mini.pupil@trinitychambers.co.uk.',
 assessments_text='Application review followed by one assessed written exercise during the mini-pupillage.',
 expenses_text='Travel expenses are not reimbursed.',
 application_url='mailto:mini.pupil@trinitychambers.co.uk',source_status_note=null,
 additional_details_text='Newcastle is the default base. Applicants may request Leeds, subject to availability.',
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='c63b9dcd-a022-44dd-9c09-958701ac8930';

update public.career_opportunities set
 public_summary='Three-day assessed mini-pupillage based primarily in Newcastle, with Leeds preferences considered, for placements in October or November 2027.',
 application_url='mailto:mini.pupil@trinitychambers.co.uk',
 research_checked_on=date '2026-10-15',next_review_on=date '2027-06-21',updated_at=now()
where id='4c81e504-4f9d-45c2-a009-abd7ec1f9a0a';

update public.career_opportunity_cycles set
 cycle_key='trinity-mini-pupillage-october-november-2027',
 cycle_label='Trinity Chambers Mini-Pupillage — October and November 2027',
 application_year=2027,programme_year=2027,intake_year=2027,application_model='fixed_deadline',
 application_dates_text='Applications open 20 May and close 20 June 2027.',
 programme_dates_text='Placements take place in October or November 2027.',
 duration_text='Three days',places_text='Approximately 20–24 places are offered annually across both application windows.',
 audience_text='People aged 18 or over considering a career at the Bar, predominantly university students studying a legal discipline.',
 study_stage_text='Applicants must be aged 18 or over and must not be enrolled in secondary education.',
 eligibility_text='Selection considers academic achievement, commitment to a legal career and extracurricular achievement.',
 application_process_text='Email a cover letter of no more than one A4 page and a CV of no more than two A4 pages as PDF or Word attachments to mini.pupil@trinitychambers.co.uk.',
 assessments_text='Application review followed by one assessed written exercise during the mini-pupillage.',
 expenses_text='Travel expenses are not reimbursed.',
 application_url='mailto:mini.pupil@trinitychambers.co.uk',source_status_note=null,
 additional_details_text='Newcastle is the default base. Applicants may request Leeds, subject to availability.',
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='4c81e504-4f9d-45c2-a009-abd7ec1f9a0a';

update public.career_opportunities set
 slug='trinity-chambers-pupillage-2027-gateway-competition',
 official_name='Trinity Chambers Pupillage — 2027 Gateway Competition',
 public_name='Trinity Chambers Pupillage — 2027 Gateway Competition',
 public_summary='Twelve-month pupillage competition administered through the Pupillage Gateway. Trinity generally recruits several pupils across its principal practice groups.',
 application_url='https://www.pupillagegateway.com/',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-21',updated_at=now()
where id='e934a70c-77c3-4d83-ab02-9e1eb7abb4c1';

update public.career_opportunity_cycles set
 cycle_key='trinity-pupillage-2027-gateway-competition',
 cycle_label='Trinity Chambers Pupillage — 2027 Gateway Competition',
 application_year=2027,programme_year=null,intake_year=null,application_model='fixed_deadline',
 programme_dates_text=null,
 places_text='Trinity generally offers several twelve-month pupillages each year.',
 source_status='upcoming',
 audience_text='Aspiring barristers applying through the Pupillage Gateway.',
 application_process_text='Apply through the Pupillage Gateway after Trinity’s vacancy adverts are released on 20 November 2026.',
 assessments_text='Written application sift followed by two interview rounds and an advocacy exercise.',
 funding_text='£40,000 package: £15,000 award during the first six months and £25,000 guaranteed earnings during the second six.',
 progression_route_text='Pupillages are generally offered where there is potential for tenancy at the end of the twelve-month programme.',
 right_to_work_text=null,source_status_note=null,
 additional_details_text=null,
 official_url='https://www.trinitychambers.co.uk/join-us/pupillage/',
 application_url='https://www.pupillagegateway.com/',
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='e934a70c-77c3-4d83-ab02-9e1eb7abb4c1';

update public.legal_organisations set
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-21',
 uk_visa_status=null,uk_visa_summary=null,uk_visa_source_url=null,uk_visa_source_title=null,uk_visa_checked_on=null,
 updated_at=now()
where id='eb439a7d-d286-4533-b9a1-504ba82e5077';

update public.chambers set
 pupillage_overview='Trinity generally offers several twelve-month pupillages annually through the Pupillage Gateway. Applications in the 2027 competition open at 11:00 on 4 January and close at 23:59 on 28 January 2027. The latest published award is £40,000: £15,000 during the first six and £25,000 guaranteed earnings during the second six. Selection uses a written sift, two interviews and an advocacy exercise. Pupillages are generally offered where tenancy potential exists.',
 mini_pupillage_overview='Three-day assessed mini-pupillages are offered in March, April, August, October and November, with approximately 20–24 places annually. Applications run from 20 November to 20 December for March, April and August placements and from 20 May to 20 June for October and November placements. Newcastle is the default base, with Leeds preferences considered subject to availability.',
 tenancy_overview='Pupillages are generally offered where there is potential for tenancy after twelve months. Established-practitioner, lateral and staff recruitment are excluded from Vacatory.',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-21',updated_at=now()
where organisation_id='eb439a7d-d286-4533-b9a1-504ba82e5077';

commit;
