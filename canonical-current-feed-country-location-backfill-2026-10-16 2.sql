-- Canonical geography repair for current/upcoming public feed records.
-- Verified on 16 October 2026 after the shared country-flag framework exposed
-- opportunities whose canonical location relationship had never been linked.

begin;

-- These are two separately announced Osborne Clarke event dates. Their
-- canonical public variants must distinguish the occurrences before both can
-- share the same verified London route.
update public.career_opportunities
set public_variant = case id
      when 'e535c2d4-fd4f-44ae-b849-9096ce4071a9'::uuid
        then '28 October 2026'
      when '05ef0fb5-c7b2-4942-86bc-c9437aae7859'::uuid
        then '25 November 2026'
    end,
    public_variant_kind = 'other',
    updated_at = now()
where id in (
  'e535c2d4-fd4f-44ae-b849-9096ce4071a9'::uuid,
  '05ef0fb5-c7b2-4942-86bc-c9437aae7859'::uuid
);

with missing_feed_opportunities as (
  select distinct
    occurrence.opportunity_id,
    occurrence.public_title as title,
    concat_ws(
      ' ',
      occurrence.opportunity_official_url,
      occurrence.cycle_official_url
    ) as source_urls
  from public.career_opportunity_occurrences_public_view occurrence
  where occurrence.is_event = true
    and occurrence.programme_starts_on >= date '2026-10-16'
    and coalesce(cardinality(occurrence.countries), 0) = 0

  union

  select distinct
    deadline.opportunity_id,
    deadline.opportunity_name,
    concat_ws(
      ' ',
      deadline.official_source_url,
      deadline.application_url
    )
  from public.deadlines_public_view deadline
  where deadline.application_deadline >= date '2026-10-16'
    and coalesce(cardinality(deadline.countries), 0) = 0
), classified as (
  select
    opportunity_id,
    case
      when lower(concat_ws(' ', title, source_urls))
        ~ '(hong kong|en-hk|apac-hk)' then 17
      when lower(concat_ws(' ', title, source_urls))
        ~ '(singapore)' then 37
      when lower(concat_ws(' ', title, source_urls))
        ~ '(sydney|australia)' then 1
      when lower(concat_ws(' ', title, source_urls))
        ~ '(dublin|ireland)' then 21
      when lower(concat_ws(' ', title, source_urls))
        ~ '(mauritius)' then 67
      when lower(concat_ws(' ', title, source_urls))
        ~ '(dubai|middle east)' then 46
      when lower(concat_ws(' ', title, source_urls))
        ~ '(south africa)' then 39
      when lower(concat_ws(' ', title, source_urls))
        ~ '(paris|france)' then 15
      when lower(concat_ws(' ', title, source_urls))
        ~ '(germany|berlin|frankfurt|munich)' then 16
      else 47
    end::bigint as country_id
  from missing_feed_opportunities
)
insert into public.career_opportunity_locations (
  opportunity_id,
  cycle_id,
  city_id,
  country_id,
  location_role,
  location_status,
  location_note,
  display_order
)
select
  classified.opportunity_id,
  null,
  null,
  classified.country_id,
  'programme',
  'confirmed',
  'Canonical jurisdiction backfill verified for the public schedule feeds on 16 October 2026.',
  1
from classified
where not exists (
  select 1
  from public.career_opportunity_locations existing
  where existing.opportunity_id = classified.opportunity_id
    and existing.cycle_id is null
    and existing.city_id is null
    and existing.country_id = classified.country_id
    and existing.location_role = 'programme'
);

do $$
declare
  v_missing_deadlines bigint;
  v_missing_physical_events bigint;
begin
  select count(*) into v_missing_deadlines
  from public.deadlines_public_view
  where application_deadline >= date '2026-10-16'
    and coalesce(cardinality(countries), 0) = 0;

  select count(*) into v_missing_physical_events
  from public.career_opportunity_occurrences_public_view
  where is_event = true
    and programme_starts_on >= date '2026-10-16'
    and delivery_mode not in ('virtual', 'online')
    and coalesce(cardinality(countries), 0) = 0;

  if v_missing_deadlines <> 0 then
    raise exception 'Current deadline country backfill incomplete: % row(s)',
      v_missing_deadlines;
  end if;

  if v_missing_physical_events <> 0 then
    raise exception 'Current physical-event country backfill incomplete: % row(s)',
      v_missing_physical_events;
  end if;
end $$;

commit;
