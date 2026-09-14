-- HSFK UK Apply accordion date refresh
-- Official source checked 14 September 2026:
-- https://careers.hsfkramer.com/global/en/uk/early-careers/apply
--
-- Notes:
-- * Use the Apply accordion for newly published application windows and Candidats apply links.
-- * Preserve stronger dedicated-page dates where HSFK pages conflict:
--   - First Year Workshops / Roger Leyland Scholarship: dedicated First Year page keeps 28 Jan 2027 where Apply accordion says 1 Feb 2027.
--   - Spring Vacation Scheme: dedicated Vacation Schemes page keeps 12–23 Apr 2027 where Apply accordion says 12–13 Apr 2027.

do $$
declare
  v_org uuid := '460bf4d2-5594-4a84-958a-07748c328c74';
  v_virtual_type uuid := 'ada445be-3234-468a-bcfe-34ce1a70f5bc';
  v_opportunity_id uuid;
begin
  update firm_programmes
  set current_status = 'upcoming',
      status = 'upcoming',
      application_opens_on = date '2026-10-26',
      application_closes_on = date '2027-02-15',
      application_date_summary = 'Applications open 26 October 2026 and close 15 February 2027.',
      programme_date_summary = 'Six-year London Solicitor Apprenticeship; successful applicants join in September 2027.',
      start_date_text = 'September 2027',
      eligible_study_stage = 'Year 13 students or school leavers who have not attended university.',
      audience_text = 'Year 13 students and school leavers without a university degree; minimum AAB or equivalent UCAS points and at least seven GCSEs at grade 6 or above including Maths and English.',
      date_precision = 'exact',
      date_status_note = 'Exact application dates published in the official HSFK UK Apply accordion on 14 September 2026.',
      primary_source_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/apply',
      application_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/solicitor-apprenticeship-programme',
      research_checked_on = date '2026-09-14',
      next_review_on = date '2026-11-01',
      updated_at = now()
  where firm_id = v_org and slug = 'solicitor-apprenticeship';

  update firm_programmes
  set programme_date_summary = 'Two workshop options: 31 March–1 April 2027 and 7–8 April 2027.',
      date_status_note = 'Apply accordion gives workshop dates and lists applications as 1 January–1 February 2027; the dedicated First Year page gives 1–28 January 2027, so the dedicated-page deadline is preserved pending HSFK reconciliation.',
      research_checked_on = date '2026-09-14',
      next_review_on = date '2026-11-01',
      updated_at = now()
  where firm_id = v_org and slug = 'first-year-workshops';

  update firm_programmes
  set current_status = 'upcoming',
      status = 'upcoming',
      application_opens_on = date '2027-01-01',
      application_closes_on = date '2027-03-31',
      application_date_summary = 'Applications open 1 January 2027 and close 31 March 2027.',
      programme_date_summary = 'Campus Ambassador role runs from 1 September 2027 to 31 March 2028.',
      programme_starts_on = date '2027-09-01',
      programme_ends_on = date '2028-03-31',
      eligible_study_stage = 'First-year university students, or second-year students on a four-year course.',
      audience_text = 'First-year university students, or second-year students on a four-year course.',
      date_precision = 'exact',
      date_status_note = 'Exact application and role dates published in the official HSFK UK Apply accordion on 14 September 2026.',
      primary_source_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/apply',
      application_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/first-year',
      research_checked_on = date '2026-09-14',
      next_review_on = date '2027-01-15',
      updated_at = now()
  where firm_id = v_org and slug = 'campus-ambassador';

  update firm_programmes
  set application_opens_on = date '2026-10-01',
      application_closes_on = date '2026-12-01',
      application_date_summary = 'Applications open 1 October 2026 and close 1 December 2026.',
      programme_date_summary = 'Spring Vacation Scheme dates: 12–23 April 2027.',
      programme_starts_on = date '2027-04-12',
      programme_ends_on = date '2027-04-23',
      current_status = 'upcoming',
      date_precision = 'exact',
      date_status_note = 'Apply accordion gives the exact application window. It lists Spring scheme dates as 12–13 April 2027, but the dedicated Vacation Schemes page lists 12–23 April 2027, so the fuller dedicated-page scheme dates are preserved.',
      primary_source_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/vacation-schemes',
      application_url = 'https://apply.candidats.io/f80fe041-e3b0-452b-9aa5-a62ea2e6db97',
      research_checked_on = date '2026-09-14',
      next_review_on = date '2026-10-15',
      updated_at = now()
  where firm_id = v_org and slug = 'spring-vacation-scheme';

  update firm_programmes
  set application_opens_on = date '2026-10-01',
      application_closes_on = date '2026-12-01',
      application_date_summary = 'Applications open 1 October 2026 and close 1 December 2026.',
      programme_date_summary = 'Summer Vacation Scheme dates: 7–25 June 2027 and 5–23 July 2027.',
      current_status = 'upcoming',
      date_precision = 'exact',
      date_status_note = 'Exact application window published in the official HSFK UK Apply accordion on 14 September 2026.',
      primary_source_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/vacation-schemes',
      application_url = 'https://apply.candidats.io/dfb09bfa-85fd-4043-b87e-29d3dcbd9c6c',
      research_checked_on = date '2026-09-14',
      next_review_on = date '2026-10-15',
      updated_at = now()
  where firm_id = v_org and slug = 'summer-vacation-schemes';

  update firm_programmes
  set date_status_note = 'Apply accordion also lists 1 October 2026–1 February 2027, but the dedicated First Year page gives 1 October 2026–28 January 2027; the dedicated-page deadline remains canonical.',
      research_checked_on = date '2026-09-14',
      next_review_on = date '2026-11-01',
      updated_at = now()
  where firm_id = v_org and slug = 'roger-leyland-scholarship';

  update career_opportunity_cycles coc
  set application_model = 'fixed_deadline',
      opens_on = date '2026-10-26',
      closes_on = date '2027-02-15',
      date_precision = 'exact',
      application_dates_text = 'Applications open 26 October 2026 and close 15 February 2027.',
      programme_dates_text = 'Six-year London Solicitor Apprenticeship; successful applicants join in September 2027.',
      official_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/solicitor-apprenticeship-programme',
      application_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/solicitor-apprenticeship-programme',
      eligibility_text = 'Year 13 students or school leavers who have not attended university; minimum AAB or equivalent UCAS points and at least seven GCSEs at grade 6 or above including Maths and English.',
      source_status = 'verified',
      source_status_note = 'Exact application dates published in the official HSFK UK Apply accordion on 14 September 2026.',
      research_checked_on = date '2026-09-14',
      updated_at = now()
  from career_opportunities co
  where co.id = coc.opportunity_id and co.organisation_id = v_org and co.slug = 'solicitor-apprenticeship';

  update career_opportunity_cycles coc
  set programme_dates_text = 'Two workshop options: 31 March–1 April 2027 and 7–8 April 2027.',
      source_status_note = 'Apply accordion gives workshop dates and lists applications as 1 January–1 February 2027; the dedicated First Year page gives 1–28 January 2027, so the dedicated-page deadline is preserved pending HSFK reconciliation.',
      research_checked_on = date '2026-09-14',
      updated_at = now()
  from career_opportunities co
  where co.id = coc.opportunity_id and co.organisation_id = v_org and co.slug = 'first-year-workshops';

  update career_opportunity_cycles coc
  set application_model = 'fixed_deadline',
      opens_on = date '2026-10-01',
      closes_on = date '2026-12-01',
      date_precision = 'exact',
      application_dates_text = 'Applications open 1 October 2026 and close 1 December 2026.',
      application_url = case co.slug
        when 'spring-vacation-scheme' then 'https://apply.candidats.io/f80fe041-e3b0-452b-9aa5-a62ea2e6db97'
        else 'https://apply.candidats.io/dfb09bfa-85fd-4043-b87e-29d3dcbd9c6c'
      end,
      source_status = 'verified',
      source_status_note = case co.slug
        when 'spring-vacation-scheme' then 'Apply accordion gives the exact application window. It lists Spring scheme dates as 12–13 April 2027, but the dedicated Vacation Schemes page lists 12–23 April 2027, so the fuller dedicated-page scheme dates are preserved.'
        else 'Exact application window published in the official HSFK UK Apply accordion on 14 September 2026.'
      end,
      research_checked_on = date '2026-09-14',
      updated_at = now()
  from career_opportunities co
  where co.id = coc.opportunity_id and co.organisation_id = v_org and co.slug in ('spring-vacation-scheme','summer-vacation-schemes');

  update career_opportunities
  set application_url = 'https://apply.candidats.io/f80fe041-e3b0-452b-9aa5-a62ea2e6db97',
      updated_at = now(),
      research_checked_on = date '2026-09-14'
  where organisation_id = v_org and slug = 'spring-vacation-scheme';

  update career_opportunities
  set application_url = 'https://apply.candidats.io/dfb09bfa-85fd-4043-b87e-29d3dcbd9c6c',
      updated_at = now(),
      research_checked_on = date '2026-09-14'
  where organisation_id = v_org and slug = 'summer-vacation-schemes';

  update career_opportunity_cycles coc
  set source_status_note = 'Apply accordion also lists 1 October 2026–1 February 2027, but the dedicated First Year page gives 1 October 2026–28 January 2027; the dedicated-page deadline remains canonical.',
      research_checked_on = date '2026-09-14',
      updated_at = now()
  from career_opportunities co
  where co.id = coc.opportunity_id and co.organisation_id = v_org and co.slug = 'roger-leyland-scholarship';

  update career_opportunities
  set official_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/first-year',
      application_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/first-year',
      research_checked_on = date '2026-09-14',
      next_review_on = date '2027-01-15',
      updated_at = now()
  where organisation_id = v_org and slug = 'campus-ambassador'
  returning id into v_opportunity_id;

  if v_opportunity_id is not null then
    if exists (select 1 from career_opportunity_cycles where opportunity_id = v_opportunity_id and cycle_key = '2027-campus-ambassador') then
      update career_opportunity_cycles
      set application_model = 'fixed_deadline',
          opens_on = date '2027-01-01',
          closes_on = date '2027-03-31',
          date_precision = 'exact',
          application_year = 2027,
          programme_year = 2027,
          intake_year = 2027,
          application_dates_text = 'Applications open 1 January 2027 and close 31 March 2027.',
          programme_starts_on = date '2027-09-01',
          programme_ends_on = date '2028-03-31',
          programme_dates_text = 'Campus Ambassador role runs from 1 September 2027 to 31 March 2028.',
          eligibility_text = 'First-year university students, or second-year students on a four-year course.',
          official_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/first-year',
          application_url = 'https://careers.hsfkramer.com/global/en/uk/early-careers/first-year',
          source_status = 'verified',
          source_status_note = 'Exact application and role dates published in the official HSFK UK Apply accordion on 14 September 2026.',
          research_checked_on = date '2026-09-14',
          updated_at = now(),
          active = true
      where opportunity_id = v_opportunity_id and cycle_key = '2027-campus-ambassador';
    else
      insert into career_opportunity_cycles (
        id, opportunity_id, cycle_key, cycle_label, application_model, opens_on, closes_on, date_precision,
        application_year, programme_year, intake_year, application_dates_text, programme_starts_on, programme_ends_on,
        programme_dates_text, eligibility_text, official_url, application_url, source_status, source_status_note,
        research_checked_on, active, created_at, updated_at
      ) values (
        gen_random_uuid(), v_opportunity_id, '2027-campus-ambassador', '2027 Campus Ambassador', 'fixed_deadline', date '2027-01-01', date '2027-03-31', 'exact',
        2027, 2027, 2027, 'Applications open 1 January 2027 and close 31 March 2027.', date '2027-09-01', date '2028-03-31',
        'Campus Ambassador role runs from 1 September 2027 to 31 March 2028.', 'First-year university students, or second-year students on a four-year course.',
        'https://careers.hsfkramer.com/global/en/uk/early-careers/first-year', 'https://careers.hsfkramer.com/global/en/uk/early-careers/first-year',
        'verified', 'Exact application and role dates published in the official HSFK UK Apply accordion on 14 September 2026.',
        date '2026-09-14', true, now(), now()
      );
    end if;
  end if;

  update career_opportunities set application_url = 'https://apply.candidats.io/c54100c0-ba12-4596-b69f-1025da7003fb', updated_at = now(), research_checked_on = date '2026-09-14' where organisation_id = v_org and slug = 'ip-cyber-technology-open-day';
  update career_opportunities set application_url = 'https://apply.candidats.io/2a50dcdd-767f-4831-9522-bfd871ef1f54', updated_at = now(), research_checked_on = date '2026-09-14' where organisation_id = v_org and slug = 'social-mobility-open-day';
  update career_opportunities set application_url = 'https://apply.candidats.io/330fcb5d-51c8-48e9-b77e-b10c4e66cfde', updated_at = now(), research_checked_on = date '2026-09-14' where organisation_id = v_org and slug = 'myplus-open-day';
  update career_opportunities set application_url = 'https://apply.candidats.io/43ffe2d7-8d00-4da5-a385-0aa6602aff84', updated_at = now(), research_checked_on = date '2026-09-14' where organisation_id = v_org and slug = 'black-talent-open-day';
  update career_opportunities set application_url = 'https://apply.candidats.io/bf36a1e8-7b63-4363-b8c0-90fa8c81a8fd', updated_at = now(), research_checked_on = date '2026-09-14' where organisation_id = v_org and slug = 'lgbt-open-day';
  update career_opportunities set application_url = 'https://apply.candidats.io/03dd2a38-568f-41f7-ba2b-6fa99f0bc942', updated_at = now(), research_checked_on = date '2026-09-14' where organisation_id = v_org and slug = 'disputes-open-day';

  update career_opportunity_cycles coc
  set application_url = co.application_url,
      updated_at = now(),
      research_checked_on = date '2026-09-14'
  from career_opportunities co
  where co.id = coc.opportunity_id
    and co.organisation_id = v_org
    and co.slug in ('ip-cyber-technology-open-day','social-mobility-open-day','myplus-open-day','black-talent-open-day','lgbt-open-day','disputes-open-day');

  if not exists (select 1 from firm_programmes where firm_id = v_org and slug = 'uk-virtual-internship') then
    insert into firm_programmes (
      id, firm_id, organisation_id, slug, programme_name, programme_type, career_stage, opportunity_level,
      country_text, location_text, delivery_mode, description, current_status, status, scope_status,
      application_date_summary, programme_date_summary, primary_source_url, application_url,
      disability_specific, positive_action, active, published, student_priority, research_checked_on, next_review_on,
      display_order, created_at, updated_at
    ) values (
      gen_random_uuid(), v_org, v_org, 'uk-virtual-internship', 'United Kingdom - Virtual Internship', 'virtual_internship', 'Students and graduates', 'virtual_experience',
      'United Kingdom', 'Online', 'online_self_paced', 'Online self-paced HSFK virtual internship for students to complete at their own pace.', 'open_ongoing', 'current', 'in_scope',
      'Open year-round — can be completed at your own pace.', 'Ongoing and self-paced.', 'https://careers.hsfkramer.com/global/en/uk/early-careers/virtual-internship', 'https://careers.hsfkramer.com/global/en/uk/early-careers/virtual-internship',
      false, false, true, true, true, date '2026-09-14', date '2027-03-01', 2145, now(), now()
    );
  end if;

  select id into v_opportunity_id
  from career_opportunities
  where organisation_id = v_org and slug = 'uk-virtual-internship';

  if v_opportunity_id is null then
    v_opportunity_id := gen_random_uuid();
    insert into career_opportunities (
      id, organisation_id, opportunity_type_id, slug, official_name, english_name, public_name, public_summary,
      delivery_mode, official_url, application_url, active, published, display_order,
      research_checked_on, next_review_on, canonical_public_suppressed, created_at, updated_at
    ) values (
      v_opportunity_id, v_org, v_virtual_type, 'uk-virtual-internship', 'UK Virtual Internship', 'UK Virtual Internship', 'Virtual Internship',
      'Online self-paced HSFK virtual internship for students to complete at their own pace.', 'online_self_paced',
      'https://careers.hsfkramer.com/global/en/uk/early-careers/virtual-internship', 'https://careers.hsfkramer.com/global/en/uk/early-careers/virtual-internship',
      true, true, 2145, date '2026-09-14', date '2027-03-01', false, now(), now()
    );
  end if;

  if not exists (select 1 from career_opportunity_cycles where opportunity_id = v_opportunity_id and cycle_key = 'ongoing') then
    insert into career_opportunity_cycles (
      id, opportunity_id, cycle_key, cycle_label, application_model, date_precision, application_dates_text, programme_dates_text,
      official_url, application_url, source_status, source_status_note, research_checked_on, active, created_at, updated_at
    ) values (
      gen_random_uuid(), v_opportunity_id, 'ongoing', 'Ongoing', 'always_available', 'text_only', 'Open year-round — can be completed at your own pace.', 'Ongoing and self-paced.',
      'https://careers.hsfkramer.com/global/en/uk/early-careers/virtual-internship', 'https://careers.hsfkramer.com/global/en/uk/early-careers/virtual-internship',
      'verified', 'Open year-round status published in the official HSFK UK Apply accordion on 14 September 2026.', date '2026-09-14', true, now(), now()
    );
  end if;
end $$;
