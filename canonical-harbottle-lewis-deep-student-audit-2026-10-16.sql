-- Harbottle & Lewis global student-opportunity audit, 16 October 2026.
-- Official evidence checked: Grad Hub, application, route, FAQ and main-site
-- careers/about pages. The firm has one London office with a global practice;
-- no separate overseas student programme is currently published.

begin;

do $$
declare
  v_deadline_count bigint;
  v_event_count bigint;
begin
  select count(*) into v_deadline_count from public.deadlines_public_view;
  select count(*) into v_event_count
  from public.career_opportunity_occurrences_public_view
  where is_event = true;

  perform set_config('vacatory.harbottle_deadline_count', v_deadline_count::text, true);
  perform set_config('vacatory.harbottle_event_count', v_event_count::text, true);
end $$;

insert into public.firm_programmes (
  firm_id, organisation_id, slug, programme_name, exact_official_name,
  programme_type, location_text, country_text, delivery_mode, career_stage,
  description, duration_text, qualification_or_outcome, active, published,
  status, status_note, application_url, primary_source_url,
  research_checked_on, next_review_on, display_order, opportunity_level,
  audience_text, student_priority, current_status, scope_status,
  application_date_summary, programme_date_summary, date_precision,
  application_opens_on, application_closes_on, date_status_note
) values
(
  'f6097783-a65c-47ea-b39c-c9a0821bebc4',
  'f6097783-a65c-47ea-b39c-c9a0821bebc4',
  'london-training-contract-2029',
  'London Training Contract 2029',
  'Training Contract',
  'training_contract',
  'London',
  'United Kingdom',
  'in_person',
  'graduate',
  'Two-year London training contract comprising four six-month seats. Harbottle & Lewis recruits six trainees each year, with three beginning in March and three in September.',
  'Two years',
  'Solicitor qualification route',
  true, true,
  'upcoming',
  'Applications open on 1 November 2026.',
  'https://gradhub.harbottle.com/grad-hub/your-application/',
  'https://gradhub.harbottle.com/grad-hub/',
  date '2026-10-16', date '2026-11-01', 10,
  'graduate',
  'Law and non-law students and graduates seeking a London training contract. Applicants should hold or expect at least a 2:1 degree; strong A-level results are considered without a fixed grade threshold, and mitigating circumstances are considered.',
  true, 'upcoming', 'in_scope',
  'Applications open on 1 November 2026.',
  'Six places each year: three March starters and three September starters. The contract lasts two years across four six-month seats.',
  'exact', date '2026-11-01', null,
  'The official Grad Hub publishes the opening date for the 2029 training-contract cycle.'
),
(
  'f6097783-a65c-47ea-b39c-c9a0821bebc4',
  'f6097783-a65c-47ea-b39c-c9a0821bebc4',
  'sutton-trust-social-mobility-work-experience',
  'Sutton Trust Social Mobility Work Experience',
  'Social Mobility Work Experience Programme',
  'work_experience',
  'London',
  'United Kingdom',
  'in_person',
  'school_student',
  'A recurring summer programme delivered with the Sutton Trust. Six students visit the London office for legal talks, lawyer Q&A, trainee-task shadowing, a CV and skills workshop, a written task and a presentation.',
  'Summer programme',
  'Legal work experience and skills development',
  true, true,
  'current',
  'Participation is arranged through the Sutton Trust social-mobility programme.',
  'https://www.suttontrust.com/our-programmes/pathways-to-law/',
  'https://www.harbottle.com/about/',
  date '2026-10-16', date '2027-01-16', 20,
  'school_student',
  'Students selected through the Sutton Trust social-mobility programme.',
  true, 'current', 'in_scope',
  'Participation is arranged through the Sutton Trust programme.',
  'The programme runs during the summer.',
  'text_only', null, null,
  'Harbottle & Lewis states that it welcomes six students to its London office each summer.'
)
on conflict (firm_id, slug) do update set
  organisation_id = excluded.organisation_id,
  programme_name = excluded.programme_name,
  exact_official_name = excluded.exact_official_name,
  programme_type = excluded.programme_type,
  location_text = excluded.location_text,
  country_text = excluded.country_text,
  delivery_mode = excluded.delivery_mode,
  career_stage = excluded.career_stage,
  description = excluded.description,
  duration_text = excluded.duration_text,
  qualification_or_outcome = excluded.qualification_or_outcome,
  active = true,
  published = true,
  status = excluded.status,
  status_note = excluded.status_note,
  application_url = excluded.application_url,
  primary_source_url = excluded.primary_source_url,
  research_checked_on = excluded.research_checked_on,
  next_review_on = excluded.next_review_on,
  display_order = excluded.display_order,
  opportunity_level = excluded.opportunity_level,
  audience_text = excluded.audience_text,
  student_priority = excluded.student_priority,
  current_status = excluded.current_status,
  scope_status = excluded.scope_status,
  application_date_summary = excluded.application_date_summary,
  programme_date_summary = excluded.programme_date_summary,
  date_precision = excluded.date_precision,
  application_opens_on = excluded.application_opens_on,
  application_closes_on = excluded.application_closes_on,
  date_status_note = excluded.date_status_note,
  updated_at = now();

