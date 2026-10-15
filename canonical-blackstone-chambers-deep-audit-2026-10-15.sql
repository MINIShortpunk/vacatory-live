begin;

update public.legal_organisations
set overview='Blackstone Chambers is a London barristers’ set practising across commercial law, public law and human rights, employment, EU and competition, international law, sport, media and entertainment, telecommunications, financial services and related specialist fields. Its members act in major domestic and international litigation, arbitration and regulatory proceedings.',
    careers_url='https://pupillage.blackstonechambers.com/',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='4b209065-6fb5-42fc-91da-26da235f4eee';

update public.chambers
set pupillage_overview='Blackstone Chambers is recruiting for non-practising pupillages beginning in September 2028. Its Gateway advertisement goes live on 23 November 2026, applications open on 4 January 2027 and close on 28 January 2027. Blackstone normally offers four pupillages and names one reserve. The award is £90,000, with up to £30,000 available as an advance during the BPC year.',
    mini_pupillage_overview='Blackstone’s three-day mini-pupillage is an assessed stage of its pupillage selection process, not a separately open scheme. Candidates are shortlisted after the Gateway application, academic and contextual review, a timed written assessment and a first-stage interview. The 2027 mini-pupillages run from 15 March to 23 April. Financial assistance of up to £250 is available for travel and out-of-pocket accommodation costs, with additional support considered in exceptional circumstances.',
    tenancy_overview='Blackstone has no tenancy quota. Pupils may be offered tenancy if they meet the published Blackstone standard, assessed through their work and performance during the non-practising training year.',
    pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where organisation_id='4b209065-6fb5-42fc-91da-26da235f4eee';

update public.career_opportunities
set official_name='Blackstone Chambers Pupillage — September 2028 Intake',public_name='Blackstone Chambers Pupillage — September 2028 Intake',
    public_summary='Apply through the Pupillage Gateway from 4 to 28 January 2027 for a non-practising pupillage beginning in September 2028, with a £90,000 award.',
    official_url='https://pupillage.blackstonechambers.com/',application_url='https://www.pupillagegateway.com/',
    active=true,published=true,research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='89a07271-a504-46a4-8087-3c62dfef6f14';

update public.career_opportunity_cycles
set cycle_key='blackstone-chambers-pupillage-september-2028',cycle_label='Blackstone Chambers Pupillage — September 2028 Intake',
    application_year=2027,programme_year=2028,intake_year=2028,application_model='fixed_deadline',
    opens_on=date '2027-01-04',opens_at=time '11:00',opens_timezone='Europe/London',closes_on=date '2027-01-28',closes_at=time '23:59',closes_timezone='Europe/London',
    programme_starts_on=date '2028-09-01',programme_ends_on=null,date_precision='month',duration_text='12 months',places_text='Four pupillages and one reserve',source_status='upcoming',
    application_dates_text='The Gateway advertisement goes live on 23 November 2026. Applications open on 4 January 2027 and close on 28 January 2027.',
    programme_dates_text='Non-practising pupillage beginning in September 2028.',
    application_process_text='Apply through the Pupillage Gateway. Selection includes academic and contextual review, a timed written assessment on 6 February 2027, online first-stage interviews from 25 February to 4 March, assessed mini-pupillages from 15 March to 23 April, and final interviews on 4 and 5 May. Offers are made on 7 May 2027.',
    assessments_text='Academic and contextual scoring, written application review, a remote timed written assessment, a first-stage interview, an assessed three-day mini-pupillage and a final interview including oral advocacy.',
    funding_text='£90,000 pupillage award, with up to £30,000 available as an advance during the BPC year.',
    expenses_text='Mini-pupillage candidates may receive up to £250 for travel and out-of-pocket accommodation costs, with additional support considered in exceptional circumstances.',
    official_url='https://pupillage.blackstonechambers.com/',application_url='https://www.pupillagegateway.com/',research_checked_on=date '2026-10-15',source_status_note=null,additional_details_text=null,updated_at=now()
