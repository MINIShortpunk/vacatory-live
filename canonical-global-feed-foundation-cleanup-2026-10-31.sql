begin;

-- Canonical global feed cleanup verified 31 October 2026.
create temporary table _elapsed_public_events(id uuid primary key) on commit drop;
insert into _elapsed_public_events(id)
select distinct e.opportunity_id
from public.career_opportunity_occurrences_public_view e
where e.is_event and e.occurrence_ends_on < date '2026-10-31'
and not exists (
 select 1 from public.career_opportunity_cycles c
 where c.opportunity_id=e.opportunity_id and c.active
 and coalesce(c.programme_ends_on,c.programme_starts_on)>=date '2026-10-31'
);
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in (select id from _elapsed_public_events);
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in (select id from _elapsed_public_events);
delete from public.career_opportunity_identity_stage where career_opportunity_id in (select id from _elapsed_public_events);
delete from public.career_opportunities where id in (select id from _elapsed_public_events);
with locations(provider_slug,opportunity_slug,country_name,city_name,note) as (values
 ('penningtons-manches-cooper','birmingham-open-day-17-november-2026','United Kingdom','Birmingham','Birmingham'),
 ('penningtons-manches-cooper','disability-open-day-24-november-2026','United Kingdom','London','London'),
 ('penningtons-manches-cooper','guildford-open-day-1-december-2026','United Kingdom','Guildford','Guildford'),
 ('blackstone-chambers','blackstone-targetjobs-national-pupillage-fair-21-november-2026','United Kingdom','London','The Honourable Society of Lincoln’s Inn, London'),
 ('blackstone-chambers','blackstone-women-at-the-commercial-bar-9-december-2026','United Kingdom','London','Blackstone Chambers, London / online')
)
insert into public.career_opportunity_locations
(opportunity_id,country_id,city_id,location_note,display_order,location_role,location_status)
select co.id,gc.id,ct.id,l.note,100,'venue','confirmed'
from locations l
join public.legal_organisations lo on lo.slug=l.provider_slug
join public.career_opportunities co on co.organisation_id=lo.id and co.slug=l.opportunity_slug
join public.geo_countries gc on gc.name=l.country_name
join public.geo_cities ct on ct.country_id=gc.id and ct.name=l.city_name
where not exists (select 1 from public.career_opportunity_locations x where x.opportunity_id=co.id and x.country_id=gc.id and x.city_id=ct.id);
commit;
