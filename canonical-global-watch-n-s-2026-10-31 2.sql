begin;

-- Vacatory Global Opportunity Watch: N-S law firms, verified against live
-- official sources on 31 October 2026.

create temporary table _expired_ns_records(id uuid primary key) on commit drop;

insert into _expired_ns_records(id)
select co.id
from public.career_opportunities co
join public.legal_organisations lo on lo.id=co.organisation_id
join public.career_opportunity_cycles c on c.opportunity_id=co.id and c.active
where lo.slug in (
  'norton-rose-fulbright','osborne-clarke','penningtons-manches-cooper',
  'pinsent-masons','rpc','shakespeare-martineau','shoosmiths',
  'simmons-simmons','slaughter-and-may','stephenson-harwood','stewarts'
)
and co.active
group by co.id,co.event_type_id
having (co.event_type_id is not null and max(c.programme_ends_on) < date '2026-10-31')
or (co.event_type_id is null and max(c.closes_on) < date '2026-10-31');

delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in (select id from _expired_ns_records);
delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in (select id from _expired_ns_records);
delete from public.career_opportunity_identity_stage
where career_opportunity_id in (select id from _expired_ns_records);
delete from public.career_opportunities
where id in (select id from _expired_ns_records);

update public.career_opportunity_cycles c
set source_status='closed',
    source_status_note='Registration closed on 30 October 2026. The event itself remains upcoming.',
    research_checked_on=date '2026-10-31',updated_at=now()
from public.career_opportunities co
join public.legal_organisations lo on lo.id=co.organisation_id
where c.opportunity_id=co.id and c.active
and lo.slug='penningtons-manches-cooper'
and co.slug in ('birmingham-open-day-17-november-2026','disability-open-day-24-november-2026','guildford-open-day-1-december-2026','virtual-open-evening-8-december-2026');

update public.career_opportunity_cycles c
set programme_starts_on=v.event_date,programme_ends_on=v.event_date,
    programme_dates_text=to_char(v.event_date,'FMDD FMMonth YYYY')||'.',
    date_precision='exact',research_checked_on=date '2026-10-31',updated_at=now()
from public.career_opportunities co
join public.legal_organisations lo on lo.id=co.organisation_id
join (values
  ('training-contract-open-day-london-2026',date '2026-12-01'),
  ('training-contract-open-day-virtual-2026',date '2026-12-09'),
  ('solicitor-apprenticeship-open-day-london-2026',date '2026-12-17'),
  ('solicitor-apprenticeship-open-day-virtual-2026',date '2026-12-15'),
  ('disability-open-day-london-2026',date '2026-12-14')
) as v(slug,event_date) on v.slug=co.slug
where c.opportunity_id=co.id and c.active and lo.slug='stephenson-harwood';

update public.career_opportunity_cycles c
set closes_at=time '23:59',closes_timezone='Europe/London',
    research_checked_on=date '2026-10-31',updated_at=now()
from public.career_opportunities co
join public.legal_organisations lo on lo.id=co.organisation_id
where c.opportunity_id=co.id and c.active and lo.slug='slaughter-and-may'
and co.slug in ('solicitor-apprenticeship','spring-forward-programme','spring-open-days','summer-work-experience-non-law-september','london-training-contract-law','london-training-contract-non-law');

commit;
