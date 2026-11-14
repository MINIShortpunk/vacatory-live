begin;

-- Remove an ordinary Keoghs employment vacancy and a duplicate Linklaters event record.
delete from career_opportunities
where (organisation_id='529b3364-d68e-4fd2-ab57-e9d1f8143831' and slug='keoghs-trainee-solicitor-casualty-glasgow')
   or (organisation_id='ac224d68-0fc9-49dc-8e37-2b48f334fdeb' and slug='linklaters-partner-panel');

-- Correct Linklaters student events that were incorrectly feeding into deadlines.
update career_opportunities set event_type_id=case slug
 when 'linklaters-pov-london-3-26' then '2359f5e3-a80c-4023-b18d-569d4c471220'::uuid
 when 'linklaters-asia-insight-event-26' then 'f2ad34e9-2e06-4dd6-8c0e-a20ec0e597a3'::uuid
 when 'linklaters-legal-cheek-fair-nov' then '0565330b-8f5f-45ff-9314-1f3b25ebf243'::uuid
 when 'linklaters-exeter-fair-26' then '0565330b-8f5f-45ff-9314-1f3b25ebf243'::uuid
 when 'linklaters-explore-26' then 'f2ad34e9-2e06-4dd6-8c0e-a20ec0e597a3'::uuid
 end, updated_at=now(), research_checked_on=date '2026-11-07'
where organisation_id='ac224d68-0fc9-49dc-8e37-2b48f334fdeb'
and slug in ('linklaters-pov-london-3-26','linklaters-asia-insight-event-26','linklaters-legal-cheek-fair-nov','linklaters-exeter-fair-26','linklaters-explore-26');

-- Latham 2028 programmes are open and close at 17:00 ET on 29 January 2027.
update career_opportunity_cycles c set
 closes_at=time '17:00', closes_timezone='America/New_York', source_status='open',
 application_dates_text='Applications opened 1 November 2026 and close 29 January 2027 at 17:00 ET.',
 research_checked_on=date '2026-11-07', updated_at=now()
from career_opportunities o
where c.opportunity_id=o.id and o.organisation_id='586f796b-fffd-4c09-8d74-481b7c206b05'
and o.slug in ('hong-kong-us-law-students-summer-program-2028','london-us-law-students-summer-program-2028',
 'texas-1l-2l-summer-associate-program-2027-2028','us-2l-summer-associate-program-2028');

-- New structured opportunities.
insert into career_opportunities
(organisation_id,opportunity_type_id,slug,official_name,public_name,english_name,language_code,public_summary,delivery_mode,
 official_url,application_url,active,published,display_order,research_checked_on,next_review_on,updated_at)
values
('101cb37a-a6df-48f6-92dd-6e6e0b7c6b79','a137274a-0cec-444b-8296-a6c16d30d116','bristol-graduate-solicitor-apprenticeship-2027',
 'Bristol 2027 Professional Liability Graduate Solicitor Apprenticeship','Bristol 2027 Professional Liability Graduate Solicitor Apprenticeship','Bristol 2027 Professional Liability Graduate Solicitor Apprenticeship','en',
 'A 33-month graduate solicitor apprenticeship in Kennedys’ Bristol Professional Liability team, combining qualifying work experience with fully funded study.','in_person',
 'https://careers.kennedyslaw.com/jobs/vacancy/bristol-2027-professional-liability-graduate-solicitor-apprenticeship---2168-bristol/2186/description/',
 'https://careers.kennedyslaw.com/jobs/vacancy/bristol-2027-professional-liability-graduate-solicitor-apprenticeship---2168-bristol/2186/description/',true,true,30,date '2026-11-07',date '2026-11-30',now()),
('101cb37a-a6df-48f6-92dd-6e6e0b7c6b79','a137274a-0cec-444b-8296-a6c16d30d116','leeds-graduate-solicitor-apprenticeship-2027',
 'Leeds 2027 Professional Liability Graduate Solicitor Apprenticeship','Leeds 2027 Professional Liability Graduate Solicitor Apprenticeship','Leeds 2027 Professional Liability Graduate Solicitor Apprenticeship','en',
 'A 33-month graduate solicitor apprenticeship in Kennedys’ Leeds Professional Liability team, combining qualifying work experience with fully funded study.','in_person',
 'https://careers.kennedyslaw.com/jobs/vacancy/leeds-2027-professional-liability-graduate-solicitor-apprenticeship---2171-leeds/2189/description/',
 'https://careers.kennedyslaw.com/jobs/vacancy/leeds-2027-professional-liability-graduate-solicitor-apprenticeship---2171-leeds/2189/description/',true,true,31,date '2026-11-07',date '2026-11-30',now()),
