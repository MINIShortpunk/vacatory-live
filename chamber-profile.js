// =======================================
// Vacatory
// chamber-profile.js
// Full barristers' chambers research profile
// =======================================

"use strict";

const chamberParams = new URLSearchParams(window.location.search);
const chamberId = chamberParams.get("id");

const state = {
  chamber: null,
  opportunities: [],
  practiceAreas: [],
  locations: [],
  links: [],
  rankings: [],
  opportunityLocationFilter: "",
  opportunityTypeFilter: ""
};

document.addEventListener("DOMContentLoaded", () => {
  setupProfileTabs();

  if (!chamberId) {
    showProfileError();
    return;
  }

  loadChamberProfile();
});

/* =======================================
   Main loading
======================================= */

async function loadChamberProfile() {
  if (typeof client === "undefined") {
    console.error("The Supabase client is unavailable.");
    showProfileError();
    return;
  }

  try {
    const [chamberResult, organisationResult] = await Promise.all([
      client
        .from("chambers")
        .select("*")
        .eq("organisation_id", chamberId)
        .eq("active", true)
        .single(),

      client
        .from("legal_organisations")
        .select("*")
        .eq("id", chamberId)
        .eq("organisation_type", "barristers_chambers")
        .eq("active", true)
        .single()
    ]);

    if (chamberResult.error || !chamberResult.data) {
      throw chamberResult.error || new Error("Chambers record not found.");
    }

    if (organisationResult.error || !organisationResult.data) {
      throw organisationResult.error || new Error("Organisation record not found.");
    }

    const chamber = {
      ...organisationResult.data,
      ...chamberResult.data,
      organisation_id: chamberResult.data.organisation_id,
      id: organisationResult.data.id,
      name: organisationResult.data.name,
      short_name: organisationResult.data.short_name,
      logo_url: organisationResult.data.logo_url,
      website_url: organisationResult.data.website_url,
      careers_url: organisationResult.data.careers_url,
      overview: organisationResult.data.overview,
      official_domain: organisationResult.data.official_domain,
      head_office_city: organisationResult.data.head_office_city,
      head_office_country: organisationResult.data.head_office_country,
      organisation_research_status: organisationResult.data.research_status,
      organisation_research_checked_on:
        organisationResult.data.research_checked_on,
      organisation_next_review_on:
        organisationResult.data.next_review_on
    };

    state.chamber = chamber;

    const [
      opportunities,
      practiceAreas,
      locations,
      links,
      rankings
    ] = await Promise.all([
      loadOpportunityRows(chamber.organisation_id),
      loadPracticeAreaRows(chamber.organisation_id),
      loadLocationRows(chamber.organisation_id),
      loadLinkRows(chamber.organisation_id),
      loadRankingRows(chamber.organisation_id)
    ]);

    state.opportunities = opportunities;
    state.practiceAreas = practiceAreas;
    state.locations = locations;
    state.links = links;
    state.rankings = rankings;

    renderHeader(chamber);
    renderOverview();
    renderOpportunityFilters();
    renderOpportunities();
    renderPracticeAreas();
    renderLocations();
    renderPupillageAndTenancy();
    renderFunding();
    renderEdi();
    renderHighlights();
    renderLinksAndSocials();

    hideLoadingAndShowProfile();
  } catch (error) {
    console.error("Unable to load chambers profile:", error);
    showProfileError();
  }
}

async function loadOpportunityRows(organisationId) {
  const api = window.VacatoryOpportunityData;

  if (!api?.loadProviderOpportunities) {
    throw new Error(
      "Load opportunity-data.js before chamber-profile.js."
    );
  }

  const opportunities = await api.loadProviderOpportunities({
    client,
    providerId: organisationId,
    includeSearchIndex: true
  });

  return deduplicateObjects(
    opportunities.map(chamberCanonicalOpportunityView),
    row => String(row.id || row.slug)
  ).sort((a, b) =>
    Number(a.display_order || 0) - Number(b.display_order || 0)
  );
}

/* VACATORY_CANONICAL_CHAMBER_PROFILE_FOUNDATION_20260817
   career_opportunities_public_view is the sole public opportunity boundary.
   This adapter preserves the established chamber tabs and presentation while
   the renderer is migrated away from the legacy vacation_schemes shape. */
function chamberCanonicalUniqueText(values) {
  return [
    ...new Set(
      (values || [])
        .flat()
        .map(value => String(value || "").trim())
        .filter(Boolean)
    )
  ].join("\n");
}

function chamberCanonicalCycleText(opportunity, field) {
  return chamberCanonicalUniqueText([
    opportunity?.[field],
    ...(opportunity?.cycles || []).map(cycle => cycle?.[field])
  ]);
}

function chamberCanonicalCompensation(opportunity) {
  const api = window.VacatoryOpportunityData;
  const values = (opportunity?.compensation || [])
    .map(item => api.formatCompensation(item))
    .filter(Boolean);

  if (!values.length) {
    values.push(
      opportunity?.primaryCompensation?.text,
      opportunity?.primaryCompensation?.details
    );
  }

  return chamberCanonicalUniqueText(values);
}

function chamberCanonicalOpportunityView(opportunity) {
  const cycleTiming = chamberCanonicalUniqueText(
    (opportunity.cycles || []).flatMap(cycle => [
      cycle.applicationDatesText,
      cycle.programmeDatesText
    ])
  );
  const expenses = chamberCanonicalUniqueText([
    chamberCanonicalCycleText(opportunity, "expensesText"),
    chamberCanonicalCycleText(opportunity, "travelSupportText"),
    chamberCanonicalCycleText(opportunity, "accommodationSupportText")
  ]);
  const compensation = chamberCanonicalCompensation(opportunity);
  const statusNote = chamberCanonicalUniqueText([
    opportunity.raw?.source_status_note,
    ...(opportunity.cycles || []).map(
      cycle => cycle.raw?.source_status_note
    )
  ]);

  return {
    id: opportunity.opportunityId,
    source_opportunity_id: opportunity.sourceOpportunityId,
    slug: opportunity.opportunitySlug,
    public_title: opportunity.publicTitle,
    scheme_name: opportunity.publicTitle,
    scheme_type: opportunity.opportunityTypeLabel,
    card_summary: opportunity.publicSummary,
    student_summary: opportunity.publicSummary,
    delivery_mode: opportunity.deliveryMode,
    location:
      opportunity.publicLocationLabel ||
      opportunity.locationSummary,
    countries: opportunity.countries || [],
    cities: opportunity.cities || [],
    country: (opportunity.countries || [])[0] || "",
    application_open_date: opportunity.opensOn,
    application_close_date: opportunity.closesOn,
    programme_start_date: opportunity.programmeStartsOn,
    programme_end: opportunity.programmeEndsOn,
    programme_dates_text: chamberCanonicalUniqueText([
      opportunity.programmeDatesText,
      cycleTiming
    ]),
    duration: opportunity.durationText,
    status: opportunity.publicApplicationStatus,
    status_note: statusNote,
    cycle_year:
      opportunity.applicationYear ||
      opportunity.programmeYear ||
      opportunity.intakeYear,
    eligibility: chamberCanonicalUniqueText([
      chamberCanonicalCycleText(opportunity, "audienceText"),
      chamberCanonicalCycleText(opportunity, "eligibilityText")
    ]),
    year_of_study_requirements:
      chamberCanonicalCycleText(opportunity, "studyStageText"),
    academic_requirements:
      chamberCanonicalCycleText(opportunity, "academicCriteria"),
    application_process:
      chamberCanonicalCycleText(opportunity, "applicationProcessText"),
    assessment_formats:
      chamberCanonicalCycleText(opportunity, "assessmentsText"),
    programme_structure:
      chamberCanonicalCycleText(opportunity, "programmeStructureText"),
    progression_route:
      chamberCanonicalCycleText(opportunity, "progressionRouteText"),
    pay_details: compensation,
    salary: compensation,
    sponsorship:
      chamberCanonicalCycleText(opportunity, "fundingText"),
    expenses,
    right_to_work_requirements:
      chamberCanonicalCycleText(opportunity, "rightToWorkText"),
    disability_support:
      chamberCanonicalCycleText(opportunity, "disabilitySupportText"),
    additional_details:
      chamberCanonicalCycleText(opportunity, "additionalDetailsText"),
    application_link:
      opportunity.applicationUrl || opportunity.officialUrl,
    source_url: opportunity.officialUrl,
    research_checked_on: opportunity.lastVerifiedOn,
    display_order: opportunity.displayOrder,
    canonical_opportunity: opportunity
  };
}

async function loadPracticeAreaRows(organisationId) {
  const { data, error } = await client
    .from("chamber_practice_areas")
    .select("*")
    .eq("organisation_id", organisationId)
    .eq("active", true)
    .order("display_order", { ascending: true })
    .order("practice_area", { ascending: true });

  if (error) {
    console.warn("Unable to load chamber practice areas:", error.message);
    return [];
  }

  return data || [];
}

async function loadLocationRows(organisationId) {
  const { data, error } = await client
    .from("organisation_locations")
    .select("*")
    .eq("organisation_id", organisationId)
    .eq("active", true)
    .order("display_order", { ascending: true });

  if (error) {
    console.warn("Unable to load chamber locations:", error.message);
    return [];
  }

  return data || [];
}

async function loadLinkRows(organisationId) {
  const { data, error } = await client
    .from("chamber_links")
    .select("*")
    .eq("organisation_id", organisationId)
    .eq("active", true)
    .order("display_order", { ascending: true });

  if (error) {
    console.warn("Unable to load chamber links:", error.message);
    return [];
  }

  return data || [];
}

async function loadRankingRows(organisationId) {
  const { data, error } = await client
    .from("chamber_rankings")
    .select("*")
    .eq("organisation_id", organisationId)
    .eq("is_current", true)
    .order("ranking_year", { ascending: false })
    .order("ranking_name", { ascending: true });

  if (error) {
    console.warn("Unable to load chamber rankings:", error.message);
    return [];
  }

  return data || [];
}

function hideLoadingAndShowProfile() {
  document.getElementById("loadingState")?.classList.add("hidden");
  document.getElementById("errorState")?.classList.add("hidden");
  document.getElementById("profileContent")?.classList.remove("hidden");
}

function showProfileError() {
  document.getElementById("loadingState")?.classList.add("hidden");
  document.getElementById("profileContent")?.classList.add("hidden");
  document.getElementById("errorState")?.classList.remove("hidden");
}

/* =======================================
   Tabs and navigation
======================================= */

function setupProfileTabs() {
  const tabs = Array.from(document.querySelectorAll(".tab-btn"));
  const panels = Array.from(document.querySelectorAll(".tab-panel"));

  tabs.forEach(tab => {
    tab.addEventListener("click", () => {
      const target = tab.dataset.tab;

      tabs.forEach(item => {
        const isActive = item === tab;
        item.classList.toggle("active", isActive);
        item.setAttribute("aria-selected", String(isActive));
        item.tabIndex = isActive ? 0 : -1;
      });

      panels.forEach(panel => {
        const isActive = panel.id === `tab-${target}`;
        panel.classList.toggle("active", isActive);
        panel.hidden = !isActive;
      });

      const activePanel = document.getElementById(`tab-${target}`);
      activePanel?.focus?.({ preventScroll: true });
    });

    tab.addEventListener("keydown", event => {
      const currentIndex = tabs.indexOf(tab);
      let nextIndex = null;

      if (event.key === "ArrowRight") {
        nextIndex = (currentIndex + 1) % tabs.length;
      }

      if (event.key === "ArrowLeft") {
        nextIndex = (currentIndex - 1 + tabs.length) % tabs.length;
      }

      if (event.key === "Home") {
        nextIndex = 0;
      }

      if (event.key === "End") {
        nextIndex = tabs.length - 1;
      }

      if (nextIndex !== null) {
        event.preventDefault();
        tabs[nextIndex].focus();
        tabs[nextIndex].click();
      }
    });
  });

  panels.forEach(panel => {
    panel.hidden = !panel.classList.contains("active");
    panel.tabIndex = -1;
  });

  tabs.forEach(tab => {
    tab.tabIndex = tab.classList.contains("active") ? 0 : -1;
  });
}

/* =======================================
   Header
======================================= */


function upsertChamberSeoMeta(attribute, key, content) {
  let element = document.head.querySelector(
    `meta[${attribute}="${key}"]`
  );

  if (!element) {
    element = document.createElement("meta");
    element.setAttribute(attribute, key);
    document.head.appendChild(element);
  }

  element.setAttribute("content", content);
}

