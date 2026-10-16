begin;

update public.legal_organisations
set careers_url='https://www.maitlandchambers.com/join-us/recruitment',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='094906c5-51f6-4e01-b001-c7d8f938f41b';

update public.chambers
set pupillage_overview='Maitland normally offers up to three fully funded 12-month commercial and commercial chancery pupillages each year through the Pupillage Gateway. Pupillages beginning in September 2028 carry an £85,000 award, with up to £30,000 available as a drawdown during vocational Bar training. Selection uses an anonymised application, a first-round hypothetical-case interview and a second-round interview.',
    mini_pupillage_overview='Maitland offers one-day, unassessed mini-pupillages during court terms. Applications are considered in three annual windows: 1 April to 31 August for October or November placements, 1 September to 15 November for December or January placements, and 16 November to 31 March for May to July placements. Each deadline is at 4:00pm. Reasonable travel expenses are reimbursed up to £100, with further support possible in exceptional circumstances by prior approval.',
    tenancy_overview='Vacatory lists Maitland’s student and aspiring-barrister routes only. Staff vacancies, tenancy recruitment and third-six vacancies are excluded.',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where organisation_id='094906c5-51f6-4e01-b001-c7d8f938f41b';

delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in ('17d89bfe-9c32-4c40-b24a-6b8c1bf5750d','cacddcb2-55ee-4bf3-859d-bb48ba3827e6');
delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in ('17d89bfe-9c32-4c40-b24a-6b8c1bf5750d','cacddcb2-55ee-4bf3-859d-bb48ba3827e6');
delete from public.career_opportunity_identity_stage
where career_opportunity_id in ('17d89bfe-9c32-4c40-b24a-6b8c1bf5750d','cacddcb2-55ee-4bf3-859d-bb48ba3827e6');
delete from public.career_opportunities
where id in ('17d89bfe-9c32-4c40-b24a-6b8c1bf5750d','cacddcb2-55ee-4bf3-859d-bb48ba3827e6');

update public.career_opportunities
set public_summary='One-day, unassessed commercial and commercial chancery mini-pupillage at Maitland Chambers for placements in December 2026 or January 2027.',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-16',updated_at=now()
where id='6d20cef5-2870-467c-bab7-4a7de710c352';
update public.career_opportunity_cycles
set opens_timezone='Europe/London',closes_timezone='Europe/London',
    funding_text='Unpaid. Reasonable travel expenses are reimbursed up to £100; further reimbursement may be available in exceptional circumstances if approved in advance.',
    assessments_text='Application-form review only; the placement is unassessed.',
    right_to_work_text=null,
    research_checked_on=date '2026-10-15',updated_at=now()
where id='5aa46fef-5b8d-40ef-9348-5abbbed06753';

update public.career_opportunities
set public_summary='One-day, unassessed commercial and commercial chancery mini-pupillage at Maitland Chambers for placements between May and July 2027.',
    research_checked_on=date '2026-10-15',next_review_on=date '2027-04-01',updated_at=now()
where id='e8b6e0ee-a791-42b4-a8e9-2f92d46248b5';
update public.career_opportunity_cycles
set cycle_label='Maitland Mini-Pupillage — May to July 2027',opens_timezone='Europe/London',closes_timezone='Europe/London',
    funding_text='Unpaid. Reasonable travel expenses are reimbursed up to £100; further reimbursement may be available in exceptional circumstances if approved in advance.',
    assessments_text='Application-form review only; the placement is unassessed.',
    right_to_work_text=null,
    research_checked_on=date '2026-10-15',updated_at=now()
where id='7136f498-a0ed-42f4-9767-4a88c1f06cc8';

update public.career_opportunities
set official_url='https://www.maitlandchambers.com/join-us/recruitment',
    public_summary='Funded 12-month commercial and commercial chancery pupillage at Maitland Chambers beginning in September 2028.',
    research_checked_on=date '2026-10-15',next_review_on=date '2027-01-29',updated_at=now()
where id='faaf5474-7c4c-47ad-98f9-b1770ab924c2';
update public.career_opportunity_cycles
set official_url='https://www.maitlandchambers.com/join-us/recruitment',
    funding_text='£85,000 award, with up to £30,000 available as a drawdown during vocational Bar training. Maitland funds compulsory BSB courses.',
    assessments_text='Anonymised application, first-round hypothetical-case interview and second-round interview.',
    right_to_work_text=null,
    source_status_note=null,research_checked_on=date '2026-10-15',updated_at=now()
