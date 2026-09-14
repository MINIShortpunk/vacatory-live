-- HSFK FaceTime: Spotlight on Private Equity
-- Official Candidats source checked 14 September 2026:
-- https://hsfkramer.app.candidats.io/event/ca68cb79-42c7-4c3e-abe5-d1eabbabe618

do $$
declare
  v_org uuid := '460bf4d2-5594-4a84-958a-07748c328c74';
  v_opp_type uuid := '5e2816dd-108f-4443-9fb2-218def79147f';
  v_event_type uuid := 'bfc52358-2f8d-4b3d-b5b0-92b80ad1101d';
  v_url text := 'https://hsfkramer.app.candidats.io/event/ca68cb79-42c7-4c3e-abe5-d1eabbabe618';
  v_slug text := 'facetime-spotlight-on-private-equity-2026';
  v_opportunity_id uuid;
  v_programme_id uuid;
begin
  select id into v_programme_id
  from firm_programmes
  where firm_id = v_org
    and slug = v_slug;

  if v_programme_id is null then
    insert into firm_programmes (
      id, firm_id, organisation_id, slug, programme_name, programme_type, career_stage, opportunity_level,
      country_text, location_text, delivery_mode, description, current_status, status, scope_status,
      application_date_summary, programme_date_summary, programme_starts_on, programme_ends_on,
      audience_text, primary_source_url, application_url,
      disability_specific, positive_action, active, published, student_priority,
      research_checked_on, next_review_on, display_order, date_precision, date_status_note, created_at, updated_at
    ) values (
      gen_random_uuid(), v_org, v_org, v_slug, 'United Kingdom - FaceTime: Spotlight on Private Equity', 'event',
      'Students interested in commercial law and private equity', 'event', 'United Kingdom', 'Virtual', 'online',
      'Virtual HSFK event focused on private equity, real-life case studies, strategic advice for clients, trainee roles and the application process.',
      'upcoming', 'current', 'in_scope',
      'Registration is open; no separate closing date is published.',
      '13 November 2026, 12:00–13:30 UK time, virtual.',
      date '2026-11-13', date '2026-11-13',
      'Students interested in commercial law, private equity and early careers at HSFK.',
      v_url, v_url,
      false, false, true, true, true,
      date '2026-09-14', date '2026-11-14', 483, 'exact',
      'Candidats event page checked 14 September 2026. The page publishes the event date/time and says registration is open; no separate registration closing date is published.',
      now(), now()
    );
  else
    update firm_programmes
    set programme_name = 'United Kingdom - FaceTime: Spotlight on Private Equity',
        programme_type = 'event',
        career_stage = 'Students interested in commercial law and private equity',
        opportunity_level = 'event',
        country_text = 'United Kingdom',
        location_text = 'Virtual',
        delivery_mode = 'online',
        description = 'Virtual HSFK event focused on private equity, real-life case studies, strategic advice for clients, trainee roles and the application process.',
        current_status = 'upcoming',
        status = 'current',
        scope_status = 'in_scope',
        application_date_summary = 'Registration is open; no separate closing date is published.',
        application_opens_on = null,
        application_closes_on = null,
        programme_date_summary = '13 November 2026, 12:00–13:30 UK time, virtual.',
        programme_starts_on = date '2026-11-13',
        programme_ends_on = date '2026-11-13',
        audience_text = 'Students interested in commercial law, private equity and early careers at HSFK.',
        primary_source_url = v_url,
        application_url = v_url,
        date_precision = 'exact',
        date_status_note = 'Candidats event page checked 14 September 2026. The page publishes the event date/time and says registration is open; no separate registration closing date is published.',
        active = true,
        published = true,
        student_priority = true,
        research_checked_on = date '2026-09-14',
        next_review_on = date '2026-11-14',
        updated_at = now()
    where id = v_programme_id;
  end if;

  select id into v_opportunity_id
  from career_opportunities
  where organisation_id = v_org
    and slug = v_slug;

  if v_opportunity_id is null then
    v_opportunity_id := gen_random_uuid();
    insert into career_opportunities (
      id, organisation_id, opportunity_type_id, event_type_id, slug, official_name, english_name, public_name, public_summary,
      delivery_mode, official_url, application_url, active, published, display_order,
      research_checked_on, next_review_on, canonical_public_suppressed, created_at, updated_at
    ) values (
      v_opportunity_id, v_org, v_opp_type, v_event_type, v_slug, 'FaceTime: Spotlight on Private Equity',
      'FaceTime: Spotlight on Private Equity', 'FaceTime: Spotlight on Private Equity',
      'Virtual HSFK event on private equity, real-life case studies, trainee roles and the application process.',
      'online', v_url, v_url, true, true, 483, date '2026-09-14', date '2026-11-14', false, now(), now()
    );
  else
    update career_opportunities
    set opportunity_type_id = v_opp_type,
        event_type_id = v_event_type,
        official_name = 'FaceTime: Spotlight on Private Equity',
        english_name = 'FaceTime: Spotlight on Private Equity',
        public_name = 'FaceTime: Spotlight on Private Equity',
        public_summary = 'Virtual HSFK event on private equity, real-life case studies, trainee roles and the application process.',
        delivery_mode = 'online',
        official_url = v_url,
        application_url = v_url,
        active = true,
        published = true,
        research_checked_on = date '2026-09-14',
        next_review_on = date '2026-11-14',
        updated_at = now()
    where id = v_opportunity_id;
  end if;

  if not exists (select 1 from career_opportunity_cycles where opportunity_id = v_opportunity_id and cycle_key = '2026-11-13') then
    insert into career_opportunity_cycles (
      id, opportunity_id, cycle_key, cycle_label, application_model, date_precision,
      application_year, programme_year, application_dates_text, programme_starts_on, programme_ends_on, programme_dates_text,
      duration_text, audience_text, application_process_text, official_url, application_url, source_status, source_status_note,
      research_checked_on, active, created_at, updated_at
    ) values (
      gen_random_uuid(), v_opportunity_id, '2026-11-13', '13 November 2026', 'rolling', 'exact',
      2026, 2026, 'Registration is open; no separate closing date is published.', date '2026-11-13', date '2026-11-13',
      '13 November 2026, 12:00–13:30 UK time, virtual.', '90 minutes',
      'Students interested in commercial law, private equity and early careers at HSFK.',
      'Register through the official Candidats event page. A joining link will be shared after registration.',
      v_url, v_url, 'verified', 'Verified on the official HSFK Candidats event page on 14 September 2026.',
      date '2026-09-14', true, now(), now()
    );
  else
    update career_opportunity_cycles
    set application_model = 'rolling',
        opens_on = null,
        closes_on = null,
        programme_starts_on = date '2026-11-13',
        programme_ends_on = date '2026-11-13',
        date_precision = 'exact',
        application_year = 2026,
        programme_year = 2026,
        application_dates_text = 'Registration is open; no separate closing date is published.',
        programme_dates_text = '13 November 2026, 12:00–13:30 UK time, virtual.',
        duration_text = '90 minutes',
        audience_text = 'Students interested in commercial law, private equity and early careers at HSFK.',
        application_process_text = 'Register through the official Candidats event page. A joining link will be shared after registration.',
        official_url = v_url,
        application_url = v_url,
        source_status = 'verified',
        source_status_note = 'Verified on the official HSFK Candidats event page on 14 September 2026.',
        research_checked_on = date '2026-09-14',
        active = true,
        updated_at = now()
    where opportunity_id = v_opportunity_id
      and cycle_key = '2026-11-13';
  end if;
end $$;
