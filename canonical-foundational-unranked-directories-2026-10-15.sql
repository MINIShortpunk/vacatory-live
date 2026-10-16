-- Foundational removal of firm and chambers rankings.
-- Public directories now use natural numerical/alphabetical name ordering.
-- Keep legacy columns and view shapes for API compatibility, but remove all
-- ranking values so deadline, event and homepage consumers cannot rank items.

begin;

do $$
declare
  deadlines_before bigint;
  events_before bigint;
  active_firms_before bigint;
  active_chambers_before bigint;
begin
  select count(*) into deadlines_before from public.deadlines_public_view;
  select count(*) into events_before
  from public.career_opportunity_occurrences_public_view
  where is_event = true;
  select count(*) into active_firms_before from public.firms where active = true;
  select count(*) into active_chambers_before
  from public.legal_organisations
  where organisation_type = 'barristers_chambers' and active = true;

  update public.firms
  set uk_rank = null,
      updated_at = now()
  where uk_rank is not null;

  delete from public.chamber_rankings;

  if exists (select 1 from public.firms where uk_rank is not null) then
    raise exception 'Firm ranking removal failed';
  end if;

  if exists (select 1 from public.chamber_rankings) then
    raise exception 'Chambers ranking removal failed';
  end if;

  if deadlines_before <> (select count(*) from public.deadlines_public_view) then
    raise exception 'Deadline feed row count changed during ranking removal';
  end if;

  if events_before <> (
    select count(*)
    from public.career_opportunity_occurrences_public_view
    where is_event = true
  ) then
    raise exception 'Event feed row count changed during ranking removal';
  end if;

  if active_firms_before <> (select count(*) from public.firms where active = true) then
    raise exception 'Active firm count changed during ranking removal';
  end if;

  if active_chambers_before <> (
    select count(*)
    from public.legal_organisations
    where organisation_type = 'barristers_chambers' and active = true
  ) then
    raise exception 'Active chambers count changed during ranking removal';
  end if;
end
$$;

commit;
