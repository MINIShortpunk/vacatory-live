begin;

update public.legal_organisations
set careers_url='https://www.serlecourt.co.uk/join-us/pupillage/',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='8de3a4f5-f592-4cc7-b627-485e7f40acf2';

update public.chambers
set pupillage_overview='Serle Court recruits up to four 12-month pupils through the Pupillage Gateway. The award is £85,000, with up to £25,000 available as a pre-pupillage drawdown. Applications are anonymised and use published competencies, a situational-judgment test and two interview stages. Pupils sit with four supervisors and are assessed individually for tenancy. The application round for pupillage commencing in 2027 is closed.',
    mini_pupillage_overview='Serle Court offers one-day, unassessed mini-pupillages in spring and autumn rounds to applicants who have completed the first year of a law degree or at least one term of the GDL or equivalent. Reasonable travel costs are reimbursed and needs-based accommodation support may be considered. Three autumn places are reserved for eligible applicants from underrepresented groups and carry a guaranteed first-round pupillage interview in the immediately following recruitment cycle. Both 2026 application rounds are closed.',
    tenancy_overview='Serle Court aims to offer tenancy to every pupil who individually meets its assessment standard. Vacatory lists student and aspiring-barrister routes only; lateral recruitment, tenancy vacancies and third-six routes are excluded.',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where organisation_id='8de3a4f5-f592-4cc7-b627-485e7f40acf2';

delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in (
  '1d88a885-efba-484f-8155-b012da9794f5','6f21a479-326e-4613-9e7f-df3452c9d03a',
  '60869475-3fbf-48fc-8e0a-26202f0b0a85','e772c96c-0447-415f-bdfa-e621d57e136c',
  '395804eb-d6fc-4dc4-9710-94a8ea1178ae'
);
delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in (
  '1d88a885-efba-484f-8155-b012da9794f5','6f21a479-326e-4613-9e7f-df3452c9d03a',
  '60869475-3fbf-48fc-8e0a-26202f0b0a85','e772c96c-0447-415f-bdfa-e621d57e136c',
  '395804eb-d6fc-4dc4-9710-94a8ea1178ae'
);
delete from public.career_opportunity_identity_stage
where career_opportunity_id in (
  '1d88a885-efba-484f-8155-b012da9794f5','6f21a479-326e-4613-9e7f-df3452c9d03a',
  '60869475-3fbf-48fc-8e0a-26202f0b0a85','e772c96c-0447-415f-bdfa-e621d57e136c',
  '395804eb-d6fc-4dc4-9710-94a8ea1178ae'
);
delete from public.career_opportunities
where id in (
  '1d88a885-efba-484f-8155-b012da9794f5','6f21a479-326e-4613-9e7f-df3452c9d03a',
  '60869475-3fbf-48fc-8e0a-26202f0b0a85','e772c96c-0447-415f-bdfa-e621d57e136c',
  '395804eb-d6fc-4dc4-9710-94a8ea1178ae'
);

update public.career_opportunities
set official_name='10,000 Black Interns — The Bar 2027 — Serle Court Participating Set',
    public_name='10,000 Black Interns — The Bar 2027 — Serle Court Participating Set',
    public_summary='Paid Summer 2027 internship programme for Black students and recent graduates, with Serle Court participating in the Legal: The Bar workstream.',
    official_url='https://www.serlecourt.co.uk/about-us/equality-diversity-outreach/outreach',
    application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='4f40362b-0bde-4e6b-9c96-a13267dfa9fb';