function upsertChamberCanonical(href) {
  let element = document.head.querySelector('link[rel="canonical"]');

  if (!element) {
    element = document.createElement("link");
    element.setAttribute("rel", "canonical");
    document.head.appendChild(element);
  }

  element.setAttribute("href", href);
}

function applyChamberProfileSeo(chamber) {
  const name = String(
    chamber.name || chamber.short_name || "Barristers’ chambers"
  ).trim();

  const id = new URLSearchParams(window.location.search).get("id");

  const url = id
    ? `https://vacatory.com/chamber-profile.html?id=${encodeURIComponent(id)}`
    : "https://vacatory.com/chamber-profile.html";

  const description =
    `${name} chambers profile with practice areas, pupillage and mini-pupillage research, student opportunities, locations and official links on Vacatory.`;

  document.title = `${name} | Vacatory`;

  upsertChamberCanonical(url);

  upsertChamberSeoMeta("name", "description", description);
  upsertChamberSeoMeta("property", "og:type", "website");
  upsertChamberSeoMeta("property", "og:site_name", "Vacatory");
  upsertChamberSeoMeta("property", "og:title", `${name} | Vacatory`);
  upsertChamberSeoMeta("property", "og:description", description);
  upsertChamberSeoMeta("property", "og:url", url);

  upsertChamberSeoMeta("name", "twitter:card", "summary");
  upsertChamberSeoMeta("name", "twitter:title", `${name} | Vacatory`);
  upsertChamberSeoMeta("name", "twitter:description", description);
}

function renderHeader(chamber) {
  const name = chamber.name || chamber.short_name || "Barristers’ chambers";
  document.title = `${name} | Vacatory`;
applyChamberProfileSeo(chamber);

  const logo = document.getElementById("chambersLogo");
  const nameElement = document.getElementById("chambersName");
  const typeElement = document.getElementById("chambersType");
  const overviewElement = document.getElementById("chambersOverview");
  const metaElement = document.getElementById("chambersMeta");
  const heroActions = document.getElementById("heroActions");

  if (logo) {
    const initial = (chamber.short_name || name).trim().charAt(0).toUpperCase();

    logo.innerHTML = chamber.logo_url
      ? `
        <img
          src="${escapeHtml(chamber.logo_url)}"
          alt="${escapeHtml(name)} logo"
        >
      `
      : escapeHtml(initial);
  }

  if (nameElement) {
    nameElement.textContent = name;
  }

  if (typeElement) {
    typeElement.textContent = "";
    typeElement.hidden = true;
  }

  if (overviewElement) {
    overviewElement.textContent =
      chamber.overview ||
      chamber.practice_summary ||
      "Detailed chambers research is being added.";
  }

  if (metaElement) {
    const meta = [];
    const location = [
      chamber.head_office_city,
      chamber.head_office_country
    ].filter(Boolean).join(", ");

    if (location) {
      meta.push(metaPill(locationIcon(), location));
    }

    if (chamber.year_founded) {
      meta.push(
        metaPill(circuitIcon(), `Founded ${chamber.year_founded}`)
      );
    }

    if (state.locations.length) {
      meta.push(
        metaPill(
          buildingIcon(),
          `${state.locations.length} location${
            state.locations.length === 1 ? "" : "s"
          }`
        )
      );
    }

    if (chamber.pupillage_gateway_member) {
      meta.push(metaPill(linkIcon(), "Pupillage Gateway member"));
    }

    metaElement.innerHTML = meta.join("");
  }

  if (heroActions) {
    const actions = [];

    if (chamber.website_url) {
      actions.push(
        heroAction(chamber.website_url, "Official website", false)
      );
    }

    if (chamber.careers_url) {
      actions.push(
        heroAction(chamber.careers_url, "Careers", true)
      );
    }

    const gatewayUrl =
      chamber.pupillage_gateway_url ||
      findLinkUrlByTypes(["application_portal"]);

    if (gatewayUrl) {
      actions.push(
        heroAction(gatewayUrl, "Pupillage Gateway", false)
      );
    }

    heroActions.innerHTML = deduplicateStrings(actions).join("");
  }
}

/* =======================================
   Overview
======================================= */

function renderOverview() {
  const loading = document.getElementById("atGlanceLoading");
  const panel = document.getElementById("atGlancePanel");
  const evidence = document.getElementById("atGlanceEvidence");
  const grid = document.getElementById("atGlanceGrid");
  const researchGrid = document.getElementById("overviewResearchGrid");
  const deadlines = document.getElementById("overviewDeadlines");

  if (!state.chamber || !grid || !researchGrid || !deadlines) {
    return;
  }

  const chamber = state.chamber;
  const opportunities = state.opportunities;
  const futureDated = opportunities
    .filter(row => isFutureOrToday(getClosingDate(row)))
    .sort((a, b) => dateValue(getClosingDate(a)) - dateValue(getClosingDate(b)));

  const currentlyOpen = opportunities.filter(isOpportunityOpenNow);
  const types = uniqueCleanPoints(
    opportunities.map(row => displayOpportunityType(row))
  );

  const locationNames = uniqueCleanPoints(
    state.locations.map(row =>
      row.location_name || row.city || row.region || row.country
    )
  );

  const adjustmentRows = opportunities.filter(row =>
    hasText(row.disability_support)
  );

  const cards = [];

  if (futureDated.length) {
    const next = futureDated[0];
    cards.push(
      glanceCard(
        "Next deadline",
        formatDate(getClosingDate(next)),
        next.scheme_name || "Application deadline",
        "confirmed"
      )
    );
  } else {
    cards.push(
      glanceCard(
        "Next deadline",
        "No future closing date published",
        "Check the Opportunities tab for standing routes and dates awaiting publication.",
        "unpublished"
      )
    );
  }

  cards.push(
    glanceCard(
      "Open applications",
      String(currentlyOpen.length),
      currentlyOpen.length
        ? currentlyOpen
            .slice(0, 2)
            .map(row => row.scheme_name)
            .filter(Boolean)
            .join(" · ")
        : "No application window is open today.",
      currentlyOpen.length ? "confirmed" : "unpublished"
    )
  );

  cards.push(
    glanceCard(
      "Researched routes",
      String(opportunities.length),
      types.slice(0, 4).join(" · ") || "No routes published",
      opportunities.length ? "verified" : "unpublished"
    )
  );
  cards.push(
    glanceCard(
      "Locations",
      String(state.locations.length || 1),
      locationNames.join(" · ") ||
        [
          chamber.head_office_city,
          chamber.head_office_country
        ].filter(Boolean).join(", "),
      "verified"
    )
  );

  cards.push(
    glanceCard(
      "Practice areas",
      String(state.practiceAreas.length),
      state.practiceAreas
        .filter(area => area.featured)
        .slice(0, 3)
        .map(area => area.practice_area)
        .join(" · ") || "See the full official inventory.",
      state.practiceAreas.length ? "verified" : "unpublished"
    )
  );

  if (chamber.member_count !== null && chamber.member_count !== undefined) {
    cards.push(
      glanceCard(
        "Members",
        String(chamber.member_count),
        chamber.pupil_count !== null && chamber.pupil_count !== undefined
          ? `${chamber.pupil_count} pupil${
              Number(chamber.pupil_count) === 1 ? "" : "s"
            } recorded`
          : "Published member total",
        "confirmed"
      )
    );
  }

  cards.push(
    glanceCard(
      "Adjustments and access",
      adjustmentRows.length || hasAccessibilityInformation() ? "Published" : "Check directly",
      adjustmentRows.length
        ? "Opportunity-specific disability and adjustment information is recorded."
        : hasAccessibilityInformation()
          ? "Location or EDI accessibility information is available."
          : "No specific adjustment wording is stored yet.",
      adjustmentRows.length || hasAccessibilityInformation()
        ? "verified"
        : "unpublished"
    )
  );

  grid.innerHTML = cards.join("");

  if (evidence) {
    const checkedOn =
      chamber.organisation_research_checked_on ||
      chamber.research_checked_on;

    const nextReview =
      chamber.organisation_next_review_on ||
      chamber.next_review_on;

    evidence.innerHTML = `
      <span class="evidence-date">
        <strong>Research checked:</strong>
        ${escapeHtml(formatDate(checkedOn) || "Date not recorded")}
      </span>

      <span class="evidence-badge ${
        normaliseStatusClass(chamber.organisation_research_status)
      }">
        ${escapeHtml(
          formatStatus(
            chamber.organisation_research_status ||
            chamber.research_status ||
            "Research in progress"
          )
        )}
      </span>

      ${
        nextReview
          ? `
            <span class="evidence-date">
              <strong>Next review:</strong>
              ${escapeHtml(formatDate(nextReview))}
            </span>
          `
          : ""
      }
    `;
  }

  researchGrid.innerHTML = buildOverviewResearchCards();
  deadlines.innerHTML = buildDeadlinePreview(futureDated);

  loading?.classList.add("hidden");
  panel?.classList.remove("hidden");
}

function buildOverviewResearchCards() {
  const chamber = state.chamber;
  const cards = [];

  if (chamber.pupillage_overview) {
    cards.push(
      overviewSummaryCard(
        "Pupillage",
        chamber.pupillage_overview,
        "Open the Pupillage & tenancy tab for structure and progression."
      )
    );
  }

  if (chamber.mini_pupillage_overview) {
    cards.push(
      overviewSummaryCard(
        "Mini-pupillage",
        chamber.mini_pupillage_overview,
        "Open the Opportunities tab for each route and application window."
      )
    );
  }

  if (chamber.tenancy_overview) {
    cards.push(
      overviewSummaryCard(
        "Tenancy",
        chamber.tenancy_overview,
        "Published progression information is kept separate from application details."
      )
    );
  }

  const internationalText = buildInternationalSummary();

  if (internationalText) {
    cards.push(
      overviewSummaryCard(
        "International opportunities",
        internationalText,
        "International legal work is not treated as a student opportunity unless a distinct route is officially published."
      )
    );
  }

  return cards.length
    ? cards.join("")
    : emptyMessage("Overview research has not yet been added.");
}

function buildInternationalSummary() {
  const text = state.opportunities
    .map(row => row.additional_details)
    .find(value =>
      hasText(value) &&
      /international|overseas|visa/i.test(String(value))
    );

  if (text) {
    return text;
  }

  const hasInternationalLocation = state.locations.some(location =>
    location.country &&
    !/united kingdom|england|wales|scotland|northern ireland/i.test(
      location.country
    )
  );

  if (hasInternationalLocation) {
    return "The chambers has at least one location outside the United Kingdom. Check each opportunity record for any location-specific eligibility.";
  }

  return "No separate overseas office or dedicated international student recruitment route is recorded in the current official-source audit.";
}

function buildDeadlinePreview(rows) {
  if (!rows.length) {
    return emptyMessage(
      "No future application closing date is currently published. Standing and closed routes remain available in the Opportunities tab for research."
    );
  }

  return rows.slice(0, 5).map(row => `
    <article class="deadline-preview-card">
      <div class="deadline-preview-date">
        ${escapeHtml(formatDate(getClosingDate(row)))}
      </div>

      <div class="deadline-preview-copy">
        <h4>${escapeHtml(row.scheme_name || displayOpportunityType(row))}</h4>
        <p>
          ${escapeHtml(
            [row.location, displayOpportunityType(row)]
              .filter(Boolean)
              .join(" · ")
          )}
        </p>
      </div>

      <span class="deadline-preview-status">
        ${escapeHtml(formatStatus(row.status || "Upcoming"))}
      </span>
    </article>
  `).join("");
}

/* =======================================
   Opportunities
======================================= */

/* VACATORY_COUNTRY_TYPE_FILTERS_20260813 */

function publicChamberCountryLabel(value) {
  const text = String(value || "")
    .replace(/\s+/g, " ")
    .trim();

  if (!text) {
    return "";
  }

  const known = {
    "uk": "United Kingdom",
    "u.k.": "United Kingdom",
    "united_kingdom": "United Kingdom",
    "united_states": "United States",
    "uae": "United Arab Emirates",
    "united_arab_emirates": "United Arab Emirates",
    "hong_kong": "Hong Kong",
    "new_zealand": "New Zealand",
    "south_africa": "South Africa",
    "republic_of_ireland": "Ireland"
  };

  const lower = text.toLowerCase();

  if (known[lower]) {
    return known[lower];
  }

  if (text.includes("_")) {
    return text
      .split("_")
      .filter(Boolean)
      .map((word, index) => {
        const lowerWord = word.toLowerCase();

        if (
          index > 0 &&
          ["and", "of", "the"].includes(lowerWord)
        ) {
          return lowerWord;
        }

        return (
          lowerWord.charAt(0).toUpperCase() +
          lowerWord.slice(1)
        );
      })
      .join(" ");
  }

  return text;
}


