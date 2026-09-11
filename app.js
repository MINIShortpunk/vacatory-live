window.__vacatoryHomepageAppLoaded = "search-results-page-v1";

// =======================================
// Vacatory
// app.js: public homepage
// =======================================

let firms = [];

let practiceAreasByFirm = new Map();
let rolesByFirm = new Map();
let searchTermsByFirm = new Map();

let homepageSearchResults = null;
let currentFilteredFirms = [];

document.addEventListener("DOMContentLoaded", () => {
  createHomepageSearchResults();
  bindHomepageControls();
  void initialiseHomepage();
});

async function initialiseHomepage() {
  await Promise.all([
    loadFirms(),
    loadHomepageChambers(),
    loadUpcomingDeadlines()
  ]);
}

/* =======================================
   Homepage controls
======================================= */

function bindHomepageControls() {
  const searchInput =
    document.getElementById("searchInput");

  const filterPracticeArea =
    document.getElementById("filterPracticeArea");

  const filterRole =
    document.getElementById("filterRole");

  const filterFirmType =
    document.getElementById("filterFirmType");

  const filterReset =
    document.getElementById("filterReset");

  searchInput?.addEventListener(
    "input",
    debounce(() => {
      const filtered = applyFilters();
      renderHomepageSearchResults(filtered);
    }, 120)
  );

  searchInput?.addEventListener(
    "focus",
    () => {
      const query = normalizeText(searchInput.value);

      if (query) {
        renderHomepageSearchResults(
          currentFilteredFirms
        );
      }
    }
  );

  filterPracticeArea?.addEventListener(
    "change",
    applyFilters
  );

  filterRole?.addEventListener(
    "change",
    applyFilters
  );

  filterFirmType?.addEventListener(
    "change",
    applyFilters
  );

  filterReset?.addEventListener(
    "click",
    resetFilters
  );

  searchInput?.addEventListener(
    "keydown",
    event => {
      if (event.key === "Escape") {
        hideHomepageSearchResults();
        searchInput.blur();
        return;
      }

      if (event.key !== "Enter") {
        return;
      }

      event.preventDefault();

      const filtered = applyFilters();

      const query =
        searchInput.value.trim();

      if (!query) {
        return;
      }

      window.location.href =
        `search-results.html?q=${
          encodeURIComponent(query)
        }`;
    }
  );

  document.addEventListener(
    "click",
    event => {
      const searchBox =
        document.getElementById("firm-search");

      if (
        searchBox &&
        !searchBox.contains(event.target)
      ) {
        hideHomepageSearchResults();
      }
    }
  );
}

/* =======================================
   Firms
======================================= */

async function loadFirms() {
  const container =
    document.getElementById("firms");

  const count =
    document.getElementById("firmCount");

  if (!container) {
    return;
  }

  setFirmLoadingState(container, count);

  if (typeof client === "undefined") {
    showFirmLoadError(
      container,
      count,
      "The database connection is not available."
    );

    return;
  }

  const { data, error } = await client
    .from("firms")
    .select(`
      id,
      name,
      short_name,
      slug,
      uk_rank,
      firm_type,
      circle_classification,
      head_office,
      head_office_city,
      head_office_country,
      active
    `)
    .eq("active", true)
    .order("uk_rank", {
      ascending: true,
      nullsFirst: false
    })
    .order("name", {
      ascending: true
    });

  if (error) {
    console.error(
      "Unable to load firms:",
      error
    );

    showFirmLoadError(
      container,
      count,
      "Unable to load firms at the moment."
    );

    return;
  }

  firms = data || [];

  displayFirms(firms);

  await loadDirectoryData();

  populateFilterOptions();

  const filtered =
    applyFilters();

  const searchInput =
    document.getElementById("searchInput");

  if (
    searchInput &&
    normalizeText(searchInput.value)
  ) {
    renderHomepageSearchResults(filtered);
  }
}