insert into public.career_opportunities (
  organisation_id, opportunity_type_id, slug, official_name, public_name,
  public_summary, delivery_mode, official_url, application_url, active,
  published, display_order, research_checked_on, next_review_on,
  canonical_public_suppressed
)
select
  fp.organisation_id,
  ot.id,
  fp.slug,
  fp.exact_official_name,
  fp.programme_name,
  fp.description,
  fp.delivery_mode,
  fp.primary_source_url,
  fp.application_url,
  true,
  true,
  fp.display_order,
  fp.research_checked_on,
  fp.next_review_on,
  false
from public.firm_programmes fp
join public.opportunity_types ot
  on ot.slug = case fp.programme_type
    when 'training_contract' then 'training_contract'
    when 'work_experience' then 'work_experience'
  end
where fp.firm_id = 'f6097783-a65c-47ea-b39c-c9a0821bebc4'
  and fp.slug in (
    'london-training-contract-2029',
    'sutton-trust-social-mobility-work-experience'
  )
on conflict (organisation_id, slug) do update set
  opportunity_type_id = excluded.opportunity_type_id,
  official_name = excluded.official_name,
  public_name = excluded.public_name,
  public_summary = excluded.public_summary,
  delivery_mode = excluded.delivery_mode,
  official_url = excluded.official_url,
  application_url = excluded.application_url,
  active = true,
  published = true,
  display_order = excluded.display_order,
  research_checked_on = excluded.research_checked_on,
  next_review_on = excluded.next_review_on,
  canonical_public_suppressed = false,
  canonical_public_suppression_reason = null,
  updated_at = now();

insert into public.career_opportunity_cycles (
  opportunity_id, cycle_key, cycle_label, application_year, programme_year,
  intake_year, application_model, opens_on, closes_on,
  application_dates_text, programme_dates_text, date_precision,
  duration_text, places_text, source_status, audience_text,
  study_stage_text, academic_criteria, eligibility_text,
  programme_structure_text, funding_text, disability_support_text,
  official_url, application_url, active, research_checked_on
)
select
  co.id,
  '2026-27-london-training-contract-2029',
  'London Training Contract 2029',
  2026,
  2029,
  2029,
  'fixed_deadline',
  date '2026-11-01',
  null,
  'Applications open on 1 November 2026.',
  'Six places each year: three March starters and three September starters.',
  'exact',
  'Two years',
  'Six training contracts each year',
  'upcoming',
  fp.audience_text,
  'University students and graduates',
  'At least a 2:1 degree; strong A-level results are considered without a fixed grade threshold. Mitigating circumstances are considered.',
  fp.audience_text,
  'Four six-month seats selected from the firm''s London practice groups.',
  'For non-law graduates, Harbottle & Lewis funds the PGDL course fees and provides a £6,000 maintenance grant. The firm partners with BPP for SQE preparation.',
  'Reasonable adjustments are available during recruitment through the application form.',
  fp.primary_source_url,
  fp.application_url,
  true,
  date '2026-10-16'
from public.career_opportunities co
join public.firm_programmes fp
  on fp.organisation_id = co.organisation_id and fp.slug = co.slug
where co.organisation_id = 'f6097783-a65c-47ea-b39c-c9a0821bebc4'
  and co.slug = 'london-training-contract-2029'
on conflict (opportunity_id, cycle_key) do update set
  cycle_label = excluded.cycle_label,
  application_year = excluded.application_year,
  programme_year = excluded.programme_year,
  intake_year = excluded.intake_year,
  application_model = excluded.application_model,
  opens_on = excluded.opens_on,
  closes_on = excluded.closes_on,
  application_dates_text = excluded.application_dates_text,
  programme_dates_text = excluded.programme_dates_text,
  date_precision = excluded.date_precision,
  duration_text = excluded.duration_text,
  places_text = excluded.places_text,
  source_status = excluded.source_status,
  audience_text = excluded.audience_text,
  study_stage_text = excluded.study_stage_text,
  academic_criteria = excluded.academic_criteria,
  eligibility_text = excluded.eligibility_text,
  programme_structure_text = excluded.programme_structure_text,
  funding_text = excluded.funding_text,
  disability_support_text = excluded.disability_support_text,
  official_url = excluded.official_url,
  application_url = excluded.application_url,
  active = true,
  research_checked_on = excluded.research_checked_on,
  updated_at = now();

