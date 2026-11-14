begin;

-- Remove internal staging rows that restrict permanent opportunity deletion.
delete from public.career_opportunity_compensation_identity_stage
where career_opportunity_id in (
  'd87e8b2f-a246-4bbb-8a8b-e340c3098a94',
  '3d927c4e-c6ca-488c-b679-b82c18c8a8d7',
  'c18c39f3-6b09-423d-97c4-7f56f8b7cf53',
  '3be0ea65-01b2-40c9-b91d-2bfcf9c1ff39',
  'a9c4f662-ba0f-497e-9db2-296722fbeca8'
);

delete from public.career_opportunity_cycle_identity_stage
where career_opportunity_id in (
  'd87e8b2f-a246-4bbb-8a8b-e340c3098a94',
  '3d927c4e-c6ca-488c-b679-b82c18c8a8d7',
  'c18c39f3-6b09-423d-97c4-7f56f8b7cf53',
  '3be0ea65-01b2-40c9-b91d-2bfcf9c1ff39',
  'a9c4f662-ba0f-497e-9db2-296722fbeca8'
);

delete from public.career_opportunity_identity_stage
where career_opportunity_id in (
  'd87e8b2f-a246-4bbb-8a8b-e340c3098a94',
  '3d927c4e-c6ca-488c-b679-b82c18c8a8d7',
  'c18c39f3-6b09-423d-97c4-7f56f8b7cf53',
  '3be0ea65-01b2-40c9-b91d-2bfcf9c1ff39',
  'a9c4f662-ba0f-497e-9db2-296722fbeca8'
);

-- These are closed, speculative, or not a structured law-student opportunity.
-- Dependent cycle, location, route and compensation rows cascade.
delete from public.career_opportunities
where id in (
  'd87e8b2f-a246-4bbb-8a8b-e340c3098a94',
  '3d927c4e-c6ca-488c-b679-b82c18c8a8d7',
  'c18c39f3-6b09-423d-97c4-7f56f8b7cf53',
  '3be0ea65-01b2-40c9-b91d-2bfcf9c1ff39',
  'a9c4f662-ba0f-497e-9db2-296722fbeca8'
);

update public.career_opportunities
set public_summary = 'Up to ten three-day mini-pupillages in Brighton, offered in person, remotely or in a hybrid format.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-15',
    updated_at = now()
where id = '3b762517-235d-49a3-9968-0e1ed0daac3c';

update public.career_opportunity_cycles
set cycle_label = '2026–27 application cycle',
    application_dates_text = 'Applications opened 1 October 2026 and close 28 February 2027.',
    programme_dates_text = 'Placements take place from April 2027, with dates agreed with successful applicants.',
    assessments_text = 'The CV and covering letter are assessed against academic achievement, relevant experience, written expression and interest in chambers. There is no interview.',
    right_to_work_text = null,
    source_status_note = null,
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = '4a0414c8-6f88-4527-83d5-9c78f2faae04';

update public.career_opportunities
set public_summary = 'Ten three-day London mini-pupillages offering insight into chambers’ work and life at the Bar.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-15',
    updated_at = now()
where id = '31f510e1-a6e8-4193-824b-4375f3386f78';

update public.career_opportunity_cycles
set cycle_label = '2026–27 application cycle',
    application_dates_text = 'Applications open 30 November 2026 and close 28 February 2027.',
    programme_dates_text = 'Placements are normally scheduled for June or early July 2027.',
    assessments_text = 'Candidates are selected from their CV and covering letter. There is no interview. Participants are assessed during the placement.',
    right_to_work_text = null,
    source_status_note = null,
    research_checked_on = date '2026-10-15',
    updated_at = now()
where id = 'dfc156b8-1a56-4330-9b65-5c219d56b3c7';

update public.legal_organisations
set overview = '1 Crown Office Row is a barristers’ chambers with offices in London and Brighton. Its members practise across civil, public, regulatory, healthcare, human rights, personal injury, family and related areas of law. The chambers offers separate London and Brighton mini-pupillage programmes for students and graduates considering a career at the Bar.',
    research_checked_on = date '2026-10-15',
    next_review_on = date '2027-01-15',
    updated_at = now()
where id = '125d93e7-38ae-4746-a866-8c428ca4196d';

commit;
