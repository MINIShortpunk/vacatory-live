begin;

delete from public.vacation_schemes where id in (
 'de686583-e4a9-4fff-a817-01e44d7545f5',
 'e35f3150-dcc1-4f31-81b6-39e752686da3',
 '47daced7-8428-4767-8588-8d8a5def7c4f',
 '4666e5e1-64d3-4a78-97bd-68a022368cfd',
 '6eb49268-87c6-4a28-bae7-588dc9b93c7a'
);

delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id='c67fe388-4609-4751-bbe3-365913c858c9';
delete from public.career_opportunity_compensation
where opportunity_id='c67fe388-4609-4751-bbe3-365913c858c9';

delete from public.opportunity_cycles
where vacation_scheme_id in ('3f242482-9e58-4595-b143-0bb955ad8394','8cd4a994-44d7-4b04-b628-c721af12e702');
delete from public.opportunity_compensation
where vacation_scheme_id='3f242482-9e58-4595-b143-0bb955ad8394';
delete from public.opportunity_research_issues
where vacation_scheme_id in ('3f242482-9e58-4595-b143-0bb955ad8394','8cd4a994-44d7-4b04-b628-c721af12e702');

update public.vacation_schemes set
 scheme_name='Old Square Chambers Pupillage — 2027 Application Cycle',
 slug='old-square-chambers-pupillage-2027-application-cycle',
 opens_on=date '2027-01-04',deadline=date '2027-01-28',
 application_open=date '2027-01-04',application_open_date=date '2027-01-04',
 application_deadline=date '2027-01-28',application_close_date=date '2027-01-28',closes_on=date '2027-01-28',
 salary=null,pay_details=null,sponsorship=null,expenses=null,
 application_link='https://www.pupillagegateway.com/',status='upcoming',
 application_process='Applications open through the Pupillage Gateway at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027. Shortlisted applicants normally complete two interview rounds.',
 academic_requirements='A minimum 2:1 degree is desirable. Intellectual ability is assessed from academic qualifications and other evidence.',
 assessment_formats='Written application, shortlisting and two interview rounds.',interview_dates=null,
 programme_structure='Twelve-month pupillage with court work, written work and supervision across Old Square’s specialist civil practices.',
 source_url='https://oldsquare.co.uk/join/pupillage/',research_checked_on=date '2026-10-15',
 programme_dates_text=null,visa_requirements=null,cycle_year=2027,status_note=null,
 card_summary='Applications open on 4 January 2027 and close on 28 January 2027 through the Pupillage Gateway.',
 programme_dates=null,assessments='Written application, shortlisting and two interview rounds.',
 visa_information=null,additional_details=null,next_review_on=date '2026-11-23',updated_at=now()
where id='3f242482-9e58-4595-b143-0bb955ad8394';

update public.vacation_schemes set
 scheme_name='Old Square Chambers School Work Experience — Summer 2027',
 opens_on=date '2026-11-30',application_open=date '2026-11-30',application_open_date=date '2026-11-30',
 deadline=null,application_deadline=null,application_close_date=null,closes_on=null,
 programme_start=date '2027-06-28',programme_end=date '2027-07-09',programme_start_date=date '2027-06-28',
 application_process='Applications open on 30 November 2026 using the form on the official page and close when 80 fully completed applications have been received. Applications are anonymised and assessed against a scoring matrix.',
 academic_requirements=null,right_to_work_requirements=null,interview_dates=null,
 programme_dates_text='Placements run from 28 June to 2 July 2027 and from 5 to 9 July 2027.',
 programme_dates='28 June to 2 July 2027; 5 to 9 July 2027',
 status_note=null,card_summary='Applications open on 30 November 2026 for two one-week London placements in June and July 2027.',
 additional_details='Applications are capped at 80 completed forms for 12 places.',
 research_checked_on=date '2026-10-15',next_review_on=date '2026-12-01',updated_at=now()
where id='8cd4a994-44d7-4b04-b628-c721af12e702';

update public.career_opportunity_identity_stage
set canonical_slug='old-square-chambers-pupillage-2027-application-cycle',updated_at=now()
where career_opportunity_id='c67fe388-4609-4751-bbe3-365913c858c9';

commit;
