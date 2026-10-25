begin;

-- Verified 25 October 2026 against the current official pages.
-- Remove application cycles whose deadlines have passed. These are deleted,
-- not archived or merely hidden.

delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in (
  'c8ca08dd-21a0-4b0b-8958-8cb82a13f866',
  '2149c141-e8cb-4afd-8338-5f20cd7ce0e7'
);

delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in (
  'c8ca08dd-21a0-4b0b-8958-8cb82a13f866',
  '2149c141-e8cb-4afd-8338-5f20cd7ce0e7'
);

delete from public.career_opportunity_identity_stage
where career_opportunity_id in (
  'c8ca08dd-21a0-4b0b-8958-8cb82a13f866',
  '2149c141-e8cb-4afd-8338-5f20cd7ce0e7'
);

delete from public.career_opportunities
where id in (
  '51586a98-e324-40a6-903c-ef0911a3c4ec', -- Hogan Lovells Cadwalader Lift Off; closed 23 October 2026
  '52e73371-1af2-4bcd-8971-03e62994d387', -- Macfarlanes Technology Grant; closed 23 October 2026
  'e905c0fd-a2d2-470f-a0c5-411fdfce14b8', -- COMBAR Mentoring Scheme at Twenty Essex; closed 23 October 2026
  'c8ca08dd-21a0-4b0b-8958-8cb82a13f866', -- Wilberforce mini-pupillage session 1; closed 20 October 2026
  '2149c141-e8cb-4afd-8338-5f20cd7ce0e7'  -- Wilberforce mini-pupillage session 2; closed 20 October 2026
);

-- Remove Wilberforce professional conferences that are not student events.
-- This includes older suppressed rows so they are permanently removed.
delete from public.career_opportunities
where id in (
  '8b991b45-fb36-484d-a918-62e3573906f6', -- Informa Asset Recovery Asia 2026
  'ac65a8cc-cae7-4ae6-93ef-5b01a20c44ac', -- Offshore Trusts Disputes Forum 2026
  'a3950d74-7518-4b98-8d31-d046a4a1fa8b', -- PLA Northern Training Day 2026
  '2a2fb861-477c-421f-8946-6506e1de70e4', -- TL4 Contentious Probate and Inheritance Claims Circle 2026
  'a2ef2689-6ffb-4215-97a0-f6cdcd936aa8', -- Wilberforce BVI Conference and Dinner 2026
  '90bfc205-c331-487f-ba7b-ee17d0c305cf', -- Wilberforce Cayman Conference and Dinner 2026
  'd74cd5a8-9543-4d4c-b185-0774ec2e5a5b'  -- Wilberforce Commercial Litigation Conference 2026
);

-- Twenty Essex publishes 8 December as its normal recurring deadline, but its
-- current page identifies 8 December 2025 as the most recent dated cycle. Do
-- not present an inferred 2026 deadline. Preserve the standing programme on
-- the chamber profile while removing the unverified cycle from the feed.
delete from public.career_opportunity_cycles
where opportunity_id = '11b8698b-3009-475a-a7f5-85b2c91d454a';

update public.career_opportunities
set public_summary = 'Two-day assessed mini-pupillage offering an insight into Twenty Essex and its work. Applications follow the deadlines published on the official mini-pupillage page.',
    research_checked_on = date '2026-10-25',
    next_review_on = date '2026-11-03',
    updated_at = now()
where id = '11b8698b-3009-475a-a7f5-85b2c91d454a';

-- Add the verified current Macfarlanes Legal Academy cycle.
update public.career_opportunities
set public_summary = 'A work-experience, mentoring and workshop programme for eligible sixth-form and college students from less advantaged backgrounds.',
    research_checked_on = date '2026-10-25',
    next_review_on = date '2026-11-28',
    updated_at = now()
where id = 'd48b2aeb-f467-445b-b978-2adbdafc4ecb';

insert into public.career_opportunity_cycles (
  id,
  opportunity_id,
  cycle_key,
  cycle_label,
  application_year,
  programme_year,
  application_model,
  opens_on,
  closes_on,
  programme_starts_on,
  programme_ends_on,
  programme_dates_text,
  application_dates_text,
  date_precision,
  duration_text,
  source_status,
  audience_text,
  eligibility_text,
  application_process_text,
  expenses_text,
  travel_support_text,
  accommodation_support_text,
  official_url,
  application_url,
  active,
  research_checked_on,
  created_at,
  updated_at
)
select
  'b40d7d13-adb6-482e-8aae-ed2ac74409a8',
  'd48b2aeb-f467-445b-b978-2adbdafc4ecb',
  'macfarlanes-legal-academy-2027',
  'Macfarlanes Legal Academy 2027',
  2026,
  2027,
  'fixed_deadline',
  date '2026-09-28',
  date '2026-11-27',
  date '2027-02-15',
  date '2027-02-19',
  '15 to 19 February 2027 in London.',
  'Applications open 28 September 2026 and close 27 November 2026.',
  'exact',
  'Main work-experience week plus mentoring and workshops across Years 12 and 13.',
  'open',
  'Sixth-form and college students from less advantaged backgrounds.',
  'Applicants must attend a state-funded, non-fee-paying school or college and meet at least one of the published social-mobility criteria. Parent or guardian permission is required.',
  'Complete the official application form; shortlisted candidates are invited to a telephone interview.',
  'Travel and lunch are covered during the work-experience week.',
  'Student travel is covered during the work-experience week.',
  'Accommodation, including breakfast, is provided for students who are not within a commutable distance of London.',
  'https://www.macfarlanes.com/join-us/early-careers/widening-access-to-law/legal-academy/',
  'https://www.macfarlanes.com/join-us/early-careers/widening-access-to-law/legal-academy/',
  true,
  date '2026-10-25',
  now(),
  now()
where not exists (
  select 1
  from public.career_opportunity_cycles
  where opportunity_id = 'd48b2aeb-f467-445b-b978-2adbdafc4ecb'
    and cycle_key = 'macfarlanes-legal-academy-2027'
);

commit;