const chamberCountryCodes=(
  "AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ " +
  "BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ " +
  "CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ " +
  "DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR " +
  "GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY " +
  "HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP " +
  "KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY " +
  "MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ " +
  "NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY " +
  "QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ " +
  "TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ " +
  "VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW"
).split(/\s+/);

function chamberCountryKey(value){
  return String(value||"")
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g,"")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g," ")
    .replace(/\s+/g," ")
    .trim();
}

const chamberCountryLookup=(()=>{
  const map=new Map();

  if(
    typeof Intl!=="undefined" &&
    Intl.DisplayNames
  ){
    const names=new Intl.DisplayNames(
      ["en-GB"],
      {type:"region"}
    );

    chamberCountryCodes.forEach(code=>{
      const name=names.of(code);

      if(name){
        map.set(
          chamberCountryKey(name),
          name
        );
      }
    });
  }

  const aliases={
    "uk":"United Kingdom",
    "u k":"United Kingdom",
    "great britain":"United Kingdom",
    "britain":"United Kingdom",
    "england":"United Kingdom",
    "wales":"United Kingdom",
    "scotland":"United Kingdom",
    "northern ireland":"United Kingdom",
    "england and wales":"United Kingdom",

    "us":"United States",
    "u s":"United States",
    "usa":"United States",
    "united states of america":"United States",

    "uae":"United Arab Emirates",
    "u a e":"United Arab Emirates",

    "republic of ireland":"Ireland",

    "the netherlands":"Netherlands",

    "hong kong":"Hong Kong",
    "hong kong sar":"Hong Kong",
    "hong kong s a r":"Hong Kong",
    "hong kong sar china":"Hong Kong",

    "czech republic":"Czechia",

    "south korea":"South Korea",
    "republic of korea":"South Korea",

    "turkey":"Türkiye"
  };

  Object.entries(aliases).forEach(
    ([key,value])=>map.set(key,value)
  );

  return map;
})();

function chamberCanonicalCountry(value){
  return chamberCountryLookup.get(
    chamberCountryKey(value)
  )||"";
}

function chamberOpportunityCountry(row) {
  for (const value of row?.countries || []) {
    const country = chamberCanonicalCountry(value);

    if (country) {
      return country;
    }
  }

  const explicit = [
    row?.country,
    row?.country_text,
    row?.country_name,
    row?.location_country,
    row?.office_country,
    row?.jurisdiction
  ];

  for (const value of explicit) {
    const country =
      chamberCanonicalCountry(value);

    if (country) {
      return country;
    }
  }

  const title = String(
    row?.scheme_name ||
    row?.opportunity_name ||
    row?.programme_name ||
    row?.title ||
    ""
  ).trim();

  const match = title.match(
    /^(.{2,60}?)\s+[-–—]\s+/
  );

  if (!match) {
    return "";
  }

  /*
   * Title fallback is permitted only when the prefix
   * validates as a real country.
   */
  return chamberCanonicalCountry(
    match[1]
  );
}


function chamberResolvedOpportunityCountry(row){
  const existing=
    chamberOpportunityCountry(row);

  if(existing)return existing;

  const location=String(
    row?.location||""
  ).trim();

  /*
   * Resolve a city such as London through chambers'
   * researched location records. The result is still passed
   * through the country validator, so a city cannot leak into
   * the Country dropdown.
   */
  for(const office of state.locations){
    const city=String(
      office.city||
      office.location_name||
      office.office_name||
      ""
    ).trim();

    const country=
      chamberCanonicalCountry(
        office.country||
        office.country_name||
        office.jurisdiction
      );

    if(
      city&&
      country&&
      (
        chamberCountryKey(location)===
          chamberCountryKey(city)||
        (` ${chamberCountryKey(location)} `).includes(
          ` ${chamberCountryKey(city)} `
        )
      )
    ){
      return country
    }
  }

  const countries=[
    ...new Set(
      [
        ...state.locations.map(office=>
          chamberCanonicalCountry(
            office.country||
            office.country_name||
            office.jurisdiction
          )
        ),
        chamberCanonicalCountry(
          state.chamber?.head_office_country
        )
      ].filter(Boolean)
    )
  ];

  return countries.length===1
    ?countries[0]
    :""
}

function chamberOpportunityCityLabel(e,t){
  let n=String(e?.location||"")
    .replace(/\s+/g," ")
    .trim();

  if(!n)return"";

  if(
    /^(?:global|international|online|virtual|remote)$/i.test(n)||
    chamberCountryKey(n)===chamberCountryKey(t)||
    /\b(?:offices?|countrywide|nationwide|various locations?|multiple locations?|office not specified)\b/i.test(n)
  ){
    return"";
  }

  n=n
    .replace(/\s+with\b.*$/i,"")
    .replace(/\bThe Netherlands\b/gi,"Netherlands")
    .replace(/\bRepublic of Ireland\b/gi,"Ireland")
    .replace(
      /\bUnited States of America\b/gi,
      "United States"
    )
    .replace(
      /\bHong Kong SAR(?:,?\s*China)?\b/gi,
      "Hong Kong"
    )
    .replace(/\bCzech Republic\b/gi,"Czechia")
    .replace(
      /\bRepublic of Korea\b/gi,
      "South Korea"
    )
    .replace(/\s+/g," ")
    .trim();

  return n;
}

function chamberFilterCityOnly(value) {
  const parts = String(value || "")
    .replace(/\s+/g, " ")
    .trim()
    .split(",")
    .map(part => part.trim())
    .filter(Boolean);

  if (!parts.length) {
    return "";
  }

  if (
    parts.length > 1 &&
    /^d\.?\s*c\.?$/i.test(parts[1])
  ) {
    return `${parts[0]} DC`;
  }

  return parts[0];
}

function chamberFilterOfficeRows() {
  const seen = new Set();
  const result = [];

  const sourceRows = [
    ...state.locations,
    {
      city: state.chamber?.head_office_city,
      country: state.chamber?.head_office_country
    }
  ];

  sourceRows.forEach(office => {
    const country =
      chamberCanonicalCountry(
        office?.country
      );

    /*
     * Only structured city data is used here.
     */
    const city =
      chamberFilterCityOnly(
        office?.city
      );

    if (!country || !city) {
      return;
    }

    const key =
      `${chamberCountryKey(country)}|` +
      `${chamberCountryKey(city)}`;

    if (seen.has(key)) {
      return;
    }

    seen.add(key);

    result.push({
      country,
      city
    });
  });

  return result;
}

function chamberFilterLocationLabel(
  country,
  city
) {
  if (!country || !city) {
    return "";
  }

  if (
    chamberCountryKey(country) ===
    chamberCountryKey(city)
  ) {
    return country;
  }

  return `${country}, ${city}`;
}

function chamberLocationTextContainsCity(
  locationText,
  city
) {
  const haystack =
    ` ${chamberCountryKey(locationText)} `;

  const needle =
    ` ${chamberCountryKey(city)} `;

  return Boolean(
    needle.trim() &&
    haystack.includes(needle)
  );
}

function chamberLooksLikeNonCity(value) {
  return /(?:\d|\b(?:building|tower|street|road|avenue|boulevard|square|wharf|district|quarter|campus|office|centre|center|quay|harbour|harbor|docklands|business park|industrial park|manhattan|zuidas|canary wharf|city of london|la défense|la defense)\b)/i
    .test(String(value || ""));
}

function chamberOpportunityFilterLocations(row) {
  const structuredCountries = (row?.countries || [])
    .map(chamberCanonicalCountry)
    .filter(Boolean);
  const structuredCities = (row?.cities || [])
    .map(value => String(value || "").trim())
    .filter(Boolean);

  if (structuredCountries.length || structuredCities.length) {
    const countries = structuredCountries.length
      ? structuredCountries
      : [""];
    const labels = countries.flatMap(country =>
      structuredCities.length
        ? structuredCities.map(city =>
            chamberFilterLocationLabel(country, city)
          )
        : [chamberFilterLocationLabel(country, "")]
    );

    return uniqueCleanPoints(labels.filter(Boolean));
  }

  const country =
    chamberResolvedOpportunityCountry(row);

  const rawLocation =
    String(row?.location || "")
      .replace(/\s+/g, " ")
      .trim();

  const offices =
    chamberFilterOfficeRows();

  const eligibleOffices =
    country
      ? offices.filter(
          office =>
            office.country === country
        )
      : offices;

  const matched =
    eligibleOffices.filter(
      office =>
        chamberLocationTextContainsCity(
          rawLocation,
          office.city
        )
    );

  if (matched.length) {
    return [
      ...new Set(
        matched
          .map(office =>
            chamberFilterLocationLabel(
              office.country,
              office.city
            )
          )
          .filter(Boolean)
      )
    ];
  }

  const fallbackText =
    chamberOpportunityCityLabel(
      row,
      country
    );

  const candidates =
    String(fallbackText || "")
      .split(",")
      .map(part => part.trim())
      .filter(Boolean)
      .filter(
        part =>
          !country ||
          chamberCountryKey(part) !==
            chamberCountryKey(country)
      );

  let city =
    candidates.find(
      candidate =>
        !chamberLooksLikeNonCity(candidate)
    ) || "";

  city =
    chamberFilterCityOnly(city);

  const label =
    chamberFilterLocationLabel(
      country,
      city
    );

  return label
    ? [label]
    : [];
}

function chamberEscapeOpportunityGeo(value){
  return String(value||"")
    .replace(/[.*+?^${}()|[\]\\]/g,"\\$&");
}

function chamberOpportunityCoreName(
  row,
  country,
  city
){
  let name=String(
    row?.scheme_name||
    row?.opportunity_name||
    row?.programme_name||
    row?.title||
    displayOpportunityType(row)||
    "Opportunity"
  )
    .replace(/[–—]/g," - ")
    .replace(/\s+/g," ")
    .trim();

  const terms=[
    country,
    city,
    ...(country==="United Kingdom"
      ?[
        "United Kingdom",
        "UK",
        "England",
        "Wales",
        "Scotland",
        "Northern Ireland",
        "England and Wales"
      ]
      :[])
  ].filter(Boolean);

  let pieces=name
    .split(/\s+-\s+/)
    .map(piece=>piece.trim())
    .filter(Boolean);

  pieces=pieces.filter(piece=>
    !terms.some(term=>
      chamberCountryKey(piece)===
        chamberCountryKey(term)
    )
  );

  name=pieces.join(" - ").trim();

  [...terms]
    .sort((a,b)=>b.length-a.length)
    .forEach(term=>{
      const escaped=
        chamberEscapeOpportunityGeo(term);

      name=name
        .replace(
          new RegExp(
            `^${escaped}\\s*(?:[-:]\\s*)?`,
            "i"
          ),
          ""
        )
        .replace(
          new RegExp(
            `\\s*(?:[-:]\\s*)?${escaped}$`,
            "i"
          ),
          ""
        )
        .trim();
    });

  return name||
    displayOpportunityType(row)||
    "Opportunity";
}

function chamberPublicOpportunityTitle(row){
  if(row?.public_title){
    return String(row.public_title).trim();
  }

  const country=
    chamberResolvedOpportunityCountry(row);

  const city=
    chamberOpportunityCityLabel(
      row,
      country
    );

  const opportunity=
    chamberOpportunityCoreName(
      row,
      country,
      city
    );

  const parts=[];

  if(country){
    parts.push(country);
  }

  if(
    city&&
    chamberCountryKey(city)!==
      chamberCountryKey(country)
  ){
    parts.push(city);
  }

  parts.push(opportunity);

  return parts
    .filter(Boolean)
    .filter(
      (part,index,array)=>
        array.findIndex(other=>
          chamberCountryKey(other)===
            chamberCountryKey(part)
        )===index
    )
    .join(" - ");
}