async function loadDirectoryData() {
  const firmIds =
    firms.map(firm => firm.id);

  practiceAreasByFirm = new Map();
  rolesByFirm = new Map();
  searchTermsByFirm = new Map();

  if (!firmIds.length) {
    return;
  }

  firmIds.forEach(firmId => {
    searchTermsByFirm.set(
      firmId,
      new Set()
    );
  });

  const results =
    await Promise.allSettled([
      client
        .from("practice_areas")
        .select(`
          firm_id,
          practice_area
        `)
        .in("firm_id", firmIds),

      client
        .from("firm_roles_public_view")
        .select(`
          firm_id,
          role_name,
          role_group,
          student_relevance,
          confirmed,
          active
        `)
        .in("firm_id", firmIds)
        .eq("active", true)
        .eq("confirmed", true),

      client
        .from("locations")
        .select(`
          firm_id,
          city,
          country
        `)
        .in("firm_id", firmIds)
        .eq("active", true),

      client
        .from("opportunity_cards_view")
        .select(`
          firm_id,
          opportunity_name,
          opportunity_type_label,
          location_summary
        `)
        .in("firm_id", firmIds),

      client
        .from("training_contract_cards_view")
        .select(`
          firm_id,
          programme_name,
          programme_type_label,
          location_summary
        `)
        .in("firm_id", firmIds)
        .eq("active", true)
    ]);

  const [
    practiceRows,
    roleRows,
    locationRows,
    opportunityRows,
    trainingRows
  ] = results.map(getSettledQueryRows);

  addPracticeAreaData(practiceRows);
  addRoleData(roleRows);
  addLocationSearchData(locationRows);
  addOpportunitySearchData(opportunityRows);
  addTrainingContractSearchData(trainingRows);
}

function getSettledQueryRows(result) {
  if (result.status === "rejected") {
    console.warn(
      "Homepage supporting query failed:",
      result.reason
    );

    return [];
  }

  if (result.value?.error) {
    console.warn(
      "Homepage supporting query failed:",
      result.value.error
    );

    return [];
  }

  return result.value?.data || [];
}

function addPracticeAreaData(rows) {
  rows.forEach(row => {
    if (
      !row.firm_id ||
      !row.practice_area
    ) {
      return;
    }

    addToMapSet(
      practiceAreasByFirm,
      row.firm_id,
      row.practice_area
    );

    addSearchTerm(
      row.firm_id,
      row.practice_area
    );
  });
}

function addRoleData(rows) {
  const usefulRoleGroups = new Set([
    "entry_route",
    "legal_role",
    "knowledge_innovation",
    "business_services",
    "qualification_status",
    "programme"
  ]);

  rows.forEach(row => {
    if (
      !row.firm_id ||
      !row.role_name
    ) {
      return;
    }

    const usefulForStudents =
      usefulRoleGroups.has(row.role_group) ||
      [
        "primary",
        "strong",
        "context"
      ].includes(row.student_relevance);

    if (usefulForStudents) {
      addToMapSet(
        rolesByFirm,
        row.firm_id,
        row.role_name
      );
    }

    addSearchTerm(
      row.firm_id,
      row.role_name
    );
  });
}

function addLocationSearchData(rows) {
  rows.forEach(row => {
    if (!row.firm_id) {
      return;
    }

    addSearchTerm(
      row.firm_id,
      row.city
    );

    addSearchTerm(
      row.firm_id,
      row.country
    );
  });
}

function addOpportunitySearchData(rows) {
  rows.forEach(row => {
    if (!row.firm_id) {
      return;
    }

    addSearchTerm(
      row.firm_id,
      row.opportunity_name
    );

    addSearchTerm(
      row.firm_id,
      row.opportunity_type_label
    );

    addSearchTerm(
      row.firm_id,
      row.location_summary
    );
  });
}

function addTrainingContractSearchData(rows) {
  rows.forEach(row => {
    if (!row.firm_id) {
      return;
    }

    addSearchTerm(
      row.firm_id,
      row.programme_name
    );

    addSearchTerm(
      row.firm_id,
      row.programme_type_label
    );

    addSearchTerm(
      row.firm_id,
      row.location_summary
    );
  });
}

function addToMapSet(map, key, value) {
  if (!value) {
    return;
  }

  if (!map.has(key)) {
    map.set(
      key,
      new Set()
    );
  }

  map.get(key).add(value);
}

function addSearchTerm(firmId, value) {
  if (
    !firmId ||
    !value
  ) {
    return;
  }

  if (!searchTermsByFirm.has(firmId)) {
    searchTermsByFirm.set(
      firmId,
      new Set()
    );
  }

  searchTermsByFirm
    .get(firmId)
    .add(String(value));
}

/* =======================================
   Firm filters
======================================= */

