begin;

update public.career_opportunities set
 slug='trinity-chambers-10000-black-interns-summer-2027',
 research_checked_on=date '2026-10-15',updated_at=now()
where id='12b397eb-d202-49a8-acd5-331a458ca782';

-- Placement months are published, but individual attendance days are arranged later.
update public.career_opportunity_cycles set
 date_precision='text_only',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id in
 ('c63b9dcd-a022-44dd-9c09-958701ac8930','4c81e504-4f9d-45c2-a009-abd7ec1f9a0a');

-- Remove the obsolete unresolved route and replace internal route wording with public information.
delete from public.career_opportunity_routes
where opportunity_id='12b397eb-d202-49a8-acd5-331a458ca782'
and route_kind='unresolved';

update public.career_opportunity_routes set
 route_note='UK-wide allocation through the 10,000 Black Interns programme.',
 route_status='confirmed',active=true,updated_at=now()
where opportunity_id='12b397eb-d202-49a8-acd5-331a458ca782'
and route_kind='flexible_scope';

commit;
