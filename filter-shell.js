/*
 * Vacatory
 * filter-shell.js
 *
 * Canonical filter interface for Vacatory directory and resource listing pages.
 *
 * ARCHITECTURE RULE:
 * - page HTML supplies only a mount point and a preset name
 * - this file owns filter labels, controls, ordering and shared markup
 * - styles.css owns all filter layout and visual states
 * - page controllers own only data population and filtering behaviour
 */

(() => {
  "use strict";

  const SEARCH_ACCESSIBILITY = Object.freeze({
    firms: {
      controls: "firmsDirectory",
      describedBy: "directoryCount"
    },
    chambers: {
      controls: "chambersDirectory",
      describedBy: "directoryCount"
    },
    deadlines: {
      controls: "deadlinesList",
      describedBy: "deadlineCount"
    },
    events: {
      controls: "eventsList",
      describedBy: "eventCount"
    },
    scholarships: {
      controls: "scholarshipsList",
      describedBy: "scholarshipCount"
    },
    resources: {
      controls: "resourceGroups",
      describedBy: "resourceCount"
    }
  });

  const SEARCHABLE_SELECT_THRESHOLD = 40;
  const SEARCHABLE_OPTION_LIMIT = 75;

  const PRESETS = Object.freeze({
    firms: {
      controls: [
        searchControl({
          id: "directorySearch",
          label: "Search firms",
          placeholder: "Search by firm name"
        }),
        selectControl({
          id: "sortFilter",
          label: "Sort by",
          options: [
            ["rank", "UK ranking"],
            ["az", "Firm name A-Z"],
            ["za", "Firm name Z-A"]
          ]
        }),
        selectControl({
          id: "locationFilter",
          label: "Location",
          options: [["", "All locations"]]
        }),
        selectControl({
          id: "practiceFilter",
          label: "Practice area",
          options: [["", "All practice areas"]]
        }),
        selectControl({
          id: "roleFilter",
          label: "Opportunity",
          options: [["", "All opportunities"]]
        }),
        selectControl({
          id: "statusFilter",
          label: "Application status",
          options: [
            ["", "All statuses"],
            ["open", "Open"],
            ["upcoming", "Upcoming"],
            ["rolling", "Rolling"],
            ["closed", "Closed"],
            ["unknown", "Dates not announced"]
          ]
        }),
        clearControl({ id: "clearFilters" })
      ]
    },

    chambers: {
      controls: [
        searchControl({
          id: "directorySearch",
          label: "Search chambers",
          placeholder: "Search by chambers name"
        }),
        selectControl({
          id: "sortFilter",
          label: "Sort by",
          options: [
            ["ranking", "Best verified ranking"],
            ["az", "Chambers name A-Z"],
            ["za", "Chambers name Z-A"]
          ]
        }),
        selectControl({
          id: "locationFilter",
          label: "Location",
          options: [["", "All locations"]]
        }),
        selectControl({
          id: "circuitFilter",
          label: "Circuit or region",
          options: [["", "All circuits and regions"]]
        }),
        selectControl({
          id: "practiceFilter",
          label: "Practice area",
          options: [["", "All practice areas"]]
        }),
        selectControl({
          id: "opportunityFilter",
          label: "Opportunity",
          options: [
            ["", "All opportunities"],
            ["pupillage", "Pupillage"],
            ["mini_pupillage", "Mini-pupillage"],
            ["assessed_mini_pupillage", "Assessed mini-pupillage"]
          ]
        }),
        clearControl({ id: "clearFilters" })
      ]
    },

    deadlines: {
      controls: [
        searchControl({
          id: "deadlineSearch",
          label: "Search opportunities",
          placeholder: "Search by opportunity or provider"
        }),
        selectControl({
          id: "deadlineType",
          label: "Opportunity type",
          options: [["", "All opportunity types"]]
        }),
        selectControl({
          id: "deadlineProvider",
          label: "Provider",
          options: [["", "All providers"]]
        }),
        selectControl({
          id: "deadlineCountry",
          label: "Country",
          options: [["", "All countries"]]
        }),
        selectControl({
          id: "deadlineLocation",
          label: "City / scope",
          options: [["", "All cities and scopes"]]
        }),
        clearControl({ id: "deadlineReset" })
      ]
    },

    events: {
      controls: [
        searchControl({
          id: "eventSearch",
          label: "Search events",
          placeholder: "Search by event or provider"
        }),
        selectControl({
          id: "eventTypeFilter",
          label: "Event type",
          options: [["", "All event types"]]
        }),
        selectControl({
          id: "eventProviderFilter",
          label: "Provider",
          options: [["", "All providers"]]
        }),
        selectControl({
          id: "eventCountryFilter",
          label: "Country",
          options: [["", "All countries"]]
        }),
        selectControl({
          id: "eventLocationFilter",
          label: "City / scope",
          options: [["", "All cities and scopes"]]
        }),
        clearControl({ id: "eventClearFilters" })
      ]
    },

    scholarships: {
      controls: [
        searchControl({
          id: "scholarshipSearch",
          label: "Search scholarships",
          placeholder: "Search by scholarship or provider"
        }),
        selectControl({
          id: "scholarshipProviderType",
          label: "Provider type",
          options: [["", "All provider types"]]
        }),
        selectControl({
          id: "scholarshipProvider",
          label: "Provider",
          options: [["", "All providers"]]
        }),
        selectControl({
          id: "scholarshipCountry",
          label: "Country",
          options: [["", "All countries"]]
        }),
        selectControl({
          id: "scholarshipStatus",
          label: "Application status",
          options: [["", "All statuses"]]
        }),
        clearControl({ id: "scholarshipReset" })
      ]
    },

    resources: {
      controls: [
        searchControl({
          id: "resourceSearch",
          label: "Search resources",
          placeholder: "Search by source, topic or resource type"
        }),
        selectControl({
          id: "resourceJurisdiction",
          label: "Jurisdiction",
          options: [
            ["england-wales", "England and Wales"],
            ["scotland", "Scotland"],
            ["northern-ireland", "Northern Ireland"],
            ["ireland", "Republic of Ireland"],
            ["eu", "European Union"],
            ["united-states", "United States"],
            ["canada", "Canada"],
            ["australia", "Australia"],
            ["new-zealand", "New Zealand"]
          ]
        }),
        selectControl({
          id: "resourceCategory",
          label: "Category",
          options: [["", "All categories"]]
        }),
        clearControl({ id: "resourceClearFilters" })
      ]
    }
  });

  function searchControl({ id, label, placeholder }) {
    return Object.freeze({
      type: "search",
      id,
      label,
      placeholder
    });
  }

  function selectControl({ id, label, options }) {
    return Object.freeze({
      type: "select",
      id,
      label,
      options: Object.freeze(options.map(option => Object.freeze([...option])))
    });
  }

  function clearControl({ id }) {
    return Object.freeze({
      type: "button",
      id,
      label: "Clear filters"
    });
  }

  function mountAll() {
    document
      .querySelectorAll("[data-vacatory-filter-shell]")
      .forEach(mount);
  }

  function mount(root) {
    if (!(root instanceof Element)) {
      return;
    }

    if (root.dataset.vacatoryFilterReady === "true") {
      return;
    }

    const presetName = root.dataset.vacatoryFilterShell;
    const preset = PRESETS[presetName];

    if (!preset) {
      console.error(`Unknown Vacatory filter preset: ${presetName}`);
      return;
    }

    const fragment = document.createDocumentFragment();

    for (const control of preset.controls) {
      fragment.appendChild(
        renderControl(control, presetName)
      );
    }

    root.replaceChildren(fragment);
    root.dataset.vacatoryFilterReady = "true";
    initialiseSearchableSelects(root);

    root.dispatchEvent(
      new CustomEvent("vacatory:filter-shell-ready", {
        bubbles: true,
        detail: { preset: presetName }
      })
    );
  }

  function renderControl(control, presetName) {
    if (control.type === "button") {
      const button = document.createElement("button");
      button.id = control.id;
      button.className = "ghost-btn";
      button.type = "button";
      button.textContent = control.label;
      return button;
    }

    const wrapper = document.createElement("div");
    wrapper.className = "filter-control";

    const label = document.createElement("label");
    label.htmlFor = control.id;
    label.textContent = control.label;
    wrapper.appendChild(label);

    if (control.type === "search") {
      const input = document.createElement("input");
      input.id = control.id;
      input.type = "search";
      input.placeholder = control.placeholder || "";
      input.autocomplete = "off";
      input.setAttribute("role", "searchbox");

      const relationship =
        SEARCH_ACCESSIBILITY[presetName];

      if (relationship) {
        input.setAttribute(
          "aria-controls",
          relationship.controls
        );
        input.setAttribute(
          "aria-describedby",
          relationship.describedBy
        );
      }

      wrapper.appendChild(input);
      return wrapper;
    }

    const select = document.createElement("select");
    select.id = control.id;
    select.dataset.filterLabel = control.label;

    for (const [value, text] of control.options || []) {
      const option = document.createElement("option");
      option.value = value;
      option.textContent = text;
      select.appendChild(option);
    }

    wrapper.appendChild(select);
    return wrapper;
  }

  function initialiseSearchableSelects(root) {
    root
      .querySelectorAll("select")
      .forEach(watchSearchableSelect);

    root.addEventListener("click", event => {
      if (!event.target.closest(".ghost-btn")) {
        return;
      }

      queueMicrotask(() => {
        root
          .querySelectorAll("select")
          .forEach(select => {
            select.vacatorySearchableSelect?.sync();
          });
      });
    });
  }

  function watchSearchableSelect(select) {
    if (
      !(select instanceof HTMLSelectElement) ||
      select.dataset.searchableSelectWatch === "true"
    ) {
      return;
    }

    select.dataset.searchableSelectWatch = "true";

    let observer;

    const enhanceWhenNeeded = () => {
      if (select.dataset.searchableSelectReady === "true") {
        observer?.disconnect();
        return true;
      }

      const optionCount =
        Array.from(select.options)
          .filter(option => !option.disabled)
          .length;

      if (optionCount <= SEARCHABLE_SELECT_THRESHOLD) {
        return false;
      }

      enhanceSearchableSelect(select);
      observer?.disconnect();
      return true;
    };

    observer = new MutationObserver(enhanceWhenNeeded);

    if (!enhanceWhenNeeded()) {
      observer.observe(select, {
        childList: true,
        subtree: true
      });
    }
  }

  function enhanceSearchableSelect(select) {
    const filterControl =
      select.closest(".filter-control");

    if (!filterControl) {
      return;
    }

    const originalLabel =
      Array.from(filterControl.querySelectorAll("label"))
        .find(label => label.htmlFor === select.id);

    const filterLabel =
      select.dataset.filterLabel ||
      originalLabel?.textContent?.trim() ||
      "Filter";

    const inputId =
      `${select.id}SearchCombobox`;

    const listboxId =
      `${select.id}SearchListbox`;

    const statusId =
      `${select.id}SearchStatus`;

    const component =
      document.createElement("div");

    component.className = "searchable-select";

    const input =
      document.createElement("input");

    input.id = inputId;
    input.className = "searchable-select-input";
    input.type = "text";
    input.autocomplete = "off";
    input.spellcheck = false;
    input.placeholder =
      `Search ${filterLabel.toLowerCase()}`;
    input.setAttribute("role", "combobox");
    input.setAttribute("aria-autocomplete", "list");
    input.setAttribute("aria-haspopup", "listbox");
    input.setAttribute("aria-expanded", "false");
    input.setAttribute("aria-controls", listboxId);
    input.setAttribute("aria-describedby", statusId);

    const listbox =
      document.createElement("div");

    listbox.id = listboxId;
    listbox.className = "searchable-select-listbox";
    listbox.setAttribute("role", "listbox");
    listbox.setAttribute(
      "aria-label",
      `${filterLabel} options`
    );
    listbox.hidden = true;

    const status =
      document.createElement("div");

    status.id = statusId;
    status.className = "sr-only";
    status.setAttribute("role", "status");
    status.setAttribute("aria-live", "polite");

    component.append(input, listbox, status);
    select.insertAdjacentElement("afterend", component);

    select.classList.add("searchable-select-native");
    select.setAttribute("aria-hidden", "true");
    select.tabIndex = -1;
    select.dataset.searchableSelectReady = "true";

    if (originalLabel) {
      originalLabel.htmlFor = inputId;
    }

    let expanded = false;
    let activeIndex = -1;
    let visibleOptions = [];

    const normalise = value => {
      return String(value || "")
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .toLowerCase()
        .trim();
    };

    const availableOptions = () => {
      return Array.from(select.options)
        .filter(option => !option.disabled)
        .map(option => ({
          value: option.value,
          label: option.textContent?.trim() || option.value,
          index: option.index
        }));
    };

    const selectedLabel = () => {
      const option = select.options[select.selectedIndex];

      if (!option || !option.value) {
        return "";
      }

      return option.textContent?.trim() || option.value;
    };

    const syncFromSelect = () => {
      input.value = selectedLabel();
    };

    const updateStatus = (matchingCount, shownCount) => {
      if (!matchingCount) {
        status.textContent =
          `No matching ${filterLabel.toLowerCase()} options.`;
        return;
      }

      if (matchingCount > shownCount) {
        status.textContent =
          `${shownCount} of ${matchingCount} matching options shown. ` +
          "Type more characters to narrow the list.";
        return;
      }

      status.textContent =
        `${matchingCount} matching ` +
        `${matchingCount === 1 ? "option" : "options"}. ` +
        "Use the arrow keys to review and Enter to select.";
    };

    const renderOptions = () => {
      const query = normalise(input.value);
      const matches = availableOptions()
        .filter(option => {
          return (
            !query ||
            normalise(option.label).includes(query)
          );
        });

      visibleOptions =
        matches.slice(0, SEARCHABLE_OPTION_LIMIT);

      if (activeIndex >= visibleOptions.length) {
        activeIndex = visibleOptions.length - 1;
      }

      const fragment =
        document.createDocumentFragment();

      visibleOptions.forEach((option, index) => {
        const optionElement =
          document.createElement("div");

        optionElement.id =
          `${listboxId}-option-${option.index}`;

        optionElement.className =
          "searchable-select-option";

        optionElement.setAttribute("role", "option");
        optionElement.setAttribute(
          "aria-selected",
          String(select.value === option.value)
        );
        optionElement.dataset.value = option.value;
        optionElement.textContent = option.label;

        if (index === activeIndex) {
          optionElement.classList.add("is-active");
          input.setAttribute(
            "aria-activedescendant",
            optionElement.id
          );
        }

        fragment.appendChild(optionElement);
      });

      if (!visibleOptions.length) {
        const empty =
          document.createElement("div");

        empty.className =
          "searchable-select-empty";

        empty.textContent = "No matching options";
        fragment.appendChild(empty);
        input.removeAttribute("aria-activedescendant");
      } else if (activeIndex < 0) {
        input.removeAttribute("aria-activedescendant");
      }

      listbox.replaceChildren(fragment);
      updateStatus(matches.length, visibleOptions.length);
    };

    const open = () => {
      if (expanded || input.disabled) {
        return;
      }

      expanded = true;
      component.classList.add("is-open");
      input.setAttribute("aria-expanded", "true");
      listbox.hidden = false;
      renderOptions();
    };

    const close = ({ restore = false } = {}) => {
      expanded = false;
      activeIndex = -1;
      component.classList.remove("is-open");
      input.setAttribute("aria-expanded", "false");
      input.removeAttribute("aria-activedescendant");
      listbox.hidden = true;

      if (restore) {
        syncFromSelect();
      }
    };

    const chooseOption = option => {
      if (!option) {
        return;
      }

      select.value = option.value;
      syncFromSelect();

      select.dispatchEvent(
        new Event("change", { bubbles: true })
      );

      status.textContent = option.value
        ? `${filterLabel} set to ${option.label}.`
        : `${filterLabel} filter cleared.`;

      close();
      input.focus();
    };

    const moveActiveOption = direction => {
      if (!expanded) {
        open();

        activeIndex =
          direction > 0
            ? 0
            : visibleOptions.length - 1;
      } else {
        activeIndex = Math.max(
          0,
          Math.min(
            visibleOptions.length - 1,
            activeIndex + direction
          )
        );
      }

      renderOptions();

      const activeOption =
        input.getAttribute("aria-activedescendant");

      if (activeOption) {
        document
          .getElementById(activeOption)
          ?.scrollIntoView({ block: "nearest" });
      }
    };

    input.addEventListener("focus", open);
    input.addEventListener("click", open);

    input.addEventListener("input", () => {
      if (
        select.value &&
        normalise(input.value) !==
          normalise(selectedLabel())
      ) {
        select.value = "";

        select.dispatchEvent(
          new Event("change", { bubbles: true })
        );
      }

      activeIndex = 0;

      if (!expanded) {
        open();
      } else {
        renderOptions();
      }
    });

    input.addEventListener("keydown", event => {
      if (event.key === "ArrowDown") {
        event.preventDefault();
        moveActiveOption(1);
        return;
      }

      if (event.key === "ArrowUp") {
        event.preventDefault();
        moveActiveOption(-1);
        return;
      }

      if (
        event.key === "Home" &&
        expanded &&
        visibleOptions.length
      ) {
        event.preventDefault();
        activeIndex = 0;
        renderOptions();
        return;
      }

      if (
        event.key === "End" &&
        expanded &&
        visibleOptions.length
      ) {
        event.preventDefault();
        activeIndex = visibleOptions.length - 1;
        renderOptions();
        return;
      }

      if (
        event.key === "Enter" &&
        expanded &&
        activeIndex >= 0
      ) {
        event.preventDefault();
        chooseOption(visibleOptions[activeIndex]);
        return;
      }

      if (event.key === "Escape" && expanded) {
        event.preventDefault();
        close({ restore: true });
        return;
      }

      if (event.key === "Tab") {
        close({ restore: true });
      }
    });

    listbox.addEventListener("mousedown", event => {
      event.preventDefault();
    });

    listbox.addEventListener("click", event => {
      const optionElement =
        event.target.closest('[role="option"]');

      if (!optionElement) {
        return;
      }

      chooseOption(
        visibleOptions.find(option => {
          return option.value ===
            optionElement.dataset.value;
        })
      );
    });

    select.addEventListener("change", syncFromSelect);

    document.addEventListener("pointerdown", event => {
      if (!component.contains(event.target)) {
        close({ restore: true });
      }
    });

    const optionObserver =
      new MutationObserver(() => {
        syncFromSelect();

        if (expanded) {
          renderOptions();
        }
      });

    optionObserver.observe(select, {
      childList: true,
      subtree: true
    });

    select.vacatorySearchableSelect =
      Object.freeze({
        sync: syncFromSelect,
        open,
        close
      });

    syncFromSelect();
  }

  window.VacatoryFilterShell = Object.freeze({
    mount,
    mountAll,
    presets: PRESETS
  });

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", mountAll, { once: true });
  } else {
    mountAll();
  }
})();
