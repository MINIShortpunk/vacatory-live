/*
 * Vacatory shared results shell
 *
 * One canonical listing/results structure for directory, opportunity and resource pages.
 * Pages provide only a data-vacatory-results-shell mount. This module owns:
 * - section/container geometry
 * - visible or screen-reader-only result headings
 * - live result counts
 * - loading, error and empty states
 * - the page's result-list mount point
 *
 * Page controllers continue to own data loading, filtering and card rendering.
 */
(() => {
  "use strict";

  const CONFIGS = Object.freeze({
    firms: {
      heading: { id: "firms-directory-title", text: "Law firms", visible: false },
      count: { id: "directoryCount", text: "Loading firms…", visible: false },
      loading: {
        id: "directoryLoading",
        title: "Loading firms…",
        detail: "Please wait while the directory loads."
      },
      error: {
        id: "directoryError",
        title: "Unable to load firms",
        detail: "Please refresh the page and try again."
      },
      empty: {
        id: "directoryEmpty",
        title: "No firms match these filters",
        detail: "Try clearing one or more filters."
      },
      list: { id: "firmsDirectory", className: "firms-grid" }
    },

    chambers: {
      heading: { id: "chambers-directory-title", text: "Chambers directory", visible: false },
      count: { id: "directoryCount", text: "Loading chambers…", visible: false },
      loading: {
        id: "directoryLoading",
        title: "Loading chambers…",
        detail: "Please wait while the directory loads."
      },
      error: {
        id: "directoryError",
        title: "Unable to load chambers",
        detail: "Please refresh the page and try again."
      },
      empty: {
        id: "directoryEmpty",
        title: "No chambers match these filters",
        detail: "Try clearing one or more filters."
      },
      list: { id: "chambersDirectory", className: "firms-grid" }
    },

    deadlines: {
      heading: { id: "deadline-results-title", text: "Current application deadlines", visible: false },
      count: { id: "deadlineCount", text: "Loading current application deadlines…", visible: false },
      loading: {
        id: "deadlinesLoading",
        title: "Loading current application deadlines…",
        detail: "Please wait while current deadlines and ongoing opportunities load."
      },
      error: {
        id: "deadlinesError",
        title: "Unable to load application deadlines",
        detail: "Please refresh the page and try again."
      },
      empty: {
        id: "deadlinesEmpty",
        title: "No current deadlines or ongoing opportunities match these filters",
        detail: "Try clearing one or more filters."
      },
      list: { id: "deadlinesList", className: "deadlines-list" }
    },

    events: {
      heading: { id: "events-list-title", text: "Upcoming events", visible: false },
      count: { id: "eventCount", text: "Loading announced events…", visible: false },
      loading: {
        id: "eventsLoading",
        title: "Loading events…",
        detail: "Please wait while announced events are loaded."
      },
      error: {
        id: "eventsError",
        title: "Unable to load events",
        detail: "Please refresh the page and try again."
      },
      empty: {
        id: "eventsEmpty",
        title: "No announced events match these filters",
        detail: "Try clearing one or more filters."
      },
      list: { id: "eventsList", className: "events-list" }
    },

    scholarships: {
      heading: { id: "scholarships-list-title", text: "Scholarships and bursaries", visible: false },
      count: { id: "scholarshipCount", text: "Loading scholarships and bursaries…", visible: false },
      loading: {
        id: "scholarshipsLoading",
        title: "Loading scholarships and bursaries…",
        detail: "Please wait while firm and chambers funding opportunities are loaded."
      },
      error: {
        id: "scholarshipsError",
        title: "Unable to load scholarships and bursaries",
        detail: "Please refresh the page and try again."
      },
      empty: {
        id: "scholarshipsEmpty",
        title: "No scholarships or bursaries match these filters",
        detail: "Try clearing one or more filters."
      },
      list: { id: "scholarshipsList", className: "events-list scholarships-list" }
    },

    resources: {
      heading: { id: "resources-list-title", text: "Legal resources", visible: true },
      count: { id: "resourceCount", text: "Loading legal resources…", visible: true },
      loading: {
        id: "resourcesLoading",
        title: "Loading legal resources…",
        detail: "Please wait while the resource library is prepared."
      },
      error: {
        id: "resourcesError",
        title: "Unable to load legal resources",
        detail: "Please refresh the page and try again."
      },
      empty: {
        id: "resourcesEmpty",
        title: "No legal resources match these filters",
        detail: "Try another search term, category or jurisdiction."
      },
      list: { id: "resourceGroups", className: "resource-groups" }
    }
  });

  function escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  function stateMarkup(state, type, hidden = true) {
    const role = type === "error" ? "alert" : "status";
    const hiddenClass = hidden ? " hidden" : "";

    return `
      <div
        id="${escapeHtml(state.id)}"
        class="results-shell-state results-shell-state-${escapeHtml(type)}${hiddenClass}"
        role="${role}"
        ${type === "empty" ? 'aria-live="polite"' : ""}
      >
        <p>${escapeHtml(state.title)}</p>
        <span>${escapeHtml(state.detail)}</span>
      </div>
    `;
  }

  function renderMount(mount) {
    const key = mount.dataset.vacatoryResultsShell;
    const config = CONFIGS[key];

    if (!config) {
      console.error(`Unknown Vacatory results shell: ${key}`);
      return;
    }

    const headingClass = config.heading.visible
      ? "results-shell-heading"
      : "sr-only";

    const countClass = config.count.visible
      ? "results-shell-count"
      : "sr-only";

    mount.classList.add("results-shell-section");
    mount.setAttribute("aria-labelledby", config.heading.id);

    mount.innerHTML = `
      <div class="container results-shell-inner">
        <div class="${headingClass}">
          <h2 id="${escapeHtml(config.heading.id)}">${escapeHtml(config.heading.text)}</h2>
          <p
            id="${escapeHtml(config.count.id)}"
            class="${countClass}"
            aria-live="polite"
          >${escapeHtml(config.count.text)}</p>
        </div>

        <div class="results-shell-states">
          ${stateMarkup(config.loading, "loading", false)}
          ${stateMarkup(config.error, "error", true)}
          ${stateMarkup(config.empty, "empty", true)}
        </div>

        <div
          id="${escapeHtml(config.list.id)}"
          class="results-shell-list ${escapeHtml(config.list.className)}"
          aria-live="polite"
        ></div>
      </div>
    `;
  }

  function initialiseResultsShells() {
    document
      .querySelectorAll("[data-vacatory-results-shell]")
      .forEach(renderMount);
  }

  window.VacatoryResultsShell = Object.freeze({
    configs: CONFIGS,
    initialise: initialiseResultsShells
  });

  document.addEventListener("DOMContentLoaded", initialiseResultsShells);
})();
