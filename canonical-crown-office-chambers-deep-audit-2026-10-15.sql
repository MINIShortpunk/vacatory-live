begin;

update public.legal_organisations
set research_status='verified', research_checked_on=date '2026-10-15', next_review_on=date '2026-11-23', updated_at=now()
where id='fccf13d2-e68e-4525-b568-25d6a47af7ce';

update public.chambers
set pupillage_overview='Crown Office normally offers up to four 12-month pupillages through the Pupillage Gateway. The most recent application round has closed. Each pupillage carries a £90,000 package comprising a £75,000 award and £15,000 guaranteed second-six earnings, with up to £20,000 available in advance. Pupils sit with two supervisors during first six and a third during second six, receive regular instructions and advocacy experience, and are recruited with a view to tenancy.',
    mini_pupillage_overview='Crown Office offers a limited number of two-day mini-pupillages, which may be completed on consecutive or separate days. Applications will reopen in late May 2027. Chambers covers reasonable expenses up to £250 and may award a confidential discretionary grant where childcare costs, lost work or another financial barrier would prevent attendance.',
    tenancy_overview='Crown Office recruits established practitioners through a separate tenancy route. That route is outside Vacatory’s student-opportunity listings.',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where organisation_id='fccf13d2-e68e-4525-b568-25d6a47af7ce';

update public.career_opportunities
set public_summary='A university-nominated award providing one funded week marshalling a judge and one funded week with a barrister during summer 2027.',
    research_checked_on=date '2026-10-15',next_review_on=date '2027-02-01',updated_at=now()
where id='24a15871-6e10-4c2e-8aee-349f0ba1ba19';

update public.career_opportunity_cycles
set cycle_key='middle-temple-access-to-the-bar-award-2027',cycle_label='Middle Temple Access to the Bar Award 2027',
    application_year=2027,programme_year=2027,application_model='fixed_deadline',closes_on=date '2027-01-31',
    date_precision='month',source_status='upcoming',
    application_dates_text='Participating universities may submit up to two nominations by 31 January 2027. A university may set an earlier internal deadline.',
    programme_dates_text='The two funded weeks run from the final week of June through the first week of July 2027.',
    source_status_note=null,
    assessments_text='Universities shortlist candidates before Middle Temple reviews the written applications. Shortlisted candidates are interviewed by practising members in March or April.',
    additional_details_text='Direct applications are not accepted. Crown Office participates in the scheme, while Middle Temple arranges placements with participating chambers and judges.',
    research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='24a15871-6e10-4c2e-8aee-349f0ba1ba19';

update public.career_opportunities
set public_name='10,000 Black Interns Summer 2027 — Crown Office Participant',official_name='10,000 Black Interns Summer 2027 — Crown Office Participant',
    public_summary='Apply by 1 November 2026 to the Law (The Bar) workstream for a paid summer 2027 internship rotation with participating chambers and organisations.',
    official_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    application_url='https://10000internsfoundation.com/candidate-form-2/',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='cdac7727-36e7-4e8a-b915-9ed4608989cc';

update public.career_opportunity_cycles
set cycle_key='10000-black-interns-summer-2027-crown-office',cycle_label='10,000 Black Interns Summer 2027 — Crown Office Participant',
    application_year=2026,programme_year=2027,intake_year=2027,application_model='fixed_deadline',closes_on=date '2026-11-01',
    programme_starts_on=date '2027-06-01',programme_ends_on=date '2027-09-30',date_precision='month',source_status='open',
    application_dates_text='Applications for the Summer 2027 programme close on 1 November 2026.',
    programme_dates_text='The Law (The Bar) workstream runs during summer 2027 and rotates interns across participating chambers and organisations within one region.',
    source_status_note=null,
    right_to_work_text='Applicants must already have an unrestricted right to work full-time in the United Kingdom when they apply.',
    additional_details_text='Applicants choose the Law (The Bar) workstream and a region. The Foundation manages applications, training and matching; participating hosts make selection decisions.',
    research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='cdac7727-36e7-4e8a-b915-9ed4608989cc';

insert into public.career_opportunities
    (id,organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,official_url,application_url,delivery_mode,active,published,display_order,research_checked_on,next_review_on,created_at,updated_at)
values
    ('db0d8630-d6b2-42cf-a58d-914d6a7b990d','fccf13d2-e68e-4525-b568-25d6a47af7ce','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89',
     'crown-office-chambers-mini-pupillage-2027','Crown Office Chambers Mini-Pupillage 2027','Crown Office Chambers Mini-Pupillage 2027',
     'Applications reopen in late May 2027 for Crown Office’s two-day mini-pupillage scheme.',
     'https://www.crownofficechambers.com/careers/mini-pupillage/','https://www.crownofficechambers.com/careers/mini-pupillage/',
     'in_person',true,true,500,date '2026-10-15',date '2027-05-20',now(),now())
on conflict (id) do nothing;

insert into public.career_opportunity_cycles
    (id,opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,opens_on,date_precision,duration_text,places_text,source_status,
     application_dates_text,audience_text,eligibility_text,application_process_text,programme_structure_text,expenses_text,disability_support_text,additional_details_text,
     official_url,application_url,active,research_checked_on,created_at,updated_at)
values
    ('b058f0cc-cf72-42a7-b00d-b5d6eefec069','db0d8630-d6b2-42cf-a58d-914d6a7b990d','crown-office-chambers-mini-pupillage-2027','Crown Office Chambers Mini-Pupillage 2027',
     2027,2027,'fixed_deadline',date '2027-05-01','month','Two days','Places are limited','upcoming',
     'Applications reopen in late May 2027.','Law students, conversion-course students and candidates preparing for the next pupillage application round.',
     'Crown Office recommends applying during the second year or early final year of a law degree, or during the CPE or GDL year.',
     'Apply through the online form linked from the official mini-pupillage page when the application window reopens.',
     'Selected candidates attend for two days, either consecutively or separately, subject to candidate and barrister availability.',
     'Reasonable travel, subsistence and accommodation expenses are covered up to £250. Discretionary grants may be available where financial barriers would otherwise prevent attendance.',
     'Crown Office offers reasonable adjustments during recruitment and attendance.',
     'Mini-pupillages are not formally assessed, although a candidate’s contribution may be considered in a later pupillage application.',
     'https://www.crownofficechambers.com/careers/mini-pupillage/','https://www.crownofficechambers.com/careers/mini-pupillage/',true,date '2026-10-15',now(),now())
on conflict (id) do nothing;

insert into public.career_opportunity_routes
    (id,opportunity_id,route_kind,country_id,city_id,route_status,route_note,display_order,active,created_at,updated_at)
values
    ('2d28454d-f24e-4dd5-9e7c-ae83308cbc8f','db0d8630-d6b2-42cf-a58d-914d6a7b990d','physical_city',47,139,'confirmed','London',10,true,now(),now())
on conflict (id) do nothing;

insert into public.career_opportunity_cycle_routes (cycle_id,route_id,opportunity_id,mapping_basis,created_at)
values ('b058f0cc-cf72-42a7-b00d-b5d6eefec069','2d28454d-f24e-4dd5-9e7c-ae83308cbc8f','db0d8630-d6b2-42cf-a58d-914d6a7b990d','single_route_default',now())
on conflict do nothing;

commit;
