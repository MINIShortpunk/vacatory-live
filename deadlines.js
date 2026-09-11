/*
 * Vacatory
 * deadlines.js
 *
 * Canonical Deadlines page controller.
 *
 * DATA RULE:
 * This page consumes window.VacatoryOpportunityData only.
 * The initial list uses the shared lean canonical occurrence projection.
 * Heavy application detail is fetched through the same shared data layer only
 * when a user opens a deadline.
 * It does not query or merge legacy opportunity tables/views.
 */

(() => {
  "use strict";

  const SHARED_MODULE_SRC =
    "opportunity-data.js?v=canonical-20260817-deadlines";

  const state = {
    deadlines: [],
    deadlinesByKey: new Map(),
    filters: {
      search: "",
      type: "",
      provider: "",
      country: "",
      location: ""
    }
  };

  const elements = {};

  document.addEventListener("DOMContentLoaded", initialiseDeadlinesPage);

  async function initialiseDeadlinesPage() {
    cacheElements();
    bindControls();
    setLoadingState();

    try {
      const data = await ensureSharedOpportunityModule();

      if (typeof client === "undefined") {
        throw new Error("The Supabase client is unavailable.");
      }

      const [exactDeadlines, ongoingOpportunities] = await Promise.all([
        data.loadDeadlineRecords({
          client,
          includePassed: false
        }),
        data.loadOngoingOnlineOpportunities({
          client,
          includeSearchIndex: true
        })
      ]);

      const ongoingRecords = data
        .buildApplicationTimingRecords(ongoingOpportunities)
        .filter(record =>
          record.publicApplicationDateState === "always_available"
        )
        .map(record => ({
          ...record,
          recordKind: "ongoing"
        }));

      state.deadlines = [
        ...exactDeadlines.map(record => ({
          ...record,
          recordKind: "deadline"
        })),
        ...ongoingRecords
      ];

      state.deadlinesByKey = new Map(
        exactDeadlines.map(record => [
          record.deadlineRecordKey,
          record
        ])
      );

      populateFilterOptions();
      applyFiltersAndRender();
    } catch (error) {
      console.error("Unable to load canonical deadlines:", error);
      showErrorState();
    }
  }

  /* ======================================================================
     SHARED MODULE
     ====================================================================== */

  async function ensureSharedOpportunityModule() {
    if (window.VacatoryOpportunityData) {
      return window.VacatoryOpportunityData;
    }

    await loadScriptOnce(
      SHARED_MODULE_SRC,
      "vacatoryOpportunityDataScript"
    );

    if (!window.VacatoryOpportunityData) {
      throw new Error(
        "The shared Vacatory opportunity data layer did not load."
      );
    }

    return window.VacatoryOpportunityData;
  }

  function loadScriptOnce(src, id) {
    return new Promise((resolve, reject) => {
      const existing = document.getElementById(id);

      if (existing) {
        if (window.VacatoryOpportunityData) {
          resolve();
          return;
        }

        existing.addEventListener("load", resolve, { once: true });
        existing.addEventListener(
          "error",
          () => reject(new Error(`Unable to load ${src}`)),
          { once: true }
        );
        return;
      }

      const script = document.createElement("script");
      script.id = id;
      script.src = src;
      script.defer = true;

      script.addEventListener("load", resolve, { once: true });
      script.addEventListener(
        "error",
        () => reject(new Error(`Unable to load ${src}`)),
        { once: true }
      );

      document.head.appendChild(script);
    });
  }

  /* ======================================================================
     CANONICAL FILTER SHELL + CONTROLS
     ====================================================================== */

  function cacheElements() {
    elements.search =
      document.getElementById("deadlineSearch");

    elements.type =
      document.getElementById("deadlineType");

    elements.provider =
      document.getElementById("deadlineProvider");

    elements.country =
      document.getElementById("deadlineCountry");

    elements.location =
      document.getElementById("deadlineLocation");

    elements.reset =
      document.getElementById("deadlineReset");

    elements.count =
      document.getElementById("deadlineCount");

    elements.loading =
      document.getElementById("deadlinesLoading");

    elements.error =
      document.getElementById("deadlinesError");

    elements.empty =
      document.getElementById("deadlinesEmpty");

    elements.list =
      document.getElementById("deadlinesList");
  }

  function bindControls() {
    elements.search?.addEventListener(
      "input",
      debounce(applyFiltersAndRender, 100)
    );

    elements.type?.addEventListener(
      "change",
      applyFiltersAndRender
    );

    elements.provider?.addEventListener(
      "change",
      applyFiltersAndRender
    );

    elements.country?.addEventListener(
      "change",
      applyFiltersAndRender
    );

    elements.location?.addEventListener(
      "change",
      applyFiltersAndRender
    );

    elements.reset?.addEventListener(
      "click",
      resetFilters
    );

    elements.list?.addEventListener(
      "click",
      handleListClick
    );

    elements.list?.addEventListener(
      "toggle",
      handleDeadlineToggle,
      true
    );
  }

  function handleListClick(event) {
    const retry = event.target.closest("[data-deadline-detail-retry]");

    if (retry) {
      const key = retry.dataset.deadlineDetailRetry || "";
      const record = state.deadlinesByKey.get(key);
      const details = retry.closest("details[data-deadline-record-key]");

      if (record && details) {
        loadDeadlineRecordDetails(record, details, true);
      }

      return;
    }

    const button =
      event.target.closest("[data-scroll-target]");

    if (!button) {
      return;
    }

    const target =
      document.getElementById(button.dataset.scrollTarget);

    target?.scrollIntoView({
      behavior: "smooth",
      block: "start"
    });
  }

  function handleDeadlineToggle(event) {
    const details = event.target;

    if (
      !(details instanceof HTMLDetailsElement) ||
      !details.open ||
      !details.matches("details[data-deadline-record-key]")
    ) {
      return;
    }

    const key = details.dataset.deadlineRecordKey || "";
    const record = state.deadlinesByKey.get(key);

    if (!record || record.detailLoaded || record.detailLoading) {
      return;
    }

    loadDeadlineRecordDetails(record, details);
  }

  async function loadDeadlineRecordDetails(
    record,
    details,
    forceReload = false
  ) {
    const data = getData();
    const body = details.querySelector("[data-deadline-detail-body]");

    if (!body) {
      return;
    }

    record.detailLoading = true;
    record.detailError = "";

    body.innerHTML = `
      <p class="deadline-detail-loading" role="status">
        Loading application details…
      </p>
    `;

    try {
      const detail = await data.loadDeadlineDetails({
        client,
        sourceOpportunityId: record.sourceOpportunityId,
        deadlineKey: record.deadlineKey,
        forceReload
      });

      record.cycles = detail.cycles;
      record.programmeOccurrences =
        detail.programmeOccurrences.length
          ? detail.programmeOccurrences
          : record.programmeOccurrences;
      record.compensation = detail.compensation;
      record.primaryCompensation = detail.primaryCompensation;
      record.detailLoaded = true;
      record.detailLoading = false;

      const officialUrl = data.opportunityOfficialUrl(record);
      body.innerHTML = renderExactDeadlineDetails(record, officialUrl);
    } catch (error) {
      console.error(
        "Unable to load canonical deadline details:",
        error
      );

      record.detailLoading = false;
      record.detailError = String(error?.message || error || "");

      body.innerHTML = `
        <div class="deadline-detail-error" role="alert">
          <p>Unable to load the detailed application information right now.</p>
          <button
            type="button"
            class="deadline-detail-retry"
            data-deadline-detail-retry="${escapeHtml(record.deadlineRecordKey)}"
          >
            Try again
          </button>
        </div>
      `;
    }
  }

  function readFilters() {
    state.filters.search =
      elements.search?.value.trim() || "";

    state.filters.type =
      elements.type?.value || "";

    state.filters.provider =
      elements.provider?.value || "";

    state.filters.country =
      elements.country?.value || "";

    state.filters.location =
      elements.location?.value || "";
  }

  function resetFilters() {
    [
      elements.search,
      elements.type,
      elements.provider,
      elements.country,
      elements.location
    ].forEach(element => {
      if (element) {
        element.value = "";
      }
    });

    applyFiltersAndRender();
    elements.search?.focus();
  }

  /* ======================================================================
     FILTER OPTIONS
     ====================================================================== */

  function populateFilterOptions() {
    populateTypeOptions();
    populateProviderOptions();
    populateCountryOptions();
    populateLocationOptions();
  }

  function populateTypeOptions() {
    replaceSelectOptions(
      elements.type,
      "All opportunity types",
      uniqueSorted(
        state.deadlines.map(
          opportunity => opportunity.opportunityTypeLabel
        )
      )
    );
  }

  function populateProviderOptions() {
    replaceSelectOptions(
      elements.provider,
      "All providers",
      uniqueSorted(
        state.deadlines.map(
          opportunity => opportunity.providerName
        )
      )
    );
  }

  function populateCountryOptions() {
    replaceSelectOptions(
      elements.country,
      "All countries",
      uniqueSorted(
        state.deadlines.flatMap(
          opportunity => recordCountries(opportunity)
        )
      )
    );
  }

  function populateLocationOptions() {
    replaceSelectOptions(
      elements.location,
      "All cities and scopes",
      uniqueSorted(
        state.deadlines
          .map(recordCityOrScope)
          .filter(Boolean)
      )
    );
  }

  function replaceSelectOptions(select, emptyLabel, values) {
    if (!select) {
      return;
    }

    const current = select.value;
    select.replaceChildren();

    const emptyOption = document.createElement("option");
    emptyOption.value = "";
    emptyOption.textContent = emptyLabel;
    select.appendChild(emptyOption);

    for (const value of values) {
      const option = document.createElement("option");
      option.value = value;
      option.textContent = value;
      select.appendChild(option);
    }

    if (values.includes(current)) {
      select.value = current;
    }
  }

  function recordCountries(record) {
    if (record?.routeCountry) {
      return [record.routeCountry];
    }

    return uniqueSorted(record?.countries || []);
  }

  function recordCityOrScope(record) {
    if (record?.routeCity) {
      return record.routeCity;
    }

    if (record?.routeScope) {
      return record.routeScope;
    }

    if (record?.cities?.length === 1) {
      return record.cities[0];
    }

    if (record?.locationSummary === "Virtual") {
      return "Virtual";
    }

    return "";
  }

  /* ======================================================================
     FILTERING + RENDER
     ====================================================================== */

  function applyFiltersAndRender() {
    if (!window.VacatoryOpportunityData) {
      return;
    }

    readFilters();

    const filteredDeadlines =
      state.deadlines.filter(matchesDeadlineFilters);

    renderResults(filteredDeadlines);
  }

  function matchesDeadlineFilters(record) {
    const data = getData();

    if (
      state.filters.search &&
      !data.matchesSearch(
        record,
        state.filters.search
      )
    ) {
      return false;
    }

    if (
      state.filters.type &&
      record.opportunityTypeLabel !==
        state.filters.type
    ) {
      return false;
    }

    if (
      state.filters.provider &&
      record.providerName !==
        state.filters.provider
    ) {
      return false;
    }

    if (
      state.filters.country &&
      !recordCountries(record).includes(
        state.filters.country
      )
    ) {
      return false;
    }

    if (
      state.filters.location &&
      recordCityOrScope(record) !==
        state.filters.location
    ) {
      return false;
    }

    return true;
  }

  function renderResults(deadlines) {
    if (!elements.list || !elements.count) {
      return;
    }

    elements.count.textContent = resultCountText(deadlines);

    elements.loading?.classList.add("hidden");
    elements.error?.classList.add("hidden");

    if (!deadlines.length) {
      elements.list.replaceChildren();
      elements.empty?.classList.remove("hidden");
      return;
    }

    elements.empty?.classList.add("hidden");

    const exactDeadlines = deadlines.filter(
      record => record.recordKind !== "ongoing"
    );
    const ongoingOpportunities = deadlines.filter(
      record => record.recordKind === "ongoing"
    );

    elements.list.innerHTML = [
      renderExactDeadlineSections(exactDeadlines),
      renderOngoingOpportunitySection(ongoingOpportunities)
    ].join("");
  }

  function resultCountText(records) {
    const deadlineCount = records.filter(
      record => record.recordKind !== "ongoing"
    ).length;
    const ongoingCount = records.length - deadlineCount;

    return [
      `${deadlineCount} ${pluralise(deadlineCount, "deadline", "deadlines")}`,
      `${ongoingCount} ongoing ${pluralise(ongoingCount, "opportunity", "opportunities")}`
    ].join(" · ");
  }

  /* ======================================================================
     EXACT DEADLINES
     ====================================================================== */

  function renderExactDeadlineSections(records) {
    if (!records.length) {
      return "";
    }

    return `
      <div
        class="deadline-list-canonical"
        role="region"
        aria-label="Exact application deadlines in date order"
      >
        ${records.map(renderDeadlineCard).join("")}
      </div>
    `;
  }

  function renderOngoingOpportunitySection(records) {
    if (!records.length) {
      return "";
    }

    return `
      <section
        class="deadline-ongoing-section"
        aria-labelledby="ongoing-opportunities-title"
      >
        <div class="section-heading-row">
          <div>
            <h2 id="ongoing-opportunities-title">Ongoing online opportunities</h2>
            <p class="section-subtitle">
              Free or open-access online opportunities with no fixed closing date.
            </p>
          </div>
        </div>

        <div
          class="deadline-list-canonical"
          role="region"
          aria-label="Ongoing online opportunities"
        >
          ${records.map(renderOngoingOpportunityCard).join("")}
        </div>
      </section>
    `;
  }

  function renderOngoingOpportunityCard(record) {
    const data = getData();
    const providerUrl = data.providerProfileUrl(record);
    const location = data.locationLabel(record);
    const officialUrl = data.opportunityOfficialUrl(record);

    return `
      <article class="deadline-card deadline-card-canonical">
        <div class="deadline-card-date" aria-label="Ongoing">
          <span class="deadline-date-day" aria-hidden="true">∞</span>
          <span class="deadline-date-month">ONGOING</span>
        </div>

        <div class="deadline-card-main">
          <div class="deadline-card-topline">
            <span class="deadline-provider-type">
              ${escapeHtml(data.providerTypeLabel(record.providerType))}
            </span>
          </div>

          <p class="deadline-provider-name">
            ${
              providerUrl
                ? `<a href="${escapeHtml(providerUrl)}">${escapeHtml(record.providerName)}</a>`
                : escapeHtml(record.providerName)
            }
          </p>

          <h5 class="deadline-opportunity-title">
            ${escapeHtml(record.publicTitle)}
          </h5>

          <div class="deadline-meta-row">
            ${metaChip(record.opportunityTypeLabel)}
            ${metaChip(location)}
            ${metaChip("Online")}
          </div>

          <p class="deadline-closing-copy">
            <strong>Availability:</strong>
            Ongoing — complete online at any time.
          </p>

          ${renderActionLinks(record, officialUrl)}
        </div>
      </article>
    `;
  }

  function renderDeadlineCard(record) {
    const data = getData();
    const dateParts =
      data.formatShortDeadlineDate(
        record.closesOn
      );

    const providerUrl =
      data.providerProfileUrl(record);

    const location =
      data.locationLabel(record);

    const detailId =
      `deadline-${safeId(record.deadlineRecordKey || record.deadlineKey)}`;

    const programmeCount =
      record.programmeOccurrences.length;

    return `
      <article class="deadline-card deadline-card-canonical">
        <div class="deadline-card-date" aria-label="${escapeHtml(data.formatDate(record.closesOn))}">
          <span class="deadline-date-day">${escapeHtml(dateParts.day)}</span>
          <span class="deadline-date-month">${escapeHtml(dateParts.month)}</span>
          <span class="deadline-date-year">${escapeHtml(dateParts.year)}</span>
        </div>

        <div class="deadline-card-main">
          <div class="deadline-card-topline">
            <span class="deadline-provider-type">
              ${escapeHtml(data.providerTypeLabel(record.providerType))}
            </span>
          </div>

          <p class="deadline-provider-name">
            ${
              providerUrl
                ? `<a href="${escapeHtml(providerUrl)}">${escapeHtml(record.providerName)}</a>`
                : escapeHtml(record.providerName)
            }
          </p>

          <h5 class="deadline-opportunity-title">
            ${escapeHtml(record.publicTitle)}
          </h5>

          <div class="deadline-meta-row">
            ${metaChip(record.opportunityTypeLabel)}
            ${metaChip(location)}
            ${
              programmeCount > 1
                ? metaChip(
                    `${programmeCount} programme options`
                  )
                : ""
            }
            ${
              record.mayCloseEarly
                ? metaChip("May close early")
                : ""
            }
          </div>

          <p class="deadline-closing-copy">
            <strong>Applications close:</strong>
            ${escapeHtml(data.formatDate(record.closesOn))}
            ${renderDeadlineTime(record)}
          </p>

          <details
            id="${escapeHtml(detailId)}"
            class="deadline-details"
            data-deadline-record-key="${escapeHtml(record.deadlineRecordKey)}"
          >
            <summary>View details</summary>
            <div
              class="deadline-detail-body"
              data-deadline-detail-body
              aria-live="polite"
            >
              <p class="deadline-detail-prompt">
                Detailed application information loads when you open this section.
              </p>
            </div>
          </details>
        </div>
      </article>
    `;
  }

  function renderDeadlineTime(record) {
    if (!record.closesAt) {
      return "";
    }

    const timezone =
      record.closesTimezone
        ? ` ${record.closesTimezone}`
        : "";

    return ` at ${escapeHtml(record.closesAt)}${escapeHtml(timezone)}`;
  }

  function renderExactDeadlineDetails(record, officialUrl) {
    const data = getData();
    const cycles = record.cycles || [];

    const first = cycles[0] || {};

    const applicationDates =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.applicationDatesText
        )
      );

    const audience =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.audienceText
        )
      );

    const studyStage =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.studyStageText
        )
      );

    const academic =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.academicCriteria
        )
      );

    const eligibility =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.eligibilityText
        )
      );

    const process =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.applicationProcessText
        )
      );

    const assessments =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.assessmentsText
        )
      );

    const progression =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.progressionRouteText
        )
      );

    const funding =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.fundingText
        )
      );

    const expenses =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.expensesText
        )
      );

    const travel =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.travelSupportText
        )
      );

    const accommodation =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.accommodationSupportText
        )
      );

    const rightToWork =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.rightToWorkText
        )
      );

    const disability =
      uniqueNonEmpty(
        cycles.map(cycle =>
          cycle.disabilitySupportText
        )
      );

    return `
      <div class="deadline-details-grid">
        <section class="deadline-detail-section">
          <h6>Application</h6>
          <dl class="deadline-detail-list">
            ${detailItem(
              "Opens",
              first.opensOn
                ? data.formatDate(first.opensOn)
                : ""
            )}
            ${detailItem(
              "Closes",
              data.formatDate(record.closesOn)
            )}
            ${detailItem(
              "Application timing",
              applicationDates.join(" | ")
            )}
            ${detailItem(
              "Status",
              data.formatApplicationStatus(
                record.publicApplicationStatus
              )
            )}
          </dl>
        </section>

        ${renderProgrammeOccurrences(record)}

        ${
          audience.length ||
          studyStage.length ||
          academic.length ||
          eligibility.length
            ? `
              <section class="deadline-detail-section">
                <h6>Eligibility</h6>
                <dl class="deadline-detail-list">
                  ${detailItem("Audience", audience.join(" | "))}
                  ${detailItem("Study stage", studyStage.join(" | "))}
                  ${detailItem("Academic criteria", academic.join(" | "))}
                  ${detailItem("Eligibility", eligibility.join(" | "))}
                </dl>
              </section>
            `
            : ""
        }

        ${
          process.length ||
          assessments.length ||
          progression.length
            ? `
              <section class="deadline-detail-section">
                <h6>Application process</h6>
                <dl class="deadline-detail-list">
                  ${detailItem("Process", process.join(" | "))}
                  ${detailItem("Assessments", assessments.join(" | "))}
                  ${detailItem("Progression", progression.join(" | "))}
                </dl>
              </section>
            `
            : ""
        }

        ${renderCompensation(record)}

        ${
          funding.length ||
          expenses.length ||
          travel.length ||
          accommodation.length ||
          rightToWork.length ||
          disability.length
            ? `
              <section class="deadline-detail-section">
                <h6>Funding and support</h6>
                <dl class="deadline-detail-list">
                  ${detailItem("Funding", funding.join(" | "))}
                  ${detailItem("Expenses", expenses.join(" | "))}
                  ${detailItem("Travel", travel.join(" | "))}
                  ${detailItem("Accommodation", accommodation.join(" | "))}
                  ${detailItem("Right to work / visa", rightToWork.join(" | "))}
                  ${detailItem("Disability support", disability.join(" | "))}
                </dl>
              </section>
            `
            : ""
        }
      </div>

      ${renderActionLinks(record, officialUrl)}
    `;
  }

  function renderProgrammeOccurrences(record) {
    const data = getData();
    const occurrences =
      record.programmeOccurrences || [];

    if (!occurrences.length) {
      return "";
    }

    return `
      <section class="deadline-detail-section">
        <h6>
          ${
            occurrences.length > 1
              ? "Programme options"
              : "Programme"
          }
        </h6>

        <ul class="deadline-programme-list">
          ${occurrences
            .map(occurrence => {
              const date =
                data.formatDateRange(
                  occurrence.programmeStartsOn,
                  occurrence.programmeEndsOn,
                  occurrence.programmeDatesText
                ) || "Programme dates not published";

              const extras = [
                occurrence.durationText,
                occurrence.placesText
              ].filter(Boolean);

              return `
                <li>
                  <strong>${escapeHtml(date)}</strong>
                  ${
                    extras.length
                      ? `<span>${escapeHtml(extras.join(" - "))}</span>`
                      : ""
                  }
                </li>
              `;
            })
            .join("")}
        </ul>
      </section>
    `;
  }

  function renderCompensation(record) {
    const data = getData();

    const items =
      record.compensation || [];

    if (!items.length) {
      return "";
    }

    const rows = items
      .map(item => {
        const value =
          data.formatCompensation(item);

        if (!value) {
          return "";
        }

        const label =
          [
            item.type
              ? data.readableLabel(item.type)
              : "Compensation",
            item.stage
              ? data.readableLabel(item.stage)
              : ""
          ]
            .filter(Boolean)
            .join(" - ");

        return detailItem(label, value);
      })
      .filter(Boolean)
      .join("");

    if (!rows) {
      return "";
    }

    return `
      <section class="deadline-detail-section">
        <h6>Pay and funding</h6>
        <dl class="deadline-detail-list">
          ${rows}
        </dl>
      </section>
    `;
  }

  function renderActionLinks(record, officialUrl) {
    const data = getData();

    const providerUrl =
      data.providerProfileUrl(record);

    const links = [];

    if (providerUrl) {
      links.push(`
        <a class="deadline-action-link" href="${escapeHtml(providerUrl)}">
          View ${escapeHtml(record.providerName)} profile
        </a>
      `);
    }

    if (officialUrl) {
      links.push(`
        <a
          class="deadline-action-link deadline-action-link-primary"
          href="${escapeHtml(officialUrl)}"
          target="_blank"
          rel="noopener noreferrer"
          aria-label="Open official page for ${escapeHtml(record.publicTitle)} in a new tab"
        >
          Official opportunity page
          <span aria-hidden="true">↗</span>
        </a>
      `);
    }

    if (!links.length) {
      return "";
    }

    return `
      <div class="deadline-actions">
        ${links.join("")}
      </div>
    `;
  }

  /* ======================================================================
     SMALL RENDER HELPERS
     ====================================================================== */

  function metaChip(value) {
    if (!value) {
      return "";
    }

    return `
      <span class="deadline-meta-chip">
        ${escapeHtml(value)}
      </span>
    `;
  }

  function detailItem(label, value) {
    if (!value) {
      return "";
    }

    return `
      <div class="deadline-detail-row">
        <dt>${escapeHtml(label)}</dt>
        <dd>${escapeHtml(value)}</dd>
      </div>
    `;
  }

  function uniqueNonEmpty(values) {
    return [
      ...new Set(
        (values || [])
          .map(value =>
            String(value || "").trim()
          )
          .filter(Boolean)
      )
    ];
  }

  function uniqueSorted(values) {
    return [...new Set(values.filter(Boolean))]
      .sort((a, b) =>
        String(a).localeCompare(String(b))
      );
  }

  function safeId(value) {
    return String(value || "")
      .replace(/[^a-zA-Z0-9_-]/g, "-");
  }

  function pluralise(number, singular, plural) {
    return number === 1 ? singular : plural;
  }

  function setText(element, value) {
    if (element) {
      element.textContent = String(value);
    }
  }

  function getData() {
    return window.VacatoryOpportunityData;
  }

  function escapeHtml(value) {
    const data = getData();

    if (data?.escapeHtml) {
      return data.escapeHtml(value);
    }

    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function debounce(fn, delay = 120) {
    let timer;

    return (...args) => {
      window.clearTimeout(timer);
      timer = window.setTimeout(
        () => fn(...args),
        delay
      );
    };
  }

  /* ======================================================================
     STATES
     ====================================================================== */

  function setLoadingState() {
    elements.loading?.classList.remove("hidden");
    elements.error?.classList.add("hidden");
    elements.empty?.classList.add("hidden");

    if (elements.list) {
      elements.list.replaceChildren();
    }

    if (elements.count) {
      elements.count.textContent =
        "Loading application deadlines...";
    }
  }

  function showErrorState() {
    elements.loading?.classList.add("hidden");
    elements.empty?.classList.add("hidden");
    elements.error?.classList.remove("hidden");

    if (elements.list) {
      elements.list.replaceChildren();
    }

    if (elements.count) {
      elements.count.textContent =
        "Application deadlines could not be loaded.";
    }
  }
})();
