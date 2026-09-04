const VACATORY_NAV_ITEMS = Object.freeze([
  { key: "firms", label: "Firms", href: "firms.html" },
  { key: "chambers", label: "Chambers", href: "chambers.html" },
  { key: "deadlines", label: "Deadlines", href: "deadlines.html" },
  { key: "events", label: "Events", href: "events.html" },
  { key: "scholarships", label: "Scholarships", href: "scholarships.html" },
  { key: "resources", label: "Resources", href: "legal-resources.html" }
]);

const VACATORY_ACTIVE_NAV = Object.freeze({
  firms: "firms",
  "firm-profile": "firms",
  chambers: "chambers",
  "chamber-profile": "chambers",
  deadlines: "deadlines",
  events: "events",
  scholarships: "scholarships",
  resources: "resources"
});

const VACATORY_SEARCH_ACTIONS = Object.freeze({
  home: { href: "#firm-search", label: "Search Vacatory" },
  firms: { href: "#directorySearch", label: "Search firms" },
  "firm-profile": { href: "firms.html", label: "Search firms", crossPage: true },
  chambers: { href: "#directorySearch", label: "Search chambers" },
  "chamber-profile": {
    href: "chambers.html",
    label: "Search chambers",
    crossPage: true
  },
  deadlines: { href: "#deadlineSearch", label: "Search application deadlines" },
  events: { href: "#eventSearch", label: "Search events" },
  scholarships: { href: "#scholarshipSearch", label: "Search scholarships" },
  resources: {
    href: "#resourceSearch",
    label: "Search legal resources"
  },
  search: { href: "#resultsSearchInput", label: "Search Vacatory" },
  favourites: { href: "firms.html", label: "Search firms", crossPage: true }
});

const VACATORY_SITE_NOTICE_VISIBLE = true;

const VACATORY_NOTICE_CONTENT = Object.freeze({
  home: {
    title: "Vacatory is currently being updated.",
    message: "Some pages or information may not display correctly while changes are in progress."
  },
  firms: {
    title: "Site update in progress.",
    message: "Some information may change while firm research is being checked and expanded."
  },
  "firm-profile": {
    title: "Site update in progress.",
    message: "Some information may change while firm research is being checked and expanded."
  },
  chambers: {
    title: "Site update in progress.",
    message: "Chambers research is being added."
  },
  "chamber-profile": {
    title: "Site update in progress.",
    message: "Detailed chambers research is being added one set at a time."
  },
  deadlines: {
    title: "Site update in progress.",
    message: "Application information is being checked and expanded."
  },
  events: {
    title: "Site update in progress.",
    message: "Event information is being checked and expanded."
  },
  scholarships: {
    title: "Site update in progress.",
    message: "Scholarship and bursary information is being checked and expanded."
  },
  resources: {
    title: "Site update in progress.",
    message: "Resource information is being checked and expanded."
  },
  search: {
    title: "Site update in progress.",
    message: "Some information may change while Vacatory is being updated."
  },
  favourites: {
    title: "Site update in progress.",
    message: "Some information may change while Vacatory is being updated."
  }
});

function escapeAttribute(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll('"', "&quot;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;");
}

