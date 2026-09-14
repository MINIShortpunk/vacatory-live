-- HSFK Singapore Arbitration Internship refresh
-- Official source checked 14 September 2026:
-- https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship
--
-- The official page says applications for 2027 internships have now closed.
-- Record the route on the firm page, but keep the deadline cycle inactive so it does not appear as an open/current deadline.

do $$
declare
  v_org uuid := '460bf4d2-5594-4a84-958a-07748c328c74';
  v_programme_id uuid;
  v_opportunity_id uuid := '9e8fdaa7-28b9-4b24-94b1-3a0fa04aa1b4';
begin
  select id into v_programme_id
  from firm_programmes
  where firm_id = v_org
    and slug = 'singapore-arbitration-internship';

  if v_programme_id is null then
    insert into firm_programmes (
      id, firm_id, organisation_id, slug, programme_name, programme_type, career_stage, opportunity_level,
      country_text, location_text, delivery_mode, description, current_status, status, scope_status,
      application_date_summary, programme_date_summary, eligible_study_stage, audience_text,
      primary_source_url, application_url, disability_specific, positive_action, active, published, student_priority,
      research_checked_on, next_review_on, display_order, date_status_note, created_at, updated_at
    ) values (
      gen_random_uuid(), v_org, v_org, 'singapore-arbitration-internship', 'Singapore - Arbitration Internship', 'international_internship',
      'Law students and recent graduates', 'internship', 'Singapore', 'Singapore', 'in_person',
      'Three-month arbitration internship in HSFK’s Singapore office, working alongside partners and associates on real arbitration matters, training, workshops and presentations.',
      'closed', 'current', 'in_scope',
      'Applications for 2027 internships have now closed. HSFK interviews on a rolling basis.',
      'Three-month internship; applicants are asked to indicate preferred dates in the application.',
      'Ambitious law students or recent graduates.',
      'Law students or recent graduates who are eligible to live and work in Singapore. Priority is given to students and graduates of NUS and SMU, and returning Singaporeans from approved US, UK and Australian universities.',
      'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
      'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
      false, false, true, true, true,
      date '2026-09-14', date '2026-12-01', 501,
      'Official HSFK Singapore Arbitration Internship page checked 14 September 2026. The page says applications for 2027 internships have now closed and does not publish next application dates.',
      now(), now()
    );
  else
    update firm_programmes
    set programme_name = 'Singapore - Arbitration Internship',
        programme_type = 'international_internship',
        career_stage = 'Law students and recent graduates',
        opportunity_level = 'internship',
        country_text = 'Singapore',
        location_text = 'Singapore',
        delivery_mode = 'in_person',
        description = 'Three-month arbitration internship in HSFK’s Singapore office, working alongside partners and associates on real arbitration matters, training, workshops and presentations.',
        current_status = 'closed',
        status = 'current',
        scope_status = 'in_scope',
        application_date_summary = 'Applications for 2027 internships have now closed. HSFK interviews on a rolling basis.',
        application_opens_on = null,
        application_closes_on = null,
        programme_date_summary = 'Three-month internship; applicants are asked to indicate preferred dates in the application.',
        programme_starts_on = null,
        programme_ends_on = null,
        eligible_study_stage = 'Ambitious law students or recent graduates.',
        audience_text = 'Law students or recent graduates who are eligible to live and work in Singapore. Priority is given to students and graduates of NUS and SMU, and returning Singaporeans from approved US, UK and Australian universities.',
        primary_source_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
        application_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
        date_precision = 'not_announced',
        date_status_note = 'Official HSFK Singapore Arbitration Internship page checked 14 September 2026. The page says applications for 2027 internships have now closed and does not publish next application dates.',
        active = true,
        published = true,
        student_priority = true,
        research_checked_on = date '2026-09-14',
        next_review_on = date '2026-12-01',
        updated_at = now()
    where id = v_programme_id;
  end if;

  update career_opportunities
  set official_name = 'Singapore Arbitration Internship',
      public_name = 'Arbitration Internship',
      public_summary = 'Three-month arbitration internship in HSFK’s Singapore office for law students or recent graduates who can live and work in Singapore.',
      official_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
      application_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
      delivery_mode = 'in_person',
      active = true,
      published = true,
      research_checked_on = date '2026-09-14',
      next_review_on = date '2026-12-01',
      updated_at = now()
  where id = v_opportunity_id;

  if not exists (select 1 from career_opportunity_cycles where opportunity_id = v_opportunity_id and cycle_key = '2027-closed-next-dates-unpublished') then
    insert into career_opportunity_cycles (
      id, opportunity_id, cycle_key, cycle_label, application_model, date_precision,
      application_year, programme_year, application_dates_text, programme_dates_text,
      eligibility_text, right_to_work_text, official_url, application_url, source_status, source_status_note,
      research_checked_on, active, created_at, updated_at
    ) values (
      gen_random_uuid(), v_opportunity_id, '2027-closed-next-dates-unpublished', '2027 internships closed', 'unknown', 'not_announced',
      2027, 2027, 'Applications for 2027 Singapore Arbitration internships have now closed. Next application dates have not yet been published.',
      'Three-month arbitration internship; applicants are asked to indicate preferred dates in the application.',
      'Ambitious law students or recent graduates. Priority is given to students and graduates of the National University of Singapore and Singapore Management University, and returning Singaporeans from approved US, UK and Australian universities.',
      'Applicants must be eligible to live and work in Singapore. The page notes that some applicants may be able to apply for a Work Holiday Pass under Singapore’s Work Holiday Programme.',
      'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
      'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
      'verified_closed',
      'Official HSFK Singapore Arbitration Internship page checked 14 September 2026. The page says applications for 2027 internships have now closed and does not publish next application dates.',
      date '2026-09-14', false, now(), now()
    );
  else
    update career_opportunity_cycles
    set application_model = 'unknown',
        opens_on = null,
        closes_on = null,
        date_precision = 'not_announced',
        application_year = 2027,
        programme_year = 2027,
        application_dates_text = 'Applications for 2027 Singapore Arbitration internships have now closed. Next application dates have not yet been published.',
        programme_dates_text = 'Three-month arbitration internship; applicants are asked to indicate preferred dates in the application.',
        eligibility_text = 'Ambitious law students or recent graduates. Priority is given to students and graduates of the National University of Singapore and Singapore Management University, and returning Singaporeans from approved US, UK and Australian universities.',
        right_to_work_text = 'Applicants must be eligible to live and work in Singapore. The page notes that some applicants may be able to apply for a Work Holiday Pass under Singapore’s Work Holiday Programme.',
        official_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
        application_url = 'https://careers.hsfkramer.com/global/en/singapore/early-careers/arbitration-internship',
        source_status = 'verified_closed',
        source_status_note = 'Official HSFK Singapore Arbitration Internship page checked 14 September 2026. The page says applications for 2027 internships have now closed and does not publish next application dates.',
        research_checked_on = date '2026-09-14',
        active = false,
        updated_at = now()
    where opportunity_id = v_opportunity_id
      and cycle_key = '2027-closed-next-dates-unpublished';
  end if;
end $$;
