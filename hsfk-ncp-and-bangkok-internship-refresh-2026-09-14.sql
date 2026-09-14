-- Herbert Smith Freehills Kramer — New Colombo Plan and Bangkok Internship
-- Checked 14 September 2026.
--
-- Official sources:
-- - New Colombo Plan:
--   https://careers.hsfkramer.com/global/en/australia/early-careers/new-colombo-plan
-- - Bangkok Internship:
--   https://careers.hsfkramer.com/global/en/bangkok/early-careers/internship
--
-- Notes:
-- - HSFK does not appear to provide the New Colombo Plan scholarship itself.
--   The official HSFK page says the New Colombo Plan is a government initiative
--   and that students who have already been awarded an NCP scholarship may apply
--   for HSFK's NCP internship programme by CV and cover letter.
-- - Bangkok page says applications for the 2027 summer internship scheme are
--   open until 30 September 2026, with interviews on a rolling basis.

begin;

-- New Colombo Plan internship: keep as current/no single HSFK deadline.
update public.career_opportunities
set opportunity_type_id = '06f22221-7e57-4379-b2a1-fcbec5d4f4bb'::uuid,
    official_name = 'New Colombo Plan Internship',
    english_name = 'New Colombo Plan Internship',
    public_summary = 'Internship route for students who have already been awarded a New Colombo Plan scholarship. HSFK says eligible students can apply directly by sending a CV and cover letter.',
    delivery_mode = 'programme_dependent',
    official_url = 'https://careers.hsfkramer.com/global/en/australia/early-careers/new-colombo-plan',
    application_url = 'mailto:graduaterecruitment.asia@hsfkramer.com',
    active = true,
    published = true,
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-14',
    updated_at = now()
where organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and slug = 'australia-new-colombo-plan-internships';

update public.career_opportunity_cycles cycle
set cycle_label = 'Current route — NCP scholarship holders',
    application_model = 'unknown',
    opens_on = null,
    closes_on = null,
    programme_starts_on = null,
    programme_ends_on = null,
    programme_dates_text = 'Placement timing is scholarship/placement-specific; no single HSFK programme date is published.',
    date_precision = 'text_only',
    source_status = 'official_current',
    audience_text = 'Students who have successfully been awarded the New Colombo Plan scholarship.',
    application_dates_text = 'No single HSFK deadline is published. Students who have already received a New Colombo Plan scholarship may apply directly to HSFK by CV and cover letter.',
    application_process_text = 'Send a CV and cover letter to graduaterecruitment.asia@hsfkramer.com.',
    funding_text = 'The New Colombo Plan is described by HSFK as a government initiative; HSFK does not state that it funds the scholarship.',
    official_url = 'https://careers.hsfkramer.com/global/en/australia/early-careers/new-colombo-plan',
    application_url = 'mailto:graduaterecruitment.asia@hsfkramer.com',
    active = true,
    research_checked_on = date '2026-09-14',
    updated_at = now(),
    additional_details_text = 'HSFK says the New Colombo Plan provides internship and mentorship opportunities to students across the Indo-Pacific.'
from public.career_opportunities opportunity
where cycle.opportunity_id = opportunity.id
  and opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug = 'australia-new-colombo-plan-internships';

update public.firm_programmes
set programme_name = 'Australia / Asia - New Colombo Plan Internship',
    programme_type = 'internship',
    delivery_mode = 'programme_dependent',
    career_stage = 'New Colombo Plan scholarship holders',
    description = 'HSFK says students who have successfully been awarded a New Colombo Plan scholarship are invited to apply for its NCP internship programme.',
    duration_text = 'Placement-specific',
    qualification_or_outcome = 'Internship and mentorship opportunity linked to the New Colombo Plan.',
    route_to_next_stage = 'Apply directly to HSFK with a CV and cover letter after being awarded an NCP scholarship.',
    active = true,
    published = true,
    status = 'current',
    current_status = 'current',
    application_opens_on = null,
    application_closes_on = null,
    application_date_summary = 'No single HSFK deadline is published. Students who have successfully been awarded an NCP scholarship may apply directly by CV and cover letter.',
    programme_date_summary = 'Placement timing is scholarship/placement-specific.',
    date_precision = 'text_only',
    date_status_note = 'HSFK page checked 14 September 2026; no fixed HSFK deadline is published.',
    application_url = 'mailto:graduaterecruitment.asia@hsfkramer.com',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/australia/early-careers/new-colombo-plan',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-12-14',
    exact_official_name = 'New Colombo Plan',
    opportunity_level = 'internship',
    audience_text = 'Students who have successfully been awarded a New Colombo Plan scholarship.',
    eligible_study_stage = 'NCP scholarship holders.',
    student_priority = true,
    scope_status = 'in_scope',
    updated_at = now()
where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and slug = 'australia-new-colombo-plan-internships';