function populateFilterOptions() {
  const allPracticeAreas =
    new Set();

  const allRoles =
    new Set();

  const allFirmTypes =
    new Set();

  practiceAreasByFirm.forEach(values => {
    values.forEach(value => {
      allPracticeAreas.add(value);
    });
  });

  rolesByFirm.forEach(values => {
    values.forEach(value => {
      allRoles.add(value);
    });
  });

  firms.forEach(firm => {
    if (firm.firm_type) {
      allFirmTypes.add(
        firm.firm_type
      );
    }
  });

  fillSelect(
    "filterPracticeArea",
    allPracticeAreas,
    "All practice areas"
  );

  fillSelect(
    "filterRole",
    allRoles,
    "All roles"
  );

  fillSelect(
    "filterFirmType",
    allFirmTypes,
    "All firm types"
  );
}

function fillSelect(
  id,
  valuesSet,
  placeholderText
) {
  const select =
    document.getElementById(id);

  if (!select) {
    return;
  }

  const currentValue =
    select.value;

  const fragment =
    document.createDocumentFragment();

  const placeholder =
    document.createElement("option");

  placeholder.value = "";
  placeholder.textContent =
    placeholderText;

  fragment.appendChild(
    placeholder
  );

  Array.from(valuesSet)
    .filter(Boolean)
    .sort((a, b) => {
      return a.localeCompare(
        b,
        "en-GB"
      );
    })
    .forEach(value => {
      const option =
        document.createElement("option");

      option.value = value;
      option.textContent = value;

      fragment.appendChild(
        option
      );
    });

  select.replaceChildren(
    fragment
  );

  const valueStillExists =
    Array.from(select.options)
      .some(option => {
        return option.value ===
          currentValue;
      });

  if (valueStillExists) {
    select.value =
      currentValue;
  }
}

function applyFilters() {
  const search =
    normalizeText(
      document
        .getElementById("searchInput")
        ?.value || ""
    );

  const practiceArea =
    document
      .getElementById("filterPracticeArea")
      ?.value || "";

  const role =
    document
      .getElementById("filterRole")
      ?.value || "";

  const firmType =
    document
      .getElementById("filterFirmType")
      ?.value || "";

  const filterReset =
    document.getElementById(
      "filterReset"
    );

  const filtered =
    firms.filter(firm => {
      const firmPracticeAreas =
        practiceAreasByFirm.get(firm.id) ||
        new Set();

      const firmRoles =
        rolesByFirm.get(firm.id) ||
        new Set();

      const extraTerms =
        searchTermsByFirm.get(firm.id) ||
        new Set();

      const searchableText =
        normalizeText(
          [
            firm.name,
            firm.short_name,
            firm.firm_type,
            firm.circle_classification,
            firm.head_office,
            firm.head_office_city,
            firm.head_office_country,
            firm.uk_rank,
            ...extraTerms
          ]
            .filter(Boolean)
            .join(" ")
        );

      const matchesSearch =
        !search ||
        searchableText.includes(search);

      const matchesPracticeArea =
        !practiceArea ||
        firmPracticeAreas.has(
          practiceArea
        );

      const matchesRole =
        !role ||
        firmRoles.has(role);

      const matchesFirmType =
        !firmType ||
        firm.firm_type === firmType;

      return (
        matchesSearch &&
        matchesPracticeArea &&
        matchesRole &&
        matchesFirmType
      );
    });

  const anyFilterActive =
    Boolean(
      search ||
      practiceArea ||
      role ||
      firmType
    );

  filterReset?.classList.toggle(
    "hidden",
    !anyFilterActive
  );

  currentFilteredFirms = filtered;
  displayFirms(filtered);

  return filtered;
}

function resetFilters() {
  const searchInput =
    document.getElementById(
      "searchInput"
    );

  const filterPracticeArea =
    document.getElementById(
      "filterPracticeArea"
    );

  const filterRole =
    document.getElementById(
      "filterRole"
    );

  const filterFirmType =
    document.getElementById(
      "filterFirmType"
    );

  if (searchInput) {
    searchInput.value = "";
  }

  if (filterPracticeArea) {
    filterPracticeArea.value = "";
  }

  if (filterRole) {
    filterRole.value = "";
  }

  if (filterFirmType) {
    filterFirmType.value = "";
  }

  applyFilters();
  hideHomepageSearchResults();
  searchInput?.focus();
}

/* =======================================
   Hero search results
======================================= */

