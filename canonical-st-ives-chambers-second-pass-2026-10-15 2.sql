begin;

update public.chambers
set pupillage_overview='St Ives runs an annual 12-month pupillage competition in line with the Pupillage Gateway timetable and recruits with a view to tenancy. The 2027 competition opens at 11:00 on 4 January and closes at 23:59 on 28 January. The latest published funding package comprised a £23,504 grant for the non-practising six and guaranteed minimum earnings of £2,500 per month during the practising six. Pupils shadow and complete monthly advocacy training during the first six, then undertake instructed court work during the second six.',
    pupillage_gateway_member=false,pupillage_gateway_url=null,
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',updated_at=now()
where organisation_id='6a2c2db7-70f3-4fd3-896e-d213e463ccd6';

update public.career_opportunities
set slug='st-ives-chambers-pupillage-2027-competition',
    official_name='St Ives Chambers Pupillage — 2027 Competition',
    public_name='St Ives Chambers Pupillage — 2027 Competition',
    public_summary='Annual 12-month multidisciplinary pupillage competition at St Ives Chambers, with pupillages offered with a view to tenancy.',
    official_url='https://stiveschambers.co.uk/applications/pupillage/',
    application_url='https://stiveschambers.co.uk/applications/pupillage/',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-24',updated_at=now()
where slug='st-ives-chambers-pupillage-2028-intake';

update public.career_opportunity_cycles c
set cycle_key='st-ives-pupillage-2027-competition',
    cycle_label='St Ives Chambers Pupillage — 2027 Competition',
    application_year=2027,programme_year=null,intake_year=null,
    programme_starts_on=null,programme_ends_on=null,programme_dates_text=null,
    application_dates_text='Applications open at 11:00 on 4 January 2027 and close at 23:59 on 28 January 2027.',
    places_text='St Ives’ latest published prospectus offered up to three pupillages.',
    eligibility_text='Applicants must be able to complete the academic and vocational stages of Bar training before commencing pupillage.',
    application_process_text='Apply using the instructions published on the official St Ives pupillage page during the application window.',
    assessments_text='Written application, first-round interview and second-round interview.',
    funding_text='The latest published package comprised a £23,504 grant during the non-practising six and guaranteed minimum earnings of £2,500 per month during the practising six.',
    official_url='https://stiveschambers.co.uk/applications/pupillage/',
    application_url='https://stiveschambers.co.uk/applications/pupillage/',
    research_checked_on=date '2026-10-15',updated_at=now()
from public.career_opportunities o
where c.opportunity_id=o.id and o.slug='st-ives-chambers-pupillage-2027-competition';

update public.career_opportunity_routes r
set route_note='Birmingham and Nottingham multidisciplinary practice',updated_at=now()
from public.career_opportunities o
where r.opportunity_id=o.id and o.slug='st-ives-chambers-pupillage-2027-competition';

update public.career_opportunity_cycles
set audience_text='Final-year law students who have not obtained a pupillage offer.',
    study_stage_text='Final-year law students.',
    eligibility_text='Applicants must be final-year law students and must not already hold a pupillage offer.',
    updated_at=now()
where opportunity_id='92a9f36e-e1e9-4d3b-9445-6c08f49c18ba';

commit;
