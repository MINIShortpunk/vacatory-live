begin;

delete from public.vacation_schemes
where organisation_id='b42f1999-d811-4a3c-b624-44a342ede9ae'
   or firm_id='b42f1999-d811-4a3c-b624-44a342ede9ae';

delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in (
  '5f3cd6ae-cb03-4b9d-bde2-89a9f37bfd61',
  'e2ceccc5-9863-4dc2-901a-86dfc3f7e990',
  'ddc6d481-42d0-4474-b407-fe22b60521ab',
  '3e0751d1-9ec7-411e-9963-d18c9409f286',
  'e39a149b-e3e3-4cb5-a24f-9b0036f69882',
  '528b8bf7-8c74-4b78-ab9c-515c5b5f8526'
);
delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in (
  '5f3cd6ae-cb03-4b9d-bde2-89a9f37bfd61',
  'e2ceccc5-9863-4dc2-901a-86dfc3f7e990',
  'ddc6d481-42d0-4474-b407-fe22b60521ab',
  '3e0751d1-9ec7-411e-9963-d18c9409f286',
  'e39a149b-e3e3-4cb5-a24f-9b0036f69882',
  '528b8bf7-8c74-4b78-ab9c-515c5b5f8526'
);
delete from public.career_opportunity_identity_stage
where career_opportunity_id in (
  '5f3cd6ae-cb03-4b9d-bde2-89a9f37bfd61',
  'e2ceccc5-9863-4dc2-901a-86dfc3f7e990',
  'ddc6d481-42d0-4474-b407-fe22b60521ab',
  '3e0751d1-9ec7-411e-9963-d18c9409f286',
  'e39a149b-e3e3-4cb5-a24f-9b0036f69882',
  '528b8bf7-8c74-4b78-ab9c-515c5b5f8526'
);
delete from public.career_opportunities
where id in (
  '5f3cd6ae-cb03-4b9d-bde2-89a9f37bfd61',
  'e2ceccc5-9863-4dc2-901a-86dfc3f7e990',
  'ddc6d481-42d0-4474-b407-fe22b60521ab',
  '3e0751d1-9ec7-411e-9963-d18c9409f286',
  'e39a149b-e3e3-4cb5-a24f-9b0036f69882',
  '528b8bf7-8c74-4b78-ab9c-515c5b5f8526'
);

update public.career_opportunities set
 official_name='Outer Temple Chambers Student Work Experience',
 public_name='Outer Temple Chambers Student Work Experience',
 public_summary='Student work-experience placements offered at points throughout the year. Enquiries are made directly to Chambers.',
 official_url='https://www.outertemple.com/join-our-team/',
 application_url='https://www.outertemple.com/join-our-team/',
 active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2027-01-15',updated_at=now()
where id='3c2c9104-34c1-4305-ba26-7e64b71a8dc9';

update public.career_opportunity_cycles set
 cycle_key='outer-temple-student-work-experience-rolling',
 cycle_label='Outer Temple Chambers Student Work Experience — Rolling Enquiries',
 application_model='rolling',opens_on=null,closes_on=null,
 application_dates_text='Enquiries are accepted throughout the year through the contact route on the official page.',
 programme_dates_text='Placements are offered at various points in the year.',
 date_precision='text_only',duration_text=null,source_status='open',
 audience_text='Students interested in learning about life in a barristers’ chambers.',
 study_stage_text='Student.',
 eligibility_text='Students interested in work experience at Outer Temple Chambers.',
 application_process_text='Use the work-experience enquiry contact on the official Join Our Team page.',
 expenses_text=null,official_url='https://www.outertemple.com/join-our-team/',
 application_url='https://www.outertemple.com/join-our-team/',active=true,
 research_checked_on=date '2026-10-15',source_status_note=null,additional_details_text=null,updated_at=now()
where opportunity_id='3c2c9104-34c1-4305-ba26-7e64b71a8dc9';

update public.chambers set
 pupillage_overview='Outer Temple recruits through the Pupillage Gateway. The application process for pupillages commencing in September 2026 and September 2027 is closed. The latest published award is £80,000 for the September 2026 intake, with up to 25% available for drawdown during Bar training.',
 mini_pupillage_overview='Outer Temple runs two non-assessed three-day mini-pupillage courses each year, normally taking up to 12 candidates: a summer course delivered with Bridging the Bar and a winter course. The Winter 2026 course is closed, and places for the June 2027 summer course are allocated directly by Bridging the Bar.',
 tenancy_overview='Established-practitioner, tenancy and fixed-term placement recruitment are excluded from Vacatory’s student-opportunity listings.',
 pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where organisation_id='b42f1999-d811-4a3c-b624-44a342ede9ae';

commit;
