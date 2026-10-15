begin;

update public.legal_organisations
set research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='5dbd3808-2889-416c-9eb6-ad69ec9023d5';

update public.chambers
set research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where organisation_id='5dbd3808-2889-416c-9eb6-ad69ec9023d5';

insert into public.career_opportunities
  (id,organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on,created_at,updated_at)
values
  ('9630cb8b-54ed-4ef4-b9a8-acde1545ed3e','5dbd3808-2889-416c-9eb6-ad69ec9023d5','06f22221-7e57-4379-b2a1-fcbec5d4f4bb',
   'fountain-court-10000-black-interns-summer-2027','10,000 Black Interns Summer 2027 — Fountain Court Participant','10,000 Black Interns Summer 2027 — Fountain Court Participant',
   'Apply by 1 November 2026 to The Bar workstream for a paid summer 2027 internship rotation with participating chambers and organisations. Fountain Court confirms that it supports the programme.',
   'in_person','https://fountaincourt.uk/about-us/social-responsibility/equality-diversity-and-inclusion/','https://survey.alchemer.eu/s3/91120967/10-000-Black-Interns-Application-Form-2026-27',
   true,true,date '2026-10-15',date '2026-11-02',now(),now())
on conflict (id) do nothing;

insert into public.career_opportunity_cycles
  (id,opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,closes_on,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,audience_text,study_stage_text,academic_criteria,eligibility_text,application_process_text,assessments_text,programme_structure_text,progression_route_text,funding_text,expenses_text,right_to_work_text,disability_support_text,additional_details_text,official_url,application_url,active,research_checked_on,created_at,updated_at)
values
  ('bb40f8ef-c165-4c1f-ad66-0be3c1276c35','9630cb8b-54ed-4ef4-b9a8-acde1545ed3e','fountain-court-10000-black-interns-summer-2027','10,000 Black Interns Summer 2027 — Fountain Court Participant',
   2026,2027,2027,'fixed_deadline',date '2026-11-01','Europe/London',date '2027-05-01',date '2027-09-30',
   'Paid internships take place between May and September 2027 and last at least six weeks. The Bar workstream rotates interns across participating chambers and organisations within one region.',
   'Applications are open and close on 1 November 2026.','season','At least six weeks','open',
   'Black students, eligible gap-year applicants and recent graduates seeking paid experience at the Bar.',
   'UK university undergraduate or postgraduate students, applicants aged 18 or over on a gap year with a confirmed UK university place, and graduates of UK universities from 2024 onwards.',
   'No minimum degree classification is stated by the Foundation.',
   'Applicants must be aged 18 or over; be Black African, Black Caribbean, Black British or of mixed Black heritage; meet the Foundation’s study or recent-graduate criteria; have no previous internship secured through this programme; and already hold an unrestricted right to work full-time in the United Kingdom.',
   'Apply through the Foundation’s 2026/27 form, select The Bar as a workstream and choose a region. Applicants submit a CV and a tailored cover letter for each selected workstream. The Foundation manages matching and participating hosts manage selection.',
   'Foundation eligibility review and matching, followed by any host selection process.',
   'A paid internship of at least six weeks, with training and mentoring. The Bar workstream provides exposure to advocacy, case preparation and legal strategy through a regional rotation.',
   'Paid experience and professional development; participation does not provide automatic progression to Fountain Court mini-pupillage, pupillage or tenancy.',
   'Paid at no less than the Real Living Wage for the internship location.',
   'Paid at no less than the Real Living Wage. Any travel or accommodation support is determined by the host.',
   'Applicants must already have an unrestricted right to work full-time in the United Kingdom when applying.',
   'Applicants may request adjustments through the Foundation and any matched host.',
   'Candidates apply by workstream and region and cannot select or be guaranteed Fountain Court as their host.',
   'https://fountaincourt.uk/about-us/social-responsibility/equality-diversity-and-inclusion/',
   'https://survey.alchemer.eu/s3/91120967/10-000-Black-Interns-Application-Form-2026-27',true,date '2026-10-15',now(),now())
on conflict (id) do nothing;

insert into public.career_opportunity_routes
  (id,opportunity_id,route_kind,country_id,city_id,route_status,route_note,display_order,active,created_at,updated_at)
values
  ('1fed5d16-386b-43aa-bd18-a45d8956ff0d','9630cb8b-54ed-4ef4-b9a8-acde1545ed3e','physical_city',47,139,'confirmed','Fountain Court is a London participant in the programme. Candidates choose a region and cannot select or be guaranteed a particular host.',10,true,now(),now())
on conflict (id) do nothing;

insert into public.career_opportunity_cycle_routes (cycle_id,route_id,opportunity_id,mapping_basis,created_at)
values ('bb40f8ef-c165-4c1f-ad66-0be3c1276c35','1fed5d16-386b-43aa-bd18-a45d8956ff0d','9630cb8b-54ed-4ef4-b9a8-acde1545ed3e','single_route_default',now())
on conflict do nothing;

insert into public.career_opportunity_locations
  (id,opportunity_id,cycle_id,country_id,city_id,location_role,location_status,location_note,display_order,created_at)
values
  ('8f95f2fd-933d-4e30-b48a-b629bdb45cdc','9630cb8b-54ed-4ef4-b9a8-acde1545ed3e',null,47,139,'programme','confirmed','Fountain Court, Temple, London. Programme matching is by workstream and region and does not guarantee a Fountain Court placement.',10,now())
on conflict (id) do nothing;

delete from public.career_opportunity_routes
where opportunity_id='9630cb8b-54ed-4ef4-b9a8-acde1545ed3e'
  and route_kind='unresolved';

commit;
