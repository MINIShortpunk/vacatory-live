begin;

update public.chambers
set pupillage_overview = '3 Verulam Buildings offers up to five pupillages each year across its formats. The standard twelve-month commercial pupillage starting in October 2028 carries a £90,000 award, with up to £22,500 available to draw down before pupillage. Applications are made through the Pupillage Gateway from 4 to 28 January 2027. Standard applicants ordinarily complete an assessed 3VB mini-pupillage before two interview rounds.',
    mini_pupillage_overview = 'Four assessed mini-pupillage sessions remain current for the 2027 pupillage cycle: 2–3 December 2026, 6–7 January 2027, 3–4 February 2027 and 10–11 February 2027. Placements normally run for two days in person, or about one and a half days virtually where necessary. Reasonable travel and necessary overnight accommodation may be reimbursed.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where organisation_id = '800d9dcd-8e79-4acc-b35d-83b0287cdaf0';

update public.legal_organisations
set research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-23',
    updated_at = now()
where id = '800d9dcd-8e79-4acc-b35d-83b0287cdaf0';

update public.career_opportunities
set public_summary = 'Funded twelve-month commercial pupillage beginning in October 2028, with applications through the Pupillage Gateway in January 2027.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-29',
    updated_at = now()
where id = 'a4bc9d3f-48cc-48b8-beee-ca113385d2ba';

update public.career_opportunity_cycles
set opens_on = date '2027-01-04',
    closes_on = date '2027-01-28',
    closes_at = time '23:59',
    closes_timezone = 'Europe/London',
    programme_starts_on = date '2028-10-01',
    programme_dates_text = 'Twelve-month commercial pupillage beginning in October 2028. Gateway offers are made on 7 May 2027 at 09:30 and must be accepted by 14 May 2027 at 09:30.',
    application_dates_text = 'Vacancies may be browsed from 23 November 2026. Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
    date_precision = 'month',
    places_text = 'Up to five pupillages each year across all 3VB pupillage formats',
    source_status = 'official_dates_published',
    application_process_text = 'Apply through the Pupillage Gateway. Standard applicants ordinarily complete an assessed 3VB mini-pupillage; shortlisted candidates then attend two interview rounds.',
    funding_text = '£90,000 pupillage award, with up to £22,500 available to draw down before pupillage.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'bee263e3-6fc4-4874-b2a7-1055a2ef1777';

update public.career_opportunities
set public_summary = case id
      when '66e7f1e1-e6a7-4686-9ab4-4b27ba6f7ad6' then 'Assessed commercial mini-pupillage on 2–3 December 2026; applications close on 19 October 2026.'
      when '695f028b-e73a-4057-8dd9-577d07df1fd5' then 'Assessed commercial mini-pupillage on 6–7 January 2027; applications run from 20 October to 10 November 2026.'
      when 'bfb30deb-0d2e-4c3d-9d28-89ea44460a52' then 'Assessed commercial mini-pupillage on 3–4 February 2027; applications run from 11 November to 3 December 2026.'
      when 'd3741943-2f90-4197-9780-0ffbffa99799' then 'Assessed commercial mini-pupillage on 10–11 February 2027; applications run from 4 December 2026 to 4 January 2027.'
    end,
    research_checked_on = date '2026-10-15',
    next_review_on = case id
      when '66e7f1e1-e6a7-4686-9ab4-4b27ba6f7ad6' then date '2026-10-20'
      when '695f028b-e73a-4057-8dd9-577d07df1fd5' then date '2026-11-11'
      when 'bfb30deb-0d2e-4c3d-9d28-89ea44460a52' then date '2026-12-04'
      when 'd3741943-2f90-4197-9780-0ffbffa99799' then date '2027-01-05'
    end,
    updated_at = now()
where id in (
  '66e7f1e1-e6a7-4686-9ab4-4b27ba6f7ad6',
  '695f028b-e73a-4057-8dd9-577d07df1fd5',
  'bfb30deb-0d2e-4c3d-9d28-89ea44460a52',
  'd3741943-2f90-4197-9780-0ffbffa99799'
);