insert into public.career_opportunity_cycles (
  opportunity_id, cycle_key, cycle_label, application_model,
  application_dates_text, programme_dates_text, date_precision,
  duration_text, places_text, source_status, audience_text,
  study_stage_text, eligibility_text, programme_structure_text,
  official_url, application_url, active, research_checked_on
)
select
  co.id,
  'recurring-summer-sutton-trust-work-experience',
  'Sutton Trust Social Mobility Work Experience',
  'unknown',
  'Participation is arranged through the Sutton Trust programme.',
  'The programme runs during the summer.',
  'text_only',
  'Summer programme',
  'Six students each summer',
  'recurring',
  fp.audience_text,
  'School students',
  fp.audience_text,
  'Legal talks and presentations, lawyer Q&A, trainee-task shadowing, a CV and skills workshop, a written task and a presentation.',
  fp.primary_source_url,
  fp.application_url,
  true,
  date '2026-10-16'
from public.career_opportunities co
join public.firm_programmes fp
  on fp.organisation_id = co.organisation_id and fp.slug = co.slug
where co.organisation_id = 'f6097783-a65c-47ea-b39c-c9a0821bebc4'
  and co.slug = 'sutton-trust-social-mobility-work-experience'
on conflict (opportunity_id, cycle_key) do update set
  cycle_label = excluded.cycle_label,
  application_model = excluded.application_model,
  application_dates_text = excluded.application_dates_text,
  programme_dates_text = excluded.programme_dates_text,
  date_precision = excluded.date_precision,
  duration_text = excluded.duration_text,
  places_text = excluded.places_text,
  source_status = excluded.source_status,
  audience_text = excluded.audience_text,
  study_stage_text = excluded.study_stage_text,
  eligibility_text = excluded.eligibility_text,
  programme_structure_text = excluded.programme_structure_text,
  official_url = excluded.official_url,
  application_url = excluded.application_url,
  active = true,
  research_checked_on = excluded.research_checked_on,
  updated_at = now();

insert into public.career_opportunity_locations (
  opportunity_id, cycle_id, city_id, country_id, location_role,
  location_status, location_note, display_order
)
select
  co.id,
  coc.id,
  139,
  47,
  'programme',
  'confirmed',
  'Harbottle & Lewis London office.',
  1
from public.career_opportunities co
join public.career_opportunity_cycles coc on coc.opportunity_id = co.id
where co.organisation_id = 'f6097783-a65c-47ea-b39c-c9a0821bebc4'
  and co.slug in (
    'london-training-contract-2029',
    'sutton-trust-social-mobility-work-experience'
  )
  and not exists (
    select 1
    from public.career_opportunity_locations col
    where col.opportunity_id = co.id
      and col.cycle_id = coc.id
      and col.city_id = 139
      and col.country_id = 47
  );

update public.firms
set student_summary = 'Harbottle & Lewis recruits six London trainees each year. Applications for its 2029 training contracts open on 1 November 2026. The firm does not currently offer a vacation scheme and also runs a recurring Sutton Trust social-mobility work-experience programme for six students each summer.',
    research_status = 'complete',
    research_checked_on = date '2026-10-16',
    next_review_on = date '2026-11-01',
    updated_at = now()
where id = 'f6097783-a65c-47ea-b39c-c9a0821bebc4';

do $$
declare
  v_bad_language_count bigint;
  v_deadline_count bigint;
  v_event_count bigint;
begin
  select count(*) into v_bad_language_count
  from public.career_opportunities_public_view
  where provider_id = 'f6097783-a65c-47ea-b39c-c9a0821bebc4'
    and concat_ws(' ', public_title, public_summary, application_dates_text,
                  programme_dates_text, eligibility_text, additional_details_text)
        ~* '(to be checked|not confirmed|unconfirmed|needs? review|placeholder|verify|verification pending|tbc|tbd|unknown date|research note|internal)';

  if v_bad_language_count <> 0 then
    raise exception 'Harbottle & Lewis prohibited public wording detected: % row(s)', v_bad_language_count;
  end if;

  select count(*) into v_deadline_count from public.deadlines_public_view;
  if v_deadline_count <> current_setting('vacatory.harbottle_deadline_count')::bigint then
    raise exception 'Deadline feed changed despite no official closing date';
  end if;

  select count(*) into v_event_count
  from public.career_opportunity_occurrences_public_view
  where is_event = true;
  if v_event_count <> current_setting('vacatory.harbottle_event_count')::bigint then
    raise exception 'Event feed changed despite no current student event';
  end if;
end $$;

commit;
