begin;
update public.career_opportunity_cycles set assessments_text='Gateway application, chamber shortlisting and interview stages.',date_precision='exact',updated_at=now() where id='45f3fbfd-1628-4f7e-b2e0-b54a5a3d4507';
update public.career_opportunity_cycles set assessments_text='Registration is required; this is an information event rather than a selection exercise.',updated_at=now() where id in('9785a105-39d9-4dfd-98dc-2c5d500d9e0c','7dfd6b96-1175-4679-bc29-5a30f082c949');
commit;