function renderOpportunityFilters() {
  const container = document.getElementById(
    "opportunityFilters"
  );

  if (!container) {
    return;
  }

  if (!state.opportunities.length) {
    container.innerHTML = "";
    return;
  }

  const countries = uniqueCleanPoints(
    state.opportunities
      .flatMap(chamberOpportunityFilterLocations)
      .filter(Boolean)
  ).sort((a, b) =>
    a.localeCompare(b, "en-GB")
  );

  const types = uniqueCleanPoints(
    state.opportunities
      .map(row => displayOpportunityType(row))
      .filter(Boolean)
  ).sort((a, b) =>
    a.localeCompare(b, "en-GB")
  );

  container.innerHTML = `
    <div
      class="chamber-opportunity-filter-panel"
      aria-label="Filter opportunities"
    >
      <div class="chamber-opportunity-filter-grid">

        <div class="chamber-opportunity-filter-control">
          <label for="chamberOpportunityLocationFilter">
            Location
          </label>

          <select id="chamberOpportunityLocationFilter">
            <option value="">All locations</option>

            ${countries.map(country => `
              <option
                value="${escapeHtml(country)}"
                ${
                  country === state.opportunityLocationFilter
                    ? "selected"
                    : ""
                }
              >
                ${escapeHtml(country)}
              </option>
            `).join("")}
          </select>
        </div>

        <div class="chamber-opportunity-filter-control">
          <label for="chamberOpportunityTypeFilter">
            Type
          </label>

          <select id="chamberOpportunityTypeFilter">
            <option value="">All types</option>

            ${types.map(type => `
              <option
                value="${escapeHtml(type)}"
                ${
                  type === state.opportunityTypeFilter
                    ? "selected"
                    : ""
                }
              >
                ${escapeHtml(type)}
              </option>
            `).join("")}
          </select>
        </div>

        <button
          id="chamberOpportunityFilterReset"
          class="secondary-btn chamber-opportunity-filter-reset"
          type="button"
          ${
            state.opportunityLocationFilter ||
            state.opportunityTypeFilter
              ? ""
              : "hidden"
          }
        >
          Reset
        </button>

      </div>
    </div>
  `;

  const countrySelect =
    document.getElementById(
      "chamberOpportunityLocationFilter"
    );

  const typeSelect =
    document.getElementById(
      "chamberOpportunityTypeFilter"
    );

  const reset =
    document.getElementById(
      "chamberOpportunityFilterReset"
    );

  countrySelect?.addEventListener(
    "change",
    () => {
      state.opportunityLocationFilter =
        countrySelect.value;

      renderOpportunityFilters();
      renderOpportunities();
    }
  );

  typeSelect?.addEventListener(
    "change",
    () => {
      state.opportunityTypeFilter =
        typeSelect.value;

      renderOpportunityFilters();
      renderOpportunities();
    }
  );

  reset?.addEventListener(
    "click",
    () => {
      state.opportunityLocationFilter = "";
      state.opportunityTypeFilter = "";

      renderOpportunityFilters();
      renderOpportunities();

      document.getElementById(
        "chamberOpportunityLocationFilter"
      )?.focus();
    }
  );
}function renderOpportunities() {
  const list = document.getElementById("opportunitiesList");
  const loading = document.getElementById("opportunitiesLoading");
  const empty = document.getElementById("opportunitiesEmpty");

  if (!list) {
    return;
  }

  const rows = state.opportunities
    .filter(row => {
      if (
        state.opportunityLocationFilter&&!chamberOpportunityFilterLocations(row).includes(state.opportunityLocationFilter)
      ) {
        return false;
      }

      if (
        state.opportunityTypeFilter &&
        displayOpportunityType(row) !==
          state.opportunityTypeFilter
      ) {
        return false;
      }

      return true;
    })
    .sort(sortOpportunityRows);

  loading?.classList.add("hidden");

  if (!rows.length) {
    list.innerHTML = "";

    if (empty) {
      empty.textContent =
        state.opportunityLocationFilter ||
        state.opportunityTypeFilter
          ? "No opportunities match these filters."
          : "No opportunities have been added for this chambers yet.";

      empty.dataset.vacatoryDeferredState = "confirmed-empty";
      empty.classList.remove("hidden");
    }

    return;
  }

  empty?.classList.add("hidden");

  list.innerHTML = rows
    .map(row =>
      renderOpportunityCard({
        ...row,
        scheme_name:
          chamberPublicOpportunityTitle(row)
      })
    )
    .join("");
}function renderOpportunityCard(row) {
  const closingDate = getClosingDate(row);
  const deadlineLabel = closingDate
    ? formatDate(closingDate)
    : "Not published";

  const summary =
    row.card_summary ||
    row.student_summary ||
    row.status_note ||
    "";

  const facts = [
    opportunityFact("Applications open", formatDate(getOpeningDate(row))),
    opportunityFact("Closing date", formatDate(closingDate)),
    opportunityFact("Programme dates", getProgrammeDates(row)),
    opportunityFact("Duration", row.duration),
    opportunityFact("Location", row.location),
    opportunityFact("Delivery", formatStatus(row.delivery_mode)),
    opportunityFact("Award or payment", row.pay_details || row.salary),
    opportunityFact("Status", formatStatus(row.status)),
    opportunityFact("Cycle", row.cycle_year ? String(row.cycle_year) : "")
  ].filter(Boolean).join("");

  const detailSections = [
    detailSection("Who can apply", [
      row.eligibility,
      row.year_of_study_requirements,
      row.degree_requirements,
      row.academic_requirements
    ]),

    detailSection("Application process", [
      row.application_process,
      row.application_link
        ? "An official application or opportunity link is provided below."
        : ""
    ]),

    detailSection("Assessments and interviews", [
      row.assessment_formats,
      row.assessments,
      row.interview_dates
    ]),

    detailSection("Programme structure", [
      row.programme_structure,
      row.programme_dates_text,
      row.programme_dates
    ]),

    detailSection("Progression", [
      row.progression_route,
      row.training_contract_route &&
      row.training_contract_route !== "not_applicable"
        ? formatStatus(row.training_contract_route)
        : ""
    ]),

    detailSection("Funding, expenses and support", [
      row.pay_details,
      row.salary,
      row.expenses,
      row.sponsorship
    ]),

    detailSection("Right to work and visa information", [
      row.right_to_work_requirements,
      row.visa_requirements,
      row.visa_information
    ]),

    detailSection("Disability support and adjustments", [
      row.disability_support
    ]),

    detailSection("Further official information", [
      row.additional_details,
      row.status_note
    ])
  ].filter(Boolean).join("");

  const officialUrl =
    row.application_link ||
    row.source_url ||
    state.chamber.careers_url ||
    state.chamber.website_url;

  return `
    <details class="opportunity-item">
      <summary class="opportunity-summary">
        <div class="opportunity-deadline ${
          closingDate ? "" : "muted"
        }">
          <span>Closing</span>
          <strong>${escapeHtml(deadlineLabel)}</strong>
        </div>

        <div class="opportunity-summary-main">
          <h3>${escapeHtml(
            row.scheme_name || displayOpportunityType(row)
          )}</h3>

          ${
            summary
              ? `<p class="opportunity-card-summary">${escapeHtml(summary)}</p>`
              : ""
          }

          <div class="opportunity-summary-meta">
            <span>
              <strong>Type:</strong>
              ${escapeHtml(displayOpportunityType(row))}
            </span>

            ${
              row.location
                ? `
                  <span>
                    <strong>Location:</strong>
                    ${escapeHtml(row.location)}
                  </span>
                `
                : ""
            }

            ${
              getProgrammeDates(row)
                ? `
                  <span>
                    <strong>Programme:</strong>
                    ${escapeHtml(getProgrammeDates(row))}
                  </span>
                `
                : ""
            }
          </div>

          ${
            row.status
              ? `
                <span class="opportunity-status-pill">
                  ${escapeHtml(formatStatus(row.status))}
                </span>
              `
              : ""
          }
        </div>

        <span class="opportunity-chevron" aria-hidden="true">
          ${chevronIcon()}
        </span>
      </summary>

      <div class="opportunity-expanded">
        ${
          facts
            ? `<div class="opportunity-facts">${facts}</div>`
            : ""
        }

        ${
          detailSections
            ? `
              <div class="opportunity-detail-sections">
                ${detailSections}
              </div>
            `
            : `
              <p class="opportunity-no-details">
                Further details have not yet been published.
              </p>
            `
        }

        ${
          officialUrl
            ? `
              <div class="opportunity-link-panel">
                ${profileLink(
                  officialUrl,
                  row.application_link
                    ? "Open official application or opportunity page"
                    : "Open official source",
                  `Official opportunity page — ${row.scheme_name || displayOpportunityType(row)}`
                )}
              </div>
            `
            : ""
        }
      </div>
    </details>
  `;
}

function sortOpportunityRows(first, second) {
  const firstDate = getClosingDate(first);
  const secondDate = getClosingDate(second);
  const firstGroup = dateSortGroup(firstDate);
  const secondGroup = dateSortGroup(secondDate);

  if (firstGroup !== secondGroup) {
    return firstGroup - secondGroup;
  }

  const firstValue = dateValue(firstDate);
  const secondValue = dateValue(secondDate);

  if (firstGroup === 2) {
    return secondValue - firstValue;
  }

  if (firstValue !== secondValue) {
    return firstValue - secondValue;
  }

  return String(first.scheme_name || "").localeCompare(
    String(second.scheme_name || "")
  );
}

function opportunityFilterGroup(row) {
  const type = displayOpportunityType(row).toLowerCase();

  if (type.includes("pupillage") && !type.includes("mini")) {
    return "Pupillage";
  }

  if (type.includes("mini-pupillage")) {
    return "Mini-pupillage";
  }

  if (
    type.includes("tenancy") ||
    type.includes("third-six") ||
    type.includes("third six")
  ) {
    return "Post-pupillage";
  }

  if (
    type.includes("school") ||
    type.includes("outreach") ||
    type.includes("work experience")
  ) {
    return "Access and experience";
  }

  return "Other routes";
}

/* =======================================
   Practice areas
======================================= */

function renderPracticeAreas() {
  const container = document.getElementById("practiceAreasList");

  if (!container) {
    return;
  }

  if (!state.practiceAreas.length) {
    container.innerHTML = emptyMessage(
      "No official practice-area inventory has been added yet."
    );
    return;
  }

  const grouped = new Map();

  state.practiceAreas.forEach(area => {
    const group = inferPracticeAreaGroup(area);

    if (!grouped.has(group)) {
      grouped.set(group, []);
    }

    grouped.get(group).push(area);
  });

  container.innerHTML = Array.from(grouped.entries())
    .map(([group, rows], index) => `
      <details class="practice-area-group" ${index === 0 ? "open" : ""}>
        <summary class="practice-group-summary">
          <div class="practice-group-copy">
            <span class="practice-group-label">Official inventory</span>
            <h3>${escapeHtml(group)}</h3>
            <p>
              ${escapeHtml(
                `${rows.length} practice area${rows.length === 1 ? "" : "s"}`
              )}
            </p>
          </div>

          <span class="practice-group-action" aria-hidden="true"></span>
        </summary>

        <div class="practice-group-expanded">
          ${rows.map(area => `
            <article class="practice-area-card">
              <div class="practice-area-title-row">
                <h4>${escapeHtml(area.practice_area)}</h4>
                ${
                  area.featured
                    ? `<span class="featured-tag">Featured</span>`
                    : ""
                }
              </div>

              ${
                area.student_summary || area.description
                  ? `
                    <p>
                      ${escapeHtml(
                        area.student_summary || area.description
                      )}
                    </p>
                  `
                  : ""
              }

              ${
                area.source_url
                  ? `
                    <div class="research-source-row">
                      ${profileLink(area.source_url, "Official practice-area source", `Official practice-area source — ${area.practice_area}`)}
                    </div>
                  `
                  : ""
              }
            </article>
          `).join("")}
        </div>
      </details>
    `)
    .join("");
}

function inferPracticeAreaGroup(area) {
  const source = `${area.source_title || ""} ${area.source_url || ""}`.toLowerCase();

  if (source.includes("brighton")) {
    return "Brighton";
  }

  if (source.includes("london")) {
    return "London";
  }

  return "Chambers-wide";
}

/* =======================================
   Locations
======================================= */