('101cb37a-a6df-48f6-92dd-6e6e0b7c6b79','a137274a-0cec-444b-8296-a6c16d30d116','london-aviation-graduate-solicitor-apprenticeship-2027',
 'London 2027 Aviation Graduate Solicitor Apprenticeship','London 2027 Aviation Graduate Solicitor Apprenticeship','London 2027 Aviation Graduate Solicitor Apprenticeship','en',
 'A 33-month graduate solicitor apprenticeship in Kennedys’ London Aviation team, combining qualifying work experience with fully funded study.','hybrid',
 'https://careers.kennedyslaw.com/jobs/vacancy/london-2027-aviation-graduate-solicitor-apprenticeship-2281-london/2299/description/',
 'https://careers.kennedyslaw.com/jobs/vacancy/london-2027-aviation-graduate-solicitor-apprenticeship-2281-london/2299/description/',true,true,32,date '2026-11-07',date '2026-11-30',now()),
('101cb37a-a6df-48f6-92dd-6e6e0b7c6b79','4dc7a4dd-fd5c-44be-bdd6-0842cb8aada8','singapore-relevant-legal-training-2027',
 'Relevant Legal Training 2027','Singapore Relevant Legal Training 2027','Singapore Relevant Legal Training 2027','en',
 'Kennedys Legal Solutions’ structured Singapore relevant legal training route for eligible law graduates with relevant internship experience.','in_person',
 'https://careers.kennedyslaw.com/jobs/vacancy/relevant-legal-training-rlt-2027-2193-singapore/2211/description/',
 'https://careers.kennedyslaw.com/jobs/vacancy/relevant-legal-training-rlt-2027-2193-singapore/2211/description/',true,true,33,date '2026-11-07',date '2026-12-01',now()),
('ac224d68-0fc9-49dc-8e37-2b48f334fdeb','a137274a-0cec-444b-8296-a6c16d30d116','solicitor-apprenticeship-2027',
 'Solicitor Apprenticeship 2027','Solicitor Apprenticeship 2027','Solicitor Apprenticeship 2027','en',
 'Linklaters’ six-year London solicitor apprenticeship for Year 13 students and school leavers without a university degree.','in_person',
 'https://www.linklaters.com/careers/early-careers/solicitor-apprenticeships','https://linklaters.app.candidats.io/',true,true,30,date '2026-11-07',date '2027-02-12',now()),
('586f796b-fffd-4c09-8d74-481b7c206b05','68a7f54d-c4da-433d-882f-c9d4a8bfb894','singapore-us-law-students-summer-program-2028',
 'Singapore Summer Program for US Law Students 2028','Singapore Summer Program for US Law Students 2028','Singapore Summer Program for US Law Students 2028','en',
 'A ten-week Singapore summer programme for Class of 2029 students enrolled at ABA-accredited US law schools, with accommodation provided.','in_person',
 'https://www.lwcareers.com/en/beginning-your-legal-career/singapore/singapore-summer-program-for-us-law-students',
 'https://www.lwcareers.com/en/beginning-your-legal-career/united-states/summer-associates',true,true,30,date '2026-11-07',date '2027-01-29',now())
on conflict(organisation_id,slug) do update set public_summary=excluded.public_summary,official_url=excluded.official_url,
 application_url=excluded.application_url,active=true,published=true,research_checked_on=excluded.research_checked_on,
 next_review_on=excluded.next_review_on,updated_at=now();

-- Cycles for the three Kennedys apprenticeships.
insert into career_opportunity_cycles
(opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,closes_on,application_dates_text,
 programme_dates_text,date_precision,duration_text,source_status,source_status_note,audience_text,study_stage_text,eligibility_text,
 funding_text,right_to_work_text,official_url,application_url,active,research_checked_on,updated_at)
