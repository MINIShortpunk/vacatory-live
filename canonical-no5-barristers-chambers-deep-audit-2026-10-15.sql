begin;

update public.legal_organisations set
 research_status='verified',research_checked_on=date '2026-10-15',
 next_review_on=date '2026-11-24',
 uk_visa_summary='Applicants who require immigration permission should contact No5 directly before applying to confirm the right-to-work and sponsorship arrangements available for the relevant pupillage intake.',
 uk_visa_checked_on=date '2026-10-15',
 uk_visa_source_url='https://www.no5.com/recruitment/pupillage/',
 uk_visa_source_title='No5 Barristers’ Chambers — Pupillage',
 updated_at=now()
where id='e46c1cdc-d113-439e-a95c-37f6ea00c043';

update public.chambers set
 pupillage_overview='No5 offers 12-month pupillages across selected practice groups, with placements based in Birmingham and/or London according to the recruiting group. The most recently published recruitment round, for pupillages commencing in 2027, is closed. That round offered up to twelve places, a £30,000 first-six award, guaranteed second-six billings of at least £30,000 and funded compulsory training.',
 mini_pupillage_overview='No5 does not currently advertise a standalone mini-pupillage application route. In its most recently completed pupillage recruitment round, candidates progressing beyond the advocacy exercise attended a one-day assessed mini-pupillage before final interview.',
 tenancy_overview='Pupillages are offered with a view to tenancy where the published benchmark requirements are met. Staff, probationary-tenancy and established-practitioner recruitment are excluded from Vacatory.',
 research_status='verified',research_checked_on=date '2026-10-15',
 next_review_on=date '2026-11-24',updated_at=now()
where organisation_id='e46c1cdc-d113-439e-a95c-37f6ea00c043';

delete from public.career_opportunity_routes
where opportunity_id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';
delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';
delete from public.career_opportunity_identity_stage
where career_opportunity_id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';
delete from public.career_opportunities
where id='d229f90c-1bf2-4949-ba27-5d67b4ad4319';

commit;