update public.career_opportunity_cycles
set audience_text = 'Prospective commercial-pupillage applicants.',
    funding_text = 'Reasonable travel expenses and necessary overnight accommodation may be reimbursed.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id in (
  'f595f95a-6dc6-4775-8d8d-e13124790f1f',
  'c408d59d-a030-41c8-a9e7-7a84dc59960e',
  '8fd15659-69a2-495b-9614-f3bf8e49fd26',
  '2803825d-f81f-4ecd-bb90-cb804bd437ae'
);

update public.career_opportunities
set public_summary = 'Two-day mini-pupillage at 3VB through the Bridging the Bar Academy for aspiring barristers from groups underrepresented at the Bar.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-06',
    updated_at = now()
where id = 'f4d3a732-9f1f-4ae9-abab-96db089bff6f';

update public.career_opportunity_cycles
set programme_dates_text = 'Two-day mini-pupillage arranged through the 2027/28 Bridging the Bar Academy.',
    application_model = 'fixed_deadline',
    application_process_text = 'Apply to the 2027/28 Bridging the Bar Academy through Bridging the Bar by 17:00 UK time on 5 November 2026.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'e852ca78-b1e2-47c8-a788-2396ff86102c';

update public.career_opportunities
set public_summary = 'Long-term mentoring and professional-network support from 3VB barristers for care-experienced university students and aspiring lawyers through Lawyers Who Care.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-15',
    updated_at = now()
where id = 'ec67f93c-4dc5-44fe-92a0-609388d74253';

update public.career_opportunity_cycles
set programme_dates_text = 'Long-term mentoring delivered through Lawyers Who Care.',
    application_dates_text = 'Access is arranged through the Lawyers Who Care programme.',
    source_status = 'current_support',
    application_model = 'rolling',
    application_process_text = 'Apply or seek referral through the Lawyers Who Care programme for care-experienced aspiring lawyers.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'a82e28fc-6b9a-48a7-9092-0d8ceac1c291';

update public.career_opportunities
set public_summary = 'Free hybrid student open evening on 11 November 2026, with talks about commercial practice, life at 3VB and routes to the Bar followed by networking.',
    official_url = 'https://3vb.com/event/student-open-evening-2026/',
    application_url = 'https://3vb.com/event/student-open-evening-2026/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-12',
    updated_at = now()
where id = '7faaba0f-714f-407a-a6b8-b1ad87afc9b6';

update public.career_opportunity_cycles
set programme_dates_text = '11 November 2026. Registration from 17:00; talks from 17:30 to 19:15; networking and drinks from 19:15 to 20:30. Attend at 3 Verulam Buildings, Gray''s Inn, London WC1R 5NT, or online.',
    application_model = 'rolling',
    application_process_text = 'Register through the official 3VB Student Open Evening page for either in-person or online attendance.',
    official_url = 'https://3vb.com/event/student-open-evening-2026/',
    application_url = 'https://3vb.com/event/student-open-evening-2026/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'f19edd87-50cb-424a-a7c3-79f21c1eed39';

update public.career_opportunities
set public_summary = 'Student essay competition on art-law disputes, with cash prizes and placements at Stephenson Harwood, the Institute of Art and Law and Sotheby''s.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2026-11-28',
    updated_at = now()
where id = '1fde298d-9e0f-408c-8120-53dcd4f702d5';

update public.career_opportunity_cycles
set audience_text = 'Undergraduate and postgraduate students interested in art law.',
    funding_text = 'First prize: £2,500 and one week with Stephenson Harwood''s Art Law team. Second prize: £1,000 and one week at the Institute of Art and Law. Third prize: £500. The best undergraduate or GDL essay also receives a two-day placement at Sotheby''s.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '17083603-5256-4e47-a9f2-8ea6e6fd8422';

commit;
