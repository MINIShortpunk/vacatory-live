// =======================================
// Vacatory
// chambers-directory.js
// Barristers' chambers directory
// =======================================

const chambersDirectoryState = {
  chambers: [],
  filteredChambers: [],
  chambersByOrganisationId: new Map()
};

const chambersDirectoryElements = {};

document.addEventListener(
  "DOMContentLoaded",
  initialiseChambersDirectory
);

async function initialiseChambersDirectory() {
  cacheChambersDirectoryElements();
  connectChambersDirectoryFilters();

  if (typeof client === "undefined") {
    console.error("The Supabase client is unavailable.");
    showChambersDirectoryError();
    return;
  }

  try {
    const chamberRows = await loadChamberRows();

    chambersDirectoryState.chambers = chamberRows
      .map(normaliseChambers)
      .filter(chambers => {
        return (
          chambers.organisation_id &&
          getChambersName(chambers) &&
          chambers.active !== false &&
          chambers.organisation_active !== false
        );
      });

    buildChambersMap();
    await loadSupportingChambersData();

    populateChambersFilterOptions();
    applyChambersFilters();

    chambersDirectoryElements.loading?.classList.add(
      "hidden"
    );
  } catch (error) {
    console.error("Unable to load chambers:", error);
    showChambersDirectoryError();
  }
}

async function loadChamberRows() {
  const { data: chamberRows, error: chamberError } =
    await client
      .from("chambers")
      .select("*")
      .eq("active", true);

  if (chamberError) {
    throw chamberError;
  }

  const validChamberRows = (chamberRows || []).filter(
    row => row?.organisation_id
  );

  if (!validChamberRows.length) {
    return [];
  }

  const organisationIds = validChamberRows.map(
    row => row.organisation_id
  );

  const { data: organisationRows, error: organisationError } =
    await client
      .from("legal_organisations")
      .select("*")
      .in("id", organisationIds)
      .eq("organisation_type", "barristers_chambers")
      .eq("active", true);

  if (organisationError) {
    throw organisationError;
  }

  const organisationsById = new Map(
    (organisationRows || []).map(row => [
      String(row.id),
      row
    ])
  );

  return validChamberRows
    .map(chamber => {
      const organisation = organisationsById.get(
        String(chamber.organisation_id)
      );

      if (!organisation) {
        return null;
      }

      return {
        ...chamber,
        ...organisation,
        organisation_id: chamber.organisation_id,
        chamber_active: chamber.active,
        organisation_active: organisation.active,
        chamber_profile_status: chamber.profile_status,
        organisation_profile_status: organisation.profile_status,
        chamber_research_status: chamber.research_status,
        organisation_research_status:
          organisation.research_status
      };
    })
    .filter(Boolean);
}

function cacheChambersDirectoryElements() {
  chambersDirectoryElements.search =
    document.getElementById("directorySearch");

  chambersDirectoryElements.sort =
    document.getElementById("sortFilter");

  chambersDirectoryElements.location =
    document.getElementById("locationFilter");

  chambersDirectoryElements.circuit =
    document.getElementById("circuitFilter");

  chambersDirectoryElements.practice =
    document.getElementById("practiceFilter");

  chambersDirectoryElements.opportunity =
    document.getElementById("opportunityFilter");

  chambersDirectoryElements.clear =
    document.getElementById("clearFilters");

  chambersDirectoryElements.count =
    document.getElementById("directoryCount");

  chambersDirectoryElements.loading =
    document.getElementById("directoryLoading");

  chambersDirectoryElements.error =
    document.getElementById("directoryError");

  chambersDirectoryElements.empty =
    document.getElementById("directoryEmpty");

  chambersDirectoryElements.list =
    document.getElementById("chambersDirectory");
}

function connectChambersDirectoryFilters() {
  chambersDirectoryElements.search?.addEventListener(
    "input",
    applyChambersFilters
  );

  chambersDirectoryElements.sort?.addEventListener(
    "change",
    applyChambersFilters
  );

  chambersDirectoryElements.location?.addEventListener(
    "change",
    applyChambersFilters
  );

  chambersDirectoryElements.circuit?.addEventListener(
    "change",
    applyChambersFilters
  );

  chambersDirectoryElements.practice?.addEventListener(
    "change",
    applyChambersFilters
  );

  chambersDirectoryElements.opportunity?.addEventListener(
    "change",
    applyChambersFilters
  );

  chambersDirectoryElements.clear?.addEventListener(
    "click",
    clearChambersFilters
  );
}