select o.id,'2027',o.official_name,2026,2027,'fixed_deadline',date '2026-11-30',
 'Applications close 30 November 2026. Kennedys does not publish a closing time.',
 'The graduate solicitor apprenticeship lasts 33 months; an exact start date is not published.','exact','33 months','open',
 'The official vacancy is accepting applications.','Law graduates and non-law graduates who have completed a GDL or PGDL.','Graduate.',
 'Applicants need a law degree, or a non-law degree plus successful completion of the GDL or PGDL.',
 'Kennedys fully funds the programme’s study requirements.','See the individual official vacancy for work-right and sponsorship conditions.',
 o.official_url,o.application_url,true,date '2026-11-07',now()
from career_opportunities o
where o.organisation_id='101cb37a-a6df-48f6-92dd-6e6e0b7c6b79'
and o.slug in ('bristol-graduate-solicitor-apprenticeship-2027','leeds-graduate-solicitor-apprenticeship-2027','london-aviation-graduate-solicitor-apprenticeship-2027')
and not exists(select 1 from career_opportunity_cycles c where c.opportunity_id=o.id);

-- Kennedys Singapore RLT cycle.
insert into career_opportunity_cycles
(opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,application_dates_text,programme_dates_text,
 date_precision,source_status,source_status_note,audience_text,study_stage_text,eligibility_text,right_to_work_text,official_url,
 application_url,active,research_checked_on,updated_at)
select o.id,'2027',o.official_name,2026,2027,'rolling','Applications are open; no deadline or closing time is published.',
 'Relevant Legal Training in Singapore during 2027; an exact start date is not published.','year','open','The official vacancy is accepting applications.',
 'Eligible law graduates with relevant internship experience.','Graduate.','A Second-Upper or Cum Laude degree or higher and relevant internship experience; overseas degrees must satisfy Singapore Ministry of Law rules.',
 'Applicants must have the right to work in Singapore.',o.official_url,o.application_url,true,date '2026-11-07',now()
from career_opportunities o where o.organisation_id='101cb37a-a6df-48f6-92dd-6e6e0b7c6b79' and o.slug='singapore-relevant-legal-training-2027'
and not exists(select 1 from career_opportunity_cycles c where c.opportunity_id=o.id);

-- Linklaters apprenticeship cycle.
insert into career_opportunity_cycles
(opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,closes_on,
 application_dates_text,programme_dates_text,date_precision,duration_text,source_status,audience_text,study_stage_text,eligibility_text,
 official_url,application_url,active,research_checked_on,updated_at)
select o.id,'2027',o.official_name,2026,2027,2027,'fixed_deadline',date '2026-10-20',date '2027-02-12',
 'Applications opened 20 October 2026 and close 12 February 2027. No closing time is published.',
 'Six-year solicitor apprenticeship; the exact 2027 start date is not published.','exact','Six years','open',
 'Year 13 students and school leavers without a university degree.','School leaver.','Applicants must not already hold a university degree; see the official page for full academic criteria.',
 o.official_url,o.application_url,true,date '2026-11-07',now()
from career_opportunities o where o.organisation_id='ac224d68-0fc9-49dc-8e37-2b48f334fdeb' and o.slug='solicitor-apprenticeship-2027'
and not exists(select 1 from career_opportunity_cycles c where c.opportunity_id=o.id);

-- Latham Singapore 2028 US-law-student programme cycle.
insert into career_opportunity_cycles
(opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,opens_on,closes_on,closes_at,closes_timezone,
 application_dates_text,programme_dates_text,date_precision,duration_text,source_status,audience_text,study_stage_text,eligibility_text,
 accommodation_support_text,official_url,application_url,active,research_checked_on,updated_at)
select o.id,'2028',o.official_name,2026,2028,'fixed_deadline',date '2026-11-01',date '2027-01-29',time '17:00','America/New_York',
 'Applications opened 1 November 2026 and close 29 January 2027 at 17:00 ET.',
 'Ten-week Singapore programme in 2028; exact programme dates are not published.','exact','Ten weeks','open',
 'Class of 2029 students at ABA-accredited US law schools.','First-year US law student.','Applicants should want to practise in Asia long term and have an interest in corporate or finance work.',
 'Accommodation is provided.',o.official_url,o.application_url,true,date '2026-11-07',now()