function normalisePathname(pathname) {
  return String(pathname || "")
    .replace(/[?#].*$/, "")
    .replace(/\\/g, "/")
    .replace(/^\/+/, "")
    .toLowerCase();
}

export function inferSiteContextFromPathname(pathname) {
  const path = normalisePathname(pathname);

  if (path === "firms.html" || path.endsWith("/firms.html")) {
    return "firms";
  }

  if (
    path === "firm-profile.html" ||
    path.endsWith("/firm-profile.html") ||
    /(^|\/)firms\/[^/]+\/?(?:index\.html)?$/.test(path)
  ) {
    return "firm-profile";
  }

  if (!path || path === "index.html" || path.endsWith("/index.html")) {
    return "home";
  }

  if (path === "chambers.html" || path.endsWith("/chambers.html")) {
    return "chambers";
  }

  if (path === "chamber-profile.html" || path.endsWith("/chamber-profile.html")) {
    return "chamber-profile";
  }

  if (path === "deadlines.html" || path.endsWith("/deadlines.html")) {
    return "deadlines";
  }

  if (path === "events.html" || path.endsWith("/events.html")) {
    return "events";
  }

  if (path === "scholarships.html" || path.endsWith("/scholarships.html")) {
    return "scholarships";
  }

  if (path === "legal-resources.html" || path.endsWith("/legal-resources.html")) {
    return "resources";
  }

  if (path === "search-results.html" || path.endsWith("/search-results.html")) {
    return "search";
  }

  if (path === "favourites.html" || path.endsWith("/favourites.html")) {
    return "favourites";
  }

  return "home";
}

function hrefWithPrefix(href, hrefPrefix) {
  if (!href || href.startsWith("#") || /^(?:https?:|mailto:|tel:)/i.test(href)) {
    return href;
  }

  const prefix = String(hrefPrefix ?? "/");

  if (!prefix) {
    return href;
  }

  if (prefix.endsWith("/")) {
    return `${prefix}${href.replace(/^\//, "")}`;
  }

  return `${prefix}/${href.replace(/^\//, "")}`;
}

function navLinkMarkup(item, activeKey, hrefPrefix) {
  const active = item.key === activeKey;
  const href = hrefWithPrefix(item.href, hrefPrefix);

  return `<a href="${escapeAttribute(href)}"${active ? ' aria-current="page"' : ""}>${item.label}</a>`;
}

function logoMarkup() {
  return `<svg class="brand-mark" viewBox="0 0 28 28" aria-hidden="true"><path d="M4 4 L14 24" class="logo-stroke-left" stroke-width="3.4" stroke-linecap="round" fill="none"></path><path d="M24 4 L14 24" class="logo-stroke-right" stroke-width="3.4" stroke-linecap="round" fill="none"></path></svg><span class="brand-word"><span class="sr-only">V</span>acatory</span>`;
}

function menuIconMarkup() {
  return `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M4 7h16"></path><path d="M4 12h16"></path><path d="M4 17h16"></path></svg>`;
}

function searchIconMarkup() {
  return `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><circle cx="11" cy="11" r="7"></circle><path d="M20 20l-3.5-3.5"></path></svg>`;
}

function themeIconMarkup() {
  return `<svg class="icon-sun" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><circle cx="12" cy="12" r="4"></circle><path d="M12 2v2"></path><path d="M12 20v2"></path><path d="M4.9 4.9l1.4 1.4"></path><path d="M17.7 17.7l1.4 1.4"></path><path d="M2 12h2"></path><path d="M20 12h2"></path><path d="M4.9 19.1l1.4-1.4"></path><path d="M17.7 6.3l1.4-1.4"></path></svg><svg class="icon-moon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"></path></svg>`;
}

function siteNoticeMarkup(context) {
  if (!VACATORY_SITE_NOTICE_VISIBLE) {
    return "";
  }

  const content = VACATORY_NOTICE_CONTENT.home;

  return `<div class="site-notice" role="status" data-vacatory-site-notice><div class="container notice-inner"><span class="notice-dot" aria-hidden="true"></span><strong>${escapeAttribute(content.title)}</strong><span>${escapeAttribute(content.message)}</span></div></div>`;
}

function ensureSiteNotice() {
  if (!VACATORY_SITE_NOTICE_VISIBLE || document.querySelector("[data-vacatory-site-notice]")) {
    return;
  }

  const shell = document.querySelector("[data-vacatory-site-shell-rendered]");

  if (shell) {
    shell.insertAdjacentHTML("beforeend", siteNoticeMarkup(inferSiteContextFromPathname(window.location.pathname)));
  }
}

export function renderSiteShell({
  pathname = "",
  context = inferSiteContextFromPathname(pathname),
  hrefPrefix = "/"
} = {}) {
  const activeKey = VACATORY_ACTIVE_NAV[context] || "";
  const searchAction = VACATORY_SEARCH_ACTIONS[context] || VACATORY_SEARCH_ACTIONS.home;
  const searchHref = searchAction.crossPage
    ? hrefWithPrefix(searchAction.href, hrefPrefix)
    : searchAction.href;
  const homeHref = hrefWithPrefix("index.html", hrefPrefix);
  const desktopLinks = VACATORY_NAV_ITEMS
    .map((item) => navLinkMarkup(item, activeKey, hrefPrefix))
    .join("");
  const mobileLinks = VACATORY_NAV_ITEMS
    .map((item) => navLinkMarkup(item, activeKey, hrefPrefix))
    .join("");

  return `<div data-vacatory-site-shell-rendered><header class="site-header"><div class="container header-inner"><a href="${escapeAttribute(homeHref)}" class="brand" aria-label="Vacatory home">${logoMarkup()}</a><nav class="main-nav" aria-label="Main navigation">${desktopLinks}</nav><div class="header-actions"><button id="mobileMenuToggle" class="mobile-menu-toggle" type="button" aria-label="Open navigation menu" aria-expanded="false" aria-controls="mobileNavigation">${menuIconMarkup()}</button><a class="header-search-link" href="${escapeAttribute(searchHref)}" aria-label="${escapeAttribute(searchAction.label)}"><span class="sr-only">${escapeAttribute(searchAction.label)}</span>${searchIconMarkup()}</a><button id="themeToggle" class="theme-toggle" type="button" aria-label="Switch to dark mode">${themeIconMarkup()}</button></div></div></header><nav id="mobileNavigation" class="mobile-navigation" aria-label="Mobile navigation" hidden>${mobileLinks}</nav>${siteNoticeMarkup(context)}</div>`;
}

function runtimeHrefPrefix() {
  if (typeof window === "undefined") {
    return "/";
  }

  if (window.location.protocol !== "file:") {
    return "/";
  }

  const path = normalisePathname(window.location.pathname);

  if (/(^|\/)firms\/[^/]+\/?(?:index\.html)?$/.test(path)) {
    return "../../";
  }

  return "";
}

function currentTheme() {
  return document.documentElement.dataset.theme === "dark" ? "dark" : "light";
}

function updateThemeButtonLabel(button) {
  if (!button) {
    return;
  }

  const dark = currentTheme() === "dark";
  const label = dark ? "Switch to light mode" : "Switch to dark mode";
  button.setAttribute("aria-label", label);
  button.setAttribute("title", label);
}

function bindThemeToggle() {
  const button = document.getElementById("themeToggle");

  if (!button || button.dataset.vacatoryBound === "true") {
    return;
  }

  button.dataset.vacatoryBound = "true";
  updateThemeButtonLabel(button);

  button.addEventListener("click", () => {
    const nextTheme = currentTheme() === "dark" ? "light" : "dark";
    document.documentElement.dataset.theme = nextTheme;
    localStorage.setItem("vacatory-theme", nextTheme);
    updateThemeButtonLabel(button);
  });
}

function closeMobileNavigation(toggle, navigation, returnFocus = false) {
  toggle.setAttribute("aria-expanded", "false");
  toggle.setAttribute("aria-label", "Open navigation menu");
  navigation.hidden = true;
  document.body.classList.remove("mobile-menu-open");

  if (returnFocus) {
    toggle.focus();
  }
}

function openMobileNavigation(toggle, navigation) {
  toggle.setAttribute("aria-expanded", "true");
  toggle.setAttribute("aria-label", "Close navigation menu");
  navigation.hidden = false;
  document.body.classList.add("mobile-menu-open");

  window.requestAnimationFrame(() => {
    navigation.querySelector("a")?.focus();
  });
}

function bindMobileNavigation() {
  const toggle = document.getElementById("mobileMenuToggle");
  const navigation = document.getElementById("mobileNavigation");

  if (!toggle || !navigation || toggle.dataset.vacatoryBound === "true") {
    return;
  }

  toggle.dataset.vacatoryBound = "true";
  closeMobileNavigation(toggle, navigation);

  toggle.addEventListener("click", (event) => {
    event.stopPropagation();

    if (toggle.getAttribute("aria-expanded") === "true") {
      closeMobileNavigation(toggle, navigation);
      return;
    }

    openMobileNavigation(toggle, navigation);
  });

  navigation.addEventListener("click", (event) => {
    event.stopPropagation();

    if (event.target.closest("a")) {
      closeMobileNavigation(toggle, navigation);
    }
  });

  document.addEventListener("click", () => {
    closeMobileNavigation(toggle, navigation);
  });

  document.addEventListener("keydown", (event) => {
    if (event.key !== "Escape") {
      return;
    }

    const wasOpen = toggle.getAttribute("aria-expanded") === "true";
    closeMobileNavigation(toggle, navigation, wasOpen);
  });

  window.addEventListener("resize", () => {
    if (window.innerWidth > 980) {
      closeMobileNavigation(toggle, navigation);
    }
  });
}

export function initialiseSiteShell() {
  if (typeof document === "undefined") {
    return;
  }

  const mount = document.querySelector("[data-vacatory-site-shell]");

  if (mount && !document.querySelector("[data-vacatory-site-shell-rendered]")) {
    mount.innerHTML = renderSiteShell({
      pathname: window.location.pathname,
      hrefPrefix: runtimeHrefPrefix()
    });
  }

  ensureSiteNotice();

  bindThemeToggle();
  bindMobileNavigation();

  if ("serviceWorker" in navigator && window.location.protocol === "https:") {
    navigator.serviceWorker
      .register("/sw.js?v=20260904-maintenance4", {
        scope: "/",
        updateViaCache: "imports"
      })
      .catch(error => console.warn("Service worker refresh was unavailable:", error));
  }
}

if (typeof document !== "undefined") {
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initialiseSiteShell, { once: true });
  } else {
    initialiseSiteShell();
  }
}
