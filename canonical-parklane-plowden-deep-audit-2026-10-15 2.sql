begin;

-- Remove the legacy mirror, which contains closed 2026 rounds, speculative future
-- cycles and partner routes without current application details.
delete from public.vacation_schemes
where organisation_id='35552b06-18cd-45c7-ac65-9d326115159d'
   or firm_id='35552b06-18cd-45c7-ac65-9d326115159d';

-- Permanently remove the closed/speculative direct cycles and the post-pupillage
-- third-six enquiry route. Dependent canonical rows cascade; identity-stage rows
-- are removed explicitly because they are maintained outside the normal cascade.
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in ('e91331ca-8f4b-447f-abc2-45bae930ba71','bae2aed3-ffd4-4e92-882c-bb497939ea31','a429ef55-ed58-4b5f-bd00-3937e737fdc5');
delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in ('e91331ca-8f4b-447f-abc2-45bae930ba71','bae2aed3-ffd4-4e92-882c-bb497939ea31','a429ef55-ed58-4b5f-bd00-3937e737fdc5');
delete from public.career_opportunity_identity_stage
where career_opportunity_id in ('e91331ca-8f4b-447f-abc2-45bae930ba71','bae2aed3-ffd4-4e92-882c-bb497939ea31','a429ef55-ed58-4b5f-bd00-3937e737fdc5');
delete from public.career_opportunities
where id in ('e91331ca-8f4b-447f-abc2-45bae930ba71','bae2aed3-ffd4-4e92-882c-bb497939ea31','a429ef55-ed58-4b5f-bd00-3937e737fdc5');

-- Correct the live Bridging the Bar Academy route.
update public.career_opportunities set
 slug='parklane-plowden-bridging-the-bar-academy-2027-28',
 official_name='Bridging the Bar Academy 2027/28 — Parklane Plowden Partner',
 public_name='Bridging the Bar Academy 2027/28 — Parklane Plowden Partner',
 public_summary='Access programme providing mentoring, advocacy and application training and at least one mini-pupillage through participating chambers. Parklane Plowden offers two placements through the scheme; allocation to a particular chambers is not guaranteed.',
 official_url='https://www.parklaneplowden.co.uk/mini-pupillage/',
 application_url='https://bridgingthebar.org/academy-applications/',
 delivery_mode='hybrid',active=true,published=true,
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-06',updated_at=now()
where id='e72e9490-ad7e-4d5b-85e0-e3355e825c58';

update public.career_opportunity_cycles set
 cycle_key='parklane-plowden-bridging-the-bar-academy-2027-28',
 cycle_label='Bridging the Bar Academy 2027/28 — Parklane Plowden Partner',
 application_year=2026,programme_year=2027,intake_year=2027,
 application_model='fixed_deadline',opens_on=date '2026-10-02',closes_on=date '2026-11-05',
 closes_at=time '17:00',closes_timezone='Europe/London',
 application_dates_text='Applications close at 17:00 on 5 November 2026.',
 programme_dates_text='The Academy runs from August 2027 to June 2028.',
 date_precision='exact',duration_text='August 2027 to June 2028',source_status='open',
 study_stage_text='Bar Course student in 2027–28 or Bar Course graduate intending to apply for pupillage in 2028.',
 eligibility_text='Applicants must meet the Academy’s published education and financial-support criteria and be available in the United Kingdom for programme activity.',
 application_process_text='Apply through Bridging the Bar. The Academy allocates mini-pupillages through participating chambers; applicants do not apply directly to Parklane Plowden for these two placements.',
 assessments_text='Bridging the Bar manages the Academy application and assessment process.',
 expenses_text='Financial support is governed by the Academy’s published terms.',
 right_to_work_text='Applicants must satisfy the Academy’s current eligibility requirements.',
 additional_details_text='Parklane Plowden confirms that it offers two mini-pupillages through Bridging the Bar, separately from its direct mini-pupillage programme.',
 official_url='https://www.parklaneplowden.co.uk/mini-pupillage/',
 application_url='https://bridgingthebar.org/academy-applications/',
 active=true,research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='e72e9490-ad7e-4d5b-85e0-e3355e825c58';

