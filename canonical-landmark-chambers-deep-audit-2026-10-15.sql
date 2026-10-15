begin;

update public.legal_organisations
set careers_url='https://www.landmarkchambers.co.uk/recruitment/',research_status='verified',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-10-19',updated_at=now()
where id='5b186bea-ec89-4c6c-8ac0-9378d044b4be';

update public.chambers
set pupillage_overview='Landmark offers up to three London-based 12-month pupillages each year: one specialist property pupillage and up to two pupillages for candidates interested in its other practice areas. The award is £80,000, paid monthly, with an optional £30,000 drawdown in the year before pupillage. Applications are made through the Pupillage Gateway. Selection comprises application review, a one-hour written assessment and an interview.',
    mini_pupillage_overview='Landmark offers three-to-five-day mini-pupillages in three annual intakes, with 15 to 20 places per intake and up to 60 placements each year. Mini-pupils may claim up to £100 for reasonable travel and lunch costs, and discretionary accommodation funding is available to students travelling from outside London. Mini-pupillages are not assessed and do not form part of pupillage selection.',
    research_status='verified',research_checked_on=date '2026-10-15',
    next_review_on=date '2026-10-19',updated_at=now()
where organisation_id='5b186bea-ec89-4c6c-8ac0-9378d044b4be';

-- Permanently remove two professional conferences, a closed competition,
-- an undated staff-side school placement and a closed-cycle mentoring placeholder.
delete from public.career_opportunity_compensation_identity_stage where career_opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab') or compensation_id in (select id from public.career_opportunity_compensation where opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab'));
delete from public.career_opportunity_cycle_identity_stage where career_opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunity_cycle_routes where opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunity_compensation where opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunity_locations where opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunity_routes where opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunity_scope_assignments where opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunity_location_candidate_stage where career_opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunity_location_migration_stage where career_opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunity_identity_stage where career_opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunity_cycles where opportunity_id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');
delete from public.career_opportunities where id in ('95b77fd6-2fa4-4879-9db3-d230059e7ee7','0bb07f8c-cc3a-4f57-b079-5e902d15524d','d034b605-9611-4bb6-8495-880eafb3ec97','1fb7a7b8-6894-429d-bb5b-481f494d4adb','e6c3b1a4-a54f-4063-af53-09b5d6d852ab');

-- The Able Interns pilot is not a current 2027 application route. Retain only the verified Black Interns cycle.
update public.career_opportunities
set official_name='10,000 Black Interns — The Bar 2027 — Landmark Chambers Partner',
    public_name='10,000 Black Interns — The Bar 2027 — Landmark Chambers Partner',
    public_summary='Paid six-week Bar internship programme for eligible Black students and recent graduates. Landmark Chambers confirms that it hosts an intern annually.',
    official_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-11-02',updated_at=now()
where id='aded9107-ea6c-42d8-952f-5f4247e9189b';

update public.career_opportunity_cycles
set cycle_label='10,000 Black Interns — The Bar 2027 — Landmark Chambers Partner',
    application_year=2026,programme_year=2027,intake_year=2027,
    application_model='fixed_deadline',closes_on=date '2026-11-01',closes_timezone='Europe/London',
    programme_starts_on=date '2027-06-01',programme_ends_on=date '2027-09-30',
    programme_dates_text='Six-week internships take place between June and September 2027, with dates agreed through the programme.',
    application_dates_text='Applications for the Summer 2027 programme close on 1 November 2026.',
    duration_text='Six weeks',date_precision='exact',source_status='open',
    funding_text='Paid internship at no less than the applicable real Living Wage.',
    eligibility_text='Applicants must be aged 18 or over, be Black African, Black Caribbean, Black British or of mixed Black heritage, meet the programme’s UK study or recent-graduate criteria, and not previously have secured a 10,000 Black Interns placement.',
    study_stage_text='UK undergraduate or postgraduate student, confirmed university entrant on a gap year, or recent UK-university graduate from 2024 or later.',
    right_to_work_text='Applicants must already have unrestricted permission to work full-time in the United Kingdom when applying.',
    application_process_text='Apply through the 10,000 Interns Foundation and select The Bar workstream. Candidates may choose a region but cannot select an individual chambers.',
    programme_structure_text='The Bar workstream rotates interns across chambers and other Bar organisations. Landmark confirms that it hosts an intern annually.',
    assessments_text='The programme and participating hosts manage application review and selection.',
    academic_criteria=null,expenses_text='Paid placement at no less than the applicable real Living Wage.',
    disability_support_text='Applicants may request reasonable adjustments through the programme and participating host selection process.',
    source_status_note=null,additional_details_text=null,
    official_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    application_url='https://10000internsfoundation.com/students-graduates/10000-black-interns/',
    research_checked_on=date '2026-10-15',updated_at=now()