function createHomepageSearchResults() {
  const searchBox =
    document.getElementById("firm-search");

  const input =
    document.getElementById("searchInput");

  if (!searchBox || !input) {
    return;
  }

  input.setAttribute("role", "combobox");
  input.setAttribute("aria-autocomplete", "list");
  input.setAttribute(
    "aria-controls",
    "homepageSearchResults"
  );
  input.setAttribute("aria-expanded", "false");

  searchBox.classList.add(
    "homepage-search-enhanced"
  );

  homepageSearchResults =
    document.createElement("div");

  homepageSearchResults.id =
    "homepageSearchResults";

  homepageSearchResults.className =
    "homepage-search-results";

  homepageSearchResults.setAttribute(
    "role",
    "listbox"
  );

  homepageSearchResults.setAttribute(
    "aria-label",
    "Firm search results"
  );

  homepageSearchResults.hidden = true;

  document.body.appendChild(
    homepageSearchResults
  );

  injectHomepageSearchStyles();

  window.addEventListener(
    "resize",
    positionHomepageSearchResults
  );

  window.addEventListener(
    "scroll",
    positionHomepageSearchResults,
    true
  );
}

function positionHomepageSearchResults() {
  const input =
    document.getElementById("searchInput");

  if (
    !homepageSearchResults ||
    !input ||
    homepageSearchResults.hidden
  ) {
    return;
  }

  const rect =
    input.getBoundingClientRect();

  const gap = 8;
  const viewportPadding = 12;
  const maximumPanelHeight = 420;

  const availableBelow =
    Math.max(
      0,
      window.innerHeight -
        rect.bottom -
        gap -
        viewportPadding
    );

  const availableAbove =
    Math.max(
      0,
      rect.top -
        gap -
        viewportPadding
    );

  const naturalHeight =
    Math.min(
      maximumPanelHeight,
      homepageSearchResults.scrollHeight
    );

  const minimumUsefulSpace = 180;

  const openAbove =
    availableBelow < minimumUsefulSpace &&
    availableAbove > availableBelow;

  const availableSpace =
    openAbove
      ? availableAbove
      : availableBelow;

  const panelHeight =
    Math.max(
      0,
      Math.min(
        naturalHeight,
        maximumPanelHeight,
        availableSpace
      )
    );

  const left =
    Math.max(
      viewportPadding,
      Math.min(
        rect.left,
        window.innerWidth -
          rect.width -
          viewportPadding
      )
    );

  const width =
    Math.min(
      rect.width,
      window.innerWidth -
        viewportPadding * 2
    );

  homepageSearchResults.style.left =
    `${left}px`;

  homepageSearchResults.style.width =
    `${width}px`;

  homepageSearchResults.style.maxHeight =
    `${panelHeight}px`;

  homepageSearchResults.dataset.position =
    openAbove
      ? "above"
      : "below";

  if (openAbove) {
    homepageSearchResults.style.top = "";
    homepageSearchResults.style.bottom =
      `${window.innerHeight - rect.top + gap}px`;
  } else {
    homepageSearchResults.style.bottom = "";
    homepageSearchResults.style.top =
      `${rect.bottom + gap}px`;
  }
}

function renderHomepageSearchResults(list) {
  const input =
    document.getElementById("searchInput");

  if (
    !homepageSearchResults ||
    !input
  ) {
    return;
  }

  const query =
    normalizeText(input.value);

  if (!query) {
    hideHomepageSearchResults();
    return;
  }

  const matches =
    list.slice(0, 8);

  if (!matches.length) {
    homepageSearchResults.innerHTML = `
      <div class="homepage-search-empty">
        <strong>No matching firms found</strong>
        <span>
          Try a firm name, city, practice area or opportunity.
        </span>
      </div>
    `;

    input.setAttribute("aria-expanded", "true");

    homepageSearchResults.hidden = false;

    window.requestAnimationFrame(
      positionHomepageSearchResults
    );

    return;
  }

  const fragment =
    document.createDocumentFragment();

  const summary =
    document.createElement("div");

  summary.className =
    "homepage-search-summary";

  summary.textContent =
    list.length === 1
      ? "1 matching firm"
      : `${list.length} matching firms`;

  fragment.appendChild(summary);

  matches.forEach(firm => {
    const link =
      document.createElement("a");

    link.className =
      "homepage-search-result";

    link.href =
      getFirmProfileUrl(firm);

    link.setAttribute(
      "role",
      "option"
    );

    const title =
      document.createElement("strong");

    title.textContent =
      firm.name || "Law firm";

    const details =
      document.createElement("span");

    const firmType =
      firm.circle_classification ||
      firm.firm_type ||
      "Law firm";

    details.textContent =
      `${firmType} · ${formatFirmLocation(firm)}`;

    link.append(
      title,
      details
    );

    fragment.appendChild(link);
  });

  if (list.length > matches.length) {
    const more =
      document.createElement("button");

    more.type = "button";
    more.className =
      "homepage-search-more";

    more.textContent =
      `View all ${list.length} matching firms`;

    more.addEventListener(
      "click",
      () => {
        hideHomepageSearchResults();

        document
          .getElementById("firms-section")
          ?.scrollIntoView({
            behavior: "smooth",
            block: "start"
          });
      }
    );

    fragment.appendChild(more);
  }

  homepageSearchResults.replaceChildren(
    fragment
  );

  homepageSearchResults.hidden = false;

  window.requestAnimationFrame(
    positionHomepageSearchResults
  );
}

