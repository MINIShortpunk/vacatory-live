create or replace view public.deadlines_public_view as
with ranked as (
  select
    d_1.*,
    row_number() over (
      partition by d_1.opportunity_id, d_1.closes_on
      order by d_1.closes_at, d_1.programme_starts_on, d_1.cycle_id
    ) as deadline_rank
  from public.career_opportunity_occurrences_public_view d_1
  where d_1.has_exact_application_deadline = true
    and d_1.is_event = false
    and d_1.closes_on >= current_date
    and d_1.public_application_status = any (
      array['open'::text, 'upcoming'::text, 'rolling'::text, 'available'::text]
    )
)
select
  deadline_key,
  'career_opportunity_cycle'::text as record_type,
  cycle_id,
  opportunity_id,
  provider_id,
  provider_type,
  provider_name,
  provider_slug,
  provider_logo_url,
  case
    when provider_type = 'law_firm'::text then provider_id
    else null::uuid
  end as firm_id,
  career_pathway,
  opportunity_type_slug,
  opportunity_type_label,
  opportunity_category,
  public_title as opportunity_name,
  opportunity_slug,
  coalesce(application_year, programme_year, intake_year) as cycle_year,
  application_model,
  opens_on as application_open,
  closes_on as application_deadline,
  public_application_status as application_status,
  days_until_deadline,
  deadline_group,
  countries,
  cities,
  location_summary,
  programme_starts_on as programme_start,
  programme_ends_on as programme_end,
  programme_dates_text,
  duration_text as duration,
  coalesce(
    nullif(btrim(cycle_application_url), ''::text),
    nullif(btrim(opportunity_application_url), ''::text),
    nullif(btrim(cycle_official_url), ''::text),
    nullif(btrim(opportunity_official_url), ''::text)
  ) as application_url,
  coalesce(
    nullif(btrim(cycle_official_url), ''::text),
    nullif(btrim(opportunity_official_url), ''::text)
  ) as official_source_url,
  null::text as official_source_title,
  last_verified_on as last_checked_on,
  case
    when last_verified_on is not null then 'verified'::text
    else 'needs_review'::text
  end as research_status,
  case
    when may_close_early then 'The provider says this opportunity may close early.'::text
    else null::text
  end as status_note
from ranked d
where deadline_rank = 1;