insert into public.firm_programme_cycles (
  programme_id,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  programme_dates_text,
  application_status,
  application_status_note,
  eligibility,
  application_process,
  programme_structure,
  active,
  research_checked_on,
  duration_text,
  audience_text,
  current_status,
  source_freshness,
  date_precision,
  funding_details,
  source_url,
  application_url,
  updated_at
)
select
  programme.id,
  'Current route — NCP scholarship holders',
  'unknown',
  null,
  null,
  'Placement timing is scholarship/placement-specific; no single HSFK programme date is published.',
  'current',
  'No single HSFK deadline is published. Students who have already received a New Colombo Plan scholarship may apply directly by CV and cover letter.',
  '{"eligibility":"Students who have successfully been awarded the New Colombo Plan scholarship."}'::jsonb,
  '["Send a CV and cover letter to graduaterecruitment.asia@hsfkramer.com"]'::jsonb,
  '["Internship opportunity for New Colombo Plan scholarship holders","Mentorship opportunities across the Indo-Pacific are referenced on the official page"]'::jsonb,
  true,
  date '2026-09-14',
  'Placement-specific',
  'Students who have successfully been awarded a New Colombo Plan scholarship.',
  'current',
  'official_current',
  'text_only',
  'The New Colombo Plan is described by HSFK as a government initiative; HSFK does not state that it funds the scholarship.',
  'https://careers.hsfkramer.com/global/en/australia/early-careers/new-colombo-plan',
  'mailto:graduaterecruitment.asia@hsfkramer.com',
  now()
from public.firm_programmes programme
where programme.firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and programme.slug = 'australia-new-colombo-plan-internships'
on conflict (programme_id, cycle_label) do update set
  application_model = excluded.application_model,
  opens_on = null,
  closes_on = null,
  programme_dates_text = excluded.programme_dates_text,
  application_status = excluded.application_status,
  application_status_note = excluded.application_status_note,
  eligibility = excluded.eligibility,
  application_process = excluded.application_process,
  programme_structure = excluded.programme_structure,
  active = true,
  research_checked_on = excluded.research_checked_on,
  duration_text = excluded.duration_text,
  audience_text = excluded.audience_text,
  current_status = excluded.current_status,
  source_freshness = excluded.source_freshness,
  date_precision = excluded.date_precision,
  funding_details = excluded.funding_details,
  source_url = excluded.source_url,
  application_url = excluded.application_url,
  updated_at = now();

-- Add a scholarship-directory note, making clear this is a government
-- scholarship and not an HSFK-funded award.
delete from public.firm_scholarships
where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and programme_name = 'New Colombo Plan scholarship holders — HSFK internship route';

insert into public.firm_scholarships (
  firm_id,
  programme_name,
  programme_type,
  amount,
  total_value,
  duration,
  cohort_size,
  eligibility,
  academic_requirements,
  year_of_study_requirements,
  application_open,
  application_deadline,
  application_process,
  funded_items,
  mentoring_and_support,
  partner_organisations,
  status,
  application_link,
  source_url,
  research_checked_on,
  updated_at
)
values (
  '460bf4d2-5594-4a84-958a-07748c328c74'::uuid,
  'New Colombo Plan scholarship holders — HSFK internship route',
  'government_scholarship_linked_internship',
  null,
  'Not funded by HSFK on the official page; the New Colombo Plan is described as a government initiative.',
  'Placement-specific',
  null,
  'Students who have successfully been awarded the New Colombo Plan scholarship.',
  null,
  'NCP scholarship holders.',
  null,
  null,
  'Apply to HSFK by sending a CV and cover letter to graduaterecruitment.asia@hsfkramer.com after being awarded an NCP scholarship.',
  'Government New Colombo Plan scholarship; HSFK page does not publish the scholarship value or funded items.',
  'HSFK says the New Colombo Plan provides internship and mentorship opportunities to students across the Indo-Pacific.',
  'New Colombo Plan / Australian Government; HSFK internship route.',
  'current',
  'mailto:graduaterecruitment.asia@hsfkramer.com',
  'https://careers.hsfkramer.com/global/en/australia/early-careers/new-colombo-plan',
  date '2026-09-14',
  now()
);