-- Add the open 10,000 Black Interns Summer 2027 Bar route. Parklane Plowden
-- confirms that it hosts a paid intern; matching is controlled centrally.
insert into public.career_opportunities
 (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select '35552b06-18cd-45c7-ac65-9d326115159d','06f22221-7e57-4379-b2a1-fcbec5d4f4bb',
 'parklane-plowden-10000-black-interns-bar-2027',
 '10,000 Black Interns — The Bar 2027 — Parklane Plowden Participant',
 '10,000 Black Interns — The Bar 2027 — Parklane Plowden Participant',
 'Paid Summer 2027 internship programme for eligible Black students and recent graduates. Parklane Plowden confirms that it hosts an intern; allocation to a particular chambers is not guaranteed.',
 'in_person','https://www.parklaneplowden.co.uk/mini-pupillage/',
 'https://10000internsfoundation.com/students-graduates/10000-black-interns/',true,true,date '2026-10-15',date '2026-11-02'
where not exists(select 1 from public.career_opportunities where slug='parklane-plowden-10000-black-interns-bar-2027');

insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,closes_on,closes_timezone,application_dates_text,programme_dates_text,date_precision,duration_text,source_status,audience_text,study_stage_text,eligibility_text,right_to_work_text,funding_text,application_process_text,assessments_text,additional_details_text,official_url,application_url,active,research_checked_on)
select id,'parklane-plowden-10000-black-interns-bar-2027',official_name,2026,2027,2027,'fixed_deadline',date '2026-10-05',date '2026-11-01','Europe/London',
 'Applications for Summer 2027 close on 1 November 2026.',
 'Paid internships take place between May and September 2027; host dates vary.','exact','At least six weeks','open',
 'Eligible Black students and recent graduates interested in the Bar.',
 'UK undergraduate or postgraduate student, confirmed university entrant on a gap year, or recent UK-university graduate from 2024 or later.',
 'Applicants must be aged 18 or over, be Black African, Black Caribbean, Black British or of mixed Black heritage, meet the programme’s UK study or recent-graduate criteria, and not previously have secured a 10,000 Black Interns placement.',
 'Applicants must already have unrestricted permission to work full-time in the United Kingdom when applying.',
 'Paid internship at no less than the applicable real Living Wage.',
 'Apply through the 10,000 Interns Foundation and select The Bar workstream. Candidates may choose a region but cannot select an individual chambers.',
 'The Foundation and participating hosts manage application review, matching and selection.',
 'Parklane Plowden confirms that it takes a paid intern through the programme. Matching to Parklane Plowden depends on programme allocation and host selection.',
 'https://www.parklaneplowden.co.uk/mini-pupillage/',
 'https://10000internsfoundation.com/students-graduates/10000-black-interns/',true,date '2026-10-15'
from public.career_opportunities
where slug='parklane-plowden-10000-black-interns-bar-2027'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=career_opportunities.id);

-- Both live central routes can lead to a placement in either chambers office.
insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select o.id,'physical_city',47,v.city_id,'Leeds or Newcastle / programme-managed allocation','confirmed',v.display_order,true
from public.career_opportunities o
cross join (values (134,10),(146,20)) v(city_id,display_order)
where o.slug='parklane-plowden-10000-black-interns-bar-2027'
and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.city_id=v.city_id);

update public.chambers set
 pupillage_overview='Parklane Plowden recruits specialist and mixed pupils in civil, employment and discrimination, family, and chancery and commercial practice. Its published 2026 application window for pupillages beginning in 2026 and 2027 closed on 22 January 2026. The published funding package is worth at least £45,000 over 12 months, comprising a £20,000 first-six award and guaranteed second-six receipts of at least £25,000.',
 mini_pupillage_overview='Parklane Plowden’s direct three-day mini-pupillage programme is for applicants in their second university year or above and includes general, Diversity and Social Mobility routes. The direct 2026 application window closed on 30 January 2026. Current central routes are the Bridging the Bar Academy 2027/28 and the paid 10,000 Black Interns Summer 2027 programme.',
 tenancy_overview='Parklane Plowden has a strong tradition of offering tenancy to pupils who demonstrate the required ability and dedication. Third-six and experienced-practitioner recruitment are excluded from Vacatory’s student-opportunity listings.',
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-06',updated_at=now()
where organisation_id='35552b06-18cd-45c7-ac65-9d326115159d';

commit;
