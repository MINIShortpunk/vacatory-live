begin;

update public.legal_organisations
set overview='Byrom Street Chambers is a specialist barristers’ set based in Manchester’s Spinningfields district. Its members handle high-value and complex civil work, particularly catastrophic personal injury, clinical negligence, industrial disease, professional liability, multi-party litigation, inquiries, insurance, regulatory matters, commercial disputes and mediation. Byrom Street does not currently recruit pupils but offers direct, unassessed mini-pupillages.',
    careers_url='https://www.byromstreet.com/mini-pupillage',research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2027-01-12',updated_at=now()
where id='3f037934-1d75-4fec-be97-b3dfd41e7cdd';

update public.chambers
set pupillage_overview='Byrom Street Chambers states that it does not currently offer pupillage. Its mini-pupillages are unassessed and are not a pupillage selection stage.',
    mini_pupillage_overview='Byrom Street offers unassessed two-day mini-pupillages in two recurring annual periods: 1 March–30 June and 1 October–15 December. Applications are accepted only from 12–16 January for period 1 and 1–5 September for period 2. There is normally one place per week and a maximum of seven places in each period. Applicants use the official form rather than a CV or covering letter.',
    tenancy_overview='Byrom Street publishes no student pupillage, third-six or student-to-tenancy route. Ordinary membership recruitment is outside the student-opportunity inventory.',
    pupillage_gateway_member=false,pupillage_gateway_url=null,research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2027-01-12',updated_at=now()
where organisation_id='3f037934-1d75-4fec-be97-b3dfd41e7cdd';

update public.career_opportunities
set official_name='Byrom Street Mini-Pupillage — Spring/Summer 2027',public_name='Byrom Street Mini-Pupillage — Spring/Summer 2027',
    public_summary='Apply from 12 to 16 January 2027 for an unassessed two-day mini-pupillage taking place between 1 March and 30 June 2027.',
    official_url='https://www.byromstreet.com/mini-pupillage',application_url='https://www.byromstreet.com/mini-pupillage',
    delivery_mode='hybrid',research_checked_on=date '2026-10-15',next_review_on=date '2027-01-17',updated_at=now()
where id='1817df2d-43ad-422b-9f39-bda0f25277d4';

update public.career_opportunity_cycles
set cycle_key='byrom-street-mini-pupillage-spring-summer-2027',cycle_label='Byrom Street Mini-Pupillage — Spring/Summer 2027',
    application_year=2027,programme_year=2027,application_model='fixed_deadline',
    opens_on=date '2027-01-12',closes_on=date '2027-01-16',programme_starts_on=date '2027-03-01',programme_ends_on=date '2027-06-30',
    date_precision='exact',duration_text='Two consecutive days',places_text='Maximum seven places during the period',source_status='upcoming',
    application_dates_text='Applications are accepted from 12 to 16 January 2027 inclusive. Successful applicants are notified by 2 February 2027.',
    programme_dates_text='Two-day placements take place from 1 March to 30 June 2027.',
    application_process_text='Download and complete the official application form when it appears on the chambers website, then email it to applications@byromstreet.com during the application window. Do not send a CV or covering letter.',
    assessments_text='Unassessed mini-pupillage.',source_status_note=null,
    additional_details_text='Applicants should contact chambers four to seven days before the placement before committing to travel because remote work may affect the available diary.',
    official_url='https://www.byromstreet.com/mini-pupillage',application_url='https://www.byromstreet.com/mini-pupillage',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='1817df2d-43ad-422b-9f39-bda0f25277d4';

update public.career_opportunities
set official_name='Byrom Street Mini-Pupillage — Autumn 2027',public_name='Byrom Street Mini-Pupillage — Autumn 2027',
    public_summary='Apply from 1 to 5 September 2027 for an unassessed two-day mini-pupillage taking place between 1 October and 15 December 2027.',
    official_url='https://www.byromstreet.com/mini-pupillage',application_url='https://www.byromstreet.com/mini-pupillage',
    delivery_mode='hybrid',research_checked_on=date '2026-10-15',next_review_on=date '2027-09-06',updated_at=now()
where id='6a90f55f-47c6-40fc-9331-a83810e52db6';

update public.career_opportunity_cycles
set cycle_key='byrom-street-mini-pupillage-autumn-2027',cycle_label='Byrom Street Mini-Pupillage — Autumn 2027',
    application_year=2027,programme_year=2027,application_model='fixed_deadline',
    opens_on=date '2027-09-01',closes_on=date '2027-09-05',programme_starts_on=date '2027-10-01',programme_ends_on=date '2027-12-15',
    date_precision='exact',duration_text='Two consecutive days',places_text='Maximum seven places during the period',source_status='upcoming',
    application_dates_text='Applications are accepted from 1 to 5 September 2027 inclusive. Successful applicants are notified by 22 September 2027.',
    programme_dates_text='Two-day placements take place from 1 October to 15 December 2027.',
    application_process_text='Download and complete the official application form when it appears on the chambers website, then email it to applications@byromstreet.com during the application window. Do not send a CV or covering letter.',
    assessments_text='Unassessed mini-pupillage.',source_status_note=null,
    additional_details_text='Applicants should contact chambers four to seven days before the placement before committing to travel because remote work may affect the available diary.',
    official_url='https://www.byromstreet.com/mini-pupillage',application_url='https://www.byromstreet.com/mini-pupillage',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='6a90f55f-47c6-40fc-9331-a83810e52db6';

-- Remove the indirect partner programme because no Byrom Street placement is guaranteed.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8' or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunity_cycle_routes where opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunity_compensation where opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunity_locations where opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunity_routes where opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunity_scope_assignments where opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunity_identity_stage where career_opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunity_cycles where opportunity_id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';
delete from public.career_opportunities where id='c90d9336-f65d-4c8d-bbb5-5c09fe02eea8';

commit;