function hideHomepageSearchResults() {
  const input =
    document.getElementById("searchInput");

  if (input) {
    input.setAttribute("aria-expanded", "false");
    input.removeAttribute("aria-activedescendant");
  }

  if (homepageSearchResults) {
    homepageSearchResults.hidden = true;
    homepageSearchResults.style.left = "";
    homepageSearchResults.style.top = "";
    homepageSearchResults.style.bottom = "";
    homepageSearchResults.style.width = "";
    homepageSearchResults.style.maxHeight = "";
    delete homepageSearchResults.dataset.position;
  }
}

function getFirmProfileUrl(firm) {
  return `firm-profile.html?id=${
    encodeURIComponent(firm.id)
  }`;
}

function openFirmProfile(firm) {
  window.location.href =
    getFirmProfileUrl(firm);
}

function injectHomepageSearchStyles() {
  if (
    document.getElementById(
      "homepageSearchStyles"
    )
  ) {
    return;
  }

  const style =
    document.createElement("style");

  style.id =
    "homepageSearchStyles";

  style.textContent = `
    .homepage-search-enhanced {
      position: relative;
      z-index: 20;
    }

    .homepage-search-results {
      position: fixed !important;
      z-index: 2147483647 !important;
      box-sizing: border-box;
      overflow-x: hidden !important;
      overflow-y: auto !important;
      overscroll-behavior: contain;
      scrollbar-gutter: stable;
      border: 1px solid color-mix(in srgb, currentColor 18%, transparent);
      border-radius: 1rem;
      background: var(--surface, #ffffff);
      box-shadow: 0 1.25rem 3rem rgba(20, 20, 30, 0.18);
      color: var(--text, #17151c);
      clip-path: none !important;
      contain: none !important;
      transform: none !important;
    }

    .homepage-search-results[data-position="above"] {
      box-shadow: 0 -1.25rem 3rem rgba(20, 20, 30, 0.18);
    }

    .homepage-search-results[hidden] {
      display: none;
    }

    .homepage-search-summary {
      padding: 0.7rem 1rem;
      border-bottom: 1px solid color-mix(in srgb, currentColor 10%, transparent);
      font-size: 0.78rem;
      font-weight: 700;
      letter-spacing: 0.02em;
      opacity: 0.68;
    }

    .homepage-search-result,
    .homepage-search-more {
      display: flex;
      width: 100%;
      box-sizing: border-box;
      flex-direction: column;
      gap: 0.2rem;
      padding: 0.9rem 1rem;
      border: 0;
      border-bottom: 1px solid color-mix(in srgb, currentColor 10%, transparent);
      background: transparent;
      color: inherit;
      font: inherit;
      text-align: left;
      text-decoration: none;
      cursor: pointer;
    }

    .homepage-search-result:last-child,
    .homepage-search-more:last-child {
      border-bottom: 0;
    }

    .homepage-search-result:hover,
    .homepage-search-result:focus-visible,
    .homepage-search-more:hover,
    .homepage-search-more:focus-visible {
      outline: none;
      background: color-mix(in srgb, currentColor 7%, transparent);
    }

    .homepage-search-result strong {
      font-size: 0.98rem;
    }

    .homepage-search-result span,
    .homepage-search-empty span {
      font-size: 0.82rem;
      opacity: 0.72;
    }

    .homepage-search-more {
      align-items: center;
      font-weight: 700;
      color: var(--accent, #6f45c5);
    }

    .homepage-search-empty {
      display: flex;
      flex-direction: column;
      gap: 0.25rem;
      padding: 1rem;
    }

    [data-theme="dark"] .homepage-search-results {
      background: var(--surface, #1d1a22);
      color: var(--text, #f7f4fb);
      box-shadow: 0 1.25rem 3rem rgba(0, 0, 0, 0.45);
    }
  `;

  document.head.appendChild(style);
}

