/*
 * Vacatory Events
 *
 * DATA RULES
 * ----------
 * - consumes window.VacatoryOpportunityData only
 * - schedule rows come from the shared lean canonical occurrence projection
 * - announced events only: an exact programme/event start date is required
 * - past events are excluded automatically
 * - public title/location are canonical and never rebuilt from free text
 * - public_opportunity_id is the public route identity after route cutover
 */

(() => {
  "use strict";

  const state = {
    occurrences: [],
    filtered: []
  };

  const elements = {};

  document.addEventListener("DOMContentLoaded", initialiseEvents);

  async function initialiseEvents() {
    cacheElements();
    connectFilters();

    if (!window.VacatoryOpportunityData || typeof client === "undefined") {
      showError();
      return;
    }

    try {
      state.occurrences =
        await window.VacatoryOpportunityData.loadEventOccurrences({
          client
        });

      populateFilters(state.occurrences);
      applyFilters();

      elements.loading?.classList.add("hidden");
    } catch (error) {
      console.error("Unable to load Vacatory events:", error);
      showError();
    }
  }

  function cacheElements() {
    elements.search = document.getElementById("eventSearch");
    elements.type = document.getElementById("eventTypeFilter");
    elements.provider = document.getElementById("eventProviderFilter");
    elements.country = document.getElementById("eventCountryFilter");
    elements.clear = document.getElementById("eventClearFilters");

    elements.count = document.getElementById("eventCount");
    elements.loading = document.getElementById("eventsLoading");
    elements.error = document.getElementById("eventsError");
    elements.empty = document.getElementById("eventsEmpty");
    elements.list = document.getElementById("eventsList");
  }

  function connectFilters() {
    elements.search?.addEventListener("input", applyFilters);
    elements.type?.addEventListener("change", applyFilters);
    elements.provider?.addEventListener("change", applyFilters);
    elements.country?.addEventListener("change", applyFilters);
    elements.clear?.addEventListener("click", clearFilters);
  }

  function populateFilters(occurrences) {
    populateSelect(
      elements.type,
      uniqueSorted(
        occurrences.map(item => eventTypeLabel(item))
      )
    );

    populateSelect(
      elements.provider,
      uniqueSorted(
        occurrences.map(item => item.providerName)
      )
    );


  }

  function populateSelect(select, values) {
    if (!select) {
      return;
    }

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
    const type = elements.type?.value || "";
    const provider = elements.provider?.value || "";
    const country = elements.country?.value || "";

    state.filtered = state.occurrences.filter(item => {
      if (query && !matchesEventSearch(item, query, data)) {
        return false;
      }

      if (type && eventTypeLabel(item) !== type) {
        return false;
      }

      if (provider && item.providerName !== provider) {
        return false;
      }

      if (country && !window.VacatoryJurisdictions.matchesOpportunity(item, country)) {
        return false;
      }

      return true;
    });

    renderEvents(state.filtered);
  }

  function clearFilters() {
    if (elements.search) elements.search.value = "";
    if (elements.type) elements.type.value = "";
    if (elements.provider) elements.provider.value = "";
    if (elements.country) elements.country.value = "";

    applyFilters();
    elements.search?.focus();
  }

  function matchesEventSearch(item, query, data) {
    const needle = data.normaliseText(query);

    if (!needle) {
      return true;
    }

    const haystack = data.normaliseText([
      item.publicTitle,
      item.providerName,
      item.providerShortName,
      eventTypeLabel(item),
      item.publicLocationLabel,
      item.routeCountry,
      item.routeCity,
      item.routeScope,
      ...(item.countries || []),
      ...(item.cities || [])
    ].filter(Boolean).join(" "));

    return haystack.includes(needle);
  }

  function renderEvents(occurrences) {
    updateCount(occurrences.length);

    if (!elements.list) {
      return;
    }

    elements.error?.classList.add("hidden");

    if (!occurrences.length) {
      elements.list.replaceChildren();
      elements.empty?.classList.remove("hidden");
      return;
    }

    elements.empty?.classList.add("hidden");

    const groups = groupByMonth(occurrences);
    const fragment = document.createDocumentFragment();

    for (const group of groups) {
      fragment.appendChild(renderMonth(group));
    }

    elements.list.replaceChildren(fragment);
  }

  function renderMonth(group) {
    const section = document.createElement("section");
    section.className = "event-month";
    section.setAttribute("aria-labelledby", group.id);

    const heading = document.createElement("h3");
    heading.id = group.id;
    heading.className = "event-month-heading";
    heading.textContent = group.label;

    const list = document.createElement("div");
    list.className = "event-month-list";

    for (const event of group.items) {
      list.appendChild(renderEventRow(event));
    }

    section.append(heading, list);
    return section;
  }

  function renderEventRow(event) {
    const data = window.VacatoryOpportunityData;
    const article = document.createElement("article");
    article.className = "event-row";

    const dateParts = shortEventDate(event.programmeStartsOn);

    const date = document.createElement("div");
    date.className = "event-date";
    date.setAttribute("aria-label", data.formatDate(event.programmeStartsOn));
    date.innerHTML = `
      <span class="event-date-day">${data.escapeHtml(dateParts.day)}</span>
      <span class="event-date-month">${data.escapeHtml(dateParts.month)}</span>
      <span class="event-date-year">${data.escapeHtml(dateParts.year)}</span>
    `;

    const main = document.createElement("div");
    main.className = "event-main";

    const title = document.createElement("h4");
    title.className = "event-title";
    title.textContent = eventDisplayTitle(event);

    const provider = document.createElement("p");
    provider.className = "event-provider";
    provider.textContent = event.providerName || "Organisation";

    const facts = document.createElement("div");
    facts.className = "event-facts";

    facts.append(
      renderFact("What", eventTypeLabel(event)),
      renderLocationFact(event, data),
      renderFact("When", eventWhenLabel(event, data))
    );

    main.append(provider, title, facts);

    const registration = registrationLabel(event, data);

    if (registration) {
      const registrationText = document.createElement("p");
      registrationText.className = "event-registration";
      registrationText.innerHTML = registration;
      main.appendChild(registrationText);
    }

    const action = document.createElement("div");
    action.className = "event-action";

    const officialUrl =
      data.safeHttpUrl(event.applicationUrl || event.officialUrl);

    if (officialUrl) {
      const link = document.createElement("a");
      link.className = "event-official-link";
      link.href = officialUrl;
      link.target = "_blank";
      link.rel = "noopener noreferrer";
      link.setAttribute(
        "aria-label",
        `${eventDisplayTitle(event)} official event page (opens in a new tab)`
      );
      link.innerHTML = `
        <span>Official event page</span>
        <span aria-hidden="true">↗</span>
      `;
      action.appendChild(link);
    }

    if (action.hasChildNodes()) {
      main.appendChild(action);
    }

    article.append(date, main);
    return article;
  }

  function renderFact(label, value) {
    const wrapper = document.createElement("div");
    wrapper.className = "event-fact";

    const labelNode = document.createElement("span");
    labelNode.className = "event-fact-label";
    labelNode.textContent = label;

    const valueNode = document.createElement("span");
    valueNode.className = "event-fact-value";
    valueNode.textContent = value || "Not specified";

    wrapper.append(labelNode, valueNode);
    return wrapper;
  }

  function renderLocationFact(event, data) {
    const countries = eventCountries(event);
    const place = cityOrScopeLabel(event);

    if (place === "Virtual") {
      return renderVirtualLocationFact();
    }

    if (!countries.length) {
      return renderFact("Where", eventLocationLabel(event));
    }

    const wrapper = document.createElement("div");
    wrapper.className = "event-fact";

    const labelNode = document.createElement("span");
    labelNode.className = "event-fact-label";
    labelNode.textContent = "Where";

    const valueNode = document.createElement("span");
    valueNode.className = "event-fact-value event-country-value";

    const accessibleLabel = [
      data.countryFlagItems(event).map(item => item.country).join(", "),
      place
    ].filter(Boolean).join(" — ");

    valueNode.setAttribute("role", "img");
    valueNode.setAttribute("aria-label", accessibleLabel);
    valueNode.title = accessibleLabel;

    const flagGroup = document.createElement("span");
    flagGroup.className = "country-flag-group";
    flagGroup.setAttribute("aria-hidden", "true");

    for (const item of data.countryFlagItems(event)) {
      const flag = document.createElement("span");
      flag.className = "country-flag";
      if (item.image) {
        const image = document.createElement("img");
        image.src = item.image;
        image.alt = "";
        image.width = 20;
        image.height = 12;
        flag.appendChild(image);
      } else {
        flag.textContent = item.flag;
      }
      flagGroup.appendChild(flag);
    }

    valueNode.appendChild(flagGroup);

    if (place) {
      const placeNode = document.createElement("span");
      placeNode.className = "event-country-place";
      placeNode.setAttribute("aria-hidden", "true");
      placeNode.textContent = place;
      valueNode.appendChild(placeNode);
    }

    wrapper.append(labelNode, valueNode);
    return wrapper;
  }

  function renderVirtualLocationFact() {
    const wrapper = document.createElement("div");
    wrapper.className = "event-fact";

    const labelNode = document.createElement("span");
    labelNode.className = "event-fact-label";
    labelNode.textContent = "Where";

    const valueNode = document.createElement("span");
    valueNode.className = "event-fact-value event-country-value";
    valueNode.setAttribute("role", "img");
    valueNode.setAttribute("aria-label", "Virtual");
    valueNode.title = "Virtual";
    valueNode.innerHTML = `
      <span class="country-flag" aria-hidden="true">💻</span>
      <span class="event-country-place" aria-hidden="true">Virtual</span>
    `;

    wrapper.append(labelNode, valueNode);
    return wrapper;
  }

  function groupByMonth(occurrences) {
    const groups = new Map();

    for (const item of occurrences) {
      const date = parseDateOnly(item.programmeStartsOn);

      if (!date) {
        continue;
      }

      const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}`;

      if (!groups.has(key)) {
        groups.set(key, {
          key,
          id: `events-${key}`,
          label: date.toLocaleDateString("en-GB", {
            month: "long",
            year: "numeric"
          }),
          items: []
        });
      }

      groups.get(key).items.push(item);
    }

    return [...groups.values()];
  }

  function eventTypeLabel(event) {
    return event.eventTypeLabel || event.opportunityTypeLabel || "Event";
  }

  function eventCountries(event) {
    if (event.routeCountry) {
      return [event.routeCountry];
    }

    return uniqueSorted(event.countries || []);
  }

  function cityOrScopeLabel(event) {
    if (event.routeCity) {
      return event.routeCity;
    }

    if (event.routeScope) {
      return event.routeScope;
    }

    if (event.cities?.length) {
      return uniqueSorted(event.cities).join(", ");
    }

    if (event.locationSummary === "Virtual") {
      return "Virtual";
    }

    if (["virtual", "online"].includes(event.deliveryMode)) {
      return "Virtual";
    }

    return "";
  }

  function eventDisplayTitle(event) {
    const title = String(event?.publicTitle || "").trim();
    if (!title) return "Legal career event";
    const countryPrefix = /^(?:(?:United Kingdom|Republic of Ireland|Ireland|England|Scotland|Wales|Northern Ireland)(?:\s*\/\s*(?:United Kingdom|Republic of Ireland|Ireland|England|Scotland|Wales|Northern Ireland))*)\s+-\s+/i;
    return title.replace(countryPrefix, "").trim() || title;
  }

  function eventLocationLabel(event) {
    return (
      event.publicLocationLabel ||
      event.locationSummary ||
      cityOrScopeLabel(event) ||
      event.routeCountry ||
      "Location on official page"
    );
  }

  function eventWhenLabel(event, data) {
    const text = String(event.programmeDatesText || "").trim();

    if (text && !containsLifecyclePlaceholder(text)) {
      return text;
    }

    return data.formatDateRange(
      event.programmeStartsOn,
      event.programmeEndsOn
    );
  }

  function registrationLabel(event, data) {
    if (!event.closesOn) {
      return "";
    }

    const today = data.todayDateOnly();
    const closed = event.closesOn < today;
    const label = closed ? "Registration closed" : "Registration closes";

    return `<strong>${data.escapeHtml(label)}:</strong> ${data.escapeHtml(data.formatDate(event.closesOn))}`;
  }

  function containsLifecyclePlaceholder(text) {
    return /(dates? not announced|future annual|next cycle|expected|not published)/i.test(text);
  }

  function shortEventDate(value) {
    const date = parseDateOnly(value);

    if (!date) {
      return { day: "", month: "", year: "" };
    }

    return {
      day: date.toLocaleDateString("en-GB", { day: "2-digit" }),
      month: date.toLocaleDateString("en-GB", { month: "short" }).toUpperCase(),
      year: date.toLocaleDateString("en-GB", { year: "numeric" })
    };
  }

  function parseDateOnly(value) {
    if (!value) {
      return null;
    }

    const text = String(value);
    const date = /^\d{4}-\d{2}-\d{2}$/.test(text)
      ? new Date(`${text}T00:00:00`)
      : new Date(text);

    return Number.isNaN(date.getTime()) ? null : date;
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
    if (!elements.count) {
      return;
    }

    elements.count.textContent =
      count === 1
        ? "1 announced upcoming event."
        : `${count} announced upcoming events.`;
  }

  function showError() {
    elements.loading?.classList.add("hidden");
    elements.empty?.classList.add("hidden");
    elements.error?.classList.remove("hidden");

    if (elements.count) {
      elements.count.textContent = "Events could not be loaded.";
    }
  }
})();
