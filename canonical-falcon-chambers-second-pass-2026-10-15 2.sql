begin;

update public.career_opportunities set
 application_url='https://www.falcon-chambers.com/join-us/mini-pupillage',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-12-01',updated_at=now()
where slug='falcon-chambers-mini-pupillage-2027';

update public.career_opportunity_cycles set
 application_model='no_application',
 application_dates_text='Applications open toward the end of 2026 through Falcon’s official mini-pupillage page.',
 application_url='https://www.falcon-chambers.com/join-us/mini-pupillage',
 expenses_text='Falcon provides successful applicants with a contribution toward expenses.',
 travel_support_text='A contribution toward expenses is available to successful applicants.',
 accommodation_support_text=null,
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id in
 (select id from public.career_opportunities where slug='falcon-chambers-mini-pupillage-2027');

update public.chambers set
 mini_pupillage_overview='Falcon normally runs three non-assessed three-day mini-pupillage programmes each year for groups of four or five. The September 2026 programme is closed. Applications for the 2027 programme open toward the end of 2026 through Falcon’s official mini-pupillage page. Law and non-law students may apply, with preference for applicants who have completed their first university year. Successful applicants receive a contribution toward expenses.',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-12-01',updated_at=now()
where organisation_id='c871c677-79fd-4680-9b45-f3ecf30475fc';

commit;