/* =======================================
   Firm preview rendering
======================================= */

function displayFirms(list) {
  const container =
    document.getElementById("firms");

  const count =
    document.getElementById("firmCount");

  if (!container) {
    return;
  }

  updateFirmCount(
    count,
    list.length
  );

  if (!list.length) {
    container.innerHTML = `
      <div class="directory-empty">
        <p>No matching firms found.</p>

        <span>
          Try a broader search or reset the filters.
        </span>
      </div>
    `;

    return;
  }

  const fragment =
    document.createDocumentFragment();

  list.forEach(firm => {
    fragment.appendChild(
      createFirmListItem(firm)
    );
  });

  container.replaceChildren(
    fragment
  );
}

function createFirmListItem(firm) {
  const firmUrl =
    getFirmProfileUrl(firm);

  const firmType =
    firm.circle_classification ||
    firm.firm_type ||
    "Law firm";

  const location =
    formatFirmLocation(firm);

  return createHomepageProfileCard({
    name: firm.name,
    url: firmUrl,
    description: `${firmType} · ${location}`,
    actionText: "View firm"
  });
}
function formatFirmLocation(firm) {
  const city =
    firm.head_office_city?.trim();

  const country =
    firm.head_office_country?.trim();

  if (
    city &&
    country
  ) {
    return `${city}, ${country}`;
  }

  if (city) {
    return city;
  }

  if (country) {
    return country;
  }

  return (
    firm.head_office ||
    "United Kingdom"
  );
}

function updateFirmCount(
  element,
  total
) {
  if (!element) {
    return;
  }

  element.textContent =
    total === 1
      ? "1 firm"
      : `${total} firms`;
}

/* =======================================
   Chambers homepage preview
======================================= */

async function loadHomepageChambers() {
  const container =
    document.getElementById("chambersPreview");

  if (!container) {
    return;
  }

  container.innerHTML = `
    <div class="directory-empty">
      <p>Loading chambers…</p>
      <span>Fetching verified chambers profiles.</span>
    </div>
  `;

  if (typeof client === "undefined") {
    container.innerHTML = `
      <div class="directory-empty">
        <p>Unable to load chambers</p>
        <span>The database connection is not available.</span>
      </div>
    `;
    return;
  }

  const {
    data: chamberRows,
    error: chamberError
  } = await client
    .from("chambers")
    .select(`
      organisation_id,
      active
    `)
    .eq("active", true);

  if (chamberError) {
    console.error(
      "Unable to load homepage chambers:",
      chamberError
    );

    container.innerHTML = `
      <div class="directory-empty">
        <p>Unable to load chambers</p>
        <span>Please refresh the page and try again.</span>
      </div>
    `;
    return;
  }

  const organisationIds = [
    ...new Set(
      (chamberRows || [])
        .map(row => row.organisation_id)
        .filter(Boolean)
    )
  ];

  if (!organisationIds.length) {
    container.innerHTML = `
      <div class="directory-empty">
        <p>No chambers profiles available</p>
        <span>Verified chambers will appear here automatically.</span>
      </div>
    `;
    return;
  }

  const [
    organisationResult,
    locationResult
  ] = await Promise.all([
    client
      .from("legal_organisations")
      .select(`
        id,
        name,
        slug,
        logo_url,
        organisation_type,
        active
      `)
      .in("id", organisationIds)
      .eq(
        "organisation_type",
        "barristers_chambers"
      )
      .eq("active", true)
      .order("name", {
        ascending: true
      }),

    client
      .from("organisation_locations")
      .select(`
        organisation_id,
        city,
        country
      `)
      .in("organisation_id", organisationIds)
      .eq("active", true)
  ]);

  if (organisationResult.error) {
    console.error(
      "Unable to load homepage chambers organisations:",
      organisationResult.error
    );

    container.innerHTML = `
      <div class="directory-empty">
        <p>Unable to load chambers</p>
        <span>Please refresh the page and try again.</span>
      </div>
    `;
    return;
  }

  if (locationResult.error) {
    console.warn(
      "Unable to load homepage chambers locations:",
      locationResult.error
    );
  }

  const locationsByOrganisation =
    new Map();

  (locationResult.data || []).forEach(row => {
    const key =
      String(row.organisation_id || "");

    if (
      !key ||
      locationsByOrganisation.has(key)
    ) {
      return;
    }

    const city =
      row.city?.trim();

    const country =
      row.country?.trim();

    const location =
      city && country
        ? `${city}, ${country}`
        : city || country || "";

    if (location) {
      locationsByOrganisation.set(
        key,
        location
      );
    }
  });

  const chambers =
    (organisationResult.data || [])
      .filter(row => row?.id && row?.name);

  const chambersCount =
    document.getElementById("chambersCount");

  if (chambersCount) {
    chambersCount.textContent =
      `${chambers.length} chambers`;
  }

  if (!chambers.length) {
    container.innerHTML = `
      <div class="directory-empty">
        <p>No chambers profiles available</p>
        <span>Verified chambers will appear here automatically.</span>
      </div>
    `;
    return;
  }

  const fragment =
    document.createDocumentFragment();

  chambers.forEach(chambersRow => {
    fragment.appendChild(
      createHomepageChambersListItem(
        chambersRow,
        locationsByOrganisation.get(
          String(chambersRow.id)
        ) || ""
      )
    );
  });

  container.replaceChildren(fragment);
}