function renderLocations() {
  const container = document.getElementById("locationsList");

  if (!container) {
    return;
  }

  const rows = [...state.locations];

  if (!rows.length && state.chamber.head_office_city) {
    rows.push({
      location_name: state.chamber.head_office_city,
      city: state.chamber.head_office_city,
      country: state.chamber.head_office_country
    });
  }

  if (!rows.length) {
    container.innerHTML = emptyMessage(
      "No chambers locations have been added yet."
    );
    return;
  }

  container.innerHTML = rows.map(location => {
    const name =
      location.location_name ||
      location.city ||
      "Chambers";

    const publicCountry =
      chamberCanonicalCountry(
        location.country
      ) ||
      String(location.country || "").trim();

    const address =
      location.full_address ||
      location.address ||
      location.office_address ||
      "";

    const phone =
      location.telephone ||
      location.phone ||
      "";

    const recruitment =
      location.offers_student_recruitment ??
      location.student_recruitment;

    return `
      <article class="location-card">
        <div class="location-card-header">
          <div>
            <h3>${escapeHtml(name)}</h3>

            ${
              location.region || publicCountry
                ? `
                  <p class="location-card-subtitle">
                    ${escapeHtml(
                      [location.region, publicCountry]
                        .filter(Boolean)
                        .join(" · ")
                    )}
                  </p>
                `
                : ""
            }
          </div>

          ${
            location.location_category
              ? `
                <span class="status-pill">
                  ${escapeHtml(location.location_category)}
                </span>
              `
              : ""
          }
        </div>

        ${
          address
            ? `<p class="location-address">${escapeHtml(address)}</p>`
            : ""
        }

        ${
          phone
            ? `<p class="location-contact">${escapeHtml(phone)}</p>`
            : ""
        }

        <div class="location-tags">
          ${
            recruitment === true
              ? `<span class="status-pill">Student recruitment</span>`
              : ""
          }

          ${
            location.is_physical_location === true
              ? `<span class="status-pill">Physical chambers</span>`
              : ""
          }
        </div>

        ${
          location.student_recruitment_note
            ? `
              <p class="location-note">
                ${escapeHtml(location.student_recruitment_note)}
              </p>
            `
            : ""
        }

        <div class="location-actions">
          ${
            location.office_url
              ? profileLink(location.office_url, "Official location page", `Official location page — ${name}${publicCountry ? `, ${publicCountry}` : ""}`)
              : ""
          }

          ${
            location.careers_url
              ? profileLink(location.careers_url, "Location careers", `Location careers — ${name}${publicCountry ? `, ${publicCountry}` : ""}`)
              : ""
          }

          ${
            location.source_url &&
            location.source_url !== location.office_url
              ? profileLink(location.source_url, "Official source", `Official source — ${name}${publicCountry ? `, ${publicCountry}` : ""}`)
              : ""
          }
        </div>
      </article>
    `;
  }).join("");
}

/* =======================================
   Pupillage and tenancy
======================================= */

function renderPupillageAndTenancy() {
  const container = document.getElementById("pupillageTenancyList");

  if (!container) {
    return;
  }

  const chamber = state.chamber;
  const pupilRows = state.opportunities.filter(row =>
    /pupillage/i.test(displayOpportunityType(row))
  );

  const items = [];

  if (chamber.pupillage_overview) {
    items.push(
      researchItem(
        "Pupillage",
        "Pupillage structure",
        shortSummary(chamber.pupillage_overview),
        [
          researchTextSection("Published overview", chamber.pupillage_overview),
          researchTextSection(
            "Current researched routes",
            pupilRows
              .filter(row => !/mini/i.test(displayOpportunityType(row)))
              .map(row => row.scheme_name)
              .filter(Boolean)
              .join(" · ")
          )
        ],
        chamber.careers_url
      )
    );
  }

  if (chamber.mini_pupillage_overview) {
    items.push(
      researchItem(
        "Mini-pupillage",
        "Mini-pupillage structure",
        shortSummary(chamber.mini_pupillage_overview),
        [
          researchTextSection(
            "Published overview",
            chamber.mini_pupillage_overview
          ),
          researchTextSection(
            "Current researched routes",
            pupilRows
              .filter(row => /mini/i.test(displayOpportunityType(row)))
              .map(row => row.scheme_name)
              .filter(Boolean)
              .join(" · ")
          )
        ],
        findLinkUrlByTypes([
          "mini_pupillage",
          "assessed_mini_pupillage"
        ])
      )
    );
  }

  if (chamber.tenancy_overview) {
    items.push(
      researchItem(
        "Progression",
        "Tenancy",
        shortSummary(chamber.tenancy_overview),
        [
          researchTextSection("Published overview", chamber.tenancy_overview),
          researchTextSection(
            "Opportunity-specific progression",
            uniqueCleanPoints(
              state.opportunities
                .map(row => row.progression_route)
                .filter(Boolean)
            ).join(" · ")
          )
        ],
        findLinkUrlByTypes(["pupillage"])
      )
    );
  }

  const assessmentText = uniqueCleanPoints(
    state.opportunities.flatMap(row => [
      row.assessment_formats,
      row.assessments,
      row.interview_dates
    ]).filter(Boolean)
  ).join(" · ");

  if (assessmentText) {
    items.push(
      researchItem(
        "Selection",
        "Assessments and interviews",
        shortSummary(assessmentText),
        [
          researchTextSection(
            "Published assessment information",
            assessmentText
          )
        ],
        findLinkUrlByTypes(["application_portal", "pupillage"])
      )
    );
  }

  if (chamber.pupillage_gateway_member || chamber.pupillage_gateway_url) {
    items.push(
      researchItem(
        "Applications",
        "Pupillage Gateway",
        "This chambers uses or is recorded as a member of the Pupillage Gateway.",
        [
          researchFacts([
            ["Gateway member", chamber.pupillage_gateway_member ? "Yes" : "Not confirmed"],
            ["Application route", "Check each cycle-specific opportunity record"]
          ])
        ],
        chamber.pupillage_gateway_url
      )
    );
  }

  container.innerHTML = items.length
    ? items.join("")
    : emptyMessage(
        "Pupillage and tenancy information has not yet been added."
      );
}

/* =======================================
   Funding
======================================= */

function chamberUkScopeText(value) {
  const key = normaliseText(value);
  if (!key) {
    return false;
  }

  const haystack = ` ${key} `;

  return [
    "united kingdom",
    "great britain",
    "england",
    "scotland",
    "wales",
    "northern ireland",
    " uk ",
    " u k ",
    "london",
    "birmingham",
    "manchester",
    "leeds",
    "bristol",
    "edinburgh",
    "glasgow",
    "belfast",
    "cardiff",
    "newcastle",
    "liverpool",
    "sheffield",
    "cambridge",
    "oxford",
    "exeter",
    "reading",
    "southampton",
    "aberdeen"
  ].some(term =>
    haystack.includes(
      term.startsWith(" ") || term.endsWith(" ")
        ? term
        : ` ${term} `
    )
  );
}

function chamberUkOpportunity(row) {
  const countries = Array.isArray(row?.countries)
    ? row.countries
    : [];

  if (countries.some(chamberUkScopeText)) {
    return true;
  }

  if (chamberUkScopeText(row?.country)) {
    return true;
  }

  return chamberUkScopeText(row?.location);
}

function chamberUkFundingStatement(row) {
  const route = normaliseText(
    [
      row?.scheme_type,
      row?.scheme_name
    ].filter(Boolean).join(" ")
  );

  const award = /pupillage|tenancy|scholarship|bursary|grant/.test(route)
    ? row?.pay_details || row?.salary
    : "";

  return uniqueCleanPoints([
    row?.sponsorship,
    award
  ]).join(" · ");
}

function chamberUkStatementEntries(rows, valueForRow) {
  const seen = new Set();
  const entries = [];

  (rows || []).forEach(row => {
    const value = String(valueForRow(row) || "").trim();

    if (!value) {
      return;
    }

    const key = normaliseText(value);

    if (seen.has(key)) {
      return;
    }

    seen.add(key);

    entries.push({
      title:
        row.scheme_name ||
        displayOpportunityType(row),
      value,
      sourceUrl:
        row.application_link ||
        row.source_url ||
        ""
    });
  });

  return entries;
}

function chamberUkFirmStatement(
  title,
  summaryFallback,
  detailTitle,
  entries,
  preferredSource
) {
  if (!entries.length) {
    return "";
  }

  const statements = entries.map(entry =>
    entry.title
      ? `${entry.title}: ${entry.value}`
      : entry.value
  );

  return researchItem(
    "United Kingdom",
    title,
    shortSummary(entries[0].value || summaryFallback),
    [
      researchTextSection(
        detailTitle,
        statements.join(" · ")
      )
    ],
    preferredSource ||
      entries.find(entry => entry.sourceUrl)?.sourceUrl ||
      ""
  );
}

function renderFunding() {
  const container = document.getElementById("fundingList");

  if (!container) {
    return;
  }

  const ukOpportunities = state.opportunities
    .filter(row => !Boolean(row?.canonical_opportunity?.isEvent))
    .filter(chamberUkOpportunity);

  const visaEntries = chamberUkStatementEntries(
    ukOpportunities,
    row => row.right_to_work_requirements
  );

  const fundingEntries = chamberUkStatementEntries(
    ukOpportunities,
    chamberUkFundingStatement
  );

  const items = [
    chamberUkFirmStatement(
      "UK visa sponsorship and right to work",
      "Published visa sponsorship and right-to-work information for joining chambers in the UK.",
      "Published UK visa and right-to-work guidance",
      visaEntries,
      findLinkUrlByTypes(["careers", "pupillage"])
    ),
    chamberUkFirmStatement(
      "UK pupillage and student funding",
      "Published pupillage awards, bursaries and other student funding in the UK.",
      "Published UK funding and support",
      fundingEntries,
      findLinkUrlByTypes(["funding", "pupillage", "careers"])
    )
  ].filter(Boolean);

  container.innerHTML = items.length
    ? items.join("")
    : emptyMessage(
        "No UK visa, right-to-work or student funding information is currently published for this chambers."
      );
}

/* =======================================
   EDI
======================================= */

function renderEdi() {
  const container = document.getElementById("ediList");

  if (!container) {
    return;
  }

  const items = [];

  const adjustmentInformation = uniqueCleanPoints(
    state.opportunities
      .map(row => row.disability_support)
      .filter(Boolean)
  );

  if (adjustmentInformation.length) {
    items.push(
      researchItem(
        "Disability and access",
        "Applicant adjustments",
        shortSummary(adjustmentInformation.join(" · ")),
        [
          researchTextSection(
            "Published support",
            adjustmentInformation.join(" · ")
          )
        ],
        findLinkUrlByTypes(["edi", "contact"])
      )
    );
  }

  const locationAccess = state.locations
    .filter(location =>
      hasText(location.student_recruitment_note) &&
      /access|wheelchair|step-free|adjustment|facilit/i.test(
        location.student_recruitment_note
      )
    )
    .map(location => ({
      name: location.location_name || location.city || "Location",
      note: location.student_recruitment_note,
      url: location.source_url || location.office_url
    }));

  if (locationAccess.length) {
    items.push(
      researchItem(
        "Physical access",
        "Chambers accessibility",
        locationAccess
          .map(item => `${item.name}: ${item.note}`)
          .join(" "),
        locationAccess.map(item =>
          researchTextSection(item.name, item.note)
        ),
        locationAccess[0].url
      )
    );
  }

  const positiveAction = state.opportunities.filter(row =>
    /assessed mini|positive|socio-economic|social mobility|less advantaged|outreach/i.test(
      [
        row.scheme_name,
        row.eligibility,
        row.additional_details,
        row.student_summary
      ].filter(Boolean).join(" ")
    )
  );

  if (positiveAction.length) {
    items.push(
      researchItem(
        "Positive action",
        "Access and social mobility programmes",
        positiveAction
          .map(row => row.scheme_name)
          .filter(Boolean)
          .join(" · "),
        positiveAction.map(row =>
          researchTextSection(
            row.scheme_name || "Programme",
            uniqueCleanPoints([
              row.eligibility,
              row.pay_details,
              row.expenses,
              row.progression_route
            ]).join(" · ")
          )
        ),
        positiveAction[0].application_link ||
          positiveAction[0].source_url
      )
    );
  }

  const ediLinks = state.links.filter(link =>
    ["edi", "contact"].includes(String(link.link_type || "").toLowerCase())
  );

  if (ediLinks.length) {
    items.push(
      researchItem(
        "Policies and contacts",
        "Official EDI and accessibility pages",
        ediLinks.map(link => link.label).filter(Boolean).join(" · "),
        [
          researchTextSection(
            "Official pages",
            ediLinks.map(link => link.label).filter(Boolean).join(" · ")
          )
        ],
        ediLinks[0].url
      )
    );
  }

  container.innerHTML = items.length
    ? items.join("")
    : emptyMessage(
        "No specific EDI, disability-access or adjustment information is currently stored."
      );
}

