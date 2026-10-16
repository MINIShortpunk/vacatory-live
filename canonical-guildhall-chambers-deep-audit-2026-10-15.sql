begin;

update public.legal_organisations
set careers_url='https://www.guildhallchambers.co.uk/careers/',
    research_status='verified',research_checked_on=date '2026-10-15',
    next_review_on=date '2026-11-09',updated_at=now()
where id='34e65b2b-ea45-4724-8960-2df9a81b0d67';

update public.chambers
set pupillage_overview='Guildhall recruits through the Pupillage Gateway. Its official page confirms pupillage beginning in October 2028 with a £60,000 package, split between a £30,000 grant and £30,000 guaranteed earnings, and up to £7,500 available for drawdown during the Bar Training Course year. The October 2028 opportunities will be advertised in November 2026. Pupils receive close supervision, a separate mentor, IT provision, internal training, funded relevant courses and paid first-six travel to professional engagements.',
    mini_pupillage_overview='Guildhall plans to offer about 30 mini-pupillages in 2027, with applications opening in November 2026. Applicants must have begun the second year of a law degree or started a law conversion course. Crime placements are offered during April, June or July, and September; civil placements are offered during June, July and September. Placements last up to three days and may include court, conferences, document review, group discussion and advocacy. Reasonable travel and accommodation expenses and adjustment support are available.',
    pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',
    research_status='verified',research_checked_on=date '2026-10-15',
    next_review_on=date '2026-11-09',updated_at=now()
where organisation_id='34e65b2b-ea45-4724-8960-2df9a81b0d67';

update public.career_opportunities
set official_name='Guildhall Chambers Mini-Pupillage — 2027 Programme',
    public_name='Guildhall Chambers Mini-Pupillage — 2027 Programme',
    public_summary='About 30 mini-pupillages are planned across Guildhall’s practice areas in 2027. Applications open in November 2026.',
    official_url='https://www.guildhallchambers.co.uk/careers/mini-pupillage/',
    application_url='https://www.guildhallchambers.co.uk/careers/mini-pupillage/',
    active=true,published=true,research_checked_on=date '2026-10-15',
    next_review_on=date '2026-11-09',updated_at=now()
where id='918adc16-fbe7-4cea-b2f4-074554391128';

update public.career_opportunity_cycles
set cycle_key='guildhall-chambers-mini-pupillage-2027',
    cycle_label='Guildhall Chambers Mini-Pupillage — 2027 Programme',
    application_year=2026,programme_year=2027,intake_year=2027,
    application_model='fixed_deadline',opens_on=null,opens_at=null,opens_timezone=null,
    closes_on=null,closes_at=null,closes_timezone=null,
    programme_dates_text='Applications open in November 2026. Crime placements are offered during April, June or July, and September 2027; civil placements are offered during June, July and September 2027.',
    date_precision='month',duration_text='Up to three days',places_text='About 30 mini-pupillages',
    source_status='upcoming',application_dates_text='Applications open in November 2026.',
    application_process_text='Apply using the form on Guildhall Chambers’ official mini-pupillage page when the 2027 application window opens.',
    source_status_note=null,additional_details_text='At least half of Guildhall’s mini-pupillages are reserved through its Bar None commitment for applicants from ethnic-minority backgrounds and state schools.',
    official_url='https://www.guildhallchambers.co.uk/careers/mini-pupillage/',
    application_url='https://www.guildhallchambers.co.uk/careers/mini-pupillage/',
    active=true,research_checked_on=date '2026-10-15',updated_at=now()
where id='e87790b7-542a-4774-a2c0-6b8456cbd696';

update public.career_opportunities
set official_name='Guildhall Chambers Pupillage — October 2028 Intake',
    public_name='Guildhall Chambers Pupillage — October 2028 Intake',
    public_summary='Guildhall will advertise pupillages beginning in October 2028 during November 2026. Each pupil receives a £60,000 funding package.',
    official_url='https://www.guildhallchambers.co.uk/careers/pupillage/',
    application_url='https://www.pupillagegateway.com/',active=true,published=true,
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-09',updated_at=now()
where id='5ddee2ea-4636-46b8-9832-e66d4ed3d3cf';

update public.career_opportunity_cycles
set cycle_key='guildhall-chambers-pupillage-october-2028',
    cycle_label='Guildhall Chambers Pupillage — October 2028 Intake',
    application_year=2026,programme_year=2028,intake_year=2028,
    application_model='fixed_deadline',opens_on=null,opens_at=null,opens_timezone=null,
    closes_on=null,closes_at=null,closes_timezone=null,
    programme_starts_on=date '2028-10-01',programme_ends_on=null,
    programme_dates_text='The application information will be released in November 2026. Pupillage begins in October 2028.',
    date_precision='month',duration_text='12 months',source_status='upcoming',
    application_dates_text='Application information will be released in November 2026.',
    application_process_text='Apply through the route stated in Guildhall’s November 2026 advert and the Pupillage Gateway listing.',
    funding_text='£60,000 comprising a £30,000 grant and £30,000 guaranteed second-six earnings. Up to £7,500 of the grant may be drawn down during the Bar Training Course year.',
    source_status_note=null,additional_details_text='Pupils receive IT equipment, close supervision, a separate mentor, internal training, funded relevant courses and paid first-six travel to professional engagements.',
    official_url='https://www.guildhallchambers.co.uk/careers/pupillage/',
    application_url='https://www.pupillagegateway.com/',active=true,
    research_checked_on=date '2026-10-15',updated_at=now()
where id='cc9146a2-be92-4d1c-9baf-bba72c7e2ea1';

-- Guildhall participates in the wider 10,000 Interns initiative, but the
-- Foundation controls matching and does not guarantee a Guildhall placement.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e' or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunity_cycle_routes where opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunity_compensation where opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunity_locations where opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunity_routes where opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunity_scope_assignments where opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunity_identity_stage where career_opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunity_cycles where opportunity_id='420208d5-2e50-4a87-86ea-4e495c216d5e';
delete from public.career_opportunities where id='420208d5-2e50-4a87-86ea-4e495c216d5e';

commit;