where id='42a46fae-51ed-4e4a-806c-e8aa72efc819';
update public.career_opportunity_compensation
set amount_text='£85,000 pupillage award',
    details='£85,000 award for pupillages beginning in September 2028; up to £30,000 may be drawn down during vocational Bar training and Maitland funds compulsory BSB courses.',updated_at=now()
where id='e03e1c1c-6310-4d27-bd8c-bc0431d3bc1e';

insert into public.career_opportunities (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select '094906c5-51f6-4e01-b001-c7d8f938f41b','45e6b1b6-6589-4e4f-b6b7-7cf2ddc28a89','maitland-mini-pupillage-october-november-2027','Maitland Mini-Pupillage — October or November 2027','Maitland Mini-Pupillage — October or November 2027','One-day, unassessed commercial and commercial chancery mini-pupillage at Maitland Chambers for placements in October or November 2027.','in_person','https://www.maitlandchambers.com/pupillage-recruitment/mini-pupillage','https://www.maitlandchambers.com/pupillage-recruitment/mini-pupillage',true,true,date '2026-10-15',date '2027-09-01'
where not exists (select 1 from public.career_opportunities where organisation_id='094906c5-51f6-4e01-b001-c7d8f938f41b' and slug='maitland-mini-pupillage-october-november-2027');
insert into public.career_opportunity_cycles (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,opens_on,opens_timezone,closes_on,closes_at,closes_timezone,programme_dates_text,application_dates_text,date_precision,duration_text,funding_text,expenses_text,source_status,study_stage_text,academic_criteria,eligibility_text,official_url,application_url,active,research_checked_on,application_process_text,programme_structure_text,assessments_text,progression_route_text,additional_details_text,disability_support_text)
select o.id,'maitland-mini-pupillage-october-november-2027','Maitland Mini-Pupillage — October or November 2027',2027,2027,2027,'fixed_deadline',date '2027-04-01','Europe/London',date '2027-08-31',time '16:00','Europe/London','One-day mini-pupillage in October or November 2027.','Applications are accepted from 1 April to 4:00pm on 31 August 2027.','exact','One day','Unpaid. Reasonable travel expenses are reimbursed up to £100; further reimbursement may be available in exceptional circumstances if approved in advance.','Reasonable travel expenses are reimbursed up to £100; more may be considered exceptionally with advance approval.','upcoming','Best suited to applicants who have completed at least one year of a law degree or started the GDL.','No fixed degree classification is specified.','Applicants should demonstrate Maitland’s qualities of reasoning and analytical ability, advocacy aptitude, judgment, and interpersonal skills and temperament.','https://www.maitlandchambers.com/pupillage-recruitment/mini-pupillage','https://www.maitlandchambers.com/pupillage-recruitment/mini-pupillage',true,date '2026-10-15','Submit the official browser-based application form during the stated window.','One day in Chambers, normally with junior members and sometimes KCs, attending court and conferences and studying papers.','Application-form review only; the placement is unassessed.','Mini-pupillage is not required for pupillage and does not provide automatic progression.','Places are limited to court terms and the programme is heavily oversubscribed.','Maitland invites requests for reasonable adjustments and can discuss alternative venues or virtual arrangements where appropriate.'
from public.career_opportunities o where o.organisation_id='094906c5-51f6-4e01-b001-c7d8f938f41b' and o.slug='maitland-mini-pupillage-october-november-2027'
and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);
insert into public.career_opportunity_locations (opportunity_id,country_id,city_id,location_note,location_role,location_status,display_order)
select o.id,47,139,'London','programme','confirmed',10 from public.career_opportunities o
where o.slug='maitland-mini-pupillage-october-november-2027' and not exists (select 1 from public.career_opportunity_locations l where l.opportunity_id=o.id);
insert into public.career_opportunity_routes (opportunity_id,route_kind,route_note,route_status,country_id,city_id,display_order,active)
select o.id,'physical_city','London','confirmed',47,139,10,true from public.career_opportunities o
where o.slug='maitland-mini-pupillage-october-november-2027' and not exists (select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id);