/* =======================================
   Highlights
======================================= */

function renderHighlights() {
  const container = document.getElementById("highlightsList");

  if (!container) {
    return;
  }

  const items = [];

  if (state.rankings.length) {
    const rankingSections = state.rankings.map(ranking =>
      researchTextSection(
        [
          ranking.ranking_band,
          ranking.ranking_name
        ].filter(Boolean).join(" — "),
        [
          ranking.practice_area,
          ranking.circuit_or_region,
          ranking.ranking_source,
          ranking.ranking_year
        ].filter(Boolean).join(" · ")
      )
    );

    items.push(
      researchItem(
        "Independent recognition",
        "Current rankings",
        state.rankings
          .map(ranking =>
            [
              ranking.ranking_band,
              ranking.ranking_name
            ].filter(Boolean).join(" in ")
          )
          .join(" · "),
        rankingSections,
        state.rankings[0].source_url
      )
    );
  }

  if (state.chamber.year_founded) {
    items.push(
      researchItem(
        "History",
        "Founded",
        `The chambers records ${state.chamber.year_founded} as its founding year.`,
        [
          researchFacts([
            ["Founded", String(state.chamber.year_founded)],
            ["Head office", state.chamber.head_office_city]
          ])
        ],
        state.chamber.website_url
      )
    );
  }

  if (state.locations.length) {
    items.push(
      researchItem(
        "Structure",
        "Locations and recruitment",
        `${state.locations.length} researched location${
          state.locations.length === 1 ? "" : "s"
        }: ${state.locations
          .map(location => location.location_name || location.city)
          .filter(Boolean)
          .join(" · ")}.`,
        state.locations.map(location =>
          researchTextSection(
            location.location_name || location.city || "Location",
            uniqueCleanPoints([
              location.student_recruitment_note,
              location.offers_student_recruitment === true
                ? "Student recruitment is recorded for this location."
                : ""
            ]).join(" ")
          )
        ),
        state.locations[0].office_url || state.locations[0].source_url
      )
    );
  }

  if (state.practiceAreas.length) {
    items.push(
      researchItem(
        "Practice breadth",
        "Official practice-area inventory",
        `${state.practiceAreas.length} practice area${
          state.practiceAreas.length === 1 ? "" : "s"
        } are recorded from official chambers sources.`,
        [
          researchTextSection(
            "Featured areas",
            state.practiceAreas
              .filter(area => area.featured)
              .map(area => area.practice_area)
              .join(" · ")
          )
        ],
        state.practiceAreas[0].source_url
      )
    );
  }

  items.push(
    researchItem(
      "Research audit",
      "Vacatory research status",
      `Profile status: ${formatStatus(
        state.chamber.profile_status
      )}. Research status: ${formatStatus(
        state.chamber.organisation_research_status ||
        state.chamber.research_status
      )}.`,
      [
        researchFacts([
          [
            "Research checked",
            formatDate(
              state.chamber.organisation_research_checked_on ||
              state.chamber.research_checked_on
            )
          ],
          [
            "Next review",
            formatDate(
              state.chamber.organisation_next_review_on ||
              state.chamber.next_review_on
            )
          ],
          ["Opportunities", String(state.opportunities.length)],
          ["Official links", String(state.links.length)]
        ])
      ],
      ""
    )
  );

  container.innerHTML = items.join("");
}

/* =======================================
   Links & Socials
======================================= */

function renderLinksAndSocials() {
  const container = document.getElementById("linksSocialsList");

  if (!container) {
    return;
  }

  const links = [
    {
      link_type: "main_website",
      label: "Official chambers website",
      url: state.chamber.website_url,
      audience: "All visitors",
      display_order: 0,
      is_primary: true
    },
    {
      link_type: "careers",
      label: "Official careers information",
      url: state.chamber.careers_url,
      audience: "Students and applicants",
      display_order: 5,
      is_primary: true
    },
    {
      link_type: "application_portal",
      label: "Pupillage Gateway",
      url: state.chamber.pupillage_gateway_url,
      audience: "Pupillage applicants",
      display_order: 8,
      is_primary: true
    },
    ...state.links
  ].filter(link => hasText(link.url));

  const uniqueLinks = deduplicateObjects(
    links,
    link => normaliseText(link.url)
  ).sort((a, b) =>
    Number(a.display_order ?? 500) - Number(b.display_order ?? 500)
  );

  if (!uniqueLinks.length) {
    container.innerHTML = emptyMessage(
      "No official links have been added yet."
    );
    return;
  }

  const grouped = new Map();

  uniqueLinks.forEach(link => {
    const category = linkCategory(link);

    if (!grouped.has(category)) {
      grouped.set(category, []);
    }

    grouped.get(category).push(link);
  });

  container.innerHTML = Array.from(grouped.entries())
    .map(([category, rows]) => `
      <section class="links-socials-group">
        <div class="links-socials-heading">
          <h3>${escapeHtml(category)}</h3>
          <p>${escapeHtml(linkCategoryDescription(category))}</p>
        </div>

        <div class="links-socials-grid">
          ${rows.map(link => `
            <article class="link-social-card">
              <div class="link-social-copy">
                <span class="link-social-type">
                  ${escapeHtml(formatLinkType(link.link_type))}
                </span>

                <h4>${escapeHtml(
                  link.label || formatLinkType(link.link_type)
                )}</h4>

                ${
                  link.audience || link.region || link.country
                    ? `
                      <p>
                        ${escapeHtml(
                          [link.audience, link.region, link.country]
                            .filter(Boolean)
                            .join(" · ")
                        )}
                      </p>
                    `
                    : ""
                }
              </div>

              ${profileLink(link.url, "Open official page", `Open official page — ${link.label || formatLinkType(link.link_type)}`)}
            </article>
          `).join("")}
        </div>
      </section>
    `)
    .join("");
}

function linkCategory(link) {
  const type = String(link.link_type || "").toLowerCase();

  if (["linkedin", "instagram", "youtube", "tiktok", "facebook", "x", "twitter"].includes(type)) {
    return "Social media";
  }

  if (["edi", "contact", "accessibility"].includes(type)) {
    return "EDI, access and contact";
  }

  if (
    type.includes("pupillage") ||
    type.includes("application") ||
    type.includes("mini_") ||
    type === "opportunity"
  ) {
    return "Applications and opportunities";
  }

  if (
    type.includes("office") ||
    type.includes("location")
  ) {
    return "Locations";
  }

  return "Websites and careers";
}

function linkCategoryDescription(category) {
  const descriptions = {
    "Websites and careers":
      "Official chambers and careers pages.",
    "Applications and opportunities":
      "Official application portals and programme pages.",
    "EDI, access and contact":
      "Official inclusion, accessibility and contact information.",
    "Locations":
      "Official London, regional or office-specific pages.",
    "Social media":
      "Verified official social accounts."
  };

  return descriptions[category] || "Official chambers links.";
}

/* =======================================
   Reusable research components
======================================= */

function researchItem(label, title, summary, sections, sourceUrl) {
  const cleanSections = (sections || []).filter(Boolean).join("");

  return `
    <details class="research-item">
      <summary class="research-item-summary">
        <div class="research-item-copy">
          <span class="research-item-label">${escapeHtml(label)}</span>
          <h3>${escapeHtml(title)}</h3>
          ${
            summary
              ? `<p>${escapeHtml(summary)}</p>`
              : ""
          }
        </div>

        <span class="research-item-action" aria-hidden="true"></span>
      </summary>

      <div class="research-item-expanded">
        ${cleanSections}

        ${
          sourceUrl
            ? `
              <div class="research-source-row">
                ${profileLink(sourceUrl, "Open official source", `Open official source — ${title}`)}
              </div>
            `
            : ""
        }
      </div>
    </details>
  `;
}

function researchTextSection(title, value) {
  if (!hasText(value)) {
    return "";
  }

  return `
    <section class="research-detail-section">
      <h4>${escapeHtml(title)}</h4>
      <p>${escapeHtml(value)}</p>
    </section>
  `;
}

function researchFacts(entries) {
  const facts = (entries || [])
    .filter(([, value]) => hasText(value))
    .map(([label, value]) => `
      <div class="research-fact">
        <span>${escapeHtml(label)}</span>
        <strong>${escapeHtml(value)}</strong>
      </div>
    `)
    .join("");

  return facts
    ? `<div class="research-facts">${facts}</div>`
    : "";
}

function detailSection(title, values) {
  const points = uniqueCleanPoints(
    (values || []).flatMap(splitIntoBulletPoints)
  );

  if (!points.length) {
    return "";
  }

  return `
    <section class="opportunity-detail-section">
      <h4>${escapeHtml(title)}</h4>

      <ul class="opportunity-bullets">
        ${points.map(point => `
          <li>${escapeHtml(point)}</li>
        `).join("")}
      </ul>
    </section>
  `;
}

function opportunityFact(label, value) {
  if (!hasText(value)) {
    return "";
  }

  return `
    <div class="fact">
      <span class="fact-label">${escapeHtml(label)}</span>
      <strong class="fact-value">${escapeHtml(value)}</strong>
    </div>
  `;
}

function glanceCard(label, value, note, evidenceStatus) {
  return `
    <article class="glance-card">
      <div class="glance-card-heading">
        <h3>${escapeHtml(label)}</h3>

        ${
          evidenceStatus
            ? `
              <span class="evidence-badge ${
                normaliseStatusClass(evidenceStatus)
              }">
                ${escapeHtml(formatStatus(evidenceStatus))}
              </span>
            `
            : ""
        }
      </div>

      <p class="glance-value">${escapeHtml(value)}</p>

      ${
        note
          ? `<p class="glance-note">${escapeHtml(note)}</p>`
          : ""
      }
    </article>
  `;
}

function overviewSummaryCard(title, text, note) {
  return `
    <article class="overview-summary-card">
      <h3>${escapeHtml(title)}</h3>
      <p>${escapeHtml(text)}</p>
      ${note ? `<p>${escapeHtml(note)}</p>` : ""}
    </article>
  `;
}

/* =======================================
   Data interpretation helpers
======================================= */

function displayOpportunityType(row) {
  return (
    row.scheme_type ||
    inferOpportunityTypeFromSlug(row.slug) ||
    "Opportunity"
  );
}

function inferOpportunityTypeFromSlug(slug) {
  const value = String(slug || "").toLowerCase();

  if (value.includes("assessed-mini")) {
    return "Assessed mini-pupillage";
  }

  if (value.includes("mini-pupillage")) {
    return "Mini-pupillage";
  }

  if (value.includes("pupillage")) {
    return "Pupillage";
  }

  if (
    value.includes("probationary-tenancy") ||
    value.includes("third-six")
  ) {
    return "Probationary tenancy";
  }

  if (value.includes("school") || value.includes("outreach")) {
    return "School student programme";
  }

  if (value.includes("work-experience")) {
    return "Work experience";
  }

  return "";
}

function getOpeningDate(row) {
  return (
    row.application_open_date ||
    row.application_open ||
    row.opens_on ||
    ""
  );
}

function getClosingDate(row) {
  return (
    row.application_close_date ||
    row.application_deadline ||
    row.deadline ||
    row.closes_on ||
    ""
  );
}

function getProgrammeDates(row) {
  if (hasText(row.programme_dates)) {
    return row.programme_dates;
  }

  if (hasText(row.programme_dates_text)) {
    return row.programme_dates_text;
  }

  const start =
    row.programme_start_date ||
    row.programme_start ||
    "";

  const end = row.programme_end || "";

  if (start && end) {
    return `${formatDate(start)} to ${formatDate(end)}`;
  }

  return start ? formatDate(start) : "";
}

function buildAwardSummary(opportunities) {
  const funded = opportunities.filter(row =>
    hasText(row.pay_details) || hasText(row.salary)
  );

  if (!funded.length) {
    return null;
  }

  const pupillage = funded.find(row =>
    /pupillage/i.test(displayOpportunityType(row)) &&
    !/mini/i.test(displayOpportunityType(row))
  );

  const selected = pupillage || funded[0];
  const value = selected.salary || selected.pay_details;

  return {
    value,
    note:
      selected.scheme_name ||
      "Officially published funding information"
  };
}