function normaliseChambers(chambers) {
  return {
    ...chambers,
    locations: [],
    circuits: [],
    practiceAreas: [],
    opportunities: [],
    rankings: []
  };
}

function getChambersName(chambers) {
  return chambers.name || chambers.short_name || "";
}

function buildChambersMap() {
  chambersDirectoryState.chambersByOrganisationId.clear();

  chambersDirectoryState.chambers.forEach(chambers => {
    chambersDirectoryState.chambersByOrganisationId.set(
      String(chambers.organisation_id),
      chambers
    );
  });
}

async function loadSupportingChambersData() {
  const organisationIds = chambersDirectoryState.chambers.map(
    chambers => chambers.organisation_id
  );

  if (!organisationIds.length) {
    return;
  }

  const [
    organisationLocations,
    chamberPracticeAreas,
    opportunities,
    chamberRankings
  ] = await Promise.all([
    readRowsForOrganisations(
      "organisation_locations",
      organisationIds,
      query => query.eq("active", true)
    ),

    readRowsForOrganisations(
      "chamber_practice_areas",
      organisationIds,
      query => query.eq("active", true)
    ),

    readRowsForOrganisations(
      "vacation_schemes",
      organisationIds,
      query => query
        .eq("active", true)
        .eq("is_published", true)
    ),

    readRowsForOrganisations(
      "chamber_rankings",
      organisationIds,
      query => query.eq("is_current", true)
    )
  ]);

  addChambersLocationRows(organisationLocations);
  addChambersPracticeAreaRows(chamberPracticeAreas);
  addChambersOpportunityRows(opportunities);
  addChambersRankingRows(chamberRankings);

  chambersDirectoryState.chambers.forEach(chambers => {
    addChambersOwnFields(chambers);

    chambers.locations = uniqueSorted(
      chambers.locations
    );

    chambers.circuits = uniqueSorted(
      chambers.circuits
    );

    chambers.practiceAreas = uniqueSorted(
      chambers.practiceAreas
    );

    chambers.opportunities = uniqueSorted(
      chambers.opportunities
    );

    chambers.rankings = sortChambersRankings(
      chambers.rankings
    );
  });
}

async function readRowsForOrganisations(
  tableName,
  organisationIds,
  refineQuery
) {
  let query = client
    .from(tableName)
    .select("*")
    .in("organisation_id", organisationIds);

  if (typeof refineQuery === "function") {
    query = refineQuery(query);
  }

  const { data, error } = await query;

  if (error) {
    console.warn(
      `Unable to read ${tableName}:`,
      error.message
    );

    return [];
  }

  return data || [];
}

function findChambersForRow(row) {
  if (!row?.organisation_id) {
    return null;
  }

  return (
    chambersDirectoryState
      .chambersByOrganisationId
      .get(String(row.organisation_id)) || null
  );
}