where opportunity_id='89a07271-a504-46a4-8087-3c62dfef6f14';

update public.career_opportunity_compensation
set amount=90000,currency_code='GBP',frequency='total',amount_text='£90,000 pupillage award',
    details='Up to £30,000 may be drawn down during the BPC year.',compensation_status='published_amount',source_status='current September 2028 intake',updated_at=now()
where opportunity_id='89a07271-a504-46a4-8087-3c62dfef6f14';

-- Remove indirect partner schemes that do not guarantee a Blackstone placement or Blackstone-specific application route.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a') or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a'));
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunity_cycle_routes where opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunity_compensation where opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunity_locations where opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunity_routes where opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunity_scope_assignments where opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunity_identity_stage where career_opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunity_cycles where opportunity_id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');
delete from public.career_opportunities where id in ('2ad42973-ff88-4f6e-bb27-3b7337ad2336','a1c970eb-0d5b-49cd-a928-7be10f1dbfbd','31ecb8b3-5b01-451f-a17d-c72298c6134a');

update public.career_opportunities set event_type_id='f2ad34e9-2e06-4dd6-8c0e-a20ec0e597a3',delivery_mode='in_person',application_url='https://forms.cloud.microsoft/Pages/ResponsePage.aspx?id=x0PQTeVVlEetG9owdnMUJbdAJZP9TzdItT068qe5vBJUQVlFMEZFOVRYTFNTMENYRElHRlVKQ0owSS4u',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-26',updated_at=now() where id='a4a64982-ac3e-487a-8ce3-bd2c63f62a7c';
update public.career_opportunities set event_type_id='0300485e-aa81-437d-9318-57fbcba0eda5',delivery_mode='online',application_url='https://forms.cloud.microsoft/Pages/ResponsePage.aspx?id=x0PQTeVVlEetG9owdnMUJbdAJZP9TzdItT068qe5vBJUQUIxSDgzSFJQRjUwRzlRMlBPMEJaRUFTNy4u',research_checked_on=date '2026-10-15',next_review_on=date '2026-12-09',updated_at=now() where id='38f5a081-b76d-41fb-97fb-01a3c66e1396';
update public.career_opportunities set event_type_id='0300485e-aa81-437d-9318-57fbcba0eda5',delivery_mode='online',application_url='https://forms.cloud.microsoft/Pages/ResponsePage.aspx?id=x0PQTeVVlEetG9owdnMUJbdAJZP9TzdItT068qe5vBJUMEk2TlQ5MFgxTkNGNDBWVjBBMklLSTRQRS4u',research_checked_on=date '2026-10-15',next_review_on=date '2027-01-15',updated_at=now() where id='e30a7326-619e-41d3-8ac0-98ab3ed45d6f';

insert into public.career_opportunity_cycles (opportunity_id,cycle_key,cycle_label,programme_year,application_model,programme_starts_on,programme_ends_on,programme_dates_text,date_precision,source_status,audience_text,eligibility_text,application_process_text,assessments_text,official_url,application_url,active,research_checked_on)
select 'a4a64982-ac3e-487a-8ce3-bd2c63f62a7c','blackstone-pupillage-information-evening-2026','Blackstone Chambers Pupillage Information Evening — 25 November 2026',2026,'rolling',date '2026-11-25',date '2026-11-25','25 November 2026 at Blackstone Chambers, 3 Garden Court, Temple, London EC4Y 9BW.','exact','open','Prospective applicants interested in Blackstone Chambers pupillage.','Free information event for people considering pupillage at Blackstone Chambers.','Register using the form linked from Blackstone Chambers’ official events page.','Information event; no assessment.','https://pupillage.blackstonechambers.com/events-webinars/','https://forms.cloud.microsoft/Pages/ResponsePage.aspx?id=x0PQTeVVlEetG9owdnMUJbdAJZP9TzdItT068qe5vBJUQVlFMEZFOVRYTFNTMENYRElHRlVKQ0owSS4u',true,date '2026-10-15'
where not exists(select 1 from public.career_opportunity_cycles where opportunity_id='a4a64982-ac3e-487a-8ce3-bd2c63f62a7c');

