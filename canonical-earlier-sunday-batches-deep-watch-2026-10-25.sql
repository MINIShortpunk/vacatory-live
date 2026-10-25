begin;

-- Canonical corrections from the full earlier Sunday-batch deep audit.
-- Verified against live official provider pages on 25 October 2026.

-- Permanently remove every public firm/chambers record whose event has ended
-- or whose application deadline had passed before this audit date. The fixed
-- cutoff makes this migration safe to replay later.
create temporary table vacatory_expired_20261025 on commit drop as
select opportunity_id
from public.career_opportunities_public_view
where provider_type in ('law_firm','chambers','barristers_chambers')
  and ((is_event and programme_ends_on < date '2026-10-25')
    or (not is_event and closes_on < date '2026-10-25'));

delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in (select opportunity_id from vacatory_expired_20261025);
delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in (select opportunity_id from vacatory_expired_20261025);
delete from public.career_opportunity_identity_stage
where career_opportunity_id in (select opportunity_id from vacatory_expired_20261025);
delete from public.career_opportunities
where id in (select opportunity_id from vacatory_expired_20261025);

-- Freshfields: the official page now gives the earlier closing deadline.
update public.career_opportunity_cycles
set closes_on=date '2026-10-26', closes_at=time '17:00',
    closes_timezone='Europe/London',
    application_dates_text='Applications opened 1 September 2026 and close at 17:00 on 26 October 2026.',
    official_url='https://www.freshfields.com/en/your-career/united-kingdom/early-careers/vacation-schemes',
    application_url='https://www.freshfields.com/en/your-career/united-kingdom/early-careers/vacation-schemes',
    research_checked_on=date '2026-10-25', updated_at=now()
where opportunity_id='a5b11a73-78ed-4396-b066-5d3d5cbc5ecd';

update public.career_opportunities
set official_url='https://www.freshfields.com/en/your-career/united-kingdom/early-careers/vacation-schemes',
    application_url='https://www.freshfields.com/en/your-career/united-kingdom/early-careers/vacation-schemes',
    research_checked_on=date '2026-10-25', next_review_on=date '2026-10-27', updated_at=now()
where id='a5b11a73-78ed-4396-b066-5d3d5cbc5ecd';

-- Clyde & Co Scotland: current 2027 vacation-scheme application window.
update public.career_opportunity_cycles
set application_year=2026, programme_year=2027,
    application_model='fixed_deadline', opens_on=date '2026-09-07',
    closes_on=date '2026-11-19',
    application_dates_text='Applications opened 7 September and close 19 November 2026.',
    source_status='open',
    official_url='https://careers.clydeco.com/en/early-careers/united-kingdom/scotland/vacation-schemes/',
    research_checked_on=date '2026-10-25', updated_at=now()
where id='cf6accdf-a5e9-467c-9bf0-fa8e40a39805';

update public.career_opportunities
set official_url='https://careers.clydeco.com/en/early-careers/united-kingdom/scotland/vacation-schemes/',
    research_checked_on=date '2026-10-25', next_review_on=date '2026-11-20', updated_at=now()
where id='8ca4a5f6-3601-4cf5-b6f1-820b00f7419b';

-- Eversheds Sutherland: correct the Dublin internship deadline.
update public.career_opportunity_cycles
set closes_on=date '2027-02-27', closes_at=time '23:59',
    closes_timezone='Europe/Dublin',
    application_dates_text='Applications are open and close at 23:59 on 27 February 2027.',
    official_url='https://www.eversheds-sutherland.com/en/ireland/careers/careers-page/students-and-recent-graduates/student-and-graduate-applications',
    research_checked_on=date '2026-10-25', updated_at=now()
where id='ab43b8ce-75ff-43a2-abe8-a6bc6b23c5b3';

-- Eversheds Sutherland: current published insight-event deadlines.
update public.career_opportunity_cycles
set closes_on=date '2027-03-02', closes_at=time '23:59',
    closes_timezone='Europe/London', application_model='fixed_deadline',
    application_dates_text='Applications close at 23:59 on 2 March 2027.',
    source_status='open', research_checked_on=date '2026-10-25', updated_at=now()
where id='a58c3510-7a15-4e9c-b4ba-5025cac1e70a';

