const firmsDirectoryState = {
    firms: [],
    filteredFirms: [],
    firmsById: new Map(),
    firmsByOrganisationId: new Map(),
    firmsByName: new Map(),
    supportingDataPromise: null,
    supportingDataLoaded: false,
  },
  directoryElements = {};
async function initialiseFirmsDirectory() {
  if (
    (cacheDirectoryElements(),
    connectDirectoryFilters(),
    "undefined" == typeof client)
  )
    return (
      console.error("The Supabase client is unavailable."),
      void showDirectoryError()
    );
  try {
    const { data: e, error: t } = await client
      .from("firms")
      .select(
        "id,name,short_name,logo_url,firm_type,head_office,uk_rank,organisation_id",
      );
    if (t) throw t;
    ((firmsDirectoryState.firms = (e || [])
      .filter((e) => e?.id && e?.name)
      .map(normaliseFirm)),
      buildFirmMaps(),
      updateFirmItemListSchema(firmsDirectoryState.firms),
      applyDirectoryFilters(),
      directoryElements.loading?.classList.add("hidden"));
  } catch (e) {
    (console.error("Unable to load firms:", e), showDirectoryError());
  }
}
function cacheDirectoryElements() {
  ((directoryElements.search = document.getElementById("directorySearch")),
    (directoryElements.sort = document.getElementById("sortFilter")),
    (directoryElements.location = document.getElementById("locationFilter")),
    (directoryElements.practice = document.getElementById("practiceFilter")),
    (directoryElements.role = document.getElementById("roleFilter")),
    (directoryElements.status = document.getElementById("statusFilter")),
    (directoryElements.clear = document.getElementById("clearFilters")),
    (directoryElements.count = document.getElementById("directoryCount")),
    (directoryElements.loading = document.getElementById("directoryLoading")),
    (directoryElements.error = document.getElementById("directoryError")),
    (directoryElements.empty = document.getElementById("directoryEmpty")),
    (directoryElements.list = document.getElementById("firmsDirectory")));
}
function connectDirectoryFilters() {
  (directoryElements.search?.addEventListener("input", applyDirectoryFilters),
    directoryElements.sort?.addEventListener("change", applyDirectoryFilters),
    directoryElements.location?.addEventListener(
      "change",
      applyDirectoryFilters,
    ),
    directoryElements.practice?.addEventListener(
      "change",
      applyDirectoryFilters,
    ),
    directoryElements.role?.addEventListener("change", applyDirectoryFilters),
    directoryElements.status?.addEventListener("change", applyDirectoryFilters),
    directoryElements.clear?.addEventListener("click", clearDirectoryFilters),
    connectAdvancedFilterLoading());
}
function normaliseFirm(e) {
  return {
    ...e,
    locations: [],
    practiceAreas: [],
    opportunities: [],
    statuses: [],
  };
}
function buildFirmMaps() {
  (firmsDirectoryState.firmsById.clear(),
    firmsDirectoryState.firmsByOrganisationId.clear(),
    firmsDirectoryState.firmsByName.clear(),
    firmsDirectoryState.firms.forEach((e) => {
      (firmsDirectoryState.firmsById.set(String(e.id), e),
        e.organisation_id &&
          firmsDirectoryState.firmsByOrganisationId.set(
            String(e.organisation_id),
            e,
          ),
        firmsDirectoryState.firmsByName.set(normaliseText(e.name), e),
        e.short_name &&
          firmsDirectoryState.firmsByName.set(normaliseText(e.short_name), e));
    }));
}
async function loadSupportingFirmData() {
  const firmIds = firmsDirectoryState.firms.map((e) => e.id).filter(Boolean),
    organisationIds = firmsDirectoryState.firms
      .map((e) => e.organisation_id)
      .filter(Boolean),
    providerNames = [
      ...new Set(
        firmsDirectoryState.firms
          .flatMap((e) => [e.name, e.short_name])
          .filter(Boolean),
      ),
    ],
    empty = Promise.resolve({ data: [], error: null });

  const results = await Promise.all([
    organisationIds.length
      ? client
          .from("organisation_locations")
          .select("organisation_id,city,country,active")
          .in("organisation_id", organisationIds)
          .eq("active", true)
      : empty,
    firmIds.length
      ? client
          .from("locations")
          .select("firm_id,city,country,active")
          .in("firm_id", firmIds)
          .eq("active", true)
      : empty,
    firmIds.length
      ? client
          .from("practice_areas")
          .select("firm_id,practice_area")
          .in("firm_id", firmIds)
      : empty,
    firmIds.length
      ? client
          .from("firm_roles_public_view")
          .select("firm_id,role_name,active,confirmed")
          .in("firm_id", firmIds)
          .eq("active", true)
          .eq("confirmed", true)
      : empty,
    firmIds.length
      ? client
          .from("firm_programmes")
          .select(
            "id,firm_id,programme_name,exact_official_name,current_status,active,published",
          )
          .in("firm_id", firmIds)
          .eq("active", true)
          .eq("published", true)
      : empty,
    providerNames.length
      ? client
          .from("deadlines_public_view")
          .select(
            "provider_name,career_pathway,opportunity_name,application_status",
          )
          .in("provider_name", providerNames)
      : empty,
  ]);

  const labels = [
    "organisation_locations",
    "locations",
    "practice_areas",
    "firm_roles_public_view",
    "firm_programmes",
    "deadlines_public_view",
  ];

  const rows = results.map((result, index) => {
    if (result.error) {
      console.warn(
        `Optional source unavailable: ${labels[index]}`,
        result.error.message,
      );
      return [];
    }
    return result.data || [];
  });

  const [
    organisationLocations,
    locations,
    practiceAreas,
    roles,
    programmes,
    deadlines,
  ] = rows;

  const programmeIds = programmes.map((e) => e.id).filter(Boolean);

  let cycles = [];
  if (programmeIds.length) {
    const cycleResult = await client
      .from("firm_programme_cycles")
      .select("programme_id,application_status,current_status,active")
      .in("programme_id", programmeIds)
      .eq("active", true);

    if (cycleResult.error) {
      console.warn(
        "Optional source unavailable: firm_programme_cycles",
        cycleResult.error.message,
      );
    } else {
      cycles = cycleResult.data || [];
    }
  }

  addLocationRows([...organisationLocations, ...locations]);
  addPracticeAreaRows(practiceAreas);
  addRoleRows(roles);
  addProgrammeRows(programmes, cycles);
  addDeadlineRows(deadlines);

  firmsDirectoryState.firms.forEach((e) => {
    e.locations = uniqueSorted(e.locations);
    e.practiceAreas = uniqueSorted(e.practiceAreas);
    e.opportunities = uniqueSorted(e.opportunities);
    e.statuses = [...new Set(e.statuses)];
  });
}
function findFirmForRow(e) {
  const t = [e.firm_id, e.provider_firm_id].filter(Boolean);
  for (const e of t) {
    const t = firmsDirectoryState.firmsById.get(String(e));
    if (t) return t;
  }
  const r = [e.organisation_id, e.legal_organisation_id, e.provider_id].filter(
    Boolean,
  );
  for (const e of r) {
    const t = firmsDirectoryState.firmsByOrganisationId.get(String(e));
    if (t) return t;
  }
  const n = [
    e.firm_name,
    e.provider_name,
    e.organisation_name,
    e.legal_organisation_name,
  ].filter(Boolean);
  for (const e of n) {
    const t = firmsDirectoryState.firmsByName.get(normaliseText(e));
    if (t) return t;
  }
  return null;
}
function directoryGeoKey(value) {
  return String(value || "")
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

const directoryCountryAliases = new Map(
  Object.entries({
    uk: "United Kingdom",
    "u k": "United Kingdom",
    "united kingdom": "United Kingdom",
    "great britain": "United Kingdom",
    britain: "United Kingdom",
    england: "United Kingdom",
    wales: "United Kingdom",
    scotland: "United Kingdom",
    "northern ireland": "United Kingdom",
    "england and wales": "United Kingdom",
    netherlands: "Netherlands",
    "the netherlands": "Netherlands",
    us: "United States",
    "u s": "United States",
    usa: "United States",
    "united states": "United States",
    "united states of america": "United States",
    uae: "United Arab Emirates",
    "u a e": "United Arab Emirates",
    "united arab emirates": "United Arab Emirates",
    ireland: "Ireland",
    "republic of ireland": "Ireland",
    "hong kong": "Hong Kong",
    "hong kong sar": "Hong Kong",
    "hong kong s a r": "Hong Kong",
    "hong kong sar china": "Hong Kong",
    "czech republic": "Czechia",
    czechia: "Czechia",
    "south korea": "South Korea",
    "republic of korea": "South Korea",
    turkey: "Türkiye",
    turkiye: "Türkiye",
  }),
);

function directoryCanonicalCountry(value) {
  const text = String(value || "")
    .replaceAll("_", " ")
    .replace(/\s+/g, " ")
    .trim();

  if (!text) return "";

  return directoryCountryAliases.get(directoryGeoKey(text)) || text;
}

function directoryCleanCity(country, city) {
  const publicCountry = directoryCanonicalCountry(country);

  let parts = String(city || "")
    .replace(/\s+/g, " ")
    .trim()
    .split(",")
    .map((part) => part.trim())
    .filter(Boolean);

  if (!parts.length) return "";

  if (
    publicCountry &&
    parts.length &&
    directoryGeoKey(directoryCanonicalCountry(parts[0])) ===
      directoryGeoKey(publicCountry)
  ) {
    parts.shift();
  }

  if (
    publicCountry &&
    parts.length &&
    directoryGeoKey(directoryCanonicalCountry(parts[parts.length - 1])) ===
      directoryGeoKey(publicCountry)
  ) {
    parts.pop();
  }

  if (!parts.length) return "";

  /*
   * The filter has exactly one city level.
   * Never carry districts/buildings/areas after it.
   */
  if (
    publicCountry === "United States" &&
    parts.length > 1 &&
    /^d\.?\s*c\.?$/i.test(parts[1])
  ) {
    return `${parts[0]} DC`;
  }

  return parts[0];
}

function directoryLocationLabel(country, city) {
  const publicCountry = directoryCanonicalCountry(country);
  const publicCity = directoryCleanCity(publicCountry, city);

  if (
    publicCountry &&
    publicCity &&
    directoryGeoKey(publicCountry) !== directoryGeoKey(publicCity)
  ) {
    return `${publicCountry}, ${publicCity}`;
  }

  return publicCountry || publicCity;
}

function addLocationRows(rows) {
  rows.forEach((row) => {
    const firm = findFirmForRow(row);

    if (!firm) return;

    /*
     * Use only the structured city column for filters.
     * location_name / office_name may contain buildings,
     * areas or office descriptors.
     */
    const city = row.city || "";

    const location = directoryLocationLabel(row.country, city);

    if (location) {
      firm.locations.push(location);
    }
  });
}

function addPracticeAreaRows(e) {
  e.forEach((e) => {
    const t = findFirmForRow(e);
    if (!t) return;
    const r = e.practice_area || e.practice_name || e.service_name || e.name;
    r && t.practiceAreas.push(r);
  });
}
function addRoleRows(e) {
  e.forEach((e) => {
    const t = findFirmForRow(e);
    if (!t) return;
    const r = e.role_name || e.official_role_title || e.role_title || e.name;
    r && t.opportunities.push(r);
  });
}
function addProgrammeRows(programmes, cycles) {
  const programmeMap = new Map();
  programmes.forEach((programme) => {
    if (programme.active === false || programme.published === false) return;
    const firm = findFirmForRow(programme);
    if (!firm) return;
    if (programme.id) programmeMap.set(String(programme.id), firm);
    const name =
      programme.programme_name ||
      programme.exact_official_name ||
      programme.opportunity_name ||
      programme.name;
    if (name) firm.opportunities.push(name);
    addStatusToFirm(
      firm,
      programme.current_status ||
        programme.status ||
        programme.application_status,
    );
  });
  cycles.forEach((cycle) => {
    if (cycle.active === false) return;
    const firm = programmeMap.get(String(cycle.programme_id));
    if (!firm) return;
    addStatusToFirm(
      firm,
      cycle.application_status || cycle.current_status || cycle.status,
    );
  });
}
function addOpportunityRows(e) {
  e.forEach((e) => {
    const t = findFirmForRow(e);
    if (!t) return;
    const r =
      e.scheme_name ||
      e.opportunity_name ||
      e.programme_name ||
      e.name ||
      "Vacation scheme";
    (t.opportunities.push(r),
      addStatusToFirm(t, e.application_status || e.status || e.cycle_status));
  });
}
function addTrainingContractRows(e) {
  e.forEach((e) => {
    const t = findFirmForRow(e);
    if (!t) return;
    const r =
      e.programme_name || e.training_contract_name || "Training contract";
    (t.opportunities.push(r),
      addStatusToFirm(t, e.application_status || e.status || e.cycle_status));
  });
}
function addDeadlineRows(e) {
  e.forEach((e) => {
    const t = normaliseText(e.career_pathway || "");
    if (t && "solicitor" !== t) return;
    const r = findFirmForRow(e);
    if (!r) return;
    const n =
      e.opportunity_type_name ||
      e.opportunity_type ||
      e.opportunity_name ||
      e.programme_name;
    (n && r.opportunities.push(n),
      addStatusToFirm(r, e.application_status || e.status || e.cycle_status));
  });
}
function addStatusToFirm(e, t) {
  const r = normaliseApplicationStatus(t);
  r && e.statuses.push(r);
}
function normaliseApplicationStatus(e) {
  if (!e) return "unknown";
  const t = normaliseText(e);
  return t.includes("rolling")
    ? "rolling"
    : "current" === t
      ? "current"
      : t.includes("upcoming") ||
          t.includes("not yet open") ||
          t.includes("opens soon") ||
          t.includes("announced")
        ? "upcoming"
        : t.includes("closed") || t.includes("expired") || t.includes("passed")
          ? "closed"
          : t.includes("open")
            ? "open"
            : "unknown";
}
function populateFilterOptions() {
  const e = uniqueSorted(firmsDirectoryState.firms.flatMap((e) => e.locations)),
    t = uniqueSorted(firmsDirectoryState.firms.flatMap((e) => e.practiceAreas)),
    r = uniqueSorted(firmsDirectoryState.firms.flatMap((e) => e.opportunities));
  (addSelectOptions(directoryElements.location, e),
    addSelectOptions(directoryElements.practice, t),
    addSelectOptions(directoryElements.role, r));
}
function addSelectOptions(e, t) {
  e &&
    t.forEach((t) => {
      const r = document.createElement("option");
      ((r.value = t), (r.textContent = t), e.appendChild(r));
    });
}
function applyDirectoryFilters() {
  const e = normaliseText(directoryElements.search?.value || ""),
    t = directoryElements.location?.value || "",
    r = directoryElements.practice?.value || "",
    n = directoryElements.role?.value || "",
    i = directoryElements.status?.value || "",
    o = directoryElements.sort?.value || "rank";
  ((firmsDirectoryState.filteredFirms = firmsDirectoryState.firms.filter(
    (o) => {
      const a = normaliseText(
          [
            o.name,
            o.short_name,
            o.firm_type,
            o.head_office,
            ...o.locations,
            ...o.practiceAreas,
            ...o.opportunities,
          ]
            .filter(Boolean)
            .join(" "),
        ),
        s = !e || a.includes(e),
        c = !t || o.locations.includes(t),
        l = !r || o.practiceAreas.includes(r),
        d = !n || o.opportunities.includes(n),
        m = o.statuses.length ? o.statuses : ["unknown"],
        u = !i || m.includes(i);
      return s && c && l && d && u;
    },
  )),
    sortFirms(firmsDirectoryState.filteredFirms, o),
    renderFirmDirectory());
}
function sortFirms(e, t) {
  e.sort((e, r) => {
    const n = e.name || "",
      i = r.name || "";
    if ("az" === t) return n.localeCompare(i);
    if ("za" === t) return i.localeCompare(n);
    const o = numericRank(e.uk_rank),
      a = numericRank(r.uk_rank);
    return o !== a ? o - a : n.localeCompare(i);
  });
}
function renderFirmDirectory() {
  if (!directoryElements.list) return;
  (directoryElements.loading?.classList.add("hidden"),
    directoryElements.error?.classList.add("hidden"));
  const e = firmsDirectoryState.firms.length,
    t = firmsDirectoryState.filteredFirms.length;
  if (
    (directoryElements.count &&
      (directoryElements.count.textContent =
        t === e ? `${e} law firms` : `${t} of ${e} law firms`),
    !t)
  )
    return (
      (directoryElements.list.innerHTML = ""),
      void directoryElements.empty?.classList.remove("hidden")
    );
  (directoryElements.empty?.classList.add("hidden"),
    (directoryElements.list.innerHTML = firmsDirectoryState.filteredFirms
      .map(createFirmCard)
      .join("")));
}
function createFirmCard(e) {
  const t = e.name || "Law firm",
    r = (e.short_name || t).trim().charAt(0).toUpperCase(),
    n = e.logo_url
      ? `\n      <img\n        src="${escapeHtml(e.logo_url)}"\n        alt=""\n        loading="lazy"\n      >\n    `
      : escapeHtml(r),
    i = e.firm_type || "Law firm",
    o = e.head_office || e.locations[0] || "Locations being researched",
    a = numericRank(e.uk_rank),
    s = Number.isFinite(a) ? `UK rank #${a}` : "Ranking not listed",
    c = getPrimaryFirmStatus(e.statuses);
  return `\n    <a\n      class="firm-card"\n      href="${firmProfileUrl(e)}"\n     \n    >\n      <div class="firm-card-header">\n        <div class="firm-logo" aria-hidden="true">\n          ${n}\n        </div>\n      </div>\n\n      <h3>\n        ${escapeHtml(t)}\n      </h3>\n\n      <p class="firm-type">\n        ${escapeHtml(i)}\n      </p>\n\n      <div class="firm-details">\n        <p class="firm-location">\n          ${escapeHtml(o)}\n        </p>\n\n        <p class="firm-location">\n          ${escapeHtml(s)}\n        </p>\n\n        <span class="status-pill">\n          ${escapeHtml(statusLabel(c))}\n        </span>\n      </div>\n\n      <span class="firm-link">\n        View firm profile\n        <span aria-hidden="true">→</span>\n      </span>\n    </a>\n  `;
}
function getPrimaryFirmStatus(e) {
  const t = e?.length ? e : ["unknown"];
  return (
    ["open", "rolling", "upcoming", "current", "closed", "unknown"].find((e) =>
      t.includes(e),
    ) || "unknown"
  );
}
function statusLabel(e) {
  const t = {
    open: "Applications open",
    rolling: "Rolling applications",
    upcoming: "Opening soon",
    current: "Current opportunity",
    closed: "Applications closed",
    unknown: "Application dates not published",
  };
  return t[e] || t.unknown;
}
function ensureSupportingFirmData() {
  if (firmsDirectoryState.supportingDataLoaded) {
    return firmsDirectoryState.supportingDataPromise || Promise.resolve();
  }
  if (!firmsDirectoryState.supportingDataPromise) {
    firmsDirectoryState.supportingDataPromise = loadSupportingFirmData()
      .then(() => {
        ((firmsDirectoryState.supportingDataLoaded = true),
          refreshFilterOptions(),
          applyDirectoryFilters());
      })
      .catch((e) => {
        ((firmsDirectoryState.supportingDataPromise = null),
          console.warn(
            "Optional firm directory filters could not be loaded:",
            e,
          ));
      });
  }
  return firmsDirectoryState.supportingDataPromise;
}
function connectAdvancedFilterLoading() {
  [
    directoryElements.location,
    directoryElements.practice,
    directoryElements.role,
    directoryElements.status,
  ].forEach((e) => {
    (e?.addEventListener("focus", ensureSupportingFirmData, { once: true }),
      e?.addEventListener("pointerdown", ensureSupportingFirmData, {
        once: true,
      }));
  });
}
function clearDirectoryFilters() {
  (directoryElements.search && (directoryElements.search.value = ""),
    directoryElements.sort && (directoryElements.sort.value = "rank"),
    directoryElements.location && (directoryElements.location.value = ""),
    directoryElements.practice && (directoryElements.practice.value = ""),
    directoryElements.role && (directoryElements.role.value = ""),
    directoryElements.status && (directoryElements.status.value = ""),
    applyDirectoryFilters(),
    directoryElements.search?.focus());
}
function showDirectoryError() {
  (directoryElements.loading?.classList.add("hidden"),
    directoryElements.empty?.classList.add("hidden"),
    directoryElements.error?.classList.remove("hidden"),
    directoryElements.count &&
      (directoryElements.count.textContent =
        "The firms directory could not be loaded."));
}
function uniqueSorted(e) {
  return [
    ...new Set(
      e
        .filter(Boolean)
        .map((e) => String(e).trim())
        .filter(Boolean),
    ),
  ].sort((e, t) => e.localeCompare(t));
}
function numericRank(e) {
  if (null == e || "" === String(e).trim()) return Number.POSITIVE_INFINITY;
  const t = Number(e);
  return Number.isFinite(t) && t > 0 ? t : Number.POSITIVE_INFINITY;
}
function normaliseText(e) {
  return String(e || "")
    .trim()
    .toLowerCase();
}
function escapeHtml(e) {
  return String(e ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}
document.addEventListener("DOMContentLoaded", initialiseFirmsDirectory);
function updateFirmItemListSchema(firms) {
  const rows = (firms || []).filter((firm) => firm?.id && firm?.name);

  let script = document.getElementById("firms-item-list-schema");

  if (!script) {
    script = document.createElement("script");
    script.id = "firms-item-list-schema";
    script.type = "application/ld+json";
    document.head.appendChild(script);
  }

  script.textContent = JSON.stringify({
    "@context": "https://schema.org",
    "@type": "ItemList",
    name: "UK Law Firms on Vacatory",
    url: "https://vacatory.com/firms.html",
    numberOfItems: rows.length,
    itemListElement: rows.map((firm, index) => ({
      "@type": "ListItem",
      position: index + 1,
      item: {
        "@type": "Organization",
        name: firm.name,
        url: `https://vacatory.com${firmProfileUrl(firm)}`,
      },
    })),
  });
}

function firmSlugForProfileUrl(value) {
  return String(value || "law-firm")
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/&/g, "")
    .replace(/['’]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .replace(/-{2,}/g, "-");
}

function firmProfileUrl(firm) {
  return `/firms/${firmSlugForProfileUrl(
    firm?.name || firm?.short_name || firm?.id,
  )}/`;
}

function refreshFilterOptions() {
  [
    directoryElements.location,
    directoryElements.practice,
    directoryElements.role,
  ].forEach((select) => {
    if (!select) {
      return;
    }

    const selectedValue = select.value;

    select
      .querySelectorAll("option:not([value=''])")
      .forEach((option) => option.remove());

    select.value = selectedValue;
  });

  populateFilterOptions();
}