function createHomepageChambersListItem(
  chambers,
  location
) {
  const chambersUrl =
    `chamber-profile.html?id=${encodeURIComponent(
      chambers.id
    )}`;

  const typeAndLocation =
    location
      ? `Barristers’ chambers · ${location}`
      : "Barristers’ chambers";

  return createHomepageProfileCard({
    name: chambers.name,
    url: chambersUrl,
    description: typeAndLocation,
    actionText: "View chambers"
  });
}

function createHomepageProfileCard({
  name,
  url,
  description,
  actionText
}) {
  const card =
    document.createElement("a");

  card.className = "firm-card";
  card.href = url;

  card.setAttribute(
    "aria-label",
    `View ${name} profile`
  );

  card.innerHTML = `
    <div class="firm-card-header">
      <div class="firm-card-copy">
        <h3>
          ${escapeHtml(name)}
        </h3>

        <p class="firm-type">
          ${escapeHtml(description)}
        </p>
      </div>
    </div>

    <span class="firm-link">
      ${escapeHtml(actionText)}
    </span>
  `;

  return card;
}


/* =======================================
   Unified deadline preview
======================================= */

async function loadUpcomingDeadlines() {
  const deadlineList =
    document.getElementById(
      "deadlinePreviewList"
    );

  if (!deadlineList) {
    return;
  }

  if (typeof client === "undefined") {
    showDeadlineMessage(
      deadlineList,
      "Deadlines are temporarily unavailable."
    );

    return;
  }

  deadlineList.innerHTML = `
    <div class="deadline-loading">
      Loading upcoming deadlines…
    </div>
  `;

  const { data, error } = await client
    .from("career_opportunity_occurrences_public_view")
    .select(`
      deadline_key,
      provider_name,
      provider_type,
      career_pathway,
      public_title,
      opportunity_type_label,
      closes_on,
      public_application_status,
      deadline_group,
      cycle_application_url,
      opportunity_application_url,
      last_verified_on
    `)
    .eq("has_exact_application_deadline", true)
    .neq("deadline_group", "passed")
    .order(
      "closes_on",
      {
        ascending: true,
        nullsFirst: false
      }
    )
    .order("provider_name", { ascending: true })
    .order("public_title", { ascending: true })
    .limit(12);

  if (error) {
    console.error(
      "Unable to load deadlines:",
      error
    );

    showDeadlineMessage(
      deadlineList,
      "Upcoming dates are being refreshed."
    );

    return;
  }

  const canonicalRows = (data || []).map(row => ({
    ...row,
    opportunity_name: row.public_title,
    application_deadline: row.closes_on,
    application_status: row.public_application_status,
    application_url:
      row.cycle_application_url ||
      row.opportunity_application_url,
    last_checked_on: row.last_verified_on
  }));

  const rows =
    deduplicateDeadlines(canonicalRows)
      .slice(0, 5);

  if (!rows.length) {
    showDeadlineMessage(
      deadlineList,
      "New application deadlines will appear here as they are verified."
    );

    return;
  }

  const fragment =
    document.createDocumentFragment();

  rows.forEach(row => {
    fragment.appendChild(
      createDeadlinePreviewRow(row)
    );
  });

  deadlineList.replaceChildren(
    fragment
  );
}

