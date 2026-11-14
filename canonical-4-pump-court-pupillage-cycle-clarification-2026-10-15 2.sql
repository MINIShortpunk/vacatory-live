begin;

update public.career_opportunities
set public_summary = 'Upcoming 12-month commercial pupillage route commencing in autumn 2028. The mandatory recruitment window runs from 4 to 28 January 2027.',
    official_url = 'https://www.4pumpcourt.com/join-us/pupillage/',
    application_url = 'https://www.4pumpcourt.com/join-us/pupillage/how-to-apply/',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-04',
    updated_at = now()
where id = '8c79bca2-0d1a-4808-81f1-1d35cb278b07';

update public.career_opportunity_cycles
set programme_starts_on = null,
    programme_ends_on = null,
    programme_dates_text = 'Twelve-month pupillage commencing in autumn 2028.',
    date_precision = 'season',
    places_text = 'Chambers normally recruits around two pupils; the current official pupillage page describes its latest recruitment round on that basis.',
    funding_text = 'The latest award published by chambers is £80,000, with up to £25,000 available during the Bar course, a second-six gross-billing guarantee of at least £10,000 and pupils retaining additional earnings from their own work.',
    source_status = 'official_dates_published',
    source_status_note = 'The official mini-pupillage page identifies the 2027 application deadline as the route for pupillages commencing in autumn 2028. The exact January 2027 opening and closing times follow the mandatory Pupillage Gateway recruitment timetable. The separate September 2027 recruitment round is closed.',
    official_url = 'https://www.4pumpcourt.com/join-us/pupillage/',
    application_url = 'https://www.4pumpcourt.com/join-us/pupillage/how-to-apply/',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '41c78cbf-54de-413a-8771-f27ee94244a0';

update public.chambers
set pupillage_overview = 'The September 2027 recruitment round is closed. The next published route is for a 12-month pupillage commencing in autumn 2028: the mandatory application window opens at 11:00 on 4 January 2027 and closes at 23:59 on 28 January 2027. Chambers normally recruits around two pupils. The latest award published by chambers is £80,000, with up to £25,000 available during the Bar course and a second-six gross-billing guarantee of at least £10,000.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-04',
    updated_at = now()
where organisation_id = '37337e06-4b8e-422a-a536-448ef1c60e73';

commit;