-- Bangkok Internship: align firm-page layer to the official 2027 deadline.
update public.firm_programmes
set programme_name = 'Thailand - Bangkok Internship',
    programme_type = 'internship',
    location_text = 'Bangkok',
    country_text = 'Thailand',
    delivery_mode = 'in_person',
    career_stage = 'Law students',
    description = 'Bangkok internship for law students seeking first-hand experience in the Bangkok office of a leading global law firm.',
    duration_text = '2 months',
    qualification_or_outcome = 'Paid internship placement in Corporate and/or Dispute Resolution practice groups.',
    active = true,
    published = true,
    status = 'current',
    current_status = 'open',
    application_opens_on = null,
    application_closes_on = date '2026-09-30',
    application_date_summary = 'Applications for the 2027 summer internship scheme are open until 30 September 2026. Interviews are rolling, so students are encouraged to apply early.',
    programme_date_summary = 'The summer internship scheme runs for two months in June and July 2027; applicants must commit to the full internship period.',
    date_precision = 'exact',
    date_status_note = 'Official Bangkok page checked 14 September 2026.',
    application_url = 'https://careers.hsfkramer.com/global/en/bangkok/early-careers/internship',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/bangkok/early-careers/internship',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-10-01',
    exact_official_name = 'Bangkok Internship',
    opportunity_level = 'internship',
    audience_text = 'Law students interested in the Bangkok office.',
    eligible_study_stage = 'Law students.',
    student_priority = true,
    scope_status = 'in_scope',
    updated_at = now()
where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and slug = 'bangkok-internship';

insert into public.firm_programme_cycles (
  programme_id,
  cycle_label,
  application_model,
  opens_on,
  closes_on,
  programme_dates_text,
  application_status,
  application_status_note,
  eligibility,
  application_process,
  programme_structure,
  active,
  research_checked_on,
  duration_text,
  audience_text,
  current_status,
  source_freshness,
  date_precision,
  pay_status,
  source_url,
  application_url,
  updated_at
)
select
  programme.id,
  '2027 summer internship',
  'fixed_deadline',
  null,
  date '2026-09-30',
  'The summer internship scheme runs for two months in June and July 2027. Applicants are required to commit to the full internship period.',
  'open',
  'Applications for the 2027 summer internship scheme are open until 30 September 2026. Interviews are rolling; apply early.',
  '{"audience":"Law students interested in first-hand experience in the Bangkok office."}'::jsonb,
  '["Initial application","Interview with partners or senior associates if shortlisted"]'::jsonb,
  '["Two-month paid internship in June and July","Corporate and/or Dispute Resolution practice groups","Insight into a global international law firm","Diverse, friendly and engaging working environment"]'::jsonb,
  true,
  date '2026-09-14',
  '2 months',
  'Law students interested in the Bangkok office.',
  'open',
  'official_current',
  'exact',
  'paid',
  'https://careers.hsfkramer.com/global/en/bangkok/early-careers/internship',
  'https://careers.hsfkramer.com/global/en/bangkok/early-careers/internship',
  now()
from public.firm_programmes programme
where programme.firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and programme.slug = 'bangkok-internship'
on conflict (programme_id, cycle_label) do update set
  application_model = excluded.application_model,
  opens_on = excluded.opens_on,
  closes_on = excluded.closes_on,
  programme_dates_text = excluded.programme_dates_text,
  application_status = excluded.application_status,
  application_status_note = excluded.application_status_note,
  eligibility = excluded.eligibility,
  application_process = excluded.application_process,
  programme_structure = excluded.programme_structure,
  active = true,
  research_checked_on = excluded.research_checked_on,
  duration_text = excluded.duration_text,
  audience_text = excluded.audience_text,
  current_status = excluded.current_status,
  source_freshness = excluded.source_freshness,
  date_precision = excluded.date_precision,
  pay_status = excluded.pay_status,
  source_url = excluded.source_url,
  application_url = excluded.application_url,
  updated_at = now();

-- Refresh canonical Bangkok cycle if present.
update public.career_opportunity_cycles cycle
set application_model = 'fixed_deadline',
    closes_on = date '2026-09-30',
    programme_dates_text = 'The 2027 summer internship scheme runs for two months in June and July. Applicants must commit to the full internship period.',
    date_precision = 'exact',
    source_status = 'official_current',
    audience_text = 'Law students interested in first-hand experience in the Bangkok office.',
    application_dates_text = 'Applications for the 2027 summer internship scheme are open until 30 September 2026. Interviews are rolling; apply early.',
    duration_text = '2 months',
    official_url = 'https://careers.hsfkramer.com/global/en/bangkok/early-careers/internship',
    application_url = 'https://careers.hsfkramer.com/global/en/bangkok/early-careers/internship',
    active = true,
    research_checked_on = date '2026-09-14',
    updated_at = now(),
    additional_details_text = 'Paid internship placement in Corporate and/or Dispute Resolution practice groups.'
from public.career_opportunities opportunity
where cycle.opportunity_id = opportunity.id
  and opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug = 'bangkok-internship'
  and cycle.cycle_key = 'official-2026-09-08:2027';

commit;

-- Verification
select opportunity.slug,
       cycle.cycle_key,
       cycle.closes_on,
       cycle.application_dates_text
from public.career_opportunities opportunity
join public.career_opportunity_cycles cycle
  on cycle.opportunity_id = opportunity.id
where opportunity.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'::uuid
  and opportunity.slug in ('australia-new-colombo-plan-internships', 'bangkok-internship')
order by opportunity.slug, cycle.cycle_key;
