begin;

delete from public.vacation_schemes
where organisation_id='549e9113-f04c-443f-bde8-57020cfbde44'
   or firm_id='549e9113-f04c-443f-bde8-57020cfbde44';

update public.career_opportunities set
 official_name='Bridging the Bar Academy 2027/28 — Pump Court Tax Chambers Partner',
 public_name='Bridging the Bar Academy 2027/28 — Pump Court Tax Chambers Partner',
 public_summary='Access programme providing mentoring, advocacy and application training and at least one mini-pupillage through participating chambers. Pump Court Tax Chambers is a founding partner; allocation to a particular chambers is not guaranteed.',
 delivery_mode='hybrid',
 official_url='https://www.pumptax.com/pupillage/mini-pupillage/',
 application_url='https://bridgingthebar.org/academy-applications/',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-11-06',updated_at=now()
where id='59d34a5e-09d5-4ba7-a417-fd43d24c05b8';

update public.career_opportunity_cycles set
 cycle_key='pump-court-tax-bridging-the-bar-academy-2027-28',
 cycle_label='Bridging the Bar Academy 2027/28 — Pump Court Tax Chambers Partner',
 application_year=2026,programme_year=2027,intake_year=2027,
 application_model='fixed_deadline',opens_on=date '2026-10-02',closes_on=date '2026-11-05',
 closes_at=time '17:00',closes_timezone='Europe/London',
 application_dates_text='Applications close at 17:00 on 5 November 2026.',
 programme_dates_text='The Academy runs from August 2027 to June 2028.',
 date_precision='exact',duration_text='August 2027 to June 2028',source_status='open',
 study_stage_text='Bar Course student in 2027–28 or Bar Course graduate intending to apply for pupillage in 2028.',
 eligibility_text='Applicants must meet the Academy’s published education and financial-support criteria and be available in the United Kingdom for programme activity.',
 application_process_text='Apply through Bridging the Bar. The Academy allocates mini-pupillages through participating chambers; applicants do not apply directly to Pump Court Tax Chambers for these placements.',
 assessments_text='Bridging the Bar manages the Academy application and assessment process.',
 expenses_text='Financial support is governed by the Academy’s published terms.',
 right_to_work_text='Applicants must satisfy the Academy’s current eligibility requirements.',
 additional_details_text='Pump Court Tax Chambers is a founding partner of Bridging the Bar and offers Academy mini-pupillage places separately from its direct mini-pupillage rounds.',
 official_url='https://www.pumptax.com/pupillage/mini-pupillage/',
 application_url='https://bridgingthebar.org/academy-applications/',
 active=true,research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='59d34a5e-09d5-4ba7-a417-fd43d24c05b8';

update public.career_opportunities set
 public_summary='Funded two-day in-person or one-day virtual tax mini-pupillage. Applications close at 16:00 on 26 October 2026 for placements from 2 November 2026 to 1 February 2027.',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-10-27',updated_at=now()
where id='68375d02-dc17-407e-aae5-8b6f90cc4d39';

update public.career_opportunity_cycles set
 application_model='fixed_deadline',closes_timezone='Europe/London',date_precision='exact',source_status='open',
 application_dates_text='Applications close at 16:00 on 26 October 2026.',
 programme_dates_text='Placements take place from 2 November 2026 to 1 February 2027, excluding 14 December 2026 to 4 January 2027.',
 duration_text='Two days in person or one day virtually.',
 funding_text='Mini-pupils receive £50 per day.',
 expenses_text='Further needs-based support is available where reasonable attendance costs exceed the daily allowance.',
 study_stage_text='Priority is given to applicants in the second or later year of a law degree, those who have started the GDL, and Bar Course students.',
 eligibility_text='Applicants considering a career at the Bar may apply. Full university examination results to date must be provided.',
 application_process_text='Email an anonymous CV and cover letter in Word format to minipupils@pumptax.com, signed “Applicant”, explaining the interest in Pump Court Tax Chambers and stating available dates.',
 assessments_text='Anonymous written CV and cover-letter review.',
 official_url='https://www.pumptax.com/pupillage/mini-pupillage/',
 application_url='https://www.pumptax.com/pupillage/mini-pupillage/',
 research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id='68375d02-dc17-407e-aae5-8b6f90cc4d39';

insert into public.career_opportunity_routes
 (opportunity_id,route_kind,route_note,route_status,display_order,active)
select '68375d02-dc17-407e-aae5-8b6f90cc4d39','virtual','One-day virtual mini-pupillage option','confirmed',20,true
where not exists(select 1 from public.career_opportunity_routes where opportunity_id='68375d02-dc17-407e-aae5-8b6f90cc4d39' and route_kind='virtual');

insert into public.career_opportunities
 (organisation_id,opportunity_type_id,event_type_id,slug,official_name,public_name,public_summary,delivery_mode,official_url,application_url,active,published,research_checked_on,next_review_on)
