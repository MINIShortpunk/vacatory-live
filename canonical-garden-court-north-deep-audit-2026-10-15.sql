begin;

update public.legal_organisations
set careers_url='https://gcnchambers.co.uk/join/',
    research_status='verified',
    research_checked_on=date '2026-10-15',
    next_review_on=date '2026-12-01',
    updated_at=now()
where id='88cbaf6c-e155-4606-b619-5d7ea39cc5cb';

update public.chambers
set pupillage_overview='Garden Court North recruits through the Pupillage Gateway. Its official pupillage page currently states that applications are closed and does not provide a current application window or future intake date. The selection process uses a scored application, a short first interview and a longer second interview including an oral advocacy exercise. The award is linked to the real living wage and includes all second-six earnings; reasonable interview travel and qualifying pupillage travel and course expenses are reimbursed.',
    mini_pupillage_overview='Garden Court North offers at least one mini-pupillage session each calendar year. A session spans two weeks, with up to two placements in each week; each placement lasts one to three days and at least two days is recommended. Applicants must be 18 or over. Weight is given to lower-income applicants, interest in legal-aid or civil-liberties and human-rights work, and those without previous legal work experience. Applications are closed and the official page does not provide the next application dates. Reasonable necessary travel is reimbursed and adjustments are available during application and placement.',
    pupillage_gateway_member=true,
    pupillage_gateway_url='https://www.pupillagegateway.com/',
    research_status='verified',
    research_checked_on=date '2026-10-15',
    next_review_on=date '2026-12-01',
    updated_at=now()
where organisation_id='88cbaf6c-e155-4606-b619-5d7ea39cc5cb';

-- The only canonical opportunity was an unpublished placeholder with no current
-- application window. Remove it and all dependent rows rather than retaining an
-- inactive or archived record.
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b'
   or compensation_id in (
     select id from public.career_opportunity_compensation
     where opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b'
   );
delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunity_cycle_routes
where opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunity_compensation
where opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunity_locations
where opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunity_routes
where opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunity_scope_assignments
where opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunity_location_candidate_stage
where career_opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunity_location_migration_stage
where career_opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunity_identity_stage
where career_opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunity_cycles
where opportunity_id='1affaf7e-0b05-430e-b682-f0785f40003b';
delete from public.career_opportunities
where id='1affaf7e-0b05-430e-b682-f0785f40003b';

commit;
