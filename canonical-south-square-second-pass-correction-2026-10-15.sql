begin;

update public.legal_organisations
set uk_visa_status=null,uk_visa_summary=null,uk_visa_source_url=null,uk_visa_source_title=null,uk_visa_checked_on=null,updated_at=now()
where id='e1dad1a3-efc8-4dbc-9879-b7b5566b5e85';

update public.chambers
set mini_pupillage_overview='South Square offers approximately 40 non-assessed two-day mini-pupillages each year. Applications are open for placements between April and July 2027, closing on 12 February 2027, and placements between September and November 2027, closing on 2 July 2027. Law students should normally apply in their final year and non-law applicants after beginning conversion study. Applications are by CV and covering letter. South Square reimburses reasonable public-transport expenses up to £100 and provides £20 per day towards other costs.',
    research_checked_on=date '2026-10-15',updated_at=now()
where organisation_id='e1dad1a3-efc8-4dbc-9879-b7b5566b5e85';

update public.career_opportunity_cycles
set expenses_text='Reasonable public-transport expenses are reimbursed up to £100, with £20 per day towards other costs.',research_checked_on=date '2026-10-15',updated_at=now()
where opportunity_id in (
  select id from public.career_opportunities
  where organisation_id='e1dad1a3-efc8-4dbc-9879-b7b5566b5e85'
    and slug in ('south-square-mini-pupillage-april-july-2027','south-square-mini-pupillage-september-november-2027')
);

commit;