function chambersDirectoryGeoKey(value) {
  return String(value || "")
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

const chambersDirectoryCountryAliases =
  new Map(Object.entries({
    "uk": "United Kingdom",
    "u k": "United Kingdom",
    "united kingdom": "United Kingdom",
    "great britain": "United Kingdom",
    "britain": "United Kingdom",
    "england": "United Kingdom",
    "wales": "United Kingdom",
    "scotland": "United Kingdom",
    "northern ireland": "United Kingdom",
    "england and wales": "United Kingdom",
    "netherlands": "Netherlands",
    "the netherlands": "Netherlands",
    "us": "United States",
    "u s": "United States",
    "usa": "United States",
    "united states": "United States",
    "united states of america": "United States",
    "uae": "United Arab Emirates",
    "u a e": "United Arab Emirates",
    "united arab emirates": "United Arab Emirates",
    "ireland": "Ireland",
    "republic of ireland": "Ireland",
    "hong kong": "Hong Kong",
    "hong kong sar": "Hong Kong",
    "hong kong s a r": "Hong Kong",
    "hong kong sar china": "Hong Kong",
    "czech republic": "Czechia",
    "czechia": "Czechia",
    "south korea": "South Korea",
    "republic of korea": "South Korea",
    "turkey": "Türkiye",
    "turkiye": "Türkiye"
  }));

function chambersDirectoryCanonicalCountry(value) {
  const text = String(value || "")
    .replaceAll("_", " ")
    .replace(/\s+/g, " ")
    .trim();

  if (!text) {
    return "";
  }

  return (
    chambersDirectoryCountryAliases.get(
      chambersDirectoryGeoKey(text)
    ) || text
  );
}

function chambersDirectoryCleanCity(country, city) {
  const publicCountry =
    chambersDirectoryCanonicalCountry(country);

  let parts = String(city || "")
    .replace(/\s+/g, " ")
    .trim()
    .split(",")
    .map(part => part.trim())
    .filter(Boolean);

  if (!parts.length) {
    return "";
  }

  if (
    publicCountry &&
    parts.length &&
    chambersDirectoryGeoKey(
      chambersDirectoryCanonicalCountry(parts[0])
    ) === chambersDirectoryGeoKey(publicCountry)
  ) {
    parts.shift();
  }

  if (
    publicCountry &&
    parts.length &&
    chambersDirectoryGeoKey(
      chambersDirectoryCanonicalCountry(
        parts[parts.length - 1]
      )
    ) === chambersDirectoryGeoKey(publicCountry)
  ) {
    parts.pop();
  }

  if (!parts.length) {
    return "";
  }

  if (
    publicCountry === "United States" &&
    parts.length > 1 &&
    /^d\.?\s*c\.?$/i.test(parts[1])
  ) {
    return `${parts[0]} DC`;
  }

  /*
   * Exactly one city level in public filters.
   */
  return parts[0];
}

function chambersDirectoryLocationLabel(country, city) {
  const publicCountry =
    chambersDirectoryCanonicalCountry(country);

  const publicCity =
    chambersDirectoryCleanCity(
      publicCountry,
      city
    );

  if (
    publicCountry &&
    publicCity &&
    chambersDirectoryGeoKey(publicCountry) !==
      chambersDirectoryGeoKey(publicCity)
  ) {
    return `${publicCountry}, ${publicCity}`;
  }

  return publicCountry || publicCity;
}

function addChambersOwnFields(chambers) {
  const location =
    chambersDirectoryLocationLabel(
      chambers.head_office_country,
      chambers.head_office_city
    );

  if (location) {
    chambers.locations.push(location);
  }
}

function addChambersLocationRows(rows) {
  rows.forEach(row => {
    const chambers = findChambersForRow(row);

    if (!chambers) {
      return;
    }

    /*
     * Only the structured city field belongs in
     * the Location filter.
     */
    const location =
      chambersDirectoryLocationLabel(
        row.country,
        row.city || ""
      );

    if (location) {
      chambers.locations.push(location);
    }

    if (row.region) {
      chambers.circuits.push(row.region);
    }
  });
}

function addChambersPracticeAreaRows(rows) {
  rows.forEach(row => {
    const chambers = findChambersForRow(row);

    if (!chambers || !row.practice_area) {
      return;
    }

    chambers.practiceAreas.push(row.practice_area);
  });
}

function addChambersOpportunityRows(rows) {
  rows.forEach(row => {
    const chambers = findChambersForRow(row);

    if (!chambers) {
      return;
    }

    const opportunity = normaliseOpportunityType(
      row.scheme_type || row.scheme_name
    );

    if (opportunity) {
      chambers.opportunities.push(opportunity);
    }
  });
}

function addChambersRankingRows(rows) {
  rows.forEach(row => {
    const chambers = findChambersForRow(row);

    if (!chambers) {
      return;
    }

    chambers.rankings.push(row);
  });
}

function sortChambersRankings(rankings) {
  return [...(rankings || [])].sort((first, second) => {
    const firstBand = numericBand(first?.ranking_band);
    const secondBand = numericBand(second?.ranking_band);

    if (firstBand !== secondBand) {
      return firstBand - secondBand;
    }

    const firstYear = Number(first?.ranking_year) || 0;
    const secondYear = Number(second?.ranking_year) || 0;

    if (firstYear !== secondYear) {
      return secondYear - firstYear;
    }

    return String(first?.practice_area || "")
      .localeCompare(String(second?.practice_area || ""));
  });
}

function numericBand(value) {
  const match = String(value || "").match(/\d+/);

  return match
    ? Number(match[0])
    : Number.POSITIVE_INFINITY;
}

function normaliseOpportunityType(value) {
  const opportunity = normaliseText(value);

  if (!opportunity) {
    return "";
  }

  if (
    opportunity.includes("assessed") &&
    opportunity.includes("mini")
  ) {
    return "assessed_mini_pupillage";
  }

  if (opportunity.includes("mini")) {
    return "mini_pupillage";
  }

  if (opportunity.includes("pupillage")) {
    return "pupillage";
  }

  if (opportunity.includes("work experience")) {
    return "work_experience";
  }

  if (
    opportunity.includes("open day") ||
    opportunity.includes("event")
  ) {
    return "open_day";
  }

  if (opportunity.includes("scholarship")) {
    return "scholarship";
  }

  if (opportunity.includes("mentoring")) {
    return "mentoring";
  }

  return opportunity
    .replaceAll(" ", "_")
    .replaceAll("-", "_");
}

function populateChambersFilterOptions() {
  const locations = uniqueSorted(
    chambersDirectoryState.chambers.flatMap(
      chambers => chambers.locations
    )
  );

  const circuits = uniqueSorted(
    chambersDirectoryState.chambers.flatMap(
      chambers => chambers.circuits
    )
  );

  const practiceAreas = uniqueSorted(
    chambersDirectoryState.chambers.flatMap(
      chambers => chambers.practiceAreas
    )
  );

  addChambersSelectOptions(
    chambersDirectoryElements.location,
    locations
  );

  addChambersSelectOptions(
    chambersDirectoryElements.circuit,
    circuits
  );

  addChambersSelectOptions(
    chambersDirectoryElements.practice,
    practiceAreas
  );
}

function addChambersSelectOptions(selectElement, values) {
  if (!selectElement) {
    return;
  }

  values.forEach(value => {
    const option = document.createElement("option");

    option.value = value;
    option.textContent = value;

    selectElement.appendChild(option);
  });
}

function applyChambersFilters() {
  const searchTerm = normaliseText(
    chambersDirectoryElements.search?.value || ""
  );

  const selectedLocation =
    chambersDirectoryElements.location?.value || "";

  const selectedCircuit =
    chambersDirectoryElements.circuit?.value || "";

  const selectedPractice =
    chambersDirectoryElements.practice?.value || "";

  const selectedOpportunity =
    chambersDirectoryElements.opportunity?.value || "";

  const selectedSort =
    chambersDirectoryElements.sort?.value || "az";

  chambersDirectoryState.filteredChambers =
    chambersDirectoryState.chambers.filter(chambers => {
      const searchableText = normaliseText(
        [
          getChambersName(chambers),
          chambers.short_name,
          chambers.chambers_type,
          chambers.overview,
          ...chambers.locations,
          ...chambers.circuits,
          ...chambers.practiceAreas,
          ...chambers.opportunities,
          ...chambers.rankings.flatMap(ranking => [
            ranking.ranking_source,
            ranking.ranking_name,
            ranking.ranking_band,
            ranking.practice_area,
            ranking.circuit_or_region
          ])
        ]
          .filter(Boolean)
          .join(" ")
      );

      const matchesSearch =
        !searchTerm || searchableText.includes(searchTerm);

      const matchesLocation =
        !selectedLocation ||
        chambers.locations.includes(selectedLocation);

      const matchesCircuit =
        !selectedCircuit ||
        chambers.circuits.includes(selectedCircuit);

      const matchesPractice =
        !selectedPractice ||
        chambers.practiceAreas.includes(selectedPractice);

      const matchesOpportunity =
        !selectedOpportunity ||
        chambers.opportunities.includes(selectedOpportunity);

      return (
        matchesSearch &&
        matchesLocation &&
        matchesCircuit &&
        matchesPractice &&
        matchesOpportunity
      );
    });

  sortChambers(
    chambersDirectoryState.filteredChambers,
    selectedSort
  );

  renderChambersDirectory();
}

function sortChambers(chambers, sortValue) {
  chambers.sort((first, second) => {
    const firstName = getChambersName(first);
    const secondName = getChambersName(second);

    if (sortValue === "za") {
      return secondName.localeCompare(firstName);
    }

    if (sortValue === "ranking") {
      const firstBand = numericBand(
        first.rankings?.[0]?.ranking_band
      );

      const secondBand = numericBand(
        second.rankings?.[0]?.ranking_band
      );

      if (firstBand !== secondBand) {
        return firstBand - secondBand;
      }
    }

    return firstName.localeCompare(secondName);
  });
}

function renderChambersDirectory() {
  if (!chambersDirectoryElements.list) {
    return;
  }

  chambersDirectoryElements.loading?.classList.add(
    "hidden"
  );

  chambersDirectoryElements.error?.classList.add(
    "hidden"
  );

  const totalChambers =
    chambersDirectoryState.chambers.length;

  const visibleChambers =
    chambersDirectoryState.filteredChambers.length;

  if (chambersDirectoryElements.count) {
    if (totalChambers === 0) {
      chambersDirectoryElements.count.textContent =
        "No verified chambers profiles added yet";
    } else if (visibleChambers === totalChambers) {
      chambersDirectoryElements.count.textContent =
        `${totalChambers} chambers`;
    } else {
      chambersDirectoryElements.count.textContent =
        `${visibleChambers} of ${totalChambers} chambers`;
    }
  }

  if (!visibleChambers) {
    chambersDirectoryElements.list.innerHTML = "";

    if (chambersDirectoryElements.empty) {
      const hasChambers = totalChambers > 0;

      chambersDirectoryElements.empty.innerHTML = hasChambers
        ? `
          <p>No chambers match these filters</p>
          <span>Try clearing one or more filters.</span>
        `
        : `
          <p>Chambers profiles are being researched</p>
          <span>Verified profiles will appear here as they are completed.</span>
        `;

      chambersDirectoryElements.empty.classList.remove(
        "hidden"
      );
    }

    return;
  }

  chambersDirectoryElements.empty?.classList.add(
    "hidden"
  );

  chambersDirectoryElements.list.innerHTML =
    chambersDirectoryState.filteredChambers
      .map(createChambersCard)
      .join("");

  loadChambersCardLogos();
}

function createChambersCard(chambers) {
  const chambersName =
    getChambersName(chambers) ||
    "Barristers’ chambers";

  const chamberMark = getChambersMark(chambers);

  const logoCandidates =
    getOfficialLogoCandidates(chambers);

  const logo = `
    <img
      class="chambers-card-logo-image"
      alt=""
      loading="lazy"
      referrerpolicy="no-referrer"
      data-logo-candidates="${escapeHtml(
        logoCandidates.join("|")
      )}"
      hidden
    >

    <span
      class="chambers-card-logo-fallback"
      style="${getChambersMarkStyle(chamberMark)}"
    >
      ${escapeHtml(chamberMark)}
    </span>
  `;

  const location =
    chambers.locations[0] ||
    "Location being researched";

  const rankingText =
    getCompactChambersRankingText(
      chambers.rankings
    );

  const opportunityText =
    getChambersOpportunityText(
      chambers.opportunities
    );

  return `
    <a
      class="firm-card"
      href="chamber-profile.html?id=${encodeURIComponent(
        chambers.organisation_id
      )}"
      aria-label="View ${escapeHtml(chambersName)} profile"
    >
      <div class="firm-card-header">
        <div class="firm-logo" aria-hidden="true">
          ${logo}
        </div>
      </div>

      <h3>
        ${escapeHtml(chambersName)}
      </h3>

      <p class="firm-type">
        Barristers’ chambers
      </p>

      <div class="firm-details">
        <p class="firm-location">
          ${escapeHtml(location)}
        </p>

        <p class="firm-location">
          ${escapeHtml(rankingText)}
        </p>

        <span class="status-pill">
          ${escapeHtml(opportunityText)}
        </span>
      </div>

      <span class="firm-link">
        View chambers profile
        <span aria-hidden="true">→</span>
      </span>
    </a>
  `;
}

function getOfficialLogoCandidates(chambers) {
  const candidates = [];

  if (chambers.logo_url) {
    candidates.push(chambers.logo_url);
  }

  if (chambers.website_url) {
    try {
      const origin = new URL(
        chambers.website_url
      ).origin;

      candidates.push(
        `${origin}/favicon.svg`,
        `${origin}/apple-touch-icon.png`,
        `${origin}/apple-touch-icon-precomposed.png`,
        `${origin}/favicon.png`,
        `${origin}/favicon.ico`
      );
    } catch (error) {
      // The abbreviation remains visible.
    }
  }

  return [...new Set(candidates.filter(Boolean))];
}

function loadChambersCardLogos() {
  const images =
    chambersDirectoryElements.list?.querySelectorAll(
      ".chambers-card-logo-image"
    ) || [];

  images.forEach(image => {
    const candidates = String(
      image.dataset.logoCandidates || ""
    )
      .split("|")
      .map(value => value.trim())
      .filter(Boolean);

    tryChambersLogoCandidate(
      image,
      candidates,
      0
    );
  });
}

function tryChambersLogoCandidate(
  image,
  candidates,
  index
) {
  if (!image || index >= candidates.length) {
    return;
  }

  const candidate = candidates[index];

  image.onload = () => {
    image.hidden = false;

    const fallback = image.nextElementSibling;

    if (fallback) {
      fallback.hidden = true;
    }
  };

  image.onerror = () => {
    image.removeAttribute("src");

    tryChambersLogoCandidate(
      image,
      candidates,
      index + 1
    );
  };

  image.src = candidate;
}

function getCompactChambersRankingText(rankings) {
  const ranking = rankings?.[0];

  if (!ranking) {
    return "Ranking not yet listed";
  }

  const area =
    ranking.practice_area ||
    ranking.ranking_name ||
    "";

  if (ranking.ranking_position) {
    return area
      ? `Rank ${ranking.ranking_position} in ${area}`
      : `Rank ${ranking.ranking_position}`;
  }

  if (ranking.ranking_band) {
    return area
      ? `${ranking.ranking_band} in ${area}`
      : ranking.ranking_band;
  }

  return area
    ? `Ranked in ${area}`
    : "Chambers UK ranked";
}

function getChambersMark(chambers) {
  const shortName = String(
    chambers.short_name || ""
  ).trim();

  if (
    shortName &&
    !shortName.includes(" ") &&
    shortName.length <= 6
  ) {
    return shortName.toUpperCase();
  }

  const source = shortName || getChambersName(chambers);

  const words = String(source || "")
    .replace(/[’']/g, "")
    .split(/[\s-]+/)
    .map(word => word.trim())
    .filter(Boolean)
    .filter(word => {
      return ![
        "the",
        "of",
        "and",
        "chambers",
        "barristers"
      ].includes(word.toLowerCase());
    });

  const mark = words
    .map(word => {
      const leadingNumber = word.match(/^\d+/);

      if (leadingNumber) {
        const letters = word
          .slice(leadingNumber[0].length)
          .replace(/[^a-zA-Z]/g, "");

        return (
          leadingNumber[0] +
          (letters ? letters.charAt(0) : "")
        );
      }

      return word.replace(/[^a-zA-Z0-9]/g, "").charAt(0);
    })
    .join("")
    .toUpperCase();

  return mark.slice(0, 6) || "C";
}

function getChambersMarkStyle(mark) {
  const length = String(mark || "").length;

  if (length >= 5) {
    return "font-size:0.82rem;letter-spacing:-0.04em;";
  }

  if (length === 4) {
    return "font-size:0.95rem;letter-spacing:-0.03em;";
  }

  return "";
}

function getChambersOpportunityText(opportunities) {
  if (opportunities.includes("pupillage")) {
    return "Pupillage information available";
  }

  if (
    opportunities.includes("assessed_mini_pupillage")
  ) {
    return "Assessed mini-pupillage";
  }

  if (opportunities.includes("mini_pupillage")) {
    return "Mini-pupillage information";
  }

  if (opportunities.length) {
    return "Student opportunities available";
  }

  return "Opportunities being researched";
}

function clearChambersFilters() {
  if (chambersDirectoryElements.search) {
    chambersDirectoryElements.search.value = "";
  }

  if (chambersDirectoryElements.sort) {
    chambersDirectoryElements.sort.value = "az";
  }

  if (chambersDirectoryElements.location) {
    chambersDirectoryElements.location.value = "";
  }

  if (chambersDirectoryElements.circuit) {
    chambersDirectoryElements.circuit.value = "";
  }

  if (chambersDirectoryElements.practice) {
    chambersDirectoryElements.practice.value = "";
  }

  if (chambersDirectoryElements.opportunity) {
    chambersDirectoryElements.opportunity.value = "";
  }

  applyChambersFilters();
  chambersDirectoryElements.search?.focus();
}

function showChambersDirectoryError() {
  chambersDirectoryElements.loading?.classList.add(
    "hidden"
  );

  chambersDirectoryElements.empty?.classList.add(
    "hidden"
  );

  chambersDirectoryElements.error?.classList.remove(
    "hidden"
  );

  if (chambersDirectoryElements.count) {
    chambersDirectoryElements.count.textContent =
      "The chambers directory could not be loaded.";
  }
}

function uniqueSorted(values) {
  return [
    ...new Set(
      values
        .filter(Boolean)
        .map(value => String(value).trim())
        .filter(Boolean)
    )
  ].sort((first, second) =>
    first.localeCompare(second)
  );
}

function normaliseText(value) {
  return String(value || "")
    .trim()
    .toLowerCase();
}

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}
