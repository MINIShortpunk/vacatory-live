-- HSFK Tokyo Internship 2027 refresh
-- Official source checked 14 September 2026:
-- https://careers.hsfkramer.com/global/en/tokyo/early-careers/internship

update firm_programmes
set current_status = 'upcoming',
    status = 'current',
    application_opens_on = date '2026-10-05',
    application_closes_on = date '2026-10-25',
    application_date_summary = 'Applications for the 2027 Tokyo Internship open 5 October 2026 and close 25 October 2026.',
    programme_date_summary = 'Minimum four-week internship in Tokyo; timing is flexible, with a focus on the June to August 2027 period.',
    programme_starts_on = null,
    programme_ends_on = null,
    eligible_study_stage = 'Law and non-law students, including postgraduate students.',
    audience_text = 'Law and non-law students, including postgraduate students, interested in first-hand experience in HSFK’s Tokyo office.',
    date_precision = 'exact',
    date_status_note = 'Official HSFK Tokyo Internship page checked 14 September 2026. Applications for the 2027 scheme open 5–25 October 2026; interviews are rolling, so students are encouraged to apply early.',
    primary_source_url = 'https://careers.hsfkramer.com/global/en/tokyo/early-careers/internship',
    application_url = 'https://careers.hsfkramer.com/global/en/tokyo/early-careers/internship',
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-10-06',
    active = true,
    published = true,
    updated_at = now()
where firm_id = '460bf4d2-5594-4a84-958a-07748c328c74'
  and slug = 'tokyo-internship';

update career_opportunities
set official_url = 'https://careers.hsfkramer.com/global/en/tokyo/early-careers/internship',
    application_url = 'https://careers.hsfkramer.com/global/en/tokyo/early-careers/internship',
    public_summary = 'Minimum four-week Tokyo internship for law and non-law students, including postgraduate students. Timing is flexible, with focus on June to August.',
    active = true,
    published = true,
    research_checked_on = date '2026-09-14',
    next_review_on = date '2026-10-06',
    updated_at = now()
where organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'
  and slug = 'tokyo-internship';

update career_opportunity_cycles coc
set application_model = 'fixed_deadline',
    opens_on = date '2026-10-05',
    closes_on = date '2026-10-25',
    date_precision = 'exact',
    application_year = 2026,
    programme_year = 2027,
    application_dates_text = 'Applications for the 2027 Tokyo Internship open 5 October 2026 and close 25 October 2026.',
    programme_starts_on = null,
    programme_ends_on = null,
    programme_dates_text = 'Minimum four-week internship in Tokyo; timing is flexible, with a focus on the June to August 2027 period.',
    eligibility_text = 'Law and non-law students, including postgraduate students.',
    official_url = 'https://careers.hsfkramer.com/global/en/tokyo/early-careers/internship',
    application_url = 'https://careers.hsfkramer.com/global/en/tokyo/early-careers/internship',
    source_status = 'verified',
    source_status_note = 'Verified on the official HSFK Tokyo Internship page on 14 September 2026. Interviews are rolling, so students are encouraged to apply early.',
    research_checked_on = date '2026-09-14',
    active = true,
    updated_at = now()
from career_opportunities co
where co.id = coc.opportunity_id
  and co.organisation_id = '460bf4d2-5594-4a84-958a-07748c328c74'
  and co.slug = 'tokyo-internship'
  and coc.cycle_key = 'official-2026-09-08:2027';

-- Remove stale duplicate old-cycle row saying the 2026 scheme was closed / next dates unpublished.
update career_opportunity_cycles
set active = false,
    source_status = 'stale_deleted_in_source',
    source_status_note = 'Stale duplicate 2026 closed cycle superseded by verified 2027 Tokyo Internship cycle. Source/live SQL file includes DELETE for cleanup.',
    updated_at = now()
where id = 'e798ab2d-1bd4-4266-a8bb-dd0616836e75';

delete from career_opportunity_cycles
where id = 'e798ab2d-1bd4-4266-a8bb-dd0616836e75';