from career_opportunities o where o.organisation_id='586f796b-fffd-4c09-8d74-481b7c206b05' and o.slug='singapore-us-law-students-summer-program-2028'
and not exists(select 1 from career_opportunity_cycles c where c.opportunity_id=o.id);

-- Latham virtual student event.
insert into career_opportunities
(organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,english_name,language_code,public_summary,delivery_mode,
 official_url,application_url,active,published,display_order,research_checked_on,next_review_on,updated_at)
values ('586f796b-fffd-4c09-8d74-481b7c206b05','5e2816dd-108f-4443-9fb2-218def79147f','0300485e-aa81-437d-9318-57fbcba0eda5',
 'latham-live-elevator-pitch-interviews-2026','Latham Live: Developing Your Elevator Pitch & Preparing for Interviews',
 'Latham Live: Developing Your Elevator Pitch & Preparing for Interviews','Latham Live: Developing Your Elevator Pitch & Preparing for Interviews','en',
 'A free virtual student session on presenting an elevator pitch, interview preparation and Latham’s recruiting programmes.','virtual',
 'https://www.lwcareers.com/en/beginning-your-legal-career/events','https://engage.lwcareers.com/',true,true,10,date '2026-11-07',date '2026-11-19',now())
on conflict(organisation_id,slug) do update set event_type_id=excluded.event_type_id,public_summary=excluded.public_summary,
 official_url=excluded.official_url,application_url=excluded.application_url,active=true,published=true,
 research_checked_on=excluded.research_checked_on,next_review_on=excluded.next_review_on,updated_at=now();

insert into career_opportunity_cycles
(opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,programme_starts_on,programme_ends_on,
 application_dates_text,programme_dates_text,date_precision,source_status,source_status_note,audience_text,study_stage_text,
 official_url,application_url,active,research_checked_on,updated_at)
select o.id,'2026-11-19',o.official_name,2026,2026,'rolling',date '2026-11-19',date '2026-11-19',
 'Registration is available through the official event page; no registration deadline is published.',
 '19 November 2026, 12:00–13:00 ET (17:00–18:00 UK time), virtual.','exact','open','The official events page currently provides a registration link.',
 'Law students and aspiring lawyers.','Law student or aspiring lawyer.',o.official_url,o.application_url,true,date '2026-11-07',now()
from career_opportunities o where o.organisation_id='586f796b-fffd-4c09-8d74-481b7c206b05' and o.slug='latham-live-elevator-pitch-interviews-2026'
and not exists(select 1 from career_opportunity_cycles c where c.opportunity_id=o.id);

-- Locations ensure country flags and city filters remain available.
insert into career_opportunity_locations(opportunity_id,cycle_id,country_id,city_id,location_note,display_order,location_role,location_status)
select o.id,c.id,v.country_id,v.city_id,v.note,10,'programme','confirmed'
from career_opportunities o join career_opportunity_cycles c on c.opportunity_id=o.id
join (values
 ('bristol-graduate-solicitor-apprenticeship-2027',47,117,'Bristol, United Kingdom'),
 ('leeds-graduate-solicitor-apprenticeship-2027',47,134,'Leeds, United Kingdom'),
 ('london-aviation-graduate-solicitor-apprenticeship-2027',47,139,'London, United Kingdom'),
 ('singapore-relevant-legal-training-2027',37,92,'Singapore'),
 ('solicitor-apprenticeship-2027',47,139,'London, United Kingdom'),
 ('singapore-us-law-students-summer-program-2028',37,92,'Singapore')
) v(slug,country_id,city_id,note) on v.slug=o.slug
where o.organisation_id in ('101cb37a-a6df-48f6-92dd-6e6e0b7c6b79','ac224d68-0fc9-49dc-8e37-2b48f334fdeb','586f796b-fffd-4c09-8d74-481b7c206b05')
and not exists(select 1 from career_opportunity_locations l where l.opportunity_id=o.id and l.cycle_id=c.id and l.city_id=v.city_id);

commit;
