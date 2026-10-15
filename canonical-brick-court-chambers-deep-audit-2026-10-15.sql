begin;

update public.legal_organisations
set overview='Brick Court Chambers is a London barristers’ chambers specialising in commercial law, competition law, public law, international and EU law, arbitration and mediation. Members appear in domestic and international courts, European institutions and arbitral proceedings.',
    careers_url='https://www.brickcourt.co.uk/pupillage-and-mini-pupillage/pupillage',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='363323c4-8cbf-4adc-b90d-2844cce1c570';

update public.chambers
set pupillage_overview='Brick Court normally offers up to five 12-month pupillages through the Pupillage Gateway. Applications for pupillages commencing in 2028 open on 4 January 2027 and close on 28 January 2027. The current official page states a £90,000 award for the 2027/28 pupillage year, divided into £60,000 during the non-practising period and £30,000 during the practising period.',
    mini_pupillage_overview='Brick Court no longer accepts separate mini-pupillage applications. Every Pupillage Gateway application for a pupillage commencing in 2028 is first considered as an application for an assessed mini-pupillage. The assessed placement normally lasts two days and includes supervised work and a standard written exercise. In-person participants may claim £10 per day, up to £100 for each necessary overnight stay and reasonable travel expenses on receipts.',
    tenancy_overview='Brick Court recruits tenants from its pupils on merit rather than by quota. Pupils normally sit with three supervisors and receive senior and junior mentors, formal reviews, standardised blind written assessments and advocacy exercises. Brick Court does not normally offer third-six pupillages.',
    pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where organisation_id='363323c4-8cbf-4adc-b90d-2844cce1c570';

update public.career_opportunities
set official_name='Brick Court Chambers Pupillage — 2028 Commencement',
    public_name='Brick Court Chambers Pupillage — 2028 Commencement',
    public_summary='Apply through the Pupillage Gateway from 4 to 28 January 2027 for a 12-month pupillage commencing in 2028. Applications are first assessed for Brick Court’s compulsory mini-pupillage stage.',
    official_url='https://www.brickcourt.co.uk/pupillage-and-mini-pupillage/pupillage',
    application_url='https://www.pupillagegateway.com/',active=true,published=true,
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='38472636-9627-4b18-b528-9f9cccd70bad';

update public.career_opportunity_cycles
set cycle_key='brick-court-chambers-pupillage-2028',cycle_label='Brick Court Chambers Pupillage — 2028 Commencement',
    application_year=2027,programme_year=2028,intake_year=2028,application_model='fixed_deadline',
    opens_on=date '2027-01-04',closes_on=date '2027-01-28',programme_starts_on=date '2028-09-01',date_precision='month',duration_text='12 months',places_text='Up to five pupillages',source_status='upcoming',
    application_dates_text='Applications open on 4 January 2027 and close on 28 January 2027 through the Pupillage Gateway.',
    programme_dates_text='Twelve-month pupillage commencing in 2028.',
    application_process_text='Apply through the Pupillage Gateway. Each application is first considered for an assessed mini-pupillage. The two-day assessed placement includes supervised work and a standard written exercise. Candidates are then considered for final interview, which includes an advocacy exercise.',
    assessments_text='Anonymous paper review, assessed mini-pupillage, standard written exercise and final interview with an advocacy assessment.',
    expenses_text='For mini-pupillages held in chambers, Brick Court offers £10 per day, up to £100 for each necessary overnight stay for candidates based outside London and reasonable travel expenses on receipts.',
    official_url='https://www.brickcourt.co.uk/pupillage-and-mini-pupillage/pupillage',application_url='https://www.pupillagegateway.com/',
    source_status_note=null,additional_details_text='Members undertake international work. Where an appropriate opportunity arises, Brick Court funds a pupil to attend one hearing before a European court or institution.',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='38472636-9627-4b18-b528-9f9cccd70bad';

update public.career_opportunity_compensation
set amount=90000,currency_code='GBP',frequency='total',amount_text='£90,000 award stated for the 2027/28 pupillage year',
    details='The current official pupillage page states £60,000 during the non-practising period and £30,000 during the practising period.',
    compensation_status='published_amount',source_status='current official pupillage page',updated_at=now()
where opportunity_id='38472636-9627-4b18-b528-9f9cccd70bad';

-- Remove the indirect partner programme: participation does not guarantee a Brick Court placement.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145' or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunity_cycle_routes where opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunity_compensation where opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunity_locations where opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunity_routes where opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunity_scope_assignments where opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunity_identity_stage where career_opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunity_cycles where opportunity_id='093c6153-a14e-4f5e-b9ef-eb88862bb145';
delete from public.career_opportunities where id='093c6153-a14e-4f5e-b9ef-eb88862bb145';

commit;
