-- Permanent cleanup of passed or undated events/deadlines, 7 November 2026.
-- Explicitly ongoing, rolling, recurring, partner-managed and always-available records are protected.

begin;

create temporary table _delete_obsolete_opportunities(id uuid primary key) on commit drop;

with classified as (
  select o.id,o.event_type_id,
         bool_or(c.closes_on is not null) has_deadline,
         max(c.closes_on) max_deadline,
         bool_or(c.closes_on < date '2026-11-07'
           or lower(coalesce(c.source_status,'')) in ('closed','full','fully_booked')) event_registration_closed,
         bool_or(c.programme_starts_on is not null) has_programme_date,
         max(c.programme_ends_on) max_programme_end,
         bool_or(
           lower(coalesce(c.application_model,'')) in ('rolling','always_available','no_application')
           or lower(coalesce(c.source_status,'')) ~
             '(ongoing|recurr|rolling|always|vacancy|partner|through_vacation_scheme|vacation_scheme_only|official_route_confirmed)'
         ) explicit_ongoing
  from career_opportunities o
  left join career_opportunity_cycles c on c.opportunity_id=o.id
  where o.active and o.published
  group by o.id,o.event_type_id
)
insert into _delete_obsolete_opportunities(id)
select id from classified
where
  (event_type_id is not null and max_programme_end < date '2026-11-07')
  or (event_type_id is not null and event_registration_closed)
  or (event_type_id is not null and not has_programme_date and not explicit_ongoing)
  or (event_type_id is null and has_deadline and max_deadline < date '2026-11-07')
  or (event_type_id is null and not has_deadline and not has_programme_date and not explicit_ongoing);

delete from career_opportunity_compensation_identity_stage s using _delete_obsolete_opportunities d where s.career_opportunity_id=d.id;
delete from career_opportunity_cycle_identity_stage s using _delete_obsolete_opportunities d where s.career_opportunity_id=d.id;
delete from career_opportunity_identity_stage s using _delete_obsolete_opportunities d where s.career_opportunity_id=d.id;
delete from career_opportunity_location_candidate_stage s using _delete_obsolete_opportunities d where s.career_opportunity_id=d.id;
delete from career_opportunity_location_migration_stage s using _delete_obsolete_opportunities d where s.career_opportunity_id=d.id;
delete from career_opportunity_routes s using _delete_obsolete_opportunities d where s.opportunity_id=d.id;
delete from career_opportunity_scope_assignments s using _delete_obsolete_opportunities d where s.opportunity_id=d.id;
delete from career_opportunity_cycle_routes s using _delete_obsolete_opportunities d where s.opportunity_id=d.id;
delete from career_opportunity_locations s using _delete_obsolete_opportunities d where s.opportunity_id=d.id;
delete from career_opportunity_compensation s using _delete_obsolete_opportunities d where s.opportunity_id=d.id;
delete from career_opportunity_cycles s using _delete_obsolete_opportunities d where s.opportunity_id=d.id;
delete from career_opportunities s using _delete_obsolete_opportunities d where s.id=d.id;

commit;
