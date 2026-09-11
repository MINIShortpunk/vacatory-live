/*
 * Vacatory Scholarships
 *
 * Canonical rules:
 * - reads career_opportunities_public_view through opportunity-data.js
 * - includes every public scholarship_bursary record from firms and chambers
 * - also includes programmes whose canonical funding text confirms direct
 *   scholarship or bursary support
 * - retains closed records because this is the complete public scholarship
 *   directory, while labelling their status and dates clearly
 */

(() => {
  "use strict";

  const state = {
    scholarships: [],
    filtered: [],
    providerLocations: new Map()
  };

  const elements = {};

  document.addEventListener("DOMContentLoaded", initialiseScholarships);

  async function initialiseScholarships() {
    cacheElements();
    connectFilters();

    if (!window.VacatoryOpportunityData || typeof client === "undefined") {
      showError();
      return;
    }

    try {
      const opportunities =
        await window.VacatoryOpportunityData.loadOpportunities({
          client,
          includeSearchIndex: true
        });

      state.scholarships = opportunities
        .filter(isScholarshipOpportunity)
        .sort(compareScholarships);

      state.providerLocations =
        await loadProviderPrimaryLocations(state.scholarships);

      populateFilters(state.scholarships);
      applyFilters();
      elements.loading?.classList.add("hidden");
    } catch (error) {
      console.error("Unable to load Vacatory scholarships:", error);
      showError();
    }
  }

  async function loadProviderPrimaryLocations(opportunities) {
    const providerIds = uniqueSorted(
      opportunities.map(item => item.providerId)
    );

    if (!providerIds.length) return new Map();

    const { data, error } = await client
      .from("organisation_locations")
      .select("organisation_id, city, country, display_order")
      .in("organisation_id", providerIds)
      .eq("active", true)
      .order("display_order", { ascending: true });

    if (error) {
      console.warn(
        "Unable to load scholarship provider locations:",
        error.message
      );
      return new Map();
    }

    const locations = new Map();

    for (const row of data || []) {
      const providerId = String(row.organisation_id || "");
      const city = String(row.city || "").trim();
      const country = String(row.country || "").trim();

      if (!providerId || !city || locations.has(providerId)) continue;
      locations.set(providerId, { city, country });
    }

    return locations;
  }

  function cacheElements() {
    elements.search = document.getElementById("scholarshipSearch");
    elements.providerType = document.getElementById("scholarshipProviderType");
    elements.provider = document.getElementById("scholarshipProvider");
    elements.country = document.getElementById("scholarshipCountry");
    elements.status = document.getElementById("scholarshipStatus");
    elements.reset = document.getElementById("scholarshipReset");

    elements.count = document.getElementById("scholarshipCount");
    elements.loading = document.getElementById("scholarshipsLoading");
    elements.error = document.getElementById("scholarshipsError");
    elements.empty = document.getElementById("scholarshipsEmpty");
    elements.list = document.getElementById("scholarshipsList");
  }

  function connectFilters() {
    elements.search?.addEventListener("input", applyFilters);
    elements.providerType?.addEventListener("change", applyFilters);
    elements.provider?.addEventListener("change", applyFilters);
    elements.country?.addEventListener("change", applyFilters);
    elements.status?.addEventListener("change", applyFilters);
    elements.reset?.addEventListener("click", clearFilters);
  }

  function populateFilters(opportunities) {
    populateSelect(
      elements.providerType,
      uniqueSorted(opportunities.map(item => providerTypeLabel(item)))
    );
    populateSelect(
      elements.provider,
      uniqueSorted(opportunities.map(item => item.providerName))
    );
    populateSelect(
      elements.country,
      uniqueSorted(opportunities.flatMap(scholarshipCountries))
    );
    populateSelect(
      elements.status,
      uniqueSorted(opportunities.map(item => statusFilterLabel(item)))
    );
  }

  function populateSelect(select, values) {
    if (!select) return;

    for (const value of values) {
      const option = document.createElement("option");
      option.value = value;
      option.textContent = value;
      select.appendChild(option);
    }
  }

  function applyFilters() {
    const data = window.VacatoryOpportunityData;
    const query = elements.search?.value || "";
    const providerType = elements.providerType?.value || "";
    const provider = elements.provider?.value || "";
    const country = elements.country?.value || "";
    const status = elements.status?.value || "";

    state.filtered = state.scholarships.filter(item => {
      if (query && !matchesSearch(item, query, data)) return false;
      if (providerType && providerTypeLabel(item) !== providerType) return false;
      if (provider && item.providerName !== provider) return false;
      if (country && !scholarshipCountries(item).includes(country)) return false;
      if (status && statusFilterLabel(item) !== status) return false;
      return true;
    });

    renderScholarships(state.filtered);
  }

  function clearFilters() {
    if (elements.search) elements.search.value = "";
    if (elements.providerType) elements.providerType.value = "";
    if (elements.provider) elements.provider.value = "";
    if (elements.country) elements.country.value = "";
    if (elements.status) elements.status.value = "";
    applyFilters();
    elements.search?.focus();
  }

  function isScholarshipOpportunity(opportunity) {
    if (opportunity.opportunityTypeSlug === "scholarship_bursary") {
      return true;
    }

    if (/\b(scholarship|bursar(?:y|ies))\b/i.test(opportunity.publicTitle)) {
      return true;
    }

    const funding = String(opportunity.fundingText || "");
    return /\bend-of-programme bursary\b/i.test(funding) ||
      /\bscholarship support is provided\b/i.test(funding) ||
      /(?:£|€|\$)\s?[\d,.]+[^.\n]*\bscholarship\b/i.test(funding);
  }

  function matchesSearch(item, query, data) {
    const needle = data.normaliseText(query);
    if (!needle) return true;

    const haystack = data.normaliseText([
      item.publicTitle,
      item.publicSummary,
      item.providerName,
      item.providerShortName,
      providerTypeLabel(item),
      item.opportunityTypeLabel,
      item.fundingText,
      item.eligibilityText,
      item.publicLocationLabel,
      ...(item.countries || []),
      ...(item.cities || [])
    ].filter(Boolean).join(" "));

    return haystack.includes(needle);
  }

  function renderScholarships(opportunities) {
    updateCount(opportunities.length);

    if (!elements.list) return;
    elements.error?.classList.add("hidden");

    if (!opportunities.length) {
      elements.list.replaceChildren();
      elements.empty?.classList.remove("hidden");
      return;
    }

    elements.empty?.classList.add("hidden");
    const fragment = document.createDocumentFragment();
    const list = document.createElement("div");
    list.className = "event-month-list";

    for (const opportunity of opportunities) {
      list.appendChild(renderScholarshipRow(opportunity));
    }

    fragment.appendChild(list);
    elements.list.replaceChildren(fragment);
  }

  function renderScholarshipRow(opportunity) {
    const data = window.VacatoryOpportunityData;
    const article = document.createElement("article");
    article.className = "event-row scholarship-row";

    const status = scholarshipStatus(opportunity);
    const statusBox = document.createElement("div");
    statusBox.className = `event-date scholarship-status scholarship-status-${status.key}`;
    statusBox.setAttribute("aria-label", status.accessible);
    statusBox.innerHTML = `
      <span class="event-date-month">Applications</span>
      <span class="event-date-day">${data.escapeHtml(status.label)}</span>
    `;

    const logo = renderLogo(opportunity);
    const main = document.createElement("div");
    main.className = "event-main";

    const displayTitle = scholarshipDisplayTitle(opportunity);
    const title = document.createElement("h3");
    title.className = "event-title";
    title.textContent = displayTitle;

    const provider = document.createElement("p");
    provider.className = "event-provider";
    provider.innerHTML = `${data.escapeHtml(opportunity.providerName || "Organisation")} <span class="scholarship-provider-kind">· ${data.escapeHtml(providerTypeLabel(opportunity))}</span>`;

    const facts = document.createElement("div");
    facts.className = "event-facts";
    facts.append(
      renderFact("Support", scholarshipKind(opportunity)),
      renderFact("Where", scholarshipLocation(opportunity)),
      renderFact("Applications", applicationTiming(opportunity, data))
    );

    main.append(title, provider, facts);

    const summaryText =
      opportunity.publicSummary ||
      opportunity.fundingText ||
      opportunity.programmeDatesText;

    if (summaryText) {
      const summary = document.createElement("p");
      summary.className = "event-registration scholarship-summary";
      summary.textContent = summaryText;
      main.appendChild(summary);
    }

    const action = document.createElement("div");
    action.className = "event-action";
    const officialUrl = data.safeHttpUrl(
      opportunity.applicationUrl || opportunity.officialUrl
    );

    if (officialUrl) {
      const link = document.createElement("a");
      link.className = "event-official-link";
      link.href = officialUrl;
      link.target = "_blank";
      link.rel = "noopener noreferrer";
      link.setAttribute(
        "aria-label",
        `${displayTitle} official page (opens in a new tab)`
      );
      link.innerHTML = `
        <span>Official scholarship page</span>
        <span aria-hidden="true">↗</span>
      `;
      action.appendChild(link);
    }

    article.append(statusBox, logo, main, action);
    return article;
  }

  function renderLogo(opportunity) {
    const data = window.VacatoryOpportunityData;
    const box = document.createElement("div");
    box.className = "event-logo";
    box.setAttribute("aria-hidden", "true");
    const logoUrl = data.safeHttpUrl(opportunity.providerLogoUrl);

    if (logoUrl) {
      const image = document.createElement("img");
      image.src = logoUrl;
      image.alt = "";
      image.loading = "lazy";
      box.appendChild(image);
      return box;
    }

    box.textContent = providerInitials(opportunity.providerName);
    return box;
  }

  function renderFact(label, value) {
    const wrapper = document.createElement("div");
    wrapper.className = "event-fact";
    const labelNode = document.createElement("span");
    labelNode.className = "event-fact-label";
    labelNode.textContent = label;
    const valueNode = document.createElement("span");
    valueNode.className = "event-fact-value";
    valueNode.textContent = value || "See official page";
    wrapper.append(labelNode, valueNode);
    return wrapper;
  }

  function scholarshipStatus(opportunity) {
    const status = opportunity.publicApplicationStatus;
    const values = {
      open: ["open", "OPEN", "Applications open"],
      upcoming: ["upcoming", "SOON", "Applications upcoming"],
      rolling: ["rolling", "ROLLING", "Rolling applications"],
      available: ["rolling", "AVAILABLE", "Always available"],
      no_application: ["tbc", "NO APPLY", "No direct application"],
      closed: ["closed", "CLOSED", "Applications closed"],
      variable: ["tbc", "VARIABLE", "Application timing varies"]
    }[status] || ["tbc", "TBC", "Application dates not announced"];

    return { key: values[0], label: values[1], accessible: values[2] };
  }

  function applicationTiming(opportunity, data) {
    if (opportunity.applicationDatesText) {
      return opportunity.applicationDatesText;
    }

    if (opportunity.opensOn && opportunity.closesOn) {
      return data.formatDateRange(opportunity.opensOn, opportunity.closesOn);
    }

    if (opportunity.closesOn) {
      return `Closes ${data.formatDate(opportunity.closesOn)}`;
    }

    if (opportunity.opensOn) {
      return `Opens ${data.formatDate(opportunity.opensOn)}`;
    }

    return data.formatApplicationDateState(
      opportunity.publicApplicationDateState
    ) || data.formatApplicationStatus(opportunity.publicApplicationStatus);
  }

  function scholarshipKind(opportunity) {
    return opportunity.opportunityTypeSlug === "scholarship_bursary"
      ? opportunity.opportunityTypeLabel || "Scholarship / bursary"
      : "Programme with scholarship or bursary funding";
  }

  function scholarshipDisplayTitle(opportunity) {
    const title =
      opportunity.publicTitle ||
      "Scholarship or bursary";

    return title.replace(
      /^(Australia|Canada|France|Germany|Hong Kong|Ireland|Norway|Singapore|Spain|United Kingdom|United States)\s+-\s+/i,
      ""
    );
  }

  function providerLocation(opportunity) {
    return state.providerLocations.get(
      String(opportunity.providerId || "")
    ) || null;
  }

  function scholarshipCountries(opportunity) {
    if (opportunity.routeCountry) return [opportunity.routeCountry];

    const directCountries = uniqueSorted(opportunity.countries || []);
    if (directCountries.length) return directCountries;

    const provider = providerLocation(opportunity);
    return provider?.country ? [provider.country] : [];
  }

  function scholarshipLocation(opportunity) {
    const directCities = uniqueSorted([
      opportunity.routeCity,
      ...(opportunity.cities || [])
    ]);

    if (directCities.length) {
      const countries = scholarshipCountries(opportunity);
      return [...directCities, ...countries].join(", ");
    }

    const provider = providerLocation(opportunity);

    if (provider?.city) {
      if (opportunity.deliveryMode === "online") {
        return `Online · Provider: ${provider.city}`;
      }

      const country =
        opportunity.routeCountry ||
        (opportunity.countries || [])[0] ||
        provider.country;

      return [provider.city, country]
        .filter(Boolean)
        .join(", ");
    }

    return opportunity.publicLocationLabel ||
      opportunity.locationSummary ||
      scholarshipCountries(opportunity).join(", ") ||
      (opportunity.deliveryMode === "online" ? "Online" : "See official page");
  }

  function providerTypeLabel(opportunity) {
    return opportunity.providerType === "law_firm"
      ? "Law firm"
      : opportunity.providerType === "barristers_chambers"
        ? "Barristers’ chambers"
        : "Legal organisation";
  }

  function statusFilterLabel(opportunity) {
    return scholarshipStatus(opportunity).accessible;
  }

  function compareScholarships(first, second) {
    const rank = {
      open: 0,
      upcoming: 1,
      rolling: 2,
      available: 3,
      variable: 4,
      no_application: 5,
      unknown: 6,
      closed: 7
    };
    const statusDifference =
      (rank[first.publicApplicationStatus] ?? 6) -
      (rank[second.publicApplicationStatus] ?? 6);

    if (statusDifference) return statusDifference;
    const providerDifference = first.providerName.localeCompare(second.providerName);
    if (providerDifference) return providerDifference;
    return first.publicTitle.localeCompare(second.publicTitle);
  }

  function providerInitials(name) {
    return String(name || "V")
      .split(/\s+/)
      .filter(Boolean)
      .slice(0, 2)
      .map(word => word.charAt(0).toUpperCase())
      .join("") || "V";
  }

  function uniqueSorted(values) {
    return [...new Set(
      (values || [])
        .filter(Boolean)
        .map(value => String(value).trim())
        .filter(Boolean)
    )].sort((first, second) => first.localeCompare(second));
  }

  function updateCount(count) {
    if (!elements.count) return;
    elements.count.textContent = count === 1
      ? "1 scholarship or bursary."
      : `${count} scholarships, bursaries and directly funded programmes.`;
  }

  function showError() {
    elements.loading?.classList.add("hidden");
    elements.empty?.classList.add("hidden");
    elements.error?.classList.remove("hidden");
    if (elements.count) {
      elements.count.textContent = "Scholarships and bursaries could not be loaded.";
    }
  }
})();