function hasAccessibilityInformation() {
  const linkMatch = state.links.some(link =>
    /edi|access|contact/i.test(String(link.link_type || ""))
  );

  const locationMatch = state.locations.some(location =>
    /access|wheelchair|step-free|adjustment|facilit/i.test(
      String(location.student_recruitment_note || "")
    )
  );

  return linkMatch || locationMatch;
}

function findLinkUrlByTypes(types) {
  const wanted = types.map(type => String(type).toLowerCase());

  const match = state.links.find(link =>
    wanted.includes(String(link.link_type || "").toLowerCase())
  );

  return match?.url || "";
}

function isOpportunityOpenNow(row) {
  const opening = parseDate(getOpeningDate(row));
  const closing = parseDate(getClosingDate(row));
  const today = startOfToday();

  if (opening && closing) {
    return opening <= today && closing >= today;
  }

  if (!opening && closing) {
    return closing >= today &&
      !/closed/i.test(String(row.status || ""));
  }

  return /open/i.test(String(row.status || "")) &&
    !/closed/i.test(String(row.status || ""));
}

/* =======================================
   Formatting and safety
======================================= */

function profileLink(url, label, accessibleLabel = label) {
  const safe = safeUrl(url);

  if (!safe) {
    return "";
  }

  const linkAccessibleLabel = /opens in new tab/i.test(String(accessibleLabel))
    ? String(accessibleLabel)
    : `${accessibleLabel} (opens in new tab)`;

  return `
    <a
      class="profile-external-link"
      href="${escapeHtml(safe)}"
      aria-label="${escapeHtml(linkAccessibleLabel)}"
      target="_blank"
      rel="noopener noreferrer"
    >
      <span>${escapeHtml(label)}</span>
      ${externalLinkIcon()}
    </a>
  `;
}

function heroAction(url, label, primary) {
  const safe = safeUrl(url);

  if (!safe) {
    return "";
  }

  return `
    <a
      class="hero-action ${primary ? "primary" : ""}"
      href="${escapeHtml(safe)}"
      target="_blank"
      rel="noopener noreferrer"
    >
      <span>${escapeHtml(label)}</span>
      ${externalLinkIcon()}
    </a>
  `;
}

function metaPill(icon, text) {
  return `
    <span class="profile-meta-pill">
      ${icon}
      <span>${escapeHtml(text)}</span>
    </span>
  `;
}

function emptyMessage(message) {
  return `
    <p class="profile-section-message">
      ${escapeHtml(message)}
    </p>
  `;
}

function formatLinkType(value) {
  return String(value || "Official link")
    .replaceAll("_", " ")
    .replace(/\b\w/g, letter => letter.toUpperCase());
}

function formatStatus(value) {
  if (!hasText(value)) {
    return "";
  }

  return String(value)
    .replaceAll("_", " ")
    .replace(/\b\w/g, letter => letter.toUpperCase());
}

function normaliseStatusClass(value) {
  const text = normaliseText(value).replace(/\s+/g, "-");

  if (text.includes("verified") || text.includes("confirmed")) {
    return "verified";
  }

  if (
    text.includes("unpublished") ||
    text.includes("not-published") ||
    text.includes("needs-review")
  ) {
    return "unpublished";
  }

  return text || "unpublished";
}

function formatDate(value) {
  const date = parseDate(value);

  if (!date) {
    return "";
  }

  return new Intl.DateTimeFormat("en-GB", {
    day: "numeric",
    month: "long",
    year: "numeric"
  }).format(date);
}

function parseDate(value) {
  if (!value) {
    return null;
  }

  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    return new Date(
      value.getFullYear(),
      value.getMonth(),
      value.getDate()
    );
  }

  const text = String(value).trim();
  const match = text.match(/^(\d{4})-(\d{2})-(\d{2})/);

  if (match) {
    const date = new Date(
      Number(match[1]),
      Number(match[2]) - 1,
      Number(match[3])
    );

    return Number.isNaN(date.getTime()) ? null : date;
  }

  const date = new Date(text);

  return Number.isNaN(date.getTime()) ? null : date;
}

function dateValue(value) {
  const date = parseDate(value);
  return date ? date.getTime() : Number.MAX_SAFE_INTEGER;
}

function dateSortGroup(value) {
  const date = parseDate(value);

  if (!date) {
    return 1;
  }

  return date >= startOfToday() ? 0 : 2;
}

function isFutureOrToday(value) {
  const date = parseDate(value);
  return Boolean(date && date >= startOfToday());
}

function startOfToday() {
  const today = new Date();

  return new Date(
    today.getFullYear(),
    today.getMonth(),
    today.getDate()
  );
}

function splitIntoBulletPoints(value) {
  if (!hasText(value)) {
    return [];
  }

  if (Array.isArray(value)) {
    return value.flatMap(splitIntoBulletPoints);
  }

  if (typeof value === "object") {
    return Object.values(value).flatMap(splitIntoBulletPoints);
  }

  const text = String(value)
    .replace(/\r/g, "\n")
    .replace(/[•●▪◦]/g, "\n")
    .replace(/\s+[–—-]\s+/g, "\n")
    .replace(/;\s+/g, "\n")
    .replace(/\n{2,}/g, "\n")
    .trim();

  let points = text
    .split("\n")
    .map(cleanPoint)
    .filter(Boolean);

  if (points.length === 1 && points[0].length > 180) {
    points = points[0]
      .split(/(?<=[.!?])\s+(?=[A-Z0-9£])/)
      .map(cleanPoint)
      .filter(Boolean);
  }

  return points;
}

function cleanPoint(value) {
  return String(value || "")
    .replace(/^[\s:;,.–—-]+/, "")
    .replace(/\s+/g, " ")
    .trim();
}

function uniqueCleanPoints(values) {
  const seen = new Set();
  const output = [];

  (values || []).forEach(value => {
    if (!hasText(value)) {
      return;
    }

    const cleaned = cleanPoint(value);
    const key = normaliseText(cleaned);

    if (!key || seen.has(key)) {
      return;
    }

    seen.add(key);
    output.push(cleaned);
  });

  return output;
}

function deduplicateObjects(items, keyFunction) {
  const seen = new Set();
  const output = [];

  (items || []).forEach(item => {
    const key = keyFunction(item);

    if (!key || seen.has(key)) {
      return;
    }

    seen.add(key);
    output.push(item);
  });

  return output;
}

function deduplicateStrings(values) {
  return uniqueCleanPoints(values);
}

function shortSummary(value, maxLength = 230) {
  const text = cleanPoint(value);

  if (text.length <= maxLength) {
    return text;
  }

  return `${text.slice(0, maxLength).replace(/\s+\S*$/, "")}…`;
}

function normaliseText(value) {
  return String(value || "")
    .trim()
    .toLowerCase()
    .replace(/\s+/g, " ");
}

function hasText(value) {
  if (value === null || value === undefined) {
    return false;
  }

  if (Array.isArray(value)) {
    return value.some(hasText);
  }

  if (typeof value === "object") {
    return Object.values(value).some(hasText);
  }

  return String(value).trim() !== "";
}