update public.career_opportunity_cycles
set cycle_key='serle-court-10000-black-interns-2027',
    cycle_label='10,000 Black Interns — The Bar 2027 — Serle Court Participating Set',
    application_year=2026,programme_year=2027,intake_year=2027,
    application_model='fixed_deadline',opens_on=date '2026-10-05',opens_at=null,opens_timezone='Europe/London',
    closes_on=date '2026-11-01',closes_at=time '23:59',closes_timezone='Europe/London',
    programme_starts_on=date '2027-05-01',programme_ends_on=date '2027-09-30',
    programme_dates_text='Paid internship of at least six weeks during Summer 2027.',
    application_dates_text='Applications opened on 5 October 2026 and close at 23:59 on 1 November 2026.',
    date_precision='exact',duration_text='At least six weeks',source_status='open',
    study_stage_text='Black students and recent graduates.',
    academic_criteria=null,
    eligibility_text='Applicants must meet the 10,000 Interns Foundation eligibility rules for the Summer 2027 programme, including the programme’s Black heritage and UK work-permission requirements.',
    application_process_text='Apply centrally to the 10,000 Black Interns programme and select the Legal: The Bar workstream and preferred location. The Foundation manages matching to participating organisations; applicants cannot select a particular chambers.',
    assessments_text='The 10,000 Interns Foundation and participating organisations manage selection and matching.',
    progression_route_text='Participation does not provide automatic progression to pupillage or tenancy.',
    funding_text='Paid at no less than the real Living Wage for at least six weeks.',
    expenses_text=null,travel_support_text=null,accommodation_support_text=null,
    right_to_work_text='Applicants must have unrestricted permission to work full-time in the United Kingdom for the internship period.',
    official_url='https://www.serlecourt.co.uk/about-us/equality-diversity-outreach/outreach',
    application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    research_checked_on=date '2026-10-15',source_status_note=null,
    additional_details_text='Serle Court states that it participates annually in the Legal: The Bar programme. Allocation to Serle Court is managed by the Foundation and is not guaranteed.',
    updated_at=now()
where opportunity_id='4f40362b-0bde-4e6b-9c96-a13267dfa9fb';

insert into public.career_opportunities
  (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select
  '8de3a4f5-f592-4cc7-b627-485e7f40acf2','b29890c7-5f97-4d55-bbf8-9e7fda5e22b3','serle-court-combar-mentoring-2026-27',
  'COMBAR Mentoring Scheme 2026–27 — Serle Court Participating Set','COMBAR Mentoring Scheme 2026–27 — Serle Court Participating Set',
  'Commercial Bar mentoring scheme for applicants from groups underrepresented at the Bar, with Serle Court participating as a member set.',
  'hybrid','https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/',
  'https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/',true,true,date '2026-10-15',date '2026-10-24'
where not exists (
  select 1 from public.career_opportunities
  where organisation_id='8de3a4f5-f592-4cc7-b627-485e7f40acf2' and slug='serle-court-combar-mentoring-2026-27'
);

insert into public.career_opportunity_cycles
  (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,closes_on,closes_at,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,study_stage_text,eligibility_text,expenses_text,official_url,application_url,active,research_checked_on,application_process_text,programme_structure_text,assessments_text,additional_details_text)
select o.id,'serle-court-combar-mentoring-2026-27','COMBAR Mentoring Scheme 2026–27 — Serle Court Participating Set',
       2026,2026,2026,'fixed_deadline',date '2026-10-23',time '23:59','Europe/London',date '2026-11-01',date '2027-06-30',
       'Mentoring takes place during the 2026–27 cycle. A pupillage application and interview workshop and social event is planned for 13 January 2027.',
       'The extended application deadline is 23:59 on 23 October 2026.','exact','2026–27 mentoring cycle','open',
       'Undergraduates and graduates who do not hold a pupillage offer and have realistic prospects of obtaining a Commercial Bar pupillage.',
       'Applicants must be from a group underrepresented at the Bar, demonstrate potential to pursue a career at the Commercial Bar and show that they would benefit from mentoring.',
       'Participating sets cover reasonable travel expenses for mentees allocated to them.',
       'https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/',
       'https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/',true,date '2026-10-15',
       'Download and complete the COMBAR application form, save it as a PDF using the required naming convention and email it to MentoringURG@combar.com by the deadline.',
       'Successful applicants receive one-to-one mentoring from a practitioner at a participating set, plus access to a pupillage application and interview workshop and social event.',
       'COMBAR gives equal weight to applicants’ need for mentoring and their potential to pursue a career at the Bar.',
       'COMBAR expects about 250 places across 26 participating sets; mentor allocation is managed by COMBAR.'
from public.career_opportunities o
where o.organisation_id='8de3a4f5-f592-4cc7-b627-485e7f40acf2' and o.slug='serle-court-combar-mentoring-2026-27'
  and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

insert into public.career_opportunity_routes
  (opportunity_id,route_kind,scope_key,route_note,route_status,display_order,active)
select o.id,'flexible_scope','partner-managed','COMBAR manages mentor allocation across participating member sets.','confirmed',100,true
from public.career_opportunities o
where o.organisation_id='8de3a4f5-f592-4cc7-b627-485e7f40acf2' and o.slug='serle-court-combar-mentoring-2026-27'
  and not exists (select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id);

commit;
