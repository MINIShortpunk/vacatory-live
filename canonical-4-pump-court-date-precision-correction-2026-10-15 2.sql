begin;

update public.career_opportunity_cycles
set closes_at = null,
    closes_timezone = null,
    research_checked_on = date '2026-10-15',
    updated_at = now()
where opportunity_id in (
  '3f06b8be-da6a-4215-9297-9e8a0c710ab9',
  'be086048-56a6-4d9c-8b76-cb878c258e51',
  'e6016e7a-ee91-40f8-917f-8c58178c6cb0',
  '72e34480-fe74-4d21-8403-7e29fe3e5759'
);

commit;