where id='d1bfa7e1-0c4e-4523-9241-568ac507fae9';

update public.career_opportunities
set public_summary='Essay competition for aspiring barristers interested in human-rights law, with a £1,000 first prize, mini-pupillage and publication opportunity.',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-10-19',updated_at=now()
where id='f1f4db80-17a7-4296-bb4f-8c47f74540c4';

update public.career_opportunities
set public_summary='Student moot competition applying planning and environmental law in a judicial-review context, with £500 and a mini-pupillage for each winning advocate.',
    research_checked_on=date '2026-10-15',next_review_on=date '2026-10-20',updated_at=now()
where id='69c41b78-d8d2-4c0b-9857-3acbcfcc2623';

update public.career_opportunity_cycles
set closes_timezone='Europe/London',date_precision='exact',research_checked_on=date '2026-10-15',updated_at=now()
where id in ('aa711036-0886-450d-aa56-de02b79e69ab','95159b2c-db50-427e-8fca-765423c0b440');

update public.career_opportunities
set application_url='https://www.pupillagegateway.com/',
    public_summary=case id
      when 'feded964-99c1-4b87-98b6-8d862e243e4e' then 'One of up to two funded 12-month Landmark pupillages for candidates interested in its planning, environment, public, local-government, rating or related practice areas.'
      else 'Funded 12-month specialist property-law pupillage at Landmark Chambers.' end,
    research_checked_on=date '2026-10-15',next_review_on=date '2027-01-29',updated_at=now()
where id in ('feded964-99c1-4b87-98b6-8d862e243e4e','284820f0-dc5d-4fa3-aec7-839d19fabd7a');

update public.career_opportunity_cycles
set funding_text='£80,000 award paid in equal monthly instalments, including an optional £30,000 drawdown during the year before pupillage.',
    duration_text='12 months',date_precision='exact',source_status='upcoming',
    application_url='https://www.pupillagegateway.com/',research_checked_on=date '2026-10-15',updated_at=now()
where id in ('668c9ef1-ebe9-4831-af80-3c8fe88aec37','09179351-d07f-4d1c-a40e-64c53db19c6c');

update public.career_opportunities
set public_summary='Three-to-five-day, non-assessed mini-pupillage at Landmark Chambers in London.',
    research_checked_on=date '2026-10-15',updated_at=now()
where id in ('b414848a-17e2-4742-8cb8-928757554576','021d5a8f-5cb5-4562-ae51-332c94a58438','4c78d67f-277d-4ffa-950e-14b852f46fdb');

update public.career_opportunity_cycles
set duration_text='Three to five days',
    expenses_text='Up to £100 reimbursement for reasonable travel and lunch costs.',
    accommodation_support_text='Discretionary accommodation funding is available to students travelling from outside London.',
    application_dates_text=case id
      when '7dd67e7b-29fd-4dc7-8ffd-6e9f146c8192' then 'Applications are accepted from 1 August to 30 November 2026.'
      when '8eddc3a8-d1a6-4ed7-86a2-fdbad11688da' then 'Applications are accepted from 1 December 2026 to 28 February 2027.'
      else 'Applications are accepted from 1 March to 31 July 2027.' end,
    date_precision='exact',research_checked_on=date '2026-10-15',updated_at=now()
where id in ('7dd67e7b-29fd-4dc7-8ffd-6e9f146c8192','8eddc3a8-d1a6-4ed7-86a2-fdbad11688da','023c4295-690c-455b-b7ce-142ae7f9fcec');

update public.career_opportunities
set public_summary=case id
      when 'c67f25d7-e783-43b1-a92c-0d7bbe10cc70' then 'In-person pupillage open evening for higher-education students at Landmark Chambers.'
      else 'Online pupillage open evening for higher-education students.' end,
    research_checked_on=date '2026-10-15',updated_at=now()
where id in ('c67f25d7-e783-43b1-a92c-0d7bbe10cc70','64f91b03-daac-48fc-b4c7-015b8b8e4a3d');

update public.career_opportunity_cycles
set application_model='rolling',date_precision='exact',source_status='open',
    research_checked_on=date '2026-10-15',updated_at=now()
where id in ('e18c7751-8286-40be-997f-fac54aba8bb7','59caf124-d31b-4eef-a17b-a464ae8cf6a8');

commit;
