begin;

update public.legal_organisations
set overview='Garden Court Chambers is a London barristers’ set founded in 1974 and known for work advancing civil liberties, human rights and social justice. Nearly 200 tenants practise across criminal defence, family, housing, immigration, public law, claims against public authorities, community care, the Court of Protection, education, environmental justice, mental health, welfare benefits, protest and international human rights.',
    careers_url='https://gardencourtchambers.co.uk/join-us/',
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='ebebbeb5-6187-4b0f-990b-0009a00897f0';

update public.chambers
set pupillage_overview='Garden Court recruits through the Pupillage Gateway. Its current published structure describes five 12-month pupillages: three general, one specialist crime and one specialist family. The award is £47,000, comprising £38,000 during the non-practising six and £9,000 guaranteed earnings during the practising six. Pupils receive an annual Zones 1–6 London Travelcard and reimbursement of appropriate additional travel expenses. Training includes three supervisors, structured in-house sessions and a junior-barrister buddy.',
    mini_pupillage_overview='Garden Court normally runs two five-day mini-pupillage courses each year, one in March and one in September or October, for eight to ten participants per course. Applicants must be over 18 and apply through Garden Court’s online form during an active application window. Mini-pupils attend hearings, undertake legal research, observe conferences and join practice-area talks. Garden Court also supports access programmes run by Bridging the Bar and Bringing (Dis)Ability to the Bar.',
    tenancy_overview='Every pupil who meets Garden Court’s published quality standard is offered tenancy, regardless of intended practice area.',
    pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',member_count=null,pupil_count=5,
    research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where organisation_id='ebebbeb5-6187-4b0f-990b-0009a00897f0';

-- Keep the open day exclusively as an event and replace legacy research notes with public facts.
update public.career_opportunities
set official_name='Garden Court Chambers Pupillage Open Day — 21 November 2026',
    public_name='Garden Court Chambers Pupillage Open Day — 21 November 2026',
    public_summary='Visit Garden Court Chambers from 10:00 to 13:00 on 21 November 2026 and speak with barristers about their experiences and pupillage. Attendance is free, advance booking is required and places are limited.',
    delivery_mode='in_person',official_url='https://gardencourtchambers.co.uk/join-us/',
    application_url='https://www.surveymonkey.com/r/VXG6QZS',active=true,published=true,
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-22',updated_at=now()
where id='c4ebb749-7900-47ca-ba5e-02051d561848';

update public.career_opportunity_cycles
set cycle_key='garden-court-pupillage-open-day-2026-11-21',
    cycle_label='Garden Court Chambers Pupillage Open Day — 21 November 2026',
    application_year=2026,programme_year=2026,intake_year=null,application_model='rolling',
    opens_on=null,opens_at=null,opens_timezone=null,closes_on=null,closes_at=null,closes_timezone=null,
    programme_starts_on=date '2026-11-21',programme_ends_on=date '2026-11-21',
    programme_dates_text='21 November 2026, 10:00–13:00, in person at Garden Court Chambers, 9 Carmelite Street, London EC4Y 0DR.',
    date_precision='exact',duration_text='Three hours',places_text='Limited places',source_status='open',
    audience_text='Aspiring barristers interested in Garden Court Chambers and its pupillage.',
    study_stage_text=null,academic_criteria=null,
    eligibility_text='Open to aspiring barristers; attendance is free and a place must be booked in advance.',
    application_dates_text='Booking is open while places remain available.',
    application_process_text='Reserve a free place through Garden Court’s official SurveyMonkey booking form.',
    assessments_text='Information event; no assessment.',progression_route_text=null,funding_text=null,expenses_text=null,
    travel_support_text=null,accommodation_support_text=null,right_to_work_text=null,
    disability_support_text='Contact Garden Court in advance about access needs so that reasonable adjustments can be arranged.',
    programme_structure_text='Visit chambers and speak with barristers about their experiences and Garden Court pupillage.',
    official_url='https://gardencourtchambers.co.uk/join-us/',application_url='https://www.surveymonkey.com/r/VXG6QZS',
    active=true,research_checked_on=date '2026-10-15',source_status_note=null,additional_details_text=null,updated_at=now()
where id='cb9a5715-23f6-44ed-ae81-049700e988ea';

update public.career_opportunity_locations
set location_note='Garden Court Chambers, 9 Carmelite Street, London EC4Y 0DR',location_status='confirmed'
where opportunity_id='c4ebb749-7900-47ca-ba5e-02051d561848';

update public.career_opportunity_routes
set route_note='Garden Court Chambers, 9 Carmelite Street, London EC4Y 0DR',route_status='confirmed',active=true
where opportunity_id='c4ebb749-7900-47ca-ba5e-02051d561848';

-- Permanently remove two past professional events and an indirect partner record that does not guarantee a Garden Court placement.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f') or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f'));
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunity_cycle_routes where opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunity_compensation where opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunity_locations where opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunity_routes where opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunity_scope_assignments where opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunity_identity_stage where career_opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunity_cycles where opportunity_id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');
delete from public.career_opportunities where id in ('114b1ba2-d16c-442b-bba6-873cf2577304','9363b272-a8c6-4f00-9066-f04e6f0c948e','3269329a-465d-442b-bd5f-2fb8e30c383f');

commit;