update public.career_opportunity_cycles
set closes_on=date '2027-04-25', closes_at=time '23:59',
    closes_timezone='Europe/London', application_model='fixed_deadline',
    application_dates_text='Applications close at 23:59 on 25 April 2027.',
    source_status='open', research_checked_on=date '2026-10-25', updated_at=now()
where id='9d4ff5c6-720b-4a3e-b185-09636df41349';

update public.career_opportunity_cycles
set closes_on=date '2026-11-02', closes_at=time '23:59',
    closes_timezone='Europe/London', application_model='fixed_deadline',
    application_dates_text='Applications close at 23:59 on 2 November 2026.',
    source_status='open', research_checked_on=date '2026-10-25', updated_at=now()
where id='327ba063-bc45-416c-9c4f-4cab573a3dbd';

-- Dechert: current Dublin legal internship cycle, previously absent.
insert into public.career_opportunities
(organisation_id,opportunity_type_id,slug,official_name,english_name,public_name,
 public_summary,delivery_mode,official_url,application_url,active,published,
 display_order,research_checked_on,next_review_on)
select lo.id,ot.id,'dublin-summer-internship-2027','Dublin Summer Internship 2027',
 'Dublin Summer Internship 2027','Dublin Summer Internship 2027',
 'A legal internship in Dechert’s Dublin office, taking place during July 2027.',
 'in_person','https://www.dechert.com/careers/emea-early-careers/dublin-training-programme/faqs.html',
 'https://dechert.app.candidats.io/',true,true,500,date '2026-10-25',date '2027-02-13'
from public.legal_organisations lo cross join public.opportunity_types ot
where lo.slug='dechert' and ot.slug='internship'
on conflict (organisation_id,slug) do update set
 opportunity_type_id=excluded.opportunity_type_id,official_name=excluded.official_name,
 english_name=excluded.english_name,public_name=excluded.public_name,
 public_summary=excluded.public_summary,delivery_mode=excluded.delivery_mode,
 official_url=excluded.official_url,application_url=excluded.application_url,
 active=true,published=true,research_checked_on=excluded.research_checked_on,
 next_review_on=excluded.next_review_on,updated_at=now();

insert into public.career_opportunity_cycles
(opportunity_id,cycle_key,cycle_label,application_year,programme_year,
 application_model,opens_on,closes_on,closes_timezone,programme_dates_text,
 application_dates_text,date_precision,duration_text,source_status,audience_text,
 academic_criteria,eligibility_text,application_process_text,expenses_text,
 official_url,application_url,active,research_checked_on)
select co.id,'dublin-summer-internship-2027','Dublin Summer Internship 2027',
 2026,2027,'fixed_deadline',date '2026-12-01',date '2027-02-12','Europe/Dublin',
 'The internship takes place during July 2027; exact dates are agreed with successful candidates.',
 'Applications open 1 December 2026 and close 12 February 2027.','month',
 'Summer internship','upcoming','Students eligible for Dechert’s Dublin legal internship programme.',
 'Applicants are normally expected to have, or be on course for, a 2:1 or first.',
 'See the official programme criteria.','Complete the official online application form.',
 'Up to €100 of interview travel expenses is reimbursed.',co.official_url,co.application_url,true,date '2026-10-25'
from public.career_opportunities co join public.legal_organisations lo on lo.id=co.organisation_id
where lo.slug='dechert' and co.slug='dublin-summer-internship-2027'
on conflict (opportunity_id,cycle_key) do update set
 opens_on=excluded.opens_on,closes_on=excluded.closes_on,
 closes_timezone=excluded.closes_timezone,programme_dates_text=excluded.programme_dates_text,
 application_dates_text=excluded.application_dates_text,date_precision=excluded.date_precision,
 source_status=excluded.source_status,academic_criteria=excluded.academic_criteria,
 application_process_text=excluded.application_process_text,expenses_text=excluded.expenses_text,
 official_url=excluded.official_url,application_url=excluded.application_url,
 active=true,research_checked_on=excluded.research_checked_on,updated_at=now();

insert into public.career_opportunity_locations
(opportunity_id,country_id,city_id,location_note,display_order,location_role,location_status)
select co.id,21,59,'Dublin office',100,'programme','confirmed'
from public.career_opportunities co join public.legal_organisations lo on lo.id=co.organisation_id
where lo.slug='dechert' and co.slug='dublin-summer-internship-2027'
and not exists(select 1 from public.career_opportunity_locations l where l.opportunity_id=co.id and l.city_id=59);

commit;