insert into public.career_opportunities (organisation_id,opportunity_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select '094906c5-51f6-4e01-b001-c7d8f938f41b','b29890c7-5f97-4d55-bbf8-9e7fda5e22b3','maitland-combar-mentoring-2026-27','COMBAR Mentoring Scheme 2026–27 — Maitland Participating Set','COMBAR Mentoring Scheme 2026–27 — Maitland Participating Set','Commercial Bar mentoring scheme for applicants from groups underrepresented at the Bar, with Maitland participating as a member set.','hybrid','https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/','https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/',true,true,date '2026-10-15',date '2026-10-24'
where not exists (select 1 from public.career_opportunities where organisation_id='094906c5-51f6-4e01-b001-c7d8f938f41b' and slug='maitland-combar-mentoring-2026-27');
insert into public.career_opportunity_cycles (opportunity_id,cycle_key,cycle_label,application_year,programme_year,intake_year,application_model,closes_on,closes_at,closes_timezone,programme_starts_on,programme_ends_on,programme_dates_text,application_dates_text,date_precision,duration_text,source_status,study_stage_text,eligibility_text,expenses_text,official_url,application_url,active,research_checked_on,application_process_text,programme_structure_text,assessments_text,additional_details_text)
select o.id,'maitland-combar-mentoring-2026-27','COMBAR Mentoring Scheme 2026–27 — Maitland Participating Set',2026,2026,2026,'fixed_deadline',date '2026-10-23',time '23:59','Europe/London',date '2026-11-01',date '2027-06-30','Mentoring takes place during the 2026–27 cycle. A pupillage application and interview workshop and social event is planned for 13 January 2027.','The extended application deadline is 23:59 on 23 October 2026.','exact','2026–27 mentoring cycle','open','Undergraduates and graduates who do not hold a pupillage offer and have realistic prospects of obtaining a Commercial Bar pupillage.','Applicants must be from a group underrepresented at the Bar, demonstrate potential to pursue a career at the Commercial Bar and show that they would benefit from mentoring.','Participating sets cover reasonable travel expenses for mentees allocated to them.','https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/','https://www.combar.com/mentoring/combar-mentoring-scheme-for-under-represented-groups-and-support/',true,date '2026-10-15','Download and complete the COMBAR application form, save it as a PDF using the required naming convention and email it to MentoringURG@combar.com by the deadline.','Successful applicants receive one-to-one mentoring from a practitioner at a participating set, plus access to a pupillage application and interview workshop and social event.','COMBAR gives equal weight to applicants’ need for mentoring and their potential to pursue a career at the Bar.','COMBAR expects about 250 places across 26 participating sets; mentor allocation is managed by COMBAR.'
from public.career_opportunities o where o.organisation_id='094906c5-51f6-4e01-b001-c7d8f938f41b' and o.slug='maitland-combar-mentoring-2026-27'
and not exists (select 1 from public.career_opportunity_cycles c where c.opportunity_id=o.id);

commit;

begin;

update public.legal_organisations
set careers_url='https://www.maitlandchambers.com/pupillage-recruitment/pupillage',updated_at=now()
where id='094906c5-51f6-4e01-b001-c7d8f938f41b';

update public.career_opportunities
set official_url='https://www.maitlandchambers.com/pupillage-recruitment/pupillage',updated_at=now()
where id='faaf5474-7c4c-47ad-98f9-b1770ab924c2';
update public.career_opportunity_cycles
set official_url='https://www.maitlandchambers.com/pupillage-recruitment/pupillage',updated_at=now()
where id='42a46fae-51ed-4e4a-806c-e8aa72efc819';

delete from public.career_opportunity_routes
where opportunity_id=(select id from public.career_opportunities where organisation_id='094906c5-51f6-4e01-b001-c7d8f938f41b' and slug='maitland-mini-pupillage-october-november-2027')
  and route_kind='unresolved';

update public.career_opportunity_routes
set route_kind='flexible_scope',scope_key='partner-managed',route_status='confirmed',
    route_note='COMBAR manages mentor allocation across participating member sets.',display_order=100,updated_at=now()
where opportunity_id=(select id from public.career_opportunities where organisation_id='094906c5-51f6-4e01-b001-c7d8f938f41b' and slug='maitland-combar-mentoring-2026-27')
  and route_kind='unresolved';

commit;