select '549e9113-f04c-443f-bde8-57020cfbde44','5e2816dd-108f-4443-9fb2-218def79147f','f2ad34e9-2e06-4dd6-8c0e-a20ec0e597a3',
 'pump-court-tax-pupillage-at-the-specialist-bar-2026',
 'Pupillage at the Specialist Bar 2026 — Pump Court Tax Chambers',
 'Pupillage at the Specialist Bar 2026 — Pump Court Tax Chambers',
 'Hybrid panel and networking evening for students and prospective pupillage applicants exploring careers in Media, Company, Intellectual Property and Tax Law.',
 'hybrid','https://www.pumptax.com/event/pupillage-at-the-specialist-bar-wednesday-4th-november-2026/',
 'https://portal.lincolnsinn.org.uk/your-profile/book-an-event/pupillage-at-the-specialist-bar.html',true,true,date '2026-10-15',date '2026-11-05'
where not exists(select 1 from public.career_opportunities where slug='pump-court-tax-pupillage-at-the-specialist-bar-2026');

insert into public.career_opportunity_cycles
 (opportunity_id,cycle_key,cycle_label,application_year,programme_year,application_model,closes_on,closes_at,closes_timezone,programme_starts_on,programme_ends_on,application_dates_text,programme_dates_text,date_precision,duration_text,source_status,audience_text,study_stage_text,eligibility_text,application_process_text,assessments_text,programme_structure_text,official_url,application_url,active,research_checked_on)
select id,'pump-court-tax-pupillage-at-the-specialist-bar-2026',official_name,2026,2026,'fixed_deadline',date '2026-11-02',time '17:00','Europe/London',date '2026-11-04',date '2026-11-04',
 'Bookings close at 17:00 on 2 November 2026.',
 '4 November 2026, 18:00–20:00, with registration from 17:45. Attend at the Ashworth Centre, Lincoln’s Inn, or online by Zoom.',
 'exact','Two hours','open','Students and prospective pupillage applicants interested in specialist Bar careers.','Any stage of study.',
 'Aspiring pupils at any stage of study may attend; Lincoln’s Inn membership and previous knowledge of the covered practice areas are not required.',
 'Book through the official Lincoln’s Inn event page.','Information event; no assessment.',
 'Panel discussion on specialist-Bar practice and routes into Media, Company, Intellectual Property and Tax Law, followed by an in-person networking reception.',
 'https://www.pumptax.com/event/pupillage-at-the-specialist-bar-wednesday-4th-november-2026/',
 'https://portal.lincolnsinn.org.uk/your-profile/book-an-event/pupillage-at-the-specialist-bar.html',true,date '2026-10-15'
from public.career_opportunities
where slug='pump-court-tax-pupillage-at-the-specialist-bar-2026'
and not exists(select 1 from public.career_opportunity_cycles c where c.opportunity_id=career_opportunities.id);

insert into public.career_opportunity_routes(opportunity_id,route_kind,country_id,city_id,route_note,route_status,display_order,active)
select id,'physical_city',47,139,'The Ashworth Centre, Lincoln’s Inn, London','confirmed',10,true
from public.career_opportunities o where slug='pump-court-tax-pupillage-at-the-specialist-bar-2026'
and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.route_kind='physical_city' and r.city_id=139);
insert into public.career_opportunity_routes(opportunity_id,route_kind,route_note,route_status,display_order,active)
select id,'virtual','Online attendance via Zoom','confirmed',20,true
from public.career_opportunities o where slug='pump-court-tax-pupillage-at-the-specialist-bar-2026'
and not exists(select 1 from public.career_opportunity_routes r where r.opportunity_id=o.id and r.route_kind='virtual');

update public.chambers set
 pupillage_overview='Pump Court Tax Chambers recruits through the Pupillage Gateway. Its published January 2026 round for one pupillage commencing in October 2027 is closed. The published award is up to £75,000 for 12 months, with up to £30,000 available for drawdown in the preceding year. Chambers aims to offer tenancy to every pupil who reaches the required standard.',
 mini_pupillage_overview='For 2026–27, applicants may choose a funded two-day in-person or one-day virtual mini-pupillage. The current round closes at 16:00 on 26 October 2026 for placements from 2 November 2026 to 1 February 2027, excluding 14 December 2026 to 4 January 2027. Mini-pupils receive £50 per day and may seek further needs-based support. The Bridging the Bar Academy uses a separate central application process.',
 tenancy_overview='Pump Court Tax Chambers aims to offer tenancy to every pupil who reaches the required standard. Third-six, new-practitioner and established-practitioner recruitment are excluded from Vacatory’s student-opportunity listings.',
 research_status='verified',research_checked_on=date '2026-10-15',next_review_on=date '2026-10-27',updated_at=now()
where organisation_id='549e9113-f04c-443f-bde8-57020cfbde44';

commit;