insert into public.career_opportunity_cycles (opportunity_id,cycle_key,cycle_label,programme_year,application_model,programme_starts_on,programme_ends_on,programme_dates_text,date_precision,source_status,audience_text,eligibility_text,application_process_text,assessments_text,official_url,application_url,active,research_checked_on)
select '38f5a081-b76d-41fb-97fb-01a3c66e1396','blackstone-pupillage-information-webinar-2026-12-08','Blackstone Chambers Pupillage Information Webinar — 8 December 2026',2026,'rolling',date '2026-12-08',date '2026-12-08','Online webinar on 8 December 2026.','exact','open','Prospective applicants interested in Blackstone Chambers pupillage.','Free online information event for people considering pupillage at Blackstone Chambers.','Register using the form linked from Blackstone Chambers’ official events page.','Information event; no assessment.','https://pupillage.blackstonechambers.com/events-webinars/','https://forms.cloud.microsoft/Pages/ResponsePage.aspx?id=x0PQTeVVlEetG9owdnMUJbdAJZP9TzdItT068qe5vBJUQUIxSDgzSFJQRjUwRzlRMlBPMEJaRUFTNy4u',true,date '2026-10-15'
where not exists(select 1 from public.career_opportunity_cycles where opportunity_id='38f5a081-b76d-41fb-97fb-01a3c66e1396');

insert into public.career_opportunity_cycles (opportunity_id,cycle_key,cycle_label,programme_year,application_model,programme_starts_on,programme_ends_on,programme_dates_text,date_precision,source_status,audience_text,eligibility_text,application_process_text,assessments_text,official_url,application_url,active,research_checked_on)
select 'e30a7326-619e-41d3-8ac0-98ab3ed45d6f','blackstone-pupillage-information-webinar-2027-01-14','Blackstone Chambers Pupillage Information Webinar — 14 January 2027',2027,'rolling',date '2027-01-14',date '2027-01-14','Online webinar on 14 January 2027.','exact','open','Prospective applicants interested in Blackstone Chambers pupillage.','Free online information event for people considering pupillage at Blackstone Chambers.','Register using the form linked from Blackstone Chambers’ official events page.','Information event; no assessment.','https://pupillage.blackstonechambers.com/events-webinars/','https://forms.cloud.microsoft/Pages/ResponsePage.aspx?id=x0PQTeVVlEetG9owdnMUJbdAJZP9TzdItT068qe5vBJUMEk2TlQ5MFgxTkNGNDBWVjBBMklLSTRQRS4u',true,date '2026-10-15'
where not exists(select 1 from public.career_opportunity_cycles where opportunity_id='e30a7326-619e-41d3-8ac0-98ab3ed45d6f');

insert into public.career_opportunity_locations (opportunity_id,city_id,country_id,location_note,display_order,location_role,location_status)
select 'a4a64982-ac3e-487a-8ce3-bd2c63f62a7c',139,47,'Blackstone Chambers, 3 Garden Court, Temple, London EC4Y 9BW',10,'programme','confirmed'
where not exists(select 1 from public.career_opportunity_locations where opportunity_id='a4a64982-ac3e-487a-8ce3-bd2c63f62a7c' and city_id=139);

insert into public.career_opportunity_routes (opportunity_id,route_kind,country_id,city_id,display_order,active,route_status,route_note)
select 'a4a64982-ac3e-487a-8ce3-bd2c63f62a7c','physical_city',47,139,10,true,'confirmed','Blackstone Chambers, 3 Garden Court, Temple, London EC4Y 9BW'
where not exists(select 1 from public.career_opportunity_routes where opportunity_id='a4a64982-ac3e-487a-8ce3-bd2c63f62a7c' and route_kind='physical_city' and city_id=139);

