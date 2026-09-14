-- Canonical fix: public event/deadline occurrences should use cycle-specific
-- locations when a cycle has them, falling back to opportunity-level locations
-- only where no cycle-specific location exists.
--
-- This prevents separate events on the same date from looking duplicated when
-- they share one parent opportunity but occur in different cities.

create or replace view public.career_opportunity_occurrences_public_view as
with eligible as (
  select
    o.id as opportunity_id,
    o.slug as opportunity_slug,
    o.official_name,
    o.delivery_mode,
    o.official_url as opportunity_official_url,
    o.application_url as opportunity_application_url,
    o.research_checked_on as opportunity_research_checked_on,
    org.id as provider_id,
    org.organisation_type as provider_type,
    org.name as provider_name,
    org.short_name as provider_short_name,
    org.slug as provider_slug,
    org.logo_url as provider_logo_url,
    ot.id as opportunity_type_id,
    ot.slug as opportunity_type_slug,
    ot.label as opportunity_type_label,
    ot.category as opportunity_category,
    ot.career_pathway,
    ot.slug = 'open_day'::text or o.event_type_id is not null as is_event,
    et.id as event_type_id,
    et.slug as event_type_slug,
    et.label as event_type_label,
    c.id as cycle_id,
    c.application_year,
    c.programme_year,
    c.intake_year,
    c.application_model,
    c.opens_on,
    c.closes_on,
    c.closes_at,
    c.closes_timezone,
    c.programme_starts_on,
    c.programme_ends_on,
    c.programme_dates_text,
    c.date_precision,
    c.duration_text,
    c.places_text,
    c.may_close_early,
    c.application_url as cycle_application_url,
    c.official_url as cycle_official_url,
    c.research_checked_on as cycle_research_checked_on,
    s.public_application_status,
    s.public_application_date_state,
    s.has_exact_application_deadline,
    s.days_until_deadline,
    s.deadline_group,
    s.deadline_key
  from public.career_opportunity_cycles c
  join public.career_opportunity_cycle_semantics_view s on s.cycle_id = c.id
  join public.career_opportunities o on o.id = c.opportunity_id
  join public.legal_organisations org on org.id = o.organisation_id
  join public.opportunity_types ot on ot.id = o.opportunity_type_id
  left join public.career_event_types et on et.id = o.event_type_id
  where c.active = true
    and o.active = true
    and o.published = true
    and org.active = true
    and ot.active = true
    and (o.event_type_id is null or et.active = true)
    and (
      ((ot.slug = 'open_day'::text or o.event_type_id is not null) and c.programme_starts_on is not null)
      or s.has_exact_application_deadline is true
    )
),
target_opportunities as (
  select distinct eligible.opportunity_id
  from eligible
),
ranked_cycles as (
  select
    c.id,
    c.opportunity_id,
    row_number() over (
      partition by c.opportunity_id
      order by
        case s.public_application_status
          when 'open'::text then 10
          when 'rolling'::text then 20
          when 'available'::text then 30
          when 'upcoming'::text then 40
          when 'variable'::text then 50
          when 'no_application'::text then 60
          when 'unknown'::text then 70
          when 'closed'::text then 90
          else 100
        end,
        case when s.public_application_status = 'open'::text then c.closes_on else null::date end,
        case when s.public_application_status = 'upcoming'::text then c.opens_on else null::date end,
        case when c.programme_starts_on >= current_date then c.programme_starts_on else null::date end,
        case when s.public_application_status = 'closed'::text then c.closes_on else null::date end desc nulls last,
        c.application_year desc nulls last,
        c.programme_year desc nulls last,
        c.intake_year desc nulls last,
        c.id
    ) as display_cycle_rank
  from public.career_opportunity_cycles c
  join public.career_opportunity_cycle_semantics_view s on s.cycle_id = c.id
  join target_opportunities t on t.opportunity_id = c.opportunity_id
  where c.active = true
),
location_rows as (
  select
    l.opportunity_id,
    l.cycle_id,
    l.country_id,
    country.name as country_name,
    l.city_id,
    city.name as city_name,
    l.location_role,
    l.location_status
  from public.career_opportunity_locations l
  join target_opportunities t on t.opportunity_id = l.opportunity_id
  join public.geo_countries country on country.id = l.country_id
  left join public.geo_cities city on city.id = l.city_id
),
visible_location_rows as (
  select *
  from location_rows
  where location_role <> 'context'::text
    and location_status <> all (array['unavailable'::text, 'historical'::text])
),
effective_location_rows as (
  select
    e.opportunity_id,
    e.cycle_id as occurrence_cycle_id,
    l.country_id,
    l.country_name,
    l.city_id,
    l.city_name,
    l.location_role,
    l.location_status
  from eligible e
  join visible_location_rows l
    on l.opportunity_id = e.opportunity_id
   and (
     l.cycle_id = e.cycle_id
     or (
       l.cycle_id is null
       and not exists (
         select 1
         from visible_location_rows cycle_l
         where cycle_l.opportunity_id = e.opportunity_id
           and cycle_l.cycle_id = e.cycle_id
       )
     )
   )
),
location_country_groups as (
  select
    opportunity_id,
    occurrence_cycle_id as cycle_id,
    country_id,
    country_name,
    bool_or(city_id is null) as has_country_only_relationship,
    string_agg(distinct city_name, ', '::text order by city_name) filter (where city_name is not null) as city_names
  from effective_location_rows
  group by opportunity_id, occurrence_cycle_id, country_id, country_name
),
location_summary_cte as (
  select
    opportunity_id,
    cycle_id,
    string_agg(
      case
        when has_country_only_relationship then country_name
        when nullif(btrim(city_names), ''::text) is not null then (country_name || ': '::text) || city_names
        else country_name
      end,
      '; '::text order by country_name
    ) as location_summary
  from location_country_groups
  group by opportunity_id, cycle_id
),
location_stats as (
  select
    opportunity_id,
    occurrence_cycle_id as cycle_id,
    array_agg(distinct country_name order by country_name) as countries,
    array_agg(distinct city_name order by city_name) filter (where city_name is not null) as cities,
    count(distinct country_id) filter (where location_role = 'programme'::text and location_status = any (array['confirmed'::text, 'conditional'::text]))::integer as programme_country_count,
    string_agg(distinct country_name, ' / '::text order by country_name) filter (where location_role = 'programme'::text and location_status = any (array['confirmed'::text, 'conditional'::text])) as programme_country_names,
    count(distinct country_id)::integer as visible_country_count,
    string_agg(distinct country_name, ' / '::text order by country_name) as visible_country_names
  from effective_location_rows
  group by opportunity_id, occurrence_cycle_id
),
location_public as (
  select
    s.opportunity_id,
    s.cycle_id,
    coalesce(s.countries, array[]::text[]) as countries,
    coalesce(s.cities, array[]::text[]) as cities,
    summary.location_summary,
    case
      when s.programme_country_count = 1 then s.programme_country_names
      when s.programme_country_count = 2 then s.programme_country_names
      when s.programme_country_count > 2 then 'International'::text
      when s.programme_country_count = 0 and s.visible_country_count = 1 then s.visible_country_names
      when s.programme_country_count = 0 and s.visible_country_count = 2 then s.visible_country_names
      when s.programme_country_count = 0 and s.visible_country_count > 2 then 'International'::text
      else null::text
    end as title_geography
  from location_stats s
  left join location_summary_cte summary on summary.opportunity_id = s.opportunity_id and summary.cycle_id = s.cycle_id
)
select
  (e.opportunity_id::text || ':'::text) || e.cycle_id::text as occurrence_id,
  e.opportunity_id,
  e.opportunity_slug,
  e.official_name,
  case
    when nullif(btrim(loc.title_geography), ''::text) is not null then (loc.title_geography || ' - '::text) || replace(replace(e.official_name, '—'::text, '-'::text), '–'::text, '-'::text)
    else replace(replace(e.official_name, '—'::text, '-'::text), '–'::text, '-'::text)
  end as public_title,
  e.delivery_mode,
  e.provider_id,
  e.provider_type,
  e.provider_name,
  e.provider_short_name,
  e.provider_slug,
  e.provider_logo_url,
  e.opportunity_type_id,
  e.opportunity_type_slug,
  e.opportunity_type_label,
  e.opportunity_category,
  e.career_pathway,
  e.is_event,
  e.event_type_id,
  e.event_type_slug,
  e.event_type_label,
  coalesce(loc.countries, array[]::text[]) as countries,
  coalesce(loc.cities, array[]::text[]) as cities,
  loc.location_summary,
  e.opportunity_application_url,
  e.opportunity_official_url,
  greatest(e.opportunity_research_checked_on, e.cycle_research_checked_on) as last_verified_on,
  e.cycle_id,
  coalesce(r.display_cycle_rank = 1, false) as is_display_cycle,
  e.application_year,
  e.programme_year,
  e.intake_year,
  e.application_model,
  e.opens_on,
  e.closes_on,
  e.closes_at::text as closes_at,
  e.closes_timezone,
  e.public_application_status,
  e.public_application_date_state,
  e.has_exact_application_deadline,
  e.days_until_deadline,
  e.deadline_group,
  e.deadline_key,
  e.programme_starts_on,
  e.programme_ends_on,
  e.programme_dates_text,
  e.date_precision,
  e.duration_text,
  e.places_text,
  coalesce(e.programme_ends_on, e.programme_starts_on) as occurrence_ends_on,
  e.may_close_early,
  e.cycle_application_url,
  e.cycle_official_url
from eligible e
left join ranked_cycles r on r.id = e.cycle_id
left join location_public loc on loc.opportunity_id = e.opportunity_id and loc.cycle_id = e.cycle_id;
