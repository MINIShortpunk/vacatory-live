begin;

update public.legal_organisations
set overview='Civitas Chambers is a Cardiff-based specialist civil and public law barristers’ chambers serving clients across Wales and England. Its work covers administrative and public law, alternative dispute resolution, chancery and commercial disputes, employment, personal injury and clinical negligence.',
    careers_url='https://www.civitaschambers.co.uk/join-us/',research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2027-01-04',updated_at=now()
where id='e9d1535f-d09e-4583-b9bb-bd049c7a65f9';

update public.chambers
set pupillage_overview='Civitas recruits pupils through the Pupillage Gateway and offers pupillage only to candidates it regards as prospective tenants. The 12-month training includes work with two pupil supervisors, experience across its civil and public law practices, advocacy development and opportunities to undertake work during the practising period.',
    mini_pupillage_overview='Civitas offers observational three-day mini-pupillages between June and September each year. Applicants must be undertaking or have completed a degree and are selected for strong academic ability and interests beyond legal study. Apply by emailing a CV and covering letter to the clerks by 1 June each year, including availability between June and September.',
    tenancy_overview='Civitas recruits pupils as prospective tenants. Established-practitioner and membership recruitment is separate from the student-opportunity inventory.',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2027-01-04',updated_at=now()
where organisation_id='e9d1535f-d09e-4583-b9bb-bd049c7a65f9';

update public.career_opportunities
set official_name='Civitas Chambers Mini-Pupillage 2027',public_name='Civitas Chambers Mini-Pupillage 2027',
    public_summary='Email a CV and covering letter by 1 June 2027 for a three-day observational mini-pupillage taking place between June and September 2027.',
    official_url='https://www.civitaschambers.co.uk/join-us/mini-pupillage/',application_url='mailto:clerks@civitaslaw.com',
    delivery_mode='in_person',research_checked_on=date '2026-10-15',next_review_on=date '2027-06-02',updated_at=now()
where id='02f977f5-552a-4a71-8214-cf82eed82ac3';

update public.career_opportunity_cycles
set cycle_key='civitas-chambers-mini-pupillage-2027',cycle_label='Civitas Chambers Mini-Pupillage 2027',
    application_year=2027,programme_year=2027,application_model='fixed_deadline',opens_on=null,opens_at=null,
    closes_on=date '2027-06-01',closes_at=null,programme_starts_on=date '2027-06-01',programme_ends_on=date '2027-09-30',
    date_precision='month',duration_text='Three days',places_text='Places are limited',source_status='open',
    application_dates_text='Applications are accepted by email and must be submitted by 1 June 2027.',
    programme_dates_text='Three-day placements take place between June and September 2027 on dates agreed with successful applicants.',
    audience_text='Degree students and graduates considering a career at the Bar.',
    eligibility_text='Applicants must be undertaking a degree course or have successfully completed one.',
    application_process_text='Email a CV and covering letter to clerks@civitaslaw.com by 1 June 2027. Include availability between June and September, explain your interest in Civitas and highlight relevant experience or activities.',
    assessments_text='Observational mini-pupillage; selection is based on academic ability and interests or activities beyond legal study.',
    source_status_note=null,additional_details_text='Successful applicants are contacted directly to agree placement dates.',
    official_url='https://www.civitaschambers.co.uk/join-us/mini-pupillage/',application_url='mailto:clerks@civitaslaw.com',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='02f977f5-552a-4a71-8214-cf82eed82ac3';

-- Permanently remove the closed January 2026 pupillage recruitment record and its dependants.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb' or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunity_cycle_routes where opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunity_compensation where opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunity_locations where opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunity_routes where opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunity_scope_assignments where opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunity_identity_stage where career_opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunity_cycles where opportunity_id='10425886-4e55-4e93-aedd-70cd556a67eb';
delete from public.career_opportunities where id='10425886-4e55-4e93-aedd-70cd556a67eb';

commit;
