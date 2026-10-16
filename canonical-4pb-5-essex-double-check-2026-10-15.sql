begin;

update public.chambers
set pupillage_overview = '4PB normally offers two or three funded 12-month family-law pupillages each year. Its current page displays the closed application window for the October 2025 intake. The latest award shown by chambers is £50,000, comprising a £40,000 grant and guaranteed minimum second-six earnings of £10,000.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where organisation_id = 'eb12d28f-15d2-411c-a472-fda0c88f79db';

update public.chambers
set pupillage_overview = '5 Essex Chambers recruits up to two 12-month pupils each year through the Pupillage Gateway. Pupils rotate through three supervisors and undertake their own work during the practising six. The current minimum package is £80,000: a £50,000 award and £30,000 guaranteed earnings, with up to £10,000 available as drawdown. The most recent advertised vacancy was for September 2027 and closed on 22 January 2026.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where organisation_id = '809887b0-9bf0-494a-8740-0afbe8503eb0';

update public.career_opportunities
set official_name = '10,000 Black Interns Programme — 4PB Participating Chambers',
    public_name = '10,000 Black Interns Programme — 4PB Participating Chambers',
    english_name = '10,000 Black Interns Programme — 4PB Participating Chambers',
    public_summary = 'Apply to the Foundation’s Summer 2027 programme through The Bar workstream. 4PB confirms that it participates, but applicants cannot select or be guaranteed a particular employer.',
    updated_at = now()
where id = 'ca355afc-e424-4fb8-90f2-ee11b3052e53';

update public.career_opportunity_cycles
set eligibility_text = 'Applicants must meet the Foundation’s Summer 2027 eligibility rules, including its ethnicity, study or graduation, prior-participation and unrestricted UK right-to-work requirements.',
    application_process_text = 'Apply through the 10,000 Interns Foundation and select The Bar workstream and preferred location. The Foundation allocates eligible applicants to participating employers; a placement and a particular employer are not guaranteed.',
    additional_details_text = '4PB confirms participation. The Foundation controls allocation and employers make their own selection decisions.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '8364e296-9e2b-40e5-9962-afa73bd7964d';

update public.career_opportunities
set official_name = '10,000 Black Interns Programme — 5 Essex Participating Chambers',
    public_name = '10,000 Black Interns Programme — 5 Essex Participating Chambers',
    english_name = '10,000 Black Interns Programme — 5 Essex Participating Chambers',
    public_summary = 'Apply to the Foundation’s Summer 2027 programme through The Bar workstream. 5 Essex confirms that it participates, but applicants cannot select or be guaranteed a particular employer.',
    updated_at = now()
where id = '91be6ce7-8a70-4940-9ada-e951f66434de';

update public.career_opportunity_cycles
set eligibility_text = 'Applicants must meet the Foundation’s Summer 2027 eligibility rules, including its ethnicity, study or graduation, prior-participation and unrestricted UK right-to-work requirements.',
    application_process_text = 'Apply through the 10,000 Interns Foundation and select The Bar workstream and preferred location. The Foundation allocates eligible applicants to participating employers; a placement and a particular employer are not guaranteed.',
    programme_structure_text = 'The Foundation allocates eligible applicants by workstream and preferred location. Participating employers then make their own selection decisions.',
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'f9f31615-b032-4287-9ac2-58f20dfdd581';

commit;