function deduplicateDeadlines(rows) {
  const unique =
    new Map();

  rows.forEach(row => {
    const key =
      row.deadline_key ||
      [
        row.provider_name,
        row.opportunity_name,
        row.application_deadline
      ].join("|");

    if (!unique.has(key)) {
      unique.set(key, row);
    }
  });

  return Array.from(
    unique.values()
  );
}

function createDeadlinePreviewRow(row) {
  const article =
    document.createElement("article");

  article.className =
    "deadline-row";

  const providerName =
    row.provider_name ||
    "Legal employer";

  const opportunityName =
    row.opportunity_name ||
    row.opportunity_type_label ||
    "Opportunity";

  const dateLabel =
    formatDate(
      row.application_deadline,
      false
    );

  const applicationUrl =
    safeHttpUrl(
      row.application_url
    );

  article.innerHTML = `
    <div>
      <strong>
        ${escapeHtml(providerName)}
      </strong>

      <span>
        ${escapeHtml(opportunityName)}
      </span>
    </div>

    ${
      applicationUrl
        ? `
          <a
            class="small-link"
            href="${escapeHtml(applicationUrl)}"
            target="_blank"
            rel="noopener noreferrer"
            aria-label="${
              escapeHtml(
                `${providerName}: ${opportunityName}, deadline ${dateLabel}`
              )
            }"
          >
            <time
              datetime="${
                escapeHtml(
                  row.application_deadline
                )
              }"
            >
              ${escapeHtml(dateLabel)}
            </time>
          </a>
        `
        : `
          <time
            datetime="${
              escapeHtml(
                row.application_deadline
              )
            }"
          >
            ${escapeHtml(dateLabel)}
          </time>
        `
    }
  `;

  return article;
}

function showDeadlineMessage(
  container,
  message
) {
  container.innerHTML = `
    <article class="deadline-row">
      <div>
        <strong>
          Dates being refreshed
        </strong>

        <span>
          ${escapeHtml(message)}
        </span>
      </div>
    </article>
  `;
}

/* =======================================
   Loading and error states
======================================= */

function setFirmLoadingState(
  container,
  count
) {
  container.innerHTML = `
    <div
      class="directory-empty"
      role="status"
    >
      <p>Loading firms…</p>

      <span>
        Preparing the firm directory.
      </span>
    </div>
  `;

  if (count) {
    count.textContent =
      "Loading firms…";
  }
}

function showFirmLoadError(
  container,
  count,
  message
) {
  container.innerHTML = `
    <div class="directory-empty">
      <p>Firms could not be loaded.</p>

      <span>
        ${escapeHtml(message)}
      </span>
    </div>
  `;

  if (count) {
    count.textContent =
      "Unable to load firms";
  }
}

/* =======================================
   Utilities
======================================= */

function debounce(
  callback,
  delay = 180
) {
  let timer;

  return (...args) => {
    window.clearTimeout(timer);

    timer = window.setTimeout(
      () => callback(...args),
      delay
    );
  };
}

function normalizeText(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(
      /[\u0300-\u036f]/g,
      ""
    )
    .toLowerCase()
    .trim();
}

function getTodayIsoDate() {
  const now =
    new Date();

  const offset =
    now.getTimezoneOffset();

  const localDate =
    new Date(
      now.getTime() -
      offset * 60_000
    );

  return localDate
    .toISOString()
    .slice(0, 10);
}

function parseDateOnly(value) {
  if (!value) {
    return null;
  }

  const date =
    new Date(
      `${value}T00:00:00`
    );

  return Number.isNaN(
    date.getTime()
  )
    ? null
    : date;
}

function formatDate(
  value,
  includeYear = true
) {
  const date =
    parseDateOnly(value);

  if (!date) {
    return value || "";
  }

  return date.toLocaleDateString(
    "en-GB",
    {
      day: "numeric",
      month: "short",
      ...(includeYear
        ? { year: "numeric" }
        : {})
    }
  );
}

function safeHttpUrl(value) {
  if (!value) {
    return "";
  }

  try {
    const url =
      new URL(value);

    if (
      url.protocol !== "http:" &&
      url.protocol !== "https:"
    ) {
      return "";
    }

    return url.href;
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