update public.career_opportunities
set application_url=null,research_checked_on=date '2026-10-15',next_review_on=date '2026-10-18',updated_at=now()
where id='e85aa575-749d-49ab-a635-71e06b87dd2c';
update public.career_opportunity_cycles
set application_model='rolling',source_status='open',application_dates_text=null,application_process_text='Attend the Bar Council Pupillage Fair and meet Blackstone Chambers representatives.',assessments_text='Information event; no assessment.',expenses_text=null,source_status_note=null,additional_details_text=null,research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='e85aa575-749d-49ab-a635-71e06b87dd2c';

insert into public.career_opportunities (id,organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,display_order,research_checked_on,next_review_on)
select '3517d189-2fe7-4e18-8853-d065082b322a','4b209065-6fb5-42fc-91da-26da235f4eee','5e2816dd-108f-4443-9fb2-218def79147f','0565330b-8f5f-45ff-9314-1f3b25ebf243','blackstone-chambers-targetjobs-national-pupillage-fair-2026','Targetjobs National Pupillage Fair 2026 — Meet Blackstone Chambers','Targetjobs National Pupillage Fair 2026 — Meet Blackstone Chambers','Meet Blackstone Chambers and other pupillage providers at the Targetjobs National Pupillage Fair on 21 November 2026.','in_person','https://pupillage.blackstonechambers.com/events-webinars/','https://targetjobs.co.uk/events/national-pupillage-fair-2026',true,true,500,date '2026-10-15',date '2026-11-22'
where not exists(select 1 from public.career_opportunities where id='3517d189-2fe7-4e18-8853-d065082b322a');

insert into public.career_opportunity_cycles (opportunity_id,cycle_key,cycle_label,programme_year,application_model,programme_starts_on,programme_ends_on,programme_dates_text,date_precision,duration_text,source_status,audience_text,eligibility_text,application_process_text,assessments_text,official_url,application_url,active,research_checked_on)
select '3517d189-2fe7-4e18-8853-d065082b322a','blackstone-targetjobs-national-pupillage-fair-2026','Targetjobs National Pupillage Fair 2026 — Meet Blackstone Chambers',2026,'rolling',date '2026-11-21',date '2026-11-21','21 November 2026, 10:30–15:00, at the Honourable Society of Lincoln’s Inn in central London.','exact','Four and a half hours','open','Aspiring barristers and students exploring a career at the Bar.','Open to people interested in pupillage and Bar careers.','Register through the Targetjobs National Pupillage Fair page.','Information and careers event; no assessment.','https://pupillage.blackstonechambers.com/events-webinars/','https://targetjobs.co.uk/events/national-pupillage-fair-2026',true,date '2026-10-15'
where not exists(select 1 from public.career_opportunity_cycles where opportunity_id='3517d189-2fe7-4e18-8853-d065082b322a');

insert into public.career_opportunity_locations (opportunity_id,city_id,country_id,location_note,display_order,location_role,location_status)
select '3517d189-2fe7-4e18-8853-d065082b322a',139,47,'The Honourable Society of Lincoln’s Inn, central London',10,'programme','confirmed'
where not exists(select 1 from public.career_opportunity_locations where opportunity_id='3517d189-2fe7-4e18-8853-d065082b322a' and city_id=139);

insert into public.career_opportunity_routes (opportunity_id,route_kind,country_id,city_id,display_order,active,route_status,route_note)
select '3517d189-2fe7-4e18-8853-d065082b322a','physical_city',47,139,10,true,'confirmed','The Honourable Society of Lincoln’s Inn, central London'
where not exists(select 1 from public.career_opportunity_routes where opportunity_id='3517d189-2fe7-4e18-8853-d065082b322a' and route_kind='physical_city' and city_id=139);

commit;