function safeUrl(value) {
  if (!hasText(value)) {
    return "";
  }

  try {
    const url = new URL(String(value), window.location.href);

    if (!["http:", "https:"].includes(url.protocol)) {
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

/* =======================================
   Icons
======================================= */

function externalLinkIcon() {
  return `
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      aria-hidden="true"
    >
      <path d="M14 3h7v7"></path>
      <path d="M10 14L21 3"></path>
      <path d="M21 14v5a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5"></path>
    </svg>
  `;
}

function chevronIcon() {
  return `
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
    >
      <path d="M6 9l6 6 6-6"></path>
    </svg>
  `;
}

function locationIcon() {
  return `
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      aria-hidden="true"
    >
      <path d="M12 21s6-5.1 6-11a6 6 0 1 0-12 0c0 5.9 6 11 6 11z"></path>
      <circle cx="12" cy="10" r="2"></circle>
    </svg>
  `;
}

function circuitIcon() {
  return `
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      aria-hidden="true"
    >
      <circle cx="12" cy="12" r="9"></circle>
      <path d="M12 7v5l3 2"></path>
    </svg>
  `;
}

function buildingIcon() {
  return `
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      aria-hidden="true"
    >
      <path d="M4 21V6l8-3 8 3v15"></path>
      <path d="M9 21v-5h6v5"></path>
      <path d="M8 9h.01M12 9h.01M16 9h.01M8 13h.01M12 13h.01M16 13h.01"></path>
    </svg>
  `;
}

function linkIcon() {
  return `
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      aria-hidden="true"
    >
      <path d="M10 13a5 5 0 0 0 7.1 0l2.8-2.8a5 5 0 0 0-7.1-7.1L11.2 4.7"></path>
      <path d="M14 11a5 5 0 0 0-7.1 0l-2.8 2.8a5 5 0 0 0 7.1 7.1l1.6-1.6"></path>
    </svg>
  `;
}


/* VACATORY_CANONICAL_PROFILE_LAZY_TABS_20260817
   Fetch and render chambers tab data only when the relevant tab is activated,
   and keep the active tab in a shareable ?tab= URL. */
const vacatoryChamberLazyTabs = new Set([
  "overview",
  "opportunities",
  "practice-areas",
  "locations",
  "pupillage-tenancy",
  "funding",
  "edi",
  "highlights",
  "links-socials"
]);
const vacatoryChamberLoadedTabs = new Set();
const vacatoryChamberDataPromises = {};

function vacatoryChamberTabFromUrl() {
  const requested = new URLSearchParams(window.location.search).get("tab");
  return vacatoryChamberLazyTabs.has(requested) ? requested : "overview";
}

function vacatoryChamberUpdateTabUrl(tab, mode = "push") {
  if (mode === "none") return;
  const url = new URL(window.location.href);
  if (tab === "overview") url.searchParams.delete("tab");
  else url.searchParams.set("tab", tab);
  history[mode === "replace" ? "replaceState" : "pushState"](
    history.state,
    "",
    `${url.pathname}${url.search}${url.hash}`
  );
}

function vacatoryChamberEnsureData(key, loader) {
  if (!vacatoryChamberDataPromises[key]) {
    vacatoryChamberDataPromises[key] = Promise.resolve()
      .then(loader)
      .catch(error => {
        delete vacatoryChamberDataPromises[key];
        throw error;
      });
  }
  return vacatoryChamberDataPromises[key];
}

function vacatoryChamberOpportunities() {
  return vacatoryChamberEnsureData("opportunities", async () => {
    state.opportunities = await loadOpportunityRows(state.chamber.organisation_id);
  });
}

function vacatoryChamberPracticeAreas() {
  return vacatoryChamberEnsureData("practiceAreas", async () => {
    state.practiceAreas = await loadPracticeAreaRows(state.chamber.organisation_id);
  });
}

function vacatoryChamberLocations() {
  return vacatoryChamberEnsureData("locations", async () => {
    state.locations = await loadLocationRows(state.chamber.organisation_id);
  });
}

function vacatoryChamberLinks() {
  return vacatoryChamberEnsureData("links", async () => {
    state.links = await loadLinkRows(state.chamber.organisation_id);
  });
}

function vacatoryChamberRankings() {
  return vacatoryChamberEnsureData("rankings", async () => {
    state.rankings = await loadRankingRows(state.chamber.organisation_id);
  });
}

async function vacatoryChamberEnsureTab(tab) {
  if (!state.chamber || vacatoryChamberLoadedTabs.has(tab)) return;

  const loaders = {
    overview: async () => {
      await Promise.all([
        vacatoryChamberOpportunities(),
        vacatoryChamberPracticeAreas(),
        vacatoryChamberLocations(),
        vacatoryChamberLinks()
      ]);
      renderOverview();
    },
    opportunities: async () => {
      await vacatoryChamberOpportunities();
      renderOpportunityFilters();
      renderOpportunities();
    },
    "practice-areas": async () => {
      await vacatoryChamberPracticeAreas();
      renderPracticeAreas();
    },
    locations: async () => {
      await vacatoryChamberLocations();
      renderLocations();
    },
    "pupillage-tenancy": async () => {
      await vacatoryChamberOpportunities();
      renderPupillageAndTenancy();
    },
    funding: async () => {
      await Promise.all([
        vacatoryChamberOpportunities(),
        vacatoryChamberLinks()
      ]);
      renderFunding();
    },
    edi: async () => {
      await Promise.all([
        vacatoryChamberOpportunities(),
        vacatoryChamberLocations(),
        vacatoryChamberLinks()
      ]);
      renderEdi();
    },
    highlights: async () => {
      await vacatoryChamberRankings();
      renderHighlights();
    },
    "links-socials": async () => {
      await vacatoryChamberLinks();
      renderLinksAndSocials();
    }
  };

  const loader = loaders[tab];
  if (!loader) return;
  const panel = document.getElementById(`tab-${tab}`);
  vacatoryChamberLoadedTabs.add(tab);
  panel?.setAttribute("aria-busy", "true");

  try {
    await loader();
  } catch (error) {
    vacatoryChamberLoadedTabs.delete(tab);
    console.error(`Unable to load ${tab} tab:`, error);
  } finally {
    panel?.removeAttribute("aria-busy");
  }
}

function vacatoryChamberSelectTab(tab, options = {}) {
  const selected = vacatoryChamberLazyTabs.has(tab) ? tab : "overview";
  const tabs = Array.from(document.querySelectorAll(".tab-btn"));
  const panels = Array.from(document.querySelectorAll(".tab-panel"));

  tabs.forEach(button => {
    const active = button.dataset.tab === selected;
    button.classList.toggle("active", active);
    button.setAttribute("aria-selected", String(active));
    button.tabIndex = active ? 0 : -1;
  });

  panels.forEach(panel => {
    const active = panel.id === `tab-${selected}`;
    panel.classList.toggle("active", active);
    panel.hidden = !active;
  });

  if (options.focus) {
    document.getElementById(`tab-${selected}`)?.focus({ preventScroll: true });
  }

  vacatoryChamberUpdateTabUrl(selected, options.historyMode || "push");
  void vacatoryChamberEnsureTab(selected);
}

setupProfileTabs = function () {
  const tabs = Array.from(document.querySelectorAll(".tab-btn"));

  tabs.forEach(tab => {
    tab.addEventListener("click", () => {
      vacatoryChamberSelectTab(tab.dataset.tab, {
        historyMode: "push",
        focus: true
      });
    });

    tab.addEventListener("keydown", event => {
      const currentIndex = tabs.indexOf(tab);
      let nextIndex = null;
      if (event.key === "ArrowRight") nextIndex = (currentIndex + 1) % tabs.length;
      if (event.key === "ArrowLeft") nextIndex = (currentIndex - 1 + tabs.length) % tabs.length;
      if (event.key === "Home") nextIndex = 0;
      if (event.key === "End") nextIndex = tabs.length - 1;

      if (nextIndex !== null) {
        event.preventDefault();
        tabs[nextIndex].focus();
        tabs[nextIndex].click();
      }
    });
  });
};

loadChamberProfile = async function () {
  if (typeof client === "undefined") {
    console.error("The Supabase client is unavailable.");
    showProfileError();
    return;
  }

  const requestedTab = vacatoryChamberTabFromUrl();

  try {
    const [chamberResult, organisationResult] = await Promise.all([
      client
        .from("chambers")
        .select("*")
        .eq("organisation_id", chamberId)
        .eq("active", true)
        .single(),
      client
        .from("legal_organisations")
        .select("*")
        .eq("id", chamberId)
        .eq("organisation_type", "barristers_chambers")
        .eq("active", true)
        .single()
    ]);

    if (chamberResult.error || !chamberResult.data) {
      throw chamberResult.error || new Error("Chambers record not found.");
    }
    if (organisationResult.error || !organisationResult.data) {
      throw organisationResult.error || new Error("Organisation record not found.");
    }

    state.chamber = {
      ...organisationResult.data,
      ...chamberResult.data,
      organisation_id: chamberResult.data.organisation_id,
      id: organisationResult.data.id,
      name: organisationResult.data.name,
      short_name: organisationResult.data.short_name,
      logo_url: organisationResult.data.logo_url,
      website_url: organisationResult.data.website_url,
      careers_url: organisationResult.data.careers_url,
      overview: organisationResult.data.overview,
      official_domain: organisationResult.data.official_domain,
      head_office_city: organisationResult.data.head_office_city,
      head_office_country: organisationResult.data.head_office_country,
      organisation_research_status: organisationResult.data.research_status,
      organisation_research_checked_on: organisationResult.data.research_checked_on,
      organisation_next_review_on: organisationResult.data.next_review_on
    };

    renderHeader(state.chamber);
    hideLoadingAndShowProfile();
    vacatoryChamberSelectTab(requestedTab, { historyMode: "replace" });
  } catch (error) {
    console.error("Unable to load chambers profile:", error);
    showProfileError();
  }
};

window.addEventListener("popstate", () => {
  if (!state.chamber) return;
  vacatoryChamberSelectTab(vacatoryChamberTabFromUrl(), { historyMode: "none" });
});

/* VACATORY_CANONICAL_CHAMBER_SEO_TABS_20260817
   Crawlable per-tab URLs, accurate tab metadata and truthful collection schema. */
const vacatoryChamberTabSeo = {
  overview: ["Overview", "chambers profile and student opportunity research"],
  opportunities: ["Opportunities", "pupillage, mini-pupillage and student opportunities"],
  "practice-areas": ["Practice areas", "practice areas and specialisms"],
  locations: ["Locations", "locations and circuit information"],
  "pupillage-tenancy": ["Pupillage & tenancy", "pupillage, tenancy and progression information"],
  funding: ["UK Visa and Funding", "UK pupillage funding, visa sponsorship and right-to-work information"],
  edi: ["EDI", "equality, diversity, inclusion and accessibility information"],
  highlights: ["Highlights", "rankings and chambers highlights"],
  "links-socials": ["Links & Socials", "official websites, application pages and social channels"]
};

function vacatoryChamberTabUrl(tab) {
  const url = new URL("https://vacatory.com/chamber-profile.html");
  const id = chamberId || new URLSearchParams(window.location.search).get("id");
  if (id) url.searchParams.set("id", id);
  if (tab !== "overview") url.searchParams.set("tab", tab);
  return url.href;
}

function vacatoryChamberTabHref(tab) {
  const url = new URL(window.location.href);
  if (tab === "overview") url.searchParams.delete("tab");
  else url.searchParams.set("tab", tab);
  return `${url.pathname}${url.search}${url.hash}`;
}

function vacatoryChamberRefreshTabLinks() {
  document.querySelectorAll(".tab-btn").forEach(tab => {
    tab.setAttribute("href", vacatoryChamberTabHref(tab.dataset.tab || "overview"));
  });
}

function vacatoryChamberPageSchema(tab) {
  if (!state.chamber) return;
  const chamber = state.chamber;
  const name = String(chamber.name || chamber.short_name || "Barristers’ chambers").trim();
  const baseUrl = vacatoryChamberTabUrl("overview");
  const pageUrl = vacatoryChamberTabUrl(tab);
  const label = vacatoryChamberTabSeo[tab]?.[0] || "Overview";
  const description = `${name} ${vacatoryChamberTabSeo[tab]?.[1] || "chambers research"} on Vacatory.`;
  const organization = {
    "@type": "Organization",
    "@id": `${baseUrl}#organization`,
    name,
    url: chamber.website_url || baseUrl
  };
  if (chamber.logo_url) organization.logo = chamber.logo_url;
  const breadcrumbs = [
    { "@type": "ListItem", position: 1, name: "Vacatory", item: "https://vacatory.com/" },
    { "@type": "ListItem", position: 2, name: "Chambers", item: "https://vacatory.com/chambers.html" },
    { "@type": "ListItem", position: 3, name, item: baseUrl }
  ];
  if (tab !== "overview") breadcrumbs.push({ "@type": "ListItem", position: 4, name: label, item: pageUrl });
  const page = {
    "@type": "CollectionPage",
    "@id": `${pageUrl}#webpage`,
    url: pageUrl,
    name: tab === "overview" ? `${name} | Vacatory` : `${name} ${label} | Vacatory`,
    description,
    isPartOf: { "@type": "WebSite", "@id": "https://vacatory.com/#website", name: "Vacatory", url: "https://vacatory.com/" },
    about: { "@id": organization["@id"] }
  };
  if (tab === "opportunities" && Array.isArray(state.opportunities)) {
    page.mainEntity = {
      "@type": "ItemList",
      name: `${name} student opportunities`,
      numberOfItems: state.opportunities.length,
      itemListElement: state.opportunities.map((row, index) => {
        const item = { "@type": "ListItem", position: index + 1, name: row.scheme_name || row.opportunity_name || row.title || "Student opportunity" };
        const url = row.application_url || row.official_url || row.source_url;
        if (/^https?:\/\//i.test(String(url || ""))) item.url = url;
        return item;
      })
    };
  }
  let script = document.getElementById("chamberProfilePageSchema");
  if (!script) {
    script = document.createElement("script");
    script.id = "chamberProfilePageSchema";
    script.type = "application/ld+json";
    document.head.appendChild(script);
  }
  script.textContent = JSON.stringify({
    "@context": "https://schema.org",
    "@graph": [
      organization,
      page,
      { "@type": "BreadcrumbList", "@id": `${pageUrl}#breadcrumb`, itemListElement: breadcrumbs }
    ]
  });
}

function vacatoryChamberApplyTabSeo(tab) {
  if (!state.chamber) return;
  const chamber = state.chamber;
  const name = String(chamber.name || chamber.short_name || "Barristers’ chambers").trim();
  const label = vacatoryChamberTabSeo[tab]?.[0] || "Overview";
  const description = `${name} ${vacatoryChamberTabSeo[tab]?.[1] || "chambers research"} on Vacatory.`;
  const url = vacatoryChamberTabUrl(tab);
  const title = tab === "overview" ? `${name} | Vacatory` : `${name} ${label} | Vacatory`;
  const shareImage = /^https?:\/\//i.test(String(chamber.logo_url || "")) ? chamber.logo_url : "https://vacatory.com/hero-legal-desk.jpg";
  const customImage = shareImage !== "https://vacatory.com/hero-legal-desk.jpg";
  document.title = title;
  upsertChamberCanonical(url);
  upsertChamberSeoMeta("name", "description", description);
  upsertChamberSeoMeta("property", "og:title", title);
  upsertChamberSeoMeta("property", "og:description", description);
  upsertChamberSeoMeta("property", "og:url", url);
  upsertChamberSeoMeta("property", "og:image", shareImage);
  upsertChamberSeoMeta("property", "og:image:alt", customImage ? `${name} logo` : "Vacatory legal careers research");
  upsertChamberSeoMeta("name", "twitter:card", customImage ? "summary" : "summary_large_image");
  upsertChamberSeoMeta("name", "twitter:title", title);
  upsertChamberSeoMeta("name", "twitter:description", description);
  upsertChamberSeoMeta("name", "twitter:image", shareImage);
  vacatoryChamberPageSchema(tab);
}

const vacatoryChamberEnsureTabSeoBase = vacatoryChamberEnsureTab;
vacatoryChamberEnsureTab = async function (tab) {
  await vacatoryChamberEnsureTabSeoBase(tab);
  vacatoryChamberApplyTabSeo(tab);
};

const vacatoryChamberSelectTabSeoBase = vacatoryChamberSelectTab;
vacatoryChamberSelectTab = function (tab, options = {}) {
  vacatoryChamberSelectTabSeoBase(tab, options);
  const selected = vacatoryChamberLazyTabs.has(tab) ? tab : "overview";
  vacatoryChamberRefreshTabLinks();
  vacatoryChamberApplyTabSeo(selected);
};

setupProfileTabs = function () {
  const tabs = Array.from(document.querySelectorAll(".tab-btn"));
  vacatoryChamberRefreshTabLinks();
  tabs.forEach(tab => {
    tab.addEventListener("click", event => {
      event.preventDefault();
      vacatoryChamberSelectTab(tab.dataset.tab, { historyMode: "push", focus: true });
    });
    tab.addEventListener("keydown", event => {
      const currentIndex = tabs.indexOf(tab);
      let nextIndex = null;
      if (event.key === "ArrowRight") nextIndex = (currentIndex + 1) % tabs.length;
      if (event.key === "ArrowLeft") nextIndex = (currentIndex - 1 + tabs.length) % tabs.length;
      if (event.key === "Home") nextIndex = 0;
      if (event.key === "End") nextIndex = tabs.length - 1;
      if (nextIndex !== null) {
        event.preventDefault();
        tabs[nextIndex].focus();
        tabs[nextIndex].click();
      }
    });
  });
};
