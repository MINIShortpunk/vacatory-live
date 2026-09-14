/*
 * Vacatory shared canonical opportunity data layer
 *
 * FOUNDATION RULES
 * ----------------
 * 1. General opportunity consumers read public.career_opportunities_public_view.
 * 2. Schedule consumers (Events and Deadlines) read the lean canonical
 *    public.career_opportunity_occurrences_public_view.
 * 3. Pages never reconstruct opportunity identity from legacy tables.
 * 4. Pages never derive application status from raw dates/source wording.
 * 5. Pages never parse geography from opportunity names/free text.
 * 6. Pages never append cycle labels to public titles.
 * 7. Public cycle/compensation detail reads use dedicated clean public-detail
 *    projections; raw research text never crosses the frontend boundary.
 * 8. Page scripts consume this shared layer; no page owns a private Supabase
 *    query contract for canonical opportunity data.
 *
 * The main public opportunity view and the occurrence projection share the
 * canonical public title and geography contract. Schedule consumers use the
 * occurrence projection so each published cycle keeps its own dates.
 */

(() => {
  "use strict";

  const PUBLIC_VIEW = "career_opportunities_public_view";
  const OCCURRENCES_VIEW =
    "career_opportunity_occurrences_public_view";
  const CYCLE_DETAIL_VIEW =
    "career_opportunity_cycle_public_detail_view";
  const COMPENSATION_DETAIL_VIEW =
    "career_opportunity_compensation_public_detail_view";
  const PAGE_SIZE = 1000;

  const EVENT_OCCURRENCE_SELECT = [
    "occurrence_id",
    "opportunity_id",
    "opportunity_slug",
    "official_name",
    "public_title",
    "delivery_mode",
    "provider_id",
    "provider_type",
    "provider_name",
    "provider_short_name",
    "provider_slug",
    "provider_logo_url",
    "opportunity_type_id",
    "opportunity_type_slug",
    "opportunity_type_label",
    "opportunity_category",
    "career_pathway",
    "is_event",
    "event_type_id",
    "event_type_slug",
    "event_type_label",
    "countries",
    "cities",
    "location_summary",
    "opportunity_application_url",
    "opportunity_official_url",
    "last_verified_on",
    "cycle_id",
    "programme_starts_on",
    "programme_ends_on",
    "programme_dates_text",
    "occurrence_ends_on",
    "public_application_status",
    "public_application_date_state",
    "closes_on",
    "closes_at",
    "closes_timezone",
    "cycle_application_url",
    "cycle_official_url"
  ].join(",");

  const DEADLINE_OCCURRENCE_SELECT = [
    "occurrence_id",
    "opportunity_id",
    "opportunity_slug",
    "official_name",
    "public_title",
    "delivery_mode",
    "provider_id",
    "provider_type",
    "provider_name",
    "provider_short_name",
    "provider_slug",
    "opportunity_type_id",
    "opportunity_type_slug",
    "opportunity_type_label",
    "opportunity_category",
    "career_pathway",
    "is_event",
    "event_type_slug",
    "event_type_label",
    "countries",
    "cities",
    "location_summary",
    "opportunity_application_url",
    "opportunity_official_url",
    "last_verified_on",
    "cycle_id",
    "opens_on",
    "closes_on",
    "closes_at",
    "closes_timezone",
    "public_application_status",
    "public_application_date_state",
    "has_exact_application_deadline",
    "days_until_deadline",
    "deadline_group",
    "deadline_key",
    "programme_starts_on",
    "programme_ends_on",
    "programme_dates_text",
    "date_precision",
    "duration_text",
    "places_text",
    "may_close_early",
    "cycle_application_url",
    "cycle_official_url"
  ].join(",");

  const DEADLINE_CYCLE_DETAIL_SELECT = [
    "cycle_id",
    "opportunity_id",
    "application_year",
    "programme_year",
    "intake_year",
    "application_model",
    "opens_on",
    "opens_at",
    "opens_timezone",
    "closes_on",
    "closes_at",
    "closes_timezone",
    "public_application_status",
    "public_application_date_state",
    "has_exact_application_deadline",
    "days_until_deadline",
    "deadline_group",
    "deadline_key",
    "application_dates_text",
    "programme_starts_on",
    "programme_ends_on",
    "programme_dates_text",
    "date_precision",
    "duration_text",
    "places_text",
    "audience_text",
    "study_stage_text",
    "academic_criteria",
    "eligibility_text",
    "application_process_text",
    "assessments_text",
    "progression_route_text",
    "programme_structure_text",
    "funding_text",
    "expenses_text",
    "travel_support_text",
    "accommodation_support_text",
    "right_to_work_text",
    "disability_support_text",
    "may_close_early",
    "additional_details_text",
    "official_url",
    "application_url",
    "last_verified_on"
  ].join(",");

  const DEADLINE_COMPENSATION_DETAIL_SELECT = [
    "compensation_id",
    "opportunity_id",
    "cycle_id",
    "is_primary",
    "type",
    "stage",
    "status",
    "amount",
    "currency",
    "frequency",
    "amount_text",
    "details"
  ].join(",");

  const opportunityLoadPromises = new Map();
  const occurrenceLoadPromises = new Map();
  const deadlineDetailPromises = new Map();

  /* ========================================================================
     GENERAL CANONICAL OPPORTUNITY LOADING
     ======================================================================== */

  async function loadOpportunities(options = {}) {
    const {
      client: suppliedClient,
      forceReload = false,
      scope = "all",
      providerId = "",
      includeSearchIndex = true
    } = options;

    const supabaseClient = resolveClient(suppliedClient);
    const descriptor = normaliseOpportunityLoadDescriptor({
      scope,
      providerId
    });

    const cacheKey = [
      descriptor.scope,
      descriptor.providerId,
      includeSearchIndex ? "search" : "lean"
    ].join(":");

    if (!forceReload && opportunityLoadPromises.has(cacheKey)) {
      return opportunityLoadPromises.get(cacheKey);
    }

    const loadPromise = fetchOpportunityRows(
      supabaseClient,
      descriptor
    )
      .then(rows =>
        rows
          .map(row =>
            normaliseOpportunity(row, {
              includeSearchIndex
            })
          )
          .filter(Boolean)
      )
      .catch(error => {
        opportunityLoadPromises.delete(cacheKey);
        throw error;
      });

    opportunityLoadPromises.set(cacheKey, loadPromise);
    return loadPromise;
  }

  function loadProviderOpportunities(options = {}) {
    if (!options.providerId) {
      throw new Error(
        "A providerId is required to load provider opportunities."
      );
    }

    return loadOpportunities({
      ...options,
      scope: "provider",
      includeSearchIndex:
        options.includeSearchIndex !== false
    });
  }

  async function loadOngoingOnlineOpportunities(options = {}) {
    const {
      client: suppliedClient,
      forceReload = false,
      includeSearchIndex = true
    } = options;

    const supabaseClient = resolveClient(suppliedClient);
    const cacheKey = [
      "ongoing-online",
      includeSearchIndex ? "search" : "lean"
    ].join(":");

    if (!forceReload && opportunityLoadPromises.has(cacheKey)) {
      return opportunityLoadPromises.get(cacheKey);
    }

    const loadPromise = (async () => {
      const rows = [];
      let from = 0;

      while (true) {
        const to = from + PAGE_SIZE - 1;
        const { data, error } = await supabaseClient
          .from(PUBLIC_VIEW)
          .select("*")
          .eq("public_application_date_state", "always_available")
          .order("provider_name", { ascending: true })
          .order("public_title", { ascending: true })
          .range(from, to);

        if (error) {
          throw error;
        }

        const page = data || [];
        rows.push(...page);

        if (page.length < PAGE_SIZE) {
          break;
        }

        from += PAGE_SIZE;
      }

      return rows
        .map(row =>
          normaliseOpportunity(row, {
            includeSearchIndex
          })
        )
        .filter(isOngoingOnlineOpportunity);
    })().catch(error => {
      opportunityLoadPromises.delete(cacheKey);
      throw error;
    });

    opportunityLoadPromises.set(cacheKey, loadPromise);
    return loadPromise;
  }

  function isOngoingOnlineOpportunity(opportunity) {
    const deliveryMode = normaliseText(opportunity?.deliveryMode);

    return Boolean(
      opportunity &&
      opportunity.publicApplicationDateState === "always_available" &&
      (deliveryMode.includes("online") || deliveryMode.includes("virtual"))
    );
  }

  function normaliseOpportunityLoadDescriptor({
    scope,
    providerId
  }) {
    if (scope === "provider") {
      return {
        scope: "provider",
        providerId: String(providerId || "")
      };
    }

    return {
      scope: "all",
      providerId: ""
    };
  }

  async function fetchOpportunityRows(
    supabaseClient,
    descriptor
  ) {
    const rows = [];
    let from = 0;

    while (true) {
      const to = from + PAGE_SIZE - 1;

      let query = supabaseClient
        .from(PUBLIC_VIEW)
        .select("*");

      if (
        descriptor.scope === "provider" &&
        descriptor.providerId
      ) {
        query = query.eq(
          "provider_id",
          descriptor.providerId
        );
      }

      const { data, error } = await query
        .order("opportunity_id", { ascending: true })
        .order("public_title", { ascending: true })
        .range(from, to);

      if (error) {
        throw error;
      }

      const page = data || [];
      rows.push(...page);

      if (page.length < PAGE_SIZE) {
        break;
      }

      from += PAGE_SIZE;
    }

    return rows;
  }

  /* ========================================================================
     CANONICAL OCCURRENCE LOADING — EVENTS + DEADLINES
     ======================================================================== */

  async function loadEventOccurrences(options = {}) {
    const {
      client: suppliedClient,
      forceReload = false,
      includePast = false,
      fromDate = todayDateOnly()
    } = options;

    const supabaseClient = resolveClient(suppliedClient);
    const cacheKey = [
      "events",
      includePast ? "all" : fromDate || "today"
    ].join(":");

    if (!forceReload && occurrenceLoadPromises.has(cacheKey)) {
      return occurrenceLoadPromises.get(cacheKey);
    }

    const loadPromise = fetchOccurrenceRows(
      supabaseClient,
      {
        kind: "events",
        select: EVENT_OCCURRENCE_SELECT,
        includePast,
        fromDate
      }
    )
      .then(rows =>
        rows
          .map(normaliseOccurrence)
          .filter(Boolean)
          .sort(compareEventOccurrences)
      )
      .catch(error => {
        occurrenceLoadPromises.delete(cacheKey);
        throw error;
      });

    occurrenceLoadPromises.set(cacheKey, loadPromise);
    return loadPromise;
  }

  async function loadDeadlineRecords(options = {}) {
    const {
      client: suppliedClient,
      forceReload = false,
      includePassed = false
    } = options;

    const supabaseClient = resolveClient(suppliedClient);
    const cacheKey = [
      "deadlines",
      includePassed ? "with-passed" : "current"
    ].join(":");

    if (!forceReload && occurrenceLoadPromises.has(cacheKey)) {
      return occurrenceLoadPromises.get(cacheKey);
    }

    const loadPromise = fetchOccurrenceRows(
      supabaseClient,
      {
        kind: "deadlines",
        select: DEADLINE_OCCURRENCE_SELECT,
        includePassed
      }
    )
      .then(rows =>
        buildDeadlineRecordsFromOccurrences(
          rows.map(normaliseOccurrence).filter(Boolean),
          { includePassed }
        )
      )
      .catch(error => {
        occurrenceLoadPromises.delete(cacheKey);
        throw error;
      });

    occurrenceLoadPromises.set(cacheKey, loadPromise);
    return loadPromise;
  }

  async function fetchOccurrenceRows(
    supabaseClient,
    descriptor
  ) {
    const rows = [];
    let from = 0;

    while (true) {
      const to = from + PAGE_SIZE - 1;

      let query = supabaseClient
        .from(OCCURRENCES_VIEW)
        .select(descriptor.select);

      if (descriptor.kind === "events") {
        query = query
          .eq("is_event", true)
          .not("programme_starts_on", "is", null);

        if (!descriptor.includePast && descriptor.fromDate) {
          query = query.gte(
            "occurrence_ends_on",
            descriptor.fromDate
          );
        }

        query = query
          .order("programme_starts_on", { ascending: true })
          .order("provider_name", { ascending: true })
          .order("public_title", { ascending: true });
      } else {
        query = query
          .eq("is_event", false)
          .eq("has_exact_application_deadline", true);

        if (!descriptor.includePassed) {
          query = query.neq("deadline_group", "passed");
        }

        query = query
          .order("closes_on", { ascending: true })
          .order("provider_name", { ascending: true })
          .order("public_title", { ascending: true });
      }

      const { data, error } = await query.range(from, to);

      if (error) {
        throw error;
      }

      const page = data || [];
      rows.push(...page);

      if (page.length < PAGE_SIZE) {
        break;
      }

      from += PAGE_SIZE;
    }

    return rows;
  }

  function normaliseOccurrence(row) {
    if (
      !row ||
      !row.occurrence_id ||
      !row.opportunity_id ||
      !row.provider_id ||
      !row.cycle_id
    ) {
      return null;
    }

    const sourceOpportunityId = String(row.opportunity_id);
    const cycleId = String(row.cycle_id);
    const publicOpportunityId = sourceOpportunityId;

    const occurrence = {
      occurrenceId: String(row.occurrence_id),
      eventKey: String(row.occurrence_id),

      opportunityId: publicOpportunityId,
      publicOpportunityId,
      sourceOpportunityId,
      opportunitySlug: stringValue(row.opportunity_slug),
      officialName: stringValue(row.official_name),
      publicTitle:
        stringValue(row.public_title) ||
        stringValue(row.official_name) ||
        "Opportunity",
      deliveryMode: stringValue(row.delivery_mode),

      providerId: String(row.provider_id),
      providerType: stringValue(row.provider_type),
      providerName: stringValue(row.provider_name) || "Organisation",
      providerShortName: stringValue(row.provider_short_name),
      providerSlug: stringValue(row.provider_slug),
      providerLogoUrl: safeHttpUrl(row.provider_logo_url),

      opportunityTypeId: stringValue(row.opportunity_type_id),
      opportunityTypeSlug: stringValue(row.opportunity_type_slug),
      opportunityTypeLabel:
        stringValue(row.opportunity_type_label) || "Opportunity",
      opportunityCategory: stringValue(row.opportunity_category),
      careerPathway: stringValue(row.career_pathway),

      isEvent: row.is_event === true,
      eventTypeId: stringValue(row.event_type_id),
      eventTypeSlug: stringValue(row.event_type_slug),
      eventTypeLabel: stringValue(row.event_type_label),

      routeKind: "",
      routeCountry: "",
      routeCity: "",
      routeScope: "",
      routeScopeKey: "",
      publicLocationLabel: stringValue(row.location_summary),

      countries: cleanStringArray(row.countries),
      cities: cleanStringArray(row.cities),
      locationSummary: stringValue(row.location_summary),

      cycleId,
      opensOn: dateOnlyValue(row.opens_on),
      closesOn: dateOnlyValue(row.closes_on),
      closesAt: stringValue(row.closes_at),
      closesTimezone: stringValue(row.closes_timezone),

      publicApplicationStatus:
        stringValue(row.public_application_status) || "unknown",
      publicApplicationDateState:
        stringValue(row.public_application_date_state) ||
        "no_published_application_date",
      hasExactApplicationDeadline:
        row.has_exact_application_deadline === true,
      daysUntilDeadline:
        integerOrNull(row.days_until_deadline),
      deadlineGroup: stringValue(row.deadline_group),
      deadlineKey: stringValue(row.deadline_key),

      programmeStartsOn: dateOnlyValue(row.programme_starts_on),
      programmeEndsOn: dateOnlyValue(row.programme_ends_on),
      programmeDatesText: stringValue(row.programme_dates_text),
      datePrecision: stringValue(row.date_precision),
      durationText: stringValue(row.duration_text),
      placesText: stringValue(row.places_text),
      occurrenceEndsOn: dateOnlyValue(row.occurrence_ends_on),

      mayCloseEarly:
        row.may_close_early === true
          ? true
          : row.may_close_early === false
            ? false
            : null,

      applicationUrl: safeHttpUrl(
        row.cycle_application_url ||
        row.opportunity_application_url
      ),
      officialUrl: safeHttpUrl(
        row.cycle_official_url ||
        row.opportunity_official_url
      ),

      lastVerifiedOn: dateOnlyValue(row.last_verified_on),
      searchText: "",
      raw: row
    };

    occurrence.searchText = buildOccurrenceSearchText(occurrence);
    return occurrence;
  }

  function buildOccurrenceSearchText(occurrence) {
    return normaliseText([
      occurrence.publicTitle,
      occurrence.officialName,
      occurrence.providerName,
      occurrence.providerShortName,
      occurrence.opportunityTypeLabel,
      occurrence.opportunityCategory,
      occurrence.careerPathway,
      occurrence.eventTypeLabel,
      occurrence.publicLocationLabel,
      occurrence.locationSummary,
      ...(occurrence.countries || []),
      ...(occurrence.cities || [])
    ].filter(Boolean).join(" "));
  }

  function buildDeadlineRecordsFromOccurrences(
    occurrences,
    options = {}
  ) {
    const { includePassed = true } = options;
    const groups = new Map();

    for (const occurrence of occurrences || []) {
      if (
        occurrence.isEvent ||
        !occurrence.hasExactApplicationDeadline ||
        !occurrence.deadlineKey ||
        !occurrence.closesOn
      ) {
        continue;
      }

      if (
        !includePassed &&
        occurrence.deadlineGroup === "passed"
      ) {
        continue;
      }

      const deadlineRecordKey =
        `${occurrence.publicOpportunityId}:${occurrence.deadlineKey}`;

      let record = groups.get(deadlineRecordKey);

      if (!record) {
        record = {
          deadlineRecordKey,
          deadlineKey: occurrence.deadlineKey,

          opportunityId: occurrence.opportunityId,
          opportunitySlug: occurrence.opportunitySlug,
          publicTitle: occurrence.publicTitle,
          officialName: occurrence.officialName,

          providerId: occurrence.providerId,
          providerType: occurrence.providerType,
          providerName: occurrence.providerName,
          providerShortName: occurrence.providerShortName,
          providerSlug: occurrence.providerSlug,

          opportunityTypeSlug: occurrence.opportunityTypeSlug,
          opportunityTypeLabel: occurrence.opportunityTypeLabel,
          opportunityCategory: occurrence.opportunityCategory,
          careerPathway: occurrence.careerPathway,

          publicOpportunityId: occurrence.publicOpportunityId,
          sourceOpportunityId: occurrence.sourceOpportunityId,
          routeKind: occurrence.routeKind,
          routeCountry: occurrence.routeCountry,
          routeCity: occurrence.routeCity,
          routeScope: occurrence.routeScope,
          routeScopeKey: occurrence.routeScopeKey,
          publicLocationLabel: occurrence.publicLocationLabel,

          isEvent: occurrence.isEvent,
          eventTypeSlug: occurrence.eventTypeSlug,
          eventTypeLabel: occurrence.eventTypeLabel,

          countries: [...occurrence.countries],
          cities: [...occurrence.cities],
          locationSummary: occurrence.locationSummary,

          opensOn: occurrence.opensOn,
          opensAt: "",
          opensTimezone: "",

          closesOn: occurrence.closesOn,
          closesAt: occurrence.closesAt,
          closesTimezone: occurrence.closesTimezone,

          publicApplicationStatus:
            occurrence.publicApplicationStatus,
          publicApplicationDateState:
            occurrence.publicApplicationDateState,
          daysUntilDeadline: occurrence.daysUntilDeadline,
          deadlineGroup: occurrence.deadlineGroup,

          applicationUrl: occurrence.applicationUrl,
          officialUrl: occurrence.officialUrl,
          mayCloseEarly: occurrence.mayCloseEarly,

          cycles: [],
          programmeOccurrences: [],
          compensation: [],
          primaryCompensation: emptyPrimaryCompensation(),

          lastVerifiedOn: occurrence.lastVerifiedOn,
          detailLoaded: false,
          detailLoading: false,
          detailError: "",
          searchText: ""
        };

        groups.set(deadlineRecordKey, record);
      }

      record.cycles.push(minimalCycleFromOccurrence(occurrence));
      record.programmeOccurrences.push(
        buildProgrammeOccurrenceFromOccurrence(occurrence)
      );

      if (occurrence.mayCloseEarly === true) {
        record.mayCloseEarly = true;
      }

      record.lastVerifiedOn = laterDateOnly(
        record.lastVerifiedOn,
        occurrence.lastVerifiedOn
      );
    }

    return [...groups.values()]
      .map(finaliseOccurrenceDeadlineRecord)
      .sort(compareDeadlineRecords);
  }

  function minimalCycleFromOccurrence(occurrence) {
    return {
      cycleId: occurrence.cycleId,
      opensOn: occurrence.opensOn,
      closesOn: occurrence.closesOn,
      closesAt: occurrence.closesAt,
      closesTimezone: occurrence.closesTimezone,
      publicApplicationStatus:
        occurrence.publicApplicationStatus,
      publicApplicationDateState:
        occurrence.publicApplicationDateState,
      hasExactApplicationDeadline:
        occurrence.hasExactApplicationDeadline,
      daysUntilDeadline: occurrence.daysUntilDeadline,
      deadlineGroup: occurrence.deadlineGroup,
      deadlineKey: occurrence.deadlineKey,
      applicationDatesText: "",
      programmeStartsOn: occurrence.programmeStartsOn,
      programmeEndsOn: occurrence.programmeEndsOn,
      programmeDatesText: occurrence.programmeDatesText,
      datePrecision: occurrence.datePrecision,
      durationText: occurrence.durationText,
      placesText: occurrence.placesText,
      audienceText: "",
      studyStageText: "",
      academicCriteria: "",
      eligibilityText: "",
      applicationProcessText: "",
      assessmentsText: "",
      progressionRouteText: "",
      programmeStructureText: "",
      fundingText: "",
      expensesText: "",
      travelSupportText: "",
      accommodationSupportText: "",
      rightToWorkText: "",
      disabilitySupportText: "",
      mayCloseEarly: occurrence.mayCloseEarly,
      additionalDetailsText: "",
      officialUrl: occurrence.officialUrl,
      applicationUrl: occurrence.applicationUrl
    };
  }

  function buildProgrammeOccurrenceFromOccurrence(occurrence) {
    return {
      cycleId: occurrence.cycleId,
      programmeStartsOn: occurrence.programmeStartsOn,
      programmeEndsOn: occurrence.programmeEndsOn,
      programmeDatesText: occurrence.programmeDatesText,
      durationText: occurrence.durationText,
      placesText: occurrence.placesText
    };
  }

  function finaliseOccurrenceDeadlineRecord(record) {
    record.cycles.sort(compareCyclesByProgrammeDate);
    record.programmeOccurrences = uniqueProgrammeOccurrences(
      record.programmeOccurrences
    );
    record.searchText = buildDeadlineSearchText(record);
    return record;
  }

  async function loadDeadlineDetails(options = {}) {
    const {
      client: suppliedClient,
      sourceOpportunityId,
      deadlineKey,
      forceReload = false
    } = options;

    if (!sourceOpportunityId || !deadlineKey) {
      throw new Error(
        "sourceOpportunityId and deadlineKey are required for deadline details."
      );
    }

    const supabaseClient = resolveClient(suppliedClient);
    const cacheKey =
      `${sourceOpportunityId}:${deadlineKey}`;

    if (!forceReload && deadlineDetailPromises.has(cacheKey)) {
      return deadlineDetailPromises.get(cacheKey);
    }

    const detailPromise = Promise.all([
      supabaseClient
        .from(CYCLE_DETAIL_VIEW)
        .select(DEADLINE_CYCLE_DETAIL_SELECT)
        .eq("opportunity_id", sourceOpportunityId)
        .eq("deadline_key", deadlineKey),

      supabaseClient
        .from(COMPENSATION_DETAIL_VIEW)
        .select(DEADLINE_COMPENSATION_DETAIL_SELECT)
        .eq("opportunity_id", sourceOpportunityId)
    ])
      .then(([cycleResult, compensationResult]) => {
        if (cycleResult.error) {
          throw cycleResult.error;
        }

        if (compensationResult.error) {
          throw compensationResult.error;
        }

        const cycles = (cycleResult.data || [])
          .map(normalisePublicCycleDetail)
          .filter(Boolean)
          .sort(compareCyclesByProgrammeDate);

        if (!cycles.length) {
          throw new Error(
            "Canonical deadline detail could not be found."
          );
        }

        const compensation = (compensationResult.data || [])
          .map(normalisePublicCompensationDetail)
          .filter(Boolean);

        const primary =
          compensation.find(item => item.isPrimary) || null;

        return {
          cycles,
          programmeOccurrences: uniqueProgrammeOccurrences(
            cycles.map(buildProgrammeOccurrence)
          ),
          compensation,
          primaryCompensation: primary
            ? {
                type: primary.type,
                stage: primary.stage,
                status: primary.status,
                amount: primary.amount,
                currency: primary.currency,
                frequency: primary.frequency,
                text: primary.amountText,
                details: primary.details
              }
            : emptyPrimaryCompensation()
        };
      })
      .catch(error => {
        deadlineDetailPromises.delete(cacheKey);
        throw error;
      });

    deadlineDetailPromises.set(cacheKey, detailPromise);
    return detailPromise;
  }

  function normalisePublicCycleDetail(row) {
    if (!row || !row.cycle_id) {
      return null;
    }

    return normaliseCycle({
      id: row.cycle_id,
      is_display_cycle: false,
      application_year: row.application_year,
      programme_year: row.programme_year,
      intake_year: row.intake_year,
      application_model: row.application_model,
      opens_on: row.opens_on,
      opens_at: row.opens_at,
      opens_timezone: row.opens_timezone,
      closes_on: row.closes_on,
      closes_at: row.closes_at,
      closes_timezone: row.closes_timezone,
      application_status: row.public_application_status,
      application_date_state: row.public_application_date_state,
      has_exact_application_deadline:
        row.has_exact_application_deadline,
      days_until_deadline: row.days_until_deadline,
      deadline_group: row.deadline_group,
      deadline_key: row.deadline_key,
      application_dates_text: row.application_dates_text,
      programme_starts_on: row.programme_starts_on,
      programme_ends_on: row.programme_ends_on,
      programme_dates_text: row.programme_dates_text,
      date_precision: row.date_precision,
      duration_text: row.duration_text,
      places_text: row.places_text,
      audience_text: row.audience_text,
      study_stage_text: row.study_stage_text,
      academic_criteria: row.academic_criteria,
      eligibility_text: row.eligibility_text,
      application_process_text: row.application_process_text,
      assessments_text: row.assessments_text,
      progression_route_text: row.progression_route_text,
      programme_structure_text: row.programme_structure_text,
      funding_text: row.funding_text,
      expenses_text: row.expenses_text,
      travel_support_text: row.travel_support_text,
      accommodation_support_text: row.accommodation_support_text,
      right_to_work_text: row.right_to_work_text,
      disability_support_text: row.disability_support_text,
      may_close_early: row.may_close_early,
      additional_details_text: row.additional_details_text,
      official_url: row.official_url,
      application_url: row.application_url
    });
  }

  function normalisePublicCompensationDetail(row) {
    if (!row || !row.compensation_id) {
      return null;
    }

    return normaliseCompensation({
      id: row.compensation_id,
      is_primary: row.is_primary,
      type: row.type,
      stage: row.stage,
      status: row.status,
      amount: row.amount,
      currency: row.currency,
      frequency: row.frequency,
      amount_text: row.amount_text,
      details: row.details
    });
  }

  function emptyPrimaryCompensation() {
    return {
      type: "",
      stage: "",
      status: "",
      amount: null,
      currency: "",
      frequency: "",
      text: "",
      details: ""
    };
  }

  function laterDateOnly(first, second) {
    if (!first) {
      return second || null;
    }

    if (!second) {
      return first;
    }

    return dateValue(second) > dateValue(first)
      ? second
      : first;
  }

  function resolveClient(suppliedClient) {
    const supabaseClient =
      suppliedClient ||
      (typeof window !== "undefined" ? window.client : undefined);

    if (!supabaseClient) {
      throw new Error("Vacatory Supabase client is unavailable.");
    }

    return supabaseClient;
  }

  function clearCache() {
    opportunityLoadPromises.clear();
    occurrenceLoadPromises.clear();
    deadlineDetailPromises.clear();
  }

  /* ========================================================================
     CANONICAL PUBLIC OBJECT
     ======================================================================== */

  function normaliseOpportunity(row, options = {}) {
    const { includeSearchIndex = true } = options;
    if (!row || !row.opportunity_id || !row.provider_id) {
      return null;
    }

    /*
     * Public identity is route-based once the canonical route contract is live.
     * Before cutover, public_opportunity_id is absent and safely falls back to
     * the source opportunity id. Existing consumers can therefore migrate
     * before the database view is switched.
     */
    const sourceOpportunityId = String(row.opportunity_id);
    const publicOpportunityId = String(
      row.public_opportunity_id || row.opportunity_id
    );

    const cycles = Array.isArray(row.cycles)
      ? row.cycles.map(normaliseCycle).filter(Boolean)
      : [];

    const locations = Array.isArray(row.locations)
      ? row.locations.map(normaliseLocation).filter(Boolean)
      : [];

    const compensation = Array.isArray(row.compensation)
      ? row.compensation.map(normaliseCompensation).filter(Boolean)
      : [];

    const opportunity = {
      /*
       * opportunityId remains the consumer-facing identity for backwards
       * compatibility, but now resolves to the stable public route id.
       */
      opportunityId: publicOpportunityId,
      publicOpportunityId,
      sourceOpportunityId,
      opportunitySlug: stringValue(row.opportunity_slug),

      officialName: stringValue(row.official_name),
      englishName: stringValue(row.english_name),
      languageCode: stringValue(row.language_code),

      publicTitle:
        stringValue(row.public_title) ||
        stringValue(row.official_name) ||
        "Opportunity",

      publicSummary: stringValue(row.public_summary),
      deliveryMode: stringValue(row.delivery_mode),

      publicName: stringValue(row.public_name),
      publicVariant: stringValue(row.public_variant),
      publicVariantKind: stringValue(row.public_variant_kind),

      routeKind: stringValue(row.route_kind),
      routeCountryId: row.route_country_id ?? null,
      routeCountry: stringValue(row.route_country),
      routeCityId: row.route_city_id ?? null,
      routeCity: stringValue(row.route_city),
      routeScopeKey: stringValue(row.route_scope_key),
      routeScope: stringValue(row.route_scope),
      routeScopeKind: stringValue(row.route_scope_kind),
      publicLocationLabel:
        stringValue(row.public_location_label) ||
        stringValue(row.location_summary),

      supportingLocationCount:
        integerOrZero(row.supporting_location_count),
      supportingLocations: Array.isArray(row.supporting_locations)
        ? row.supporting_locations.map(normaliseLocation).filter(Boolean)
        : [],

      providerId: String(row.provider_id),
      providerType: stringValue(row.provider_type),
      providerName: stringValue(row.provider_name) || "Organisation",
      providerShortName: stringValue(row.provider_short_name),
      providerSlug: stringValue(row.provider_slug),
      providerLogoUrl: safeHttpUrl(row.provider_logo_url),
      providerWebsiteUrl: safeHttpUrl(row.provider_website_url),
      providerCareersUrl: safeHttpUrl(row.provider_careers_url),

      opportunityTypeId: stringValue(row.opportunity_type_id),
      opportunityTypeSlug: stringValue(row.opportunity_type_slug),
      opportunityTypeLabel:
        stringValue(row.opportunity_type_label) || "Opportunity",
      opportunityCategory: stringValue(row.opportunity_category),
      careerPathway: stringValue(row.career_pathway),

      isEvent: row.is_event === true,
      eventTypeId: stringValue(row.event_type_id),
      eventTypeSlug: stringValue(row.event_type_slug),
      eventTypeLabel: stringValue(row.event_type_label),

      officialUrl: safeHttpUrl(row.official_url),
      applicationUrl: safeHttpUrl(row.application_url),

      primaryCycleId: stringValue(row.primary_cycle_id),

      applicationYear: row.application_year ?? null,
      programmeYear: row.programme_year ?? null,
      intakeYear: row.intake_year ?? null,

      applicationModel: stringValue(row.application_model),

      opensOn: dateOnlyValue(row.opens_on),
      opensAt: stringValue(row.opens_at),
      opensTimezone: stringValue(row.opens_timezone),

      closesOn: dateOnlyValue(row.closes_on),
      closesAt: stringValue(row.closes_at),
      closesTimezone: stringValue(row.closes_timezone),

      publicApplicationStatus:
        stringValue(row.public_application_status) ||
        stringValue(row.application_status) ||
        "unknown",

      publicApplicationDateState:
        stringValue(row.public_application_date_state) ||
        "no_published_application_date",

      hasExactApplicationDeadline:
        row.has_exact_application_deadline === true,

      daysUntilDeadline:
        integerOrNull(row.days_until_deadline),

      deadlineGroup: stringValue(row.deadline_group),
      deadlineKey: stringValue(row.deadline_key),

      applicationDatesText: stringValue(row.application_dates_text),

      programmeStartsOn: dateOnlyValue(row.programme_starts_on),
      programmeEndsOn: dateOnlyValue(row.programme_ends_on),
      programmeDatesText: stringValue(row.programme_dates_text),
      datePrecision: stringValue(row.date_precision),

      durationText: stringValue(row.duration_text),
      placesText: stringValue(row.places_text),

      audienceText: stringValue(row.audience_text),
      studyStageText: stringValue(row.study_stage_text),
      academicCriteria: stringValue(row.academic_criteria),
      eligibilityText: stringValue(row.eligibility_text),

      applicationProcessText: stringValue(row.application_process_text),
      assessmentsText: stringValue(row.assessments_text),
      progressionRouteText: stringValue(row.progression_route_text),
      programmeStructureText: stringValue(row.programme_structure_text),

      fundingText: stringValue(row.funding_text),
      expensesText: stringValue(row.expenses_text),
      travelSupportText: stringValue(row.travel_support_text),
      accommodationSupportText: stringValue(row.accommodation_support_text),

      rightToWorkText: stringValue(row.right_to_work_text),
      disabilitySupportText: stringValue(row.disability_support_text),

      mayCloseEarly:
        row.may_close_early === true
          ? true
          : row.may_close_early === false
            ? false
            : null,

      additionalDetailsText: stringValue(row.additional_details_text),

      cycleCount: integerOrZero(row.cycle_count),
      cycles,

      locationCount: integerOrZero(row.location_count),
      countries: cleanStringArray(row.countries),
      cities: cleanStringArray(row.cities),
      locationSummary: stringValue(row.location_summary),
      locations,

      primaryCompensation: {
        type: stringValue(row.primary_compensation_type),
        stage: stringValue(row.primary_compensation_stage),
        status: stringValue(row.primary_compensation_status),
        amount: numberOrNull(row.primary_compensation_amount),
        currency: stringValue(row.primary_compensation_currency),
        frequency: stringValue(row.primary_compensation_frequency),
        text: stringValue(row.primary_compensation_text),
        details: stringValue(row.primary_compensation_details)
      },

      compensationCount: integerOrZero(row.compensation_count),
      compensation,

      lastVerifiedOn: dateOnlyValue(row.last_verified_on),
      displayOrder: integerOrZero(row.display_order),

      raw: row
    };

    opportunity.searchText = includeSearchIndex
      ? buildSearchText(opportunity)
      : "";

    return opportunity;
  }

  function normaliseCycle(cycle) {
    if (!cycle || !cycle.id) {
      return null;
    }

    return {
      cycleId: String(cycle.id),
      isDisplayCycle: cycle.is_display_cycle === true,

      applicationYear: cycle.application_year ?? null,
      programmeYear: cycle.programme_year ?? null,
      intakeYear: cycle.intake_year ?? null,

      applicationModel: stringValue(cycle.application_model),

      opensOn: dateOnlyValue(cycle.opens_on),
      opensAt: stringValue(cycle.opens_at),
      opensTimezone: stringValue(cycle.opens_timezone),

      closesOn: dateOnlyValue(cycle.closes_on),
      closesAt: stringValue(cycle.closes_at),
      closesTimezone: stringValue(cycle.closes_timezone),

      publicApplicationStatus:
        stringValue(cycle.application_status) || "unknown",

      publicApplicationDateState:
        stringValue(cycle.application_date_state) ||
        "no_published_application_date",

      hasExactApplicationDeadline:
        cycle.has_exact_application_deadline === true,

      daysUntilDeadline:
        integerOrNull(cycle.days_until_deadline),

      deadlineGroup: stringValue(cycle.deadline_group),
      deadlineKey: stringValue(cycle.deadline_key),

      applicationDatesText: stringValue(cycle.application_dates_text),

      programmeStartsOn: dateOnlyValue(cycle.programme_starts_on),
      programmeEndsOn: dateOnlyValue(cycle.programme_ends_on),
      programmeDatesText: stringValue(cycle.programme_dates_text),
      datePrecision: stringValue(cycle.date_precision),

      durationText: stringValue(cycle.duration_text),
      placesText: stringValue(cycle.places_text),

      audienceText: stringValue(cycle.audience_text),
      studyStageText: stringValue(cycle.study_stage_text),
      academicCriteria: stringValue(cycle.academic_criteria),
      eligibilityText: stringValue(cycle.eligibility_text),

      applicationProcessText: stringValue(cycle.application_process_text),
      assessmentsText: stringValue(cycle.assessments_text),
      progressionRouteText: stringValue(cycle.progression_route_text),
      programmeStructureText: stringValue(cycle.programme_structure_text),

      fundingText: stringValue(cycle.funding_text),
      expensesText: stringValue(cycle.expenses_text),
      travelSupportText: stringValue(cycle.travel_support_text),
      accommodationSupportText: stringValue(cycle.accommodation_support_text),

      rightToWorkText: stringValue(cycle.right_to_work_text),
      disabilitySupportText: stringValue(cycle.disability_support_text),

      mayCloseEarly:
        cycle.may_close_early === true
          ? true
          : cycle.may_close_early === false
            ? false
            : null,

      additionalDetailsText: stringValue(cycle.additional_details_text),

      officialUrl: safeHttpUrl(cycle.official_url),
      applicationUrl: safeHttpUrl(cycle.application_url),

      raw: cycle
    };
  }

  function normaliseLocation(location) {
    if (!location || !location.id) {
      return null;
    }

    return {
      locationId: String(location.id),
      countryId: location.country_id ?? null,
      country: stringValue(location.country),
      cityId: location.city_id ?? null,
      city: stringValue(location.city),
      role: stringValue(location.role),
      status: stringValue(location.status),
      note: stringValue(location.note),
      displayOrder: integerOrZero(location.display_order),
      raw: location
    };
  }

  function normaliseCompensation(compensation) {
    if (!compensation || !compensation.id) {
      return null;
    }

    return {
      compensationId: String(compensation.id),
      isPrimary: compensation.is_primary === true,
      type: stringValue(compensation.type),
      stage: stringValue(compensation.stage),
      status: stringValue(compensation.status),
      amount: numberOrNull(compensation.amount),
      currency: stringValue(compensation.currency),
      frequency: stringValue(compensation.frequency),
      amountText: stringValue(compensation.amount_text),
      details: stringValue(compensation.details),
      raw: compensation
    };
  }

  /* ========================================================================
     DEADLINES
     ======================================================================== */

  function buildProgrammeOccurrence(cycle) {
    return {
      cycleId: cycle.cycleId,
      programmeStartsOn: cycle.programmeStartsOn,
      programmeEndsOn: cycle.programmeEndsOn,
      programmeDatesText: cycle.programmeDatesText,
      durationText: cycle.durationText,
      placesText: cycle.placesText
    };
  }

  function uniqueProgrammeOccurrences(occurrences) {
    const seen = new Set();
    const result = [];

    for (const occurrence of occurrences || []) {
      const signature = [
        occurrence.programmeStartsOn,
        occurrence.programmeEndsOn,
        normaliseText(occurrence.programmeDatesText),
        normaliseText(occurrence.durationText),
        normaliseText(occurrence.placesText)
      ].join("|");

      if (seen.has(signature)) {
        continue;
      }

      seen.add(signature);
      result.push(occurrence);
    }

    return result.sort(compareProgrammeOccurrences);
  }

  function compareDeadlineRecords(first, second) {
    const firstGroup = deadlineGroupRank(first.deadlineGroup);
    const secondGroup = deadlineGroupRank(second.deadlineGroup);

    if (firstGroup !== secondGroup) {
      return firstGroup - secondGroup;
    }

    const firstDate = dateValue(first.closesOn);
    const secondDate = dateValue(second.closesOn);

    if (first.deadlineGroup === "passed") {
      if (firstDate !== secondDate) {
        return secondDate - firstDate;
      }
    } else if (firstDate !== secondDate) {
      return firstDate - secondDate;
    }

    const providerComparison =
      first.providerName.localeCompare(second.providerName);

    if (providerComparison !== 0) {
      return providerComparison;
    }

    return first.publicTitle.localeCompare(second.publicTitle);
  }

  function deadlineGroupRank(group) {
    return {
      today: 0,
      within_7_days: 1,
      within_30_days: 2,
      later: 3,
      passed: 4
    }[group] ?? 5;
  }

  function compareCyclesByProgrammeDate(first, second) {
    const firstDate =
      dateValue(first.programmeStartsOn);

    const secondDate =
      dateValue(second.programmeStartsOn);

    if (firstDate !== secondDate) {
      return firstDate - secondDate;
    }

    return first.cycleId.localeCompare(second.cycleId);
  }

  function compareProgrammeOccurrences(first, second) {
    const firstDate =
      dateValue(first.programmeStartsOn);

    const secondDate =
      dateValue(second.programmeStartsOn);

    if (firstDate !== secondDate) {
      return firstDate - secondDate;
    }

    return String(
      first.programmeDatesText || ""
    ).localeCompare(
      String(second.programmeDatesText || "")
    );
  }

  /*
   * Non-exact application timing remains cycle-level data.
   * This helper returns those cycles without pretending they are deadlines.
   */
  function buildApplicationTimingRecords(opportunities) {
    const records = [];

    for (const opportunity of opportunities || []) {
      for (const cycle of opportunity.cycles || []) {
        if (cycle.hasExactApplicationDeadline || cycle.deadlineKey) {
          continue;
        }

        records.push({
          timingKey:
            `${opportunity.opportunityId}:${cycle.cycleId}`,

          opportunityId: opportunity.opportunityId,
          opportunitySlug: opportunity.opportunitySlug,
          publicTitle: opportunity.publicTitle,

          providerId: opportunity.providerId,
          providerType: opportunity.providerType,
          providerName: opportunity.providerName,
          providerShortName: opportunity.providerShortName,
          providerSlug: opportunity.providerSlug,

          opportunityTypeSlug: opportunity.opportunityTypeSlug,
          opportunityTypeLabel: opportunity.opportunityTypeLabel,

          publicOpportunityId: opportunity.publicOpportunityId,
          sourceOpportunityId: opportunity.sourceOpportunityId,
          routeKind: opportunity.routeKind,
          routeCountry: opportunity.routeCountry,
          routeCity: opportunity.routeCity,
          routeScope: opportunity.routeScope,
          routeScopeKey: opportunity.routeScopeKey,
          publicLocationLabel: opportunity.publicLocationLabel,

          countries: [...opportunity.countries],
          cities: [...opportunity.cities],
          locationSummary: opportunity.locationSummary,

          publicApplicationStatus:
            cycle.publicApplicationStatus,

          publicApplicationDateState:
            cycle.publicApplicationDateState,

          applicationModel:
            cycle.applicationModel,

          opensOn: cycle.opensOn,
          applicationDatesText:
            cycle.applicationDatesText,

          programmeStartsOn:
            cycle.programmeStartsOn,

          programmeEndsOn:
            cycle.programmeEndsOn,

          programmeDatesText:
            cycle.programmeDatesText,

          applicationUrl:
            cycle.applicationUrl ||
            opportunity.applicationUrl,

          officialUrl:
            cycle.officialUrl ||
            opportunity.officialUrl,

          cycle,
          opportunity
        });
      }
    }

    return records.sort(compareApplicationTimingRecords);
  }

  function compareApplicationTimingRecords(first, second) {
    const firstStatus =
      applicationStatusRank(first.publicApplicationStatus);

    const secondStatus =
      applicationStatusRank(second.publicApplicationStatus);

    if (firstStatus !== secondStatus) {
      return firstStatus - secondStatus;
    }

    const firstOpening = dateValue(first.opensOn);
    const secondOpening = dateValue(second.opensOn);

    if (firstOpening !== secondOpening) {
      return firstOpening - secondOpening;
    }

    const providerComparison =
      first.providerName.localeCompare(second.providerName);

    if (providerComparison !== 0) {
      return providerComparison;
    }

    return first.publicTitle.localeCompare(second.publicTitle);
  }

  /* ========================================================================
     EVENTS
     ======================================================================== */

  function compareEventOccurrences(first, second) {
    const firstDate = dateValue(first.programmeStartsOn);
    const secondDate = dateValue(second.programmeStartsOn);

    if (firstDate !== secondDate) {
      return firstDate - secondDate;
    }

    const providerComparison =
      first.providerName.localeCompare(second.providerName);

    if (providerComparison !== 0) {
      return providerComparison;
    }

    return first.publicTitle.localeCompare(second.publicTitle);
  }

  /* ========================================================================
     FILTER / DIRECTORY / SEARCH HELPERS
     ======================================================================== */

  function getFilterOptions(opportunities) {
    return {
      providerTypes: uniqueSorted(
        (opportunities || []).map(item => item.providerType)
      ),

      opportunityTypes: uniqueSorted(
        (opportunities || []).map(item => item.opportunityTypeLabel)
      ),

      opportunityTypeSlugs: uniqueSorted(
        (opportunities || []).map(item => item.opportunityTypeSlug)
      ),

      countries: uniqueSorted(
        (opportunities || []).flatMap(item => item.countries)
      ),

      cities: uniqueSorted(
        (opportunities || []).flatMap(item => item.cities)
      ),

      routeScopes: uniqueSorted(
        (opportunities || []).map(item => item.routeScope)
      ),

      providers: uniqueSorted(
        (opportunities || []).map(item => item.providerName)
      ),

      applicationStatuses: uniqueSorted(
        (opportunities || []).map(item => item.publicApplicationStatus)
      ),

      eventTypes: uniqueSorted(
        (opportunities || [])
          .filter(item => item.isEvent)
          .map(item => item.eventTypeLabel)
      )
    };
  }

  function opportunitiesForProvider(opportunities, providerId) {
    const id = String(providerId || "");

    return (opportunities || [])
      .filter(opportunity => opportunity.providerId === id)
      .sort(compareOpportunities);
  }

  function compareOpportunities(first, second) {
    const firstDisplay = first.displayOrder || 0;
    const secondDisplay = second.displayOrder || 0;

    if (firstDisplay !== secondDisplay) {
      return firstDisplay - secondDisplay;
    }

    const typeComparison =
      first.opportunityTypeLabel.localeCompare(
        second.opportunityTypeLabel
      );

    if (typeComparison !== 0) {
      return typeComparison;
    }

    return first.publicTitle.localeCompare(second.publicTitle);
  }

  function buildSearchText(opportunity) {
    const parts = [
      opportunity.publicTitle,
      opportunity.officialName,
      opportunity.englishName,
      opportunity.providerName,
      opportunity.providerShortName,
      opportunity.opportunityTypeLabel,
      opportunity.opportunityCategory,
      opportunity.careerPathway,
      opportunity.eventTypeLabel,
      opportunity.deliveryMode,
      opportunity.publicName,
      opportunity.publicVariant,
      opportunity.publicLocationLabel,
      opportunity.routeCountry,
      opportunity.routeCity,
      opportunity.routeScope,
      opportunity.locationSummary,
      ...(opportunity.countries || []),
      ...(opportunity.cities || []),
      opportunity.publicSummary,
      opportunity.audienceText,
      opportunity.studyStageText,
      opportunity.academicCriteria,
      opportunity.eligibilityText
    ];

    for (const cycle of opportunity.cycles || []) {
      parts.push(
        cycle.applicationDatesText,
        cycle.programmeDatesText,
        cycle.durationText,
        cycle.placesText,
        cycle.audienceText,
        cycle.studyStageText,
        cycle.academicCriteria,
        cycle.eligibilityText,
        cycle.applicationProcessText,
        cycle.assessmentsText,
        cycle.progressionRouteText,
        cycle.programmeStructureText,
        cycle.fundingText,
        cycle.expensesText,
        cycle.travelSupportText,
        cycle.accommodationSupportText,
        cycle.rightToWorkText,
        cycle.disabilitySupportText,
        cycle.additionalDetailsText
      );
    }

    for (const item of opportunity.compensation || []) {
      parts.push(
        item.type,
        item.stage,
        item.status,
        item.amountText,
        item.details
      );
    }

    return normaliseText(
      parts
        .filter(Boolean)
        .join(" ")
    );
  }

  function buildDeadlineSearchText(record) {
    return normaliseText([
      record.publicTitle,
      record.officialName,
      record.providerName,
      record.providerShortName,
      record.opportunityTypeLabel,
      record.opportunityCategory,
      record.careerPathway,
      record.eventTypeLabel,
      record.publicLocationLabel,
      record.routeCountry,
      record.routeCity,
      record.routeScope,
      record.locationSummary,
      ...(record.countries || []),
      ...(record.cities || [])
    ].filter(Boolean).join(" "));
  }

  function matchesSearch(record, query) {
    const needle = normaliseText(query);

    if (!needle) {
      return true;
    }

    const haystack =
      record.searchText ||
      record.opportunity?.searchText ||
      "";

    return haystack.includes(needle);
  }

  /* ========================================================================
     PURE DISPLAY HELPERS
     ======================================================================== */

  function formatApplicationStatus(status) {
    return {
      open: "Applications open",
      upcoming: "Applications upcoming",
      closed: "Applications closed",
      rolling: "Rolling applications",
      available: "Ongoing",
      no_application: "No direct application",
      variable: "Variable / vacancy-led",
      unknown: "Application status not confirmed"
    }[status] || readableLabel(status) || "Application status not confirmed";
  }

  function formatApplicationDateState(state) {
    return {
      exact_deadline: "Exact deadline published",
      dates_not_announced: "Dates not announced",
      always_available: "Ongoing",
      no_fixed_deadline: "No fixed deadline",
      no_application: "No direct application",
      opening_date_only: "Opening date published",
      published_application_information: "Application timing published",
      no_published_application_date: "No published application date"
    }[state] || readableLabel(state);
  }

  function formatDeadlineGroup(group) {
    return {
      today: "Closing today",
      within_7_days: "Closing within 7 days",
      within_30_days: "Closing within 30 days",
      later: "Later deadline",
      passed: "Passed deadline",
      no_exact_deadline: "No exact deadline",
      no_application: "No direct application"
    }[group] || readableLabel(group);
  }

  function providerTypeLabel(providerType) {
    return {
      law_firm: "Law firm",
      barristers_chambers: "Barristers' chambers"
    }[providerType] || readableLabel(providerType) || "Organisation";
  }

  function locationLabel(record) {
    if (record?.publicLocationLabel) {
      return record.publicLocationLabel;
    }

    if (record?.routeCity) {
      return record.routeCountry
        ? `${record.routeCountry} - ${record.routeCity}`
        : record.routeCity;
    }

    if (record?.routeScope) {
      return record.routeScope;
    }

    if (record?.routeCountry) {
      return record.routeCountry;
    }

    if (record?.locationSummary) {
      return record.locationSummary;
    }

    const countries = cleanStringArray(record?.countries);
    const cities = cleanStringArray(record?.cities);

    if (cities.length && countries.length) {
      return [...new Set([...cities, ...countries])].join(", ");
    }

    if (cities.length) {
      return cities.join(", ");
    }

    if (countries.length) {
      return countries.join(", ");
    }

    return "";
  }

  function formatCompensation(item) {
    if (!item) {
      return "";
    }

    if (item.amountText) {
      return item.amountText;
    }

    if (
      item.amount != null &&
      item.currency
    ) {
      const formatted = formatCurrency(
        item.amount,
        item.currency
      );

      if (item.frequency) {
        return `${formatted} ${formatFrequency(item.frequency)}`;
      }

      return formatted;
    }

    if (item.details) {
      return item.details;
    }

    return {
      paid_amount_not_published: "Paid - amount not published",
      amount_not_published: "Amount not published",
      unpaid: "Unpaid",
      not_applicable: "Not applicable",
      variable: "Variable",
      historical_or_unconfirmed: "Historical / unconfirmed",
      unknown: "Not published"
    }[item.status] || "";
  }

  function formatCurrency(amount, currencyCode) {
    const number = Number(amount);

    if (!Number.isFinite(number)) {
      return String(amount ?? "");
    }

    try {
      return new Intl.NumberFormat("en-GB", {
        style: "currency",
        currency: currencyCode,
        maximumFractionDigits:
          Number.isInteger(number) ? 0 : 2
      }).format(number);
    } catch {
      return `${currencyCode} ${number.toLocaleString("en-GB")}`;
    }
  }

  function formatFrequency(frequency) {
    return {
      year: "per year",
      month: "per month",
      week: "per week",
      day: "per day",
      hour: "per hour",
      one_off: "one-off",
      programme: "for the programme"
    }[frequency] || readableLabel(frequency).toLowerCase();
  }

  function formatDate(value, options = {}) {
    const {
      includeWeekday = false,
      month = "short"
    } = options;

    const date = parseDateOnly(value);

    if (!date) {
      return stringValue(value);
    }

    return date.toLocaleDateString("en-GB", {
      ...(includeWeekday ? { weekday: "short" } : {}),
      day: "numeric",
      month,
      year: "numeric"
    });
  }

  function formatShortDeadlineDate(value) {
    const date = parseDateOnly(value);

    if (!date) {
      return {
        day: "",
        month: "",
        year: ""
      };
    }

    return {
      day: date.toLocaleDateString("en-GB", {
        day: "2-digit"
      }),
      month: date.toLocaleDateString("en-GB", {
        month: "short"
      }).toUpperCase(),
      year: date.toLocaleDateString("en-GB", {
        year: "numeric"
      })
    };
  }

  function formatDateRange(start, end, text = "") {
    if (text) {
      return text;
    }

    if (start && end) {
      if (start === end) {
        return formatDate(start);
      }

      return `${formatDate(start)} - ${formatDate(end)}`;
    }

    return formatDate(start || end);
  }

  /*
   * Keep routing in one place.
   *
   * We currently use the existing profile entry points. When Vacatory's
   * generated clean routes are fully switched on, change this helper once
   * rather than changing every consumer.
   */
  function providerProfileUrl(record) {
    const providerId =
      record?.providerId ||
      record?.opportunity?.providerId ||
      "";

    const providerType =
      record?.providerType ||
      record?.opportunity?.providerType ||
      "";

    if (!providerId) {
      return "";
    }

    if (providerType === "barristers_chambers") {
      return `chamber-profile.html?id=${encodeURIComponent(providerId)}`;
    }

    return `firm-profile.html?id=${encodeURIComponent(providerId)}`;
  }

  function opportunityOfficialUrl(record) {
    return safeHttpUrl(
      record?.applicationUrl ||
      record?.officialUrl ||
      record?.opportunity?.applicationUrl ||
      record?.opportunity?.officialUrl
    );
  }

  /* ========================================================================
     GENERIC UTILITIES
     ======================================================================== */

  function applicationStatusRank(status) {
    return {
      open: 0,
      upcoming: 1,
      rolling: 2,
      available: 3,
      variable: 4,
      no_application: 5,
      unknown: 6,
      closed: 7
    }[status] ?? 8;
  }

  function uniqueSorted(values) {
    return [...new Set(
      (values || [])
        .filter(Boolean)
        .map(value => String(value).trim())
        .filter(Boolean)
    )].sort((first, second) => first.localeCompare(second));
  }

  function cleanStringArray(value) {
    if (!Array.isArray(value)) {
      return [];
    }

    return [...new Set(
      value
        .filter(Boolean)
        .map(item => String(item).trim())
        .filter(Boolean)
    )];
  }

  function stringValue(value) {
    if (value == null) {
      return "";
    }

    return String(value).trim();
  }

  function integerOrNull(value) {
    if (value == null || value === "") {
      return null;
    }

    const parsed = Number.parseInt(value, 10);
    return Number.isFinite(parsed) ? parsed : null;
  }

  function integerOrZero(value) {
    return integerOrNull(value) ?? 0;
  }

  function numberOrNull(value) {
    if (value == null || value === "") {
      return null;
    }

    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : null;
  }

  function parseDateOnly(value) {
    if (!value) {
      return null;
    }

    const text = String(value);

    const date = /^\d{4}-\d{2}-\d{2}$/.test(text)
      ? new Date(`${text}T00:00:00`)
      : new Date(text);

    return Number.isNaN(date.getTime())
      ? null
      : date;
  }

  function dateOnlyValue(value) {
    if (!value) {
      return null;
    }

    const text = String(value);

    if (/^\d{4}-\d{2}-\d{2}$/.test(text)) {
      return text;
    }

    const date = parseDateOnly(text);

    if (!date) {
      return null;
    }

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");

    return `${year}-${month}-${day}`;
  }

  function todayDateOnly() {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, "0");
    const day = String(today.getDate()).padStart(2, "0");

    return `${year}-${month}-${day}`;
  }

  function dateValue(value) {
    const date = parseDateOnly(value);

    return date
      ? date.getTime()
      : Number.POSITIVE_INFINITY;
  }

  function normaliseText(value) {
    return String(value || "")
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .toLowerCase()
      .replace(/\s+/g, " ")
      .trim();
  }

  function readableLabel(value) {
    return String(value || "")
      .replace(/[_-]+/g, " ")
      .replace(/\s+/g, " ")
      .trim()
      .replace(/\b\w/g, character => character.toUpperCase());
  }

  function safeHttpUrl(value) {
    if (!value) {
      return "";
    }

    try {
      const url = new URL(value);

      return ["http:", "https:"].includes(url.protocol)
        ? url.href
        : "";
    } catch {
      return "";
    }
  }

  function escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  /* ========================================================================
     PUBLIC NAMESPACE
     ======================================================================== */

  window.VacatoryOpportunityData = Object.freeze({
    PUBLIC_VIEW,
    OCCURRENCES_VIEW,

    loadOpportunities,
    loadProviderOpportunities,
    loadOngoingOnlineOpportunities,
    loadEventOccurrences,
    loadDeadlineRecords,
    loadDeadlineDetails,
    clearCache,

    buildApplicationTimingRecords,

    getFilterOptions,
    opportunitiesForProvider,
    matchesSearch,

    formatApplicationStatus,
    formatApplicationDateState,
    formatDeadlineGroup,
    providerTypeLabel,
    locationLabel,
    formatCompensation,
    formatCurrency,
    formatDate,
    formatShortDeadlineDate,
    formatDateRange,
    todayDateOnly,

    providerProfileUrl,
    opportunityOfficialUrl,

    normaliseText,
    readableLabel,
    safeHttpUrl,
    escapeHtml
  });
})();
