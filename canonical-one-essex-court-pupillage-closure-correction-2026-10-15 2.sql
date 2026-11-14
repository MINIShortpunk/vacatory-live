begin;
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id='733cf815-d16c-443d-aed7-bab37823d1a0';
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id='733cf815-d16c-443d-aed7-bab37823d1a0';
delete from public.career_opportunity_identity_stage where career_opportunity_id='733cf815-d16c-443d-aed7-bab37823d1a0';
delete from public.career_opportunities where id='733cf815-d16c-443d-aed7-bab37823d1a0';
update public.chambers set pupillage_overview='One Essex Court recruits pupils through the Pupillage Gateway. The most recent vacancy offered October 2027 and October 2028 start options and closed on 22 January 2026. Pupils sit with three supervisors and receive a £90,000 award, while retaining second-six earnings. All pupils who meet the required standard are offered tenancy.',next_review_on=date '2026-11-23',updated_at=now() where organisation_id='4d88055b-f3d8-41ab-a009-6de45b57b928';
commit;
