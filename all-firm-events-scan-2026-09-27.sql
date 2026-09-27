-- Vacatory all-firm events scan actions
-- Applied directly to Supabase project vac-attack (qusyglgevgyjaoasmjhz) on 2026-09-27.
-- Backup/audit note for GitHub Desktop; this records live canonical data changes.

-- Scope:
-- - Top-50 UK firm set currently in Vacatory.
-- - Student/new-graduate-facing open days, insight events, law fairs, skills sessions and similar events.
-- - Only current/future dated events were kept active.

-- Cleanup:
-- - Removed 25 past one-off top-50 firm event cycles whose dates had passed.
-- - Suppressed 4 additional past event cycles where hard-delete was blocked by protected dependent rows.
-- - Verified after cleanup: zero active top-50 firm open-day/event cycles remain with programme_ends_on before 2026-09-27.

-- Added/updated:
-- - RPC: added 6 missing future events from the official RPC Meet us page.
-- - Gateley: added Manchester and Birmingham Open Days 2026 using Gateley/AllAboutLaw provider details.
-- - Osborne Clarke: added 18 future events from the official Osborne Clarke events page.
-- - Clifford Chance: added future 2026/27 Meet us events including One Firm, London/Middle East Insight Days,
--   skills sessions, Year 12/Young Professionals events and Legal Cheek regional fairs.
-- - Charles Russell Speechlys: updated the four Open Day records with exact 2026 event dates:
--   Guildford 1 Dec, Cheltenham 3 Dec, London 8 Dec and Virtual 11 Dec.
-- - Brodies: corrected Career Insight Day event dates to Edinburgh 29 Sep and Glasgow 2 Oct 2026;
--   Aberdeen 25 Sep 2026 is now past and was suppressed.
-- - Future City Lawyers partner insight days: added Hogan Lovells Cadwalader 2 Nov 2026 and
--   Simmons & Simmons 4 Nov 2026, both closing 18 Oct 2026 with travel-expense support noted.

-- Checked and already represented:
-- - Hogan Lovells Cadwalader future events.
-- - Norton Rose Fulbright open days/insight days.
--
-- Additional cleanup:
-- - Suppressed past one-day Hogan Lovells Cadwalader / Norton Rose Fulbright events that had no programme end date.
-- - Suppressed additional expired one-off event rows found during final verification.
-- - Final verification returned zero active expired one-off event rows.
