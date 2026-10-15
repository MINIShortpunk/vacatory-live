begin;

update public.legal_organisations
set careers_url='https://www.hendersonpupillage.co.uk/',research_status='verified',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-23',updated_at=now()
where id='4d1e053a-174d-4fc3-90ed-f65d6c8727ea';

update public.chambers
set pupillage_overview='Henderson recruits funded 12-month pupils through the Pupillage Gateway. Its published recruitment information describes an £85,000 award plus the pupil’s own second-six earnings, with up to £40,000 available as drawdown after acceptance. Pupils rotate through four supervisors, receive assessed advocacy training and continuous feedback, undertake their own cases in second six and may complete a one-month Turks and Caicos secondment with flights and self-catering accommodation provided. Henderson’s next vacancy will be added when its advert appears on the Pupillage Gateway.',
    mini_pupillage_overview='Henderson offers unassessed mini-pupillages lasting one to three days. Applicants must be at least 18 and are assessed for academic record, wider achievement, commitment to the Bar and enthusiasm for Henderson’s work. Applications close at midday on 20 November 2026 for January to April 2027 placements, midday on 19 March 2027 for May to July placements, and midday on 16 July 2027 for September to December placements. Shadowing travel expenses are paid and up to 15 annual bursaries of £200 support eligible candidates outside London.',
    pupillage_gateway_member=true,pupillage_gateway_url='https://www.pupillagegateway.com/',
    research_status='verified',research_checked_on=date '2026-10-15',
    next_review_on=date '2026-11-23',updated_at=now()
where organisation_id='4d1e053a-174d-4fc3-90ed-f65d6c8727ea';

update public.career_opportunities
set public_summary='One- to three-day Henderson Chambers mini-pupillage between May and July 2027, with applications closing at midday on 19 March 2027.',
    research_checked_on=date '2026-10-15',next_review_on=date '2027-03-20',updated_at=now()
where id='8e0e92be-bb91-4096-8511-5d457bb1aa4a';

update public.career_opportunity_cycles
set cycle_key='henderson-mini-pupillage-may-july-2027',
    cycle_label='Henderson Chambers Mini-Pupillage — May to July 2027',
    date_precision='exact',duration_text='One to three days',source_status='open',
    application_dates_text='Applications close at midday on 19 March 2027.',
    official_url='https://www.hendersonpupillage.co.uk/mini-pupillage/how-to-apply',
    application_url='https://www.hendersonpupillage.co.uk/mini-pupillage/application-form',
    research_checked_on=date '2026-10-15',updated_at=now()
where id='932580fc-fcdc-47cf-be3e-f9b8fa390392';

update public.career_opportunities
set public_summary='One- to three-day Henderson Chambers mini-pupillage between September and December 2027, with applications closing at midday on 16 July 2027.',
    application_url='https://www.hendersonpupillage.co.uk/mini-pupillage/application-form',
    research_checked_on=date '2026-10-15',next_review_on=date '2027-07-17',updated_at=now()
where id='a490689d-88a5-41c2-8c3e-fe11609bc90e';

update public.career_opportunity_cycles
set cycle_key='henderson-mini-pupillage-september-december-2027',
    cycle_label='Henderson Chambers Mini-Pupillage — September to December 2027',
    date_precision='exact',duration_text='One to three days',source_status='open',
    application_dates_text='Applications close at midday on 16 July 2027.',
    expenses_text='Travel costs incurred while shadowing members outside chambers are paid. Henderson offers up to 15 annual £200 bursaries for eligible candidates outside London.',
    official_url='https://www.hendersonpupillage.co.uk/mini-pupillage/how-to-apply',
    application_url='https://www.hendersonpupillage.co.uk/mini-pupillage/application-form',
    research_checked_on=date '2026-10-15',updated_at=now()
where id='7fe5bb6c-711f-4755-a29d-65f18a5286c5';

update public.career_opportunities
set research_checked_on=date '2026-10-15',next_review_on=date '2026-11-21',updated_at=now()
where id='c0d084cf-1604-4eec-9191-7d53aaec275c';

update public.career_opportunity_cycles
set date_precision='exact',duration_text='One to three days',source_status='open',
    application_dates_text='Applications close at midday on 20 November 2026.',
    official_url='https://www.hendersonpupillage.co.uk/mini-pupillage/how-to-apply',
    application_url='https://www.hendersonpupillage.co.uk/mini-pupillage/application-form',
    research_checked_on=date '2026-10-15',updated_at=now()
where id='29c43ce2-8321-48b3-b8f8-cd63e096f1b0';

-- Closed probationary tenancy is a post-pupillage recruitment route, not a
-- current law-student opportunity.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef' or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef');
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunity_cycle_routes where opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunity_compensation where opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunity_locations where opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunity_routes where opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunity_scope_assignments where opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunity_location_migration_stage where career_opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunity_identity_stage where career_opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunity_cycles where opportunity_id='b5e34401-4197-46fd-8474-ed2fdcac78ef';
delete from public.career_opportunities where id='b5e34401-4197-46fd-8474-ed2fdcac78ef';

commit;
