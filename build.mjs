import {
  readFile,
  writeFile,
  mkdir,
  rm,
  copyFile,
  cp
} from "node:fs/promises";

import { extname, join } from "node:path";
import { minify as minifyHtml } from "html-minifier-terser";
import CleanCSS from "clean-css";
import { minify as minifyJavaScript } from "terser";
import { renderSiteShell } from "./site-shell.js";

const OUTPUT_DIRECTORY = "dist";
const SITE_URL = "https://vacatory.com";
const DEFAULT_SHARE_IMAGE = `${SITE_URL}/hero-legal-desk.jpg`;

const CLOUDFLARE_ANALYTICS_SNIPPET =
  `<script type="module" src="https://static.cloudflareinsights.com/beacon.min.js" data-cf-beacon='{"token":"51e87907114d4fe4a032208c76473b59"}'></script>`;

const PUBLIC_FILES = [
  "CNAME",
  "manifest.json",
  "robots.txt",
  "sitemap.xml",
  "hero-legal-desk.jpg",

  "index.html",
  "legal-resources.html",
  "chamber-profile.html",
  "chambers.html",
  "deadlines.html",
  "events.html",
  "scholarships.html",
  "firm-profile.html",
  "firms.html",
  "search-results.html",

  "styles.css",
  "chamber-profile.css",
  "deadlines.css",
  "events.css",
  "scholarships.css",
  "firm-profile.css",

  "app.js",
  "chamber-profile.js",
  "chambers-directory.js",
  "deadlines.js",
  "events.js",
  "scholarships.js",
  "filter-shell.js",
  "results-shell.js",
  "resources.js",
  "search-results.js",
  "opportunity-data.js",
  "firm-profile.js",
  "firms-directory.js",
  "supabase.js",
  "sw.js",
  "site-shell.js"
];

const PUBLIC_DIRECTORIES = [
  "assets"
];

const PRIVATE_ASSET_DIRECTORIES = new Set([
  "Chambers Official Logos",
  "Firm Official Logos "
]);

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function firmSlug(value) {
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

function firstFirmValue(firm, fields) {
  for (const field of fields) {
    const value = firm?.[field];

    if (value !== null && value !== undefined && String(value).trim()) {
      return String(value).trim();
    }
  }

  return "";
}

function safeExternalUrl(value) {
  if (!value) {
    return "";
  }

  try {
    const url = new URL(value);

    if (url.protocol !== "https:" && url.protocol !== "http:") {
      return "";
    }

    return url.href;
  } catch {
    return "";
  }
}

function firmWebsite(firm) {
  return safeExternalUrl(
    firstFirmValue(firm, [
      "website",
      "website_url",
      "official_website",
      "official_url",
      "uk_website_url",
      "uk_website"
    ])
  );
}

function firmDescription(firm) {
  const name = firstFirmValue(firm, ["name", "short_name"]) || "Law firm";

  return `${name} law firm profile with practice areas, locations, student opportunities, application information and official links on Vacatory.`;
}

function makeRootRelativeLinksAbsolute(html) {
  return html.replace(
    /\b(href|src)="(?!https?:|\/\/|#|\/|mailto:|tel:|data:)([^"]+)"/gi,
    '$1="/$2"'
  );
}

function jsonForHtml(value) {
  return JSON.stringify(value).replace(/</g, "\\u003c");
}

async function prepareOutputDirectory() {
  await rm(OUTPUT_DIRECTORY, {
    recursive: true,
    force: true
  });

  await mkdir(OUTPUT_DIRECTORY, {
    recursive: true
  });
}

function injectCanonicalSiteShell(source, fileName) {
  const mountPattern = /<div\s+data-vacatory-site-shell(?:=["'][^"']*["'])?\s*>\s*<\/div>/i;

  if (!mountPattern.test(source)) {
    throw new Error(`Missing canonical site-shell mount in ${fileName}`);
  }

  return source.replace(
    mountPattern,
    renderSiteShell({
      pathname: fileName,
      hrefPrefix: "/"
    })
  );
}

async function minifyHtmlSource(source, fileName) {
  if (!source.includes("</body>")) {
    throw new Error(`Missing </body> in ${fileName}`);
  }

  const sourceWithAnalytics = source.includes(
    "static.cloudflareinsights.com/beacon.min.js"
  )
    ? source
    : source.replace(
        "</body>",
        `${CLOUDFLARE_ANALYTICS_SNIPPET}\n</body>`
      );

  return minifyHtml(sourceWithAnalytics, {
    collapseWhitespace: true,
    conservativeCollapse: true,
    removeComments: true,
    removeRedundantAttributes: true,
    removeEmptyAttributes: false,
    removeOptionalTags: false,
    sortAttributes: false,
    sortClassName: false,
    minifyCSS: true,
    minifyJS: true
  });
}

async function processHtml(fileName) {
  const source = await readFile(fileName, "utf8");
  const sourceWithSiteShell = injectCanonicalSiteShell(source, fileName);
  const result = await minifyHtmlSource(sourceWithSiteShell, fileName);

  await writeFile(
    join(OUTPUT_DIRECTORY, fileName),
    result,
    "utf8"
  );
}

async function processCss(fileName) {
  const source = await readFile(fileName, "utf8");

  const result = new CleanCSS({
    level: 2,
    sourceMap: false
  }).minify(source);

  if (result.errors.length > 0) {
    throw new Error(
      `CSS minification failed for ${fileName}: ${result.errors.join("; ")}`
    );
  }

  result.warnings.forEach((warning) => {
    console.warn(`CSS warning in ${fileName}: ${warning}`);
  });

  await writeFile(
    join(OUTPUT_DIRECTORY, fileName),
    result.styles,
    "utf8"
  );
}

async function processJavaScript(fileName) {
  const source = await readFile(fileName, "utf8");

  const result = await minifyJavaScript(source, {
    module: fileName === "site-shell.js",
    compress: {
      passes: 2
    },
    mangle: true,
    format: {
      comments: false
    },
    sourceMap: false
  });

  if (!result.code) {
    throw new Error(
      `JavaScript minification produced no output for ${fileName}.`
    );
  }

  await writeFile(
    join(OUTPUT_DIRECTORY, fileName),
    result.code,
    "utf8"
  );
}

async function copyPublicFile(fileName) {
  await copyFile(
    fileName,
    join(OUTPUT_DIRECTORY, fileName)
  );
}

async function copyPublicDirectory(directoryName) {
  await cp(
    directoryName,
    join(OUTPUT_DIRECTORY, directoryName),
    {
      recursive: true,
      force: true,
      filter(source) {
        if (source.endsWith(".DS_Store")) {
          return false;
        }

        if (directoryName !== "assets" || source === directoryName) {
          return true;
        }

        const relativeSource = source
          .slice(directoryName.length)
          .replace(/^[/\\\\]+/, "");

        const topLevelDirectory = relativeSource.split(/[/\\\\]/, 1)[0];

        return !PRIVATE_ASSET_DIRECTORIES.has(topLevelDirectory);
      }
    }
  );
}

async function buildFile(fileName) {
  const extension = extname(fileName).toLowerCase();

  if (extension === ".html") {
    await processHtml(fileName);
    return;
  }

  if (extension === ".css") {
    await processCss(fileName);
    return;
  }

  if (extension === ".js") {
    await processJavaScript(fileName);
    return;
  }

  await copyPublicFile(fileName);
}

async function readSupabasePublicConfig() {
  const source = await readFile("supabase.js", "utf8");

  const urlMatch = source.match(
    /SUPABASE_URL\s*=\s*["']([^"']+)["']/
  );

  const keyMatch = source.match(
    /SUPABASE_ANON_KEY\s*=\s*["']([^"']+)["']/
  );

  if (!urlMatch || !keyMatch) {
    throw new Error(
      "Could not read the public Supabase configuration from supabase.js."
    );
  }

  return {
    url: urlMatch[1],
    key: keyMatch[1]
  };
}

async function fetchPublicFirms() {
  const config = await readSupabasePublicConfig();

  const response = await fetch(
    `${config.url}/rest/v1/firms?select=*&order=name.asc`,
    {
      headers: {
        apikey: config.key,
        Accept: "application/json"
      }
    }
  );

  if (!response.ok) {
    throw new Error(
      `Unable to fetch firms for static generation: HTTP ${response.status} ${await response.text()}`
    );
  }

  const rows = await response.json();

  if (!Array.isArray(rows)) {
    throw new Error("Supabase firms response was not an array.");
  }

  return rows.filter((firm) => {
    return Boolean(
      firm &&
      firm.id &&
      (firm.name || firm.short_name) &&
      firm.active !== false &&
      firm.published !== false &&
      firm.is_public !== false
    );
  });
}

function organisationSchema(firm, cleanUrl) {
  const name =
    firstFirmValue(firm, ["name", "short_name"]) ||
    "Law firm";

  const officialWebsite = firmWebsite(firm);

  const sameAs = [
    officialWebsite,
    safeExternalUrl(firstFirmValue(firm, ["linkedin_url", "linkedin"])),
    safeExternalUrl(firstFirmValue(firm, ["instagram_url", "instagram"])),
    safeExternalUrl(firstFirmValue(firm, ["youtube_url", "youtube"])),
    safeExternalUrl(firstFirmValue(firm, ["facebook_url", "facebook"])),
    safeExternalUrl(
      firstFirmValue(firm, [
        "x_url",
        "twitter_url",
        "x",
        "twitter"
      ])
    )
  ].filter(Boolean);

  const schema = {
    "@context": "https://schema.org",
    "@type": "Organization",
    "@id": `${cleanUrl}#organization`,
    name,
    url: officialWebsite || cleanUrl
  };

  if (sameAs.length) {
    schema.sameAs = [...new Set(sameAs)];
  }

  const logo = safeExternalUrl(firm.logo_url);

  if (logo) {
    schema.logo = logo;
  }

  return schema;
}

function buildStaticFirmMeta(firm) {
  const items = [];

  const headOffice =
    firstFirmValue(firm, ["head_office"]) ||
    [
      firstFirmValue(firm, ["head_office_city"]),
      firstFirmValue(firm, ["head_office_country"])
    ].filter(Boolean).join(", ");

  if (headOffice) {
    items.push(
      `<span class="profile-meta-pill">${escapeHtml(headOffice)}</span>`
    );
  }

  if (
    firm.uk_rank !== null &&
    firm.uk_rank !== undefined &&
    String(firm.uk_rank).trim()
  ) {
    items.push(
      `<span class="profile-meta-pill">UK rank #${escapeHtml(firm.uk_rank)}</span>`
    );
  }

  const website = firmWebsite(firm);

  if (website) {
    items.push(
      `<a class="profile-meta-pill profile-meta-link" href="${escapeHtml(website)}" target="_blank" rel="noopener noreferrer">Official website (opens in new tab)</a>`
    );
  }

  return items.join("");
}

function preRenderFirmTemplate(template, firm, slug) {
  const name =
    firstFirmValue(firm, ["name", "short_name"]) ||
    "Law firm";


  const overview =
    firstFirmValue(firm, ["overview"]) ||
    "A detailed overview has not yet been added.";

  const description = firmDescription(firm);
  const cleanUrl = `${SITE_URL}/firms/${slug}/`;
  const schema = organisationSchema(firm, cleanUrl);
  const shareImage = `${SITE_URL}/assets/social/firm-${slug}.png`;
  const pageSchema = {
    "@context": "https://schema.org",
    "@graph": [
      {
        "@type": "CollectionPage",
        "@id": `${cleanUrl}#webpage`,
        url: cleanUrl,
        name: `${name} | Vacatory`,
        description,
        isPartOf: {
          "@type": "WebSite",
          "@id": `${SITE_URL}/#website`,
          name: "Vacatory",
          url: `${SITE_URL}/`
        },
        about: { "@id": `${cleanUrl}#organization` }
      },
      {
        "@type": "BreadcrumbList",
        "@id": `${cleanUrl}#breadcrumb`,
        itemListElement: [
          { "@type": "ListItem", position: 1, name: "Vacatory", item: `${SITE_URL}/` },
          { "@type": "ListItem", position: 2, name: "Firms", item: `${SITE_URL}/firms.html` },
          { "@type": "ListItem", position: 3, name, item: cleanUrl }
        ]
      }
    ]
  };

  let html = makeRootRelativeLinksAbsolute(template);

  html = html.replace(
    /<title>[\s\S]*?<\/title>/i,
    `<title>${escapeHtml(name)} | Vacatory</title>`
  );

  html = html.replace(
    /<meta\s+name="description"\s+content="[^"]*"\s*\/?>/i,
    `<meta name="description" content="${escapeHtml(description)}">`
  );

  html = html.replace(
    /\s*<link[^>]+rel=["']canonical["'][^>]*>/gi,
    ""
  );

  html = html.replace(
    /\s*<meta[^>]+(?:property|name)=["'](?:og:|twitter:)[^"']*["'][^>]*>/gi,
    ""
  );

  html = html.replace(
    /<script[^>]+id=["']firmOrganizationSchema["'][\s\S]*?<\/script>/gi,
    ""
  );

  const seoMarkup = `
<link rel="canonical" href="${escapeHtml(cleanUrl)}">
<meta property="og:type" content="website">
<meta property="og:site_name" content="Vacatory">
<meta property="og:title" content="${escapeHtml(name)} | Vacatory">
<meta property="og:description" content="${escapeHtml(description)}">
<meta property="og:url" content="${escapeHtml(cleanUrl)}">
<meta property="og:image" content="${escapeHtml(shareImage)}">
<meta property="og:image:alt" content="${escapeHtml(`${name} firm profile on Vacatory`)}">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:type" content="image/png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="${escapeHtml(name)} | Vacatory">
<meta name="twitter:description" content="${escapeHtml(description)}">
<meta name="twitter:image" content="${escapeHtml(shareImage)}">
<meta name="twitter:image:alt" content="${escapeHtml(`${name} firm profile on Vacatory`)}">
<script id="firmOrganizationSchema" type="application/ld+json">${jsonForHtml(schema)}</script>\n<script id="firmProfilePageSchema" type="application/ld+json">${jsonForHtml(pageSchema)}</script>
<script>
window.__VACATORY_FIRM_ID__=${jsonForHtml(String(firm.id))};
window.__VACATORY_FIRM_SLUG__=${jsonForHtml(slug)};
window.__VACATORY_PRE_RENDERED__=true;
</script>
`;

  html = html.replace(
    "</head>",
    `${seoMarkup}\n</head>`
  );

  html = removeStaticElement(html, "loadingState");
  html = removeStaticElement(html, "errorState");
  html = revealStaticElement(html, "profileContent");

  html = replaceStaticElementContent(
    html,
    "firmName",
    escapeHtml(name)
  );

  html = replaceStaticElementContent(
    html,
    "firmOverview",
    escapeHtml(overview)
  );

  html = replaceStaticElementContent(
    html,
    "firmMeta",
    buildStaticFirmMeta(firm)
  );

  const initial =
    (firstFirmValue(firm, ["short_name", "name"]) || "V")
      .trim()
      .charAt(0)
      .toUpperCase();

  const logo = safeExternalUrl(firm.logo_url);

  html = replaceStaticElementContent(
    html,
    "firmLogo",
    logo
      ? `<img src="${escapeHtml(logo)}" alt="">`
      : escapeHtml(initial)
  );

  return html;
}


const STATIC_FIRM_TABLES = [
  "career_opportunities_public_view",
  "legal_organisations",

  "practice_areas",
  "locations",
  "organisation_locations",
  "firm_roles_public_view",
  "firm_roles",
  "firm_disability_support",
  "firm_research_sections",
  "firm_inclusion_initiatives",
  "firm_pro_bono",
  "firm_awards",
  "firm_sectors",
  "firm_matters",
  "firm_official_sources"
];

async function fetchAllPublicRows(config, tableName) {
  const rows = [];
  const pageSize = 1000;

  for (let offset = 0; ; offset += pageSize) {
    const response = await fetch(
      `${config.url}/rest/v1/${tableName}?select=*&limit=${pageSize}&offset=${offset}`,
      {
        headers: {
          apikey: config.key,
          Accept: "application/json"
        }
      }
    );

    if (!response.ok) {
      console.warn(
        `Static SEO: ${tableName} unavailable (HTTP ${response.status}).`
      );

      return [];
    }

    const batch = await response.json();

    if (!Array.isArray(batch)) {
      console.warn(
        `Static SEO: ${tableName} returned an unexpected response.`
      );

      return [];
    }

    rows.push(...batch);

    if (batch.length < pageSize) {
      break;
    }
  }

  return rows;
}

async function fetchStaticFirmData() {
  const config = await readSupabasePublicConfig();

  const entries = await Promise.all(
    STATIC_FIRM_TABLES.map(async (tableName) => {
      const rows = await fetchAllPublicRows(
        config,
        tableName
      );

      console.log(
        `Static SEO: ${tableName} - ${rows.length} rows`
      );

      return [tableName, rows];
    })
  );

  return Object.fromEntries(entries);
}

function staticPublicRow(row) {
  if (!row) {
    return false;
  }

  if (row.active === false) {
    return false;
  }

  if (row.published === false) {
    return false;
  }

  if (row.is_public === false) {
    return false;
  }

  return true;
}


function staticPublicLabel(value) {
  const text = String(value ?? "")
    .replace(/[_-]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();

  if (!text) return "";

  const acronyms = {
    edi: "EDI",
    lgbt: "LGBT+",
    sqe: "SQE",
    nq: "NQ",
    llm: "LL.M.",
    llb: "LLB",
    gdl: "GDL",
    pgdl: "PGDL",
    lpc: "LPC"
  };

  return text
    .split(" ")
    .map((word, index) => {
      const lower = word.toLowerCase();

      if (acronyms[lower]) {
        return acronyms[lower];
      }

      return index === 0
        ? lower.charAt(0).toUpperCase() + lower.slice(1)
        : lower;
    })
    .join(" ");
}

function staticValue(row, fields) {
  for (const field of fields) {
    const value = row?.[field];

    if (
      value !== null &&
      value !== undefined &&
      String(value).trim()
    ) {
      return String(value).trim();
    }
  }

  return "";
}

function staticRowsForFirm(data, tableName, firm) {
  const rows = data[tableName] || [];

  if (tableName === "organisation_locations") {
    if (!firm.organisation_id) {
      return [];
    }

    return rows.filter(
      (row) =>
        String(row.organisation_id || "") ===
          String(firm.organisation_id) &&
        staticPublicRow(row)
    );
  }

  return rows.filter(
    (row) =>
      String(row.firm_id || "") ===
        String(firm.id) &&
      staticPublicRow(row)
  );
}

function staticNormalise(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/\s+/g, " ")
    .trim();
}

function staticFormatDate(value) {
  if (!value) {
    return "";
  }

  const text = String(value);

  const date = /^\d{4}-\d{2}-\d{2}$/.test(text)
    ? new Date(`${text}T12:00:00Z`)
    : new Date(text);

  if (Number.isNaN(date.getTime())) {
    return text;
  }

  return date.toLocaleDateString(
    "en-GB",
    {
      day: "numeric",
      month: "long",
      year: "numeric",
      timeZone: "UTC"
    }
  );
}

function staticOfficialLink(url, label) {
  const safe = safeExternalUrl(url);

  if (!safe) {
    return "";
  }

  return `
    <p>
      <a
        class="firm-link profile-external-link"
        href="${escapeHtml(safe)}"
        target="_blank"
        rel="noopener noreferrer"
      >
        ${escapeHtml(label)} (opens in new tab)
      </a>
    </p>
  `;
}


function staticGeoKey(value) {
  return String(value || "")
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

const staticCountryAliases = new Map(Object.entries({
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

function staticCanonicalCountry(value) {
  const text = String(value || "")
    .replaceAll("_", " ")
    .replace(/\s+/g, " ")
    .trim();

  if (!text) {
    return "";
  }

  return (
    staticCountryAliases.get(staticGeoKey(text)) ||
    text
  );
}

function staticCanonicaliseGeoText(value) {
  return String(value || "")
    .replace(/\bThe Netherlands\b/gi, "Netherlands")
    .replace(/\bRepublic of Ireland\b/gi, "Ireland")
    .replace(
      /\bUnited States of America\b/gi,
      "United States"
    )
    .replace(
      /\bHong Kong SAR(?:,?\s*China)?\b/gi,
      "Hong Kong"
    )
    .replace(/\bCzech Republic\b/gi, "Czechia")
    .replace(
      /\bRepublic of Korea\b/gi,
      "South Korea"
    )
    .replace(/\s+/g, " ")
    .trim();
}

function staticCleanLocationCity(country, city) {
  const publicCountry =
    staticCanonicalCountry(country);

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
    parts.length
  ) {
    const firstCountry =
      staticCanonicalCountry(parts[0]);

    if (
      staticGeoKey(firstCountry) ===
      staticGeoKey(publicCountry)
    ) {
      parts.shift();
    }
  }

  if (
    publicCountry &&
    parts.length
  ) {
    const lastCountry =
      staticCanonicalCountry(
        parts[parts.length - 1]
      );

    if (
      staticGeoKey(lastCountry) ===
      staticGeoKey(publicCountry)
    ) {
      parts.pop();
    }
  }

  return staticCanonicaliseGeoText(
    parts.join(", ")
  );
}

function staticPublicLocation(country, city) {
  const publicCountry =
    staticCanonicalCountry(country);

  const publicCity =
    staticCleanLocationCity(
      publicCountry,
      city
    );

  if (
    publicCountry &&
    publicCity &&
    staticGeoKey(publicCountry) !==
      staticGeoKey(publicCity)
  ) {
    return `${publicCountry}, ${publicCity}`;
  }

  return publicCountry || publicCity;
}

function staticOpportunityTitle(row){
  return staticValue(row,["public_title","official_name"]);
}

function staticChooseProgrammeCycle(){return null;}

function staticProgrammeView(row){return row;}

function staticOpportunityCycleTiming(row){
  const lines=[];

  (Array.isArray(row?.cycles)?row.cycles:[]).forEach(cycle=>{
    if(!cycle)return;

    const applicationDates=staticValue(cycle,["application_dates_text"])||[
      staticValue(cycle,["opens_on"])?`Applications open ${staticValue(cycle,["opens_on"])}`:"",
      staticValue(cycle,["closes_on"])?`Close ${staticValue(cycle,["closes_on"])}${staticValue(cycle,["closes_at"])?` at ${staticValue(cycle,["closes_at"])}`:""}${staticValue(cycle,["closes_timezone"])?` ${staticValue(cycle,["closes_timezone"])}`:""}`:""
    ].filter(Boolean).join("; ");
    const programmeDates=staticValue(cycle,["programme_dates_text"])||[
      staticValue(cycle,["programme_starts_on"]),
      staticValue(cycle,["programme_ends_on"])
    ].filter(Boolean).join(" – ");

    if(applicationDates)lines.push(applicationDates);
    if(programmeDates)lines.push(`Programme: ${programmeDates}`);
  });

  return [...new Set(lines)];
}

function staticOpportunityIsCurrent(row){
  if(!row)return false;

  // The canonical public view already decides which programmes are suitable
  // for publication. Keep closed programmes on firm profiles so their latest
  // published application windows remain useful to future applicants. Only
  // dated one-off events expire at the consumer layer.
  if(!Boolean(row.is_event))return true;

  const today=new Date();
  today.setUTCHours(0,0,0,0);

  const end=staticValue(row,["programme_ends_on"]);
  if(end&&/^\d{4}-\d{2}-\d{2}/.test(end)){
    const endDate=new Date(`${end.slice(0,10)}T23:59:59Z`);
    if(!Number.isNaN(endDate.getTime())&&endDate<today)return false;
  }

  const start=staticValue(row,["programme_starts_on"]);
  if(Boolean(row.is_event)&&!end&&start&&/^\d{4}-\d{2}-\d{2}/.test(start)){
    const startDate=new Date(`${start.slice(0,10)}T23:59:59Z`);
    if(!Number.isNaN(startDate.getTime())&&startDate<today)return false;
  }

  return true;
}

function renderStaticOpportunity(row){
  const title=staticOpportunityTitle(row);
  if(!title)return"";

  const type=staticValue(row,["opportunity_type_label"]);
  const location=staticValue(row,["location_summary"]);
  const status=staticValue(row,["public_application_status"]);
  const opens=staticValue(row,["opens_on"]);
  const closes=staticValue(row,["closes_on"]);
  const closesAt=staticValue(row,["closes_at"]);
  const closesTimezone=staticValue(row,["closes_timezone"]);
  const applicationDates=staticValue(row,["application_dates_text"]);
  const programmeDates=staticValue(row,["programme_dates_text"])||[
    staticValue(row,["programme_starts_on"]),
    staticValue(row,["programme_ends_on"])
  ].filter(Boolean).join(" – ");
  const duration=staticValue(row,["duration_text"]);
  const places=staticValue(row,["places_text"]);
  const audience=staticValue(row,["audience_text","study_stage_text"]);
  const eligibility=staticValue(row,["eligibility_text"]);
  const academic=staticValue(row,["academic_criteria"]);
  const process=staticValue(row,["application_process_text"]);
  const assessments=staticValue(row,["assessments_text"]);
  const progression=staticValue(row,["progression_route_text"]);
  const funding=staticValue(row,["funding_text"]);
  const expenses=staticValue(row,["expenses_text"]);
  const travel=staticValue(row,["travel_support_text"]);
  const accommodation=staticValue(row,["accommodation_support_text"]);
  const rightToWork=staticValue(row,["right_to_work_text"]);
  const disability=staticValue(row,["disability_support_text"]);
  const source=staticValue(row,["application_url","official_url"]);
  const cycleTiming=staticOpportunityCycleTiming(row);

  const facts=[
    opens?`Applications open: ${opens}`:"",
    closes?`Closing date: ${closes}${closesAt?` ${closesAt}`:""}${closesTimezone?` ${closesTimezone}`:""}`:"",
    applicationDates?`Application timing: ${applicationDates}`:"",
    programmeDates?`Programme dates: ${programmeDates}`:"",
    duration?`Duration: ${duration}`:"",
    places?`Places: ${places}`:"",
    status?`Status: ${status}`:""
  ].filter(Boolean);

  const details=[
    audience?`<li><strong>Who can apply:</strong> ${escapeHtml(audience)}</li>`:"",
    eligibility?`<li><strong>Eligibility:</strong> ${escapeHtml(eligibility)}</li>`:"",
    academic?`<li><strong>Academic requirements:</strong> ${escapeHtml(academic)}</li>`:"",
    process?`<li><strong>Application process:</strong> ${escapeHtml(process)}</li>`:"",
    assessments?`<li><strong>Assessments:</strong> ${escapeHtml(assessments)}</li>`:"",
    progression?`<li><strong>Progression:</strong> ${escapeHtml(progression)}</li>`:"",
    funding?`<li><strong>Funding:</strong> ${escapeHtml(funding)}</li>`:"",
    expenses?`<li><strong>Expenses:</strong> ${escapeHtml(expenses)}</li>`:"",
    travel?`<li><strong>Travel support:</strong> ${escapeHtml(travel)}</li>`:"",
    accommodation?`<li><strong>Accommodation support:</strong> ${escapeHtml(accommodation)}</li>`:"",
    rightToWork?`<li><strong>Right to work:</strong> ${escapeHtml(rightToWork)}</li>`:"",
    disability?`<li><strong>Disability support:</strong> ${escapeHtml(disability)}</li>`:""
  ].filter(Boolean);

  return `
    <article class="profile-card static-seo-card">
      <h3>${escapeHtml(title)}</h3>
      ${type?`<p><strong>Type:</strong> ${escapeHtml(type)}</p>`:""}
      ${location?`<p><strong>Location:</strong> ${escapeHtml(location)}</p>`:""}
      ${facts.length?`<ul>${facts.map(item=>`<li>${escapeHtml(item)}</li>`).join("")}</ul>`:""}
      ${cycleTiming.length?`<h4>Published application and programme dates</h4><ul>${cycleTiming.map(item=>`<li>${escapeHtml(item)}</li>`).join("")}</ul>`:""}
      ${details.length?`<ul>${details.join("")}</ul>`:""}
      ${source?`<a href="${escapeHtml(source)}" target="_blank" rel="noopener noreferrer">View ${escapeHtml(title)} official opportunity page (opens in new tab)</a>`:""}
    </article>
  `;
}

function renderStaticPracticeArea(row) {
  const name = staticValue(
    row,
    [
      "practice_area",
      "practice_name",
      "service_name",
      "name"
    ]
  );

  if (!name) {
    return "";
  }

  const description = staticValue(
    row,
    [
      "student_summary",
      "description",
      "summary"
    ]
  );

  return `
    <article class="profile-card static-seo-card">
      <h3>${escapeHtml(name)}</h3>
      ${description
        ? `<p>${escapeHtml(description)}</p>`
        : ""}
    </article>
  `;
}

function staticLocationParts(row) {
  const country =
    staticCanonicalCountry(
      staticValue(
        row,
        [
          "country",
          "country_name",
          "jurisdiction"
        ]
      )
    );

  const rawCity =
    staticValue(
      row,
      [
        "city",
        "location_name",
        "office_name"
      ]
    );

  const city =
    staticCleanLocationCity(
      country,
      rawCity
    );

  return {
    country,
    city
  };
}

function staticLocationKey(row) {
  const {
    country,
    city
  } = staticLocationParts(row);

  return [
    country,
    city
  ]
    .map(staticNormalise)
    .join("|");
}

function renderStaticLocations(rows) {
  const unique = new Map();

  for (const row of rows) {
    const key = staticLocationKey(row);

    if (!key || key === "|") {
      continue;
    }

    if (!unique.has(key)) {
      unique.set(key, row);
    }
  }

  const locations = [...unique.values()].sort(
    (a, b) => {
      const aParts = staticLocationParts(a);
      const bParts = staticLocationParts(b);

      if (
        aParts.country === "United Kingdom" &&
        bParts.country !== "United Kingdom"
      ) {
        return -1;
      }

      if (
        bParts.country === "United Kingdom" &&
        aParts.country !== "United Kingdom"
      ) {
        return 1;
      }

      return `${aParts.country} ${aParts.city}`
        .localeCompare(
          `${bParts.country} ${bParts.city}`,
          "en-GB"
        );
    }
  );

  return locations.map((row) => {
    const {
      country,
      city
    } = staticLocationParts(row);

    const officeType = staticValue(
      row,
      [
        "office_type",
        "location_category"
      ]
    );

    const address = staticValue(
      row,
      [
        "full_address",
        "office_address",
        "address"
      ]
    );

    const url = staticValue(
      row,
      [
        "office_url",
        "source_url"
      ]
    );

    const title =
      staticPublicLocation(
        country,
        city
      );

    return `
      <article class="profile-card static-seo-card">
        <h3>${escapeHtml(title || "Office")}</h3>

        ${
          officeType
            ? `<p>${escapeHtml(
                staticPublicLabel(officeType)
              )}</p>`
            : ""
        }

        ${
          address
            ? `<p>${escapeHtml(address)}</p>`
            : ""
        }

        ${staticOfficialLink(
          url,
          `View ${title || "office"} official page`
        )}
      </article>
    `;
  }).join("");
}

function renderStaticRole(row) {
  const name = staticValue(
    row,
    [
      "role_name",
      "name",
      "title"
    ]
  );

  if (!name) {
    return "";
  }

  const description = staticValue(
    row,
    [
      "description",
      "summary"
    ]
  );

  const location = staticValue(
    row,
    [
      "location_text",
      "jurisdiction_text"
    ]
  );

  const url = staticValue(
    row,
    [
      "primary_source_url",
      "source_url"
    ]
  );

  return `
    <article class="profile-card static-seo-card">
      <h3>${escapeHtml(name)}</h3>

      ${description
        ? `<p>${escapeHtml(description)}</p>`
        : ""}

      ${location
        ? `<p><strong>Location:</strong> ${escapeHtml(location)}</p>`
        : ""}

      ${staticOfficialLink(
        url,
        `View official information for ${name}`
      )}
    </article>
  `;
}

function renderStaticResearchItem(row, fallbackTitle) {
  const title = staticValue(
    row,
    [
      "initiative_name",
      "programme_name",
      "award_name",
      "sector_name",
      "matter_name",
      "client_name",
      "title",
      "section_title",
      "support_name",
      "name"
    ]
  ) || fallbackTitle;

  const description = staticValue(
    row,
    [
      "summary",
      "description",
      "student_summary",
      "content",
      "detail",
      "recognition_details",
      "target_or_commitment"
    ]
  );

  if (!title && !description) {
    return "";
  }

  const url = staticValue(
    row,
    [
      "source_url",
      "primary_source_url"
    ]
  );

  return `
    <article class="profile-card static-seo-card">
      ${title
        ? `<h3>${escapeHtml(title)}</h3>`
        : ""}

      ${description
        ? `<p>${escapeHtml(description)}</p>`
        : ""}

      ${staticOfficialLink(
        url,
        `View official source for ${title || fallbackTitle}`
      )}
    </article>
  `;
}

function staticResearchMatches(row, keywords) {
  const haystack = staticNormalise(
    [
      staticValue(row, ["section_key"]),
      staticValue(row, ["section_title"]),
      staticValue(row, ["title"]),
      staticValue(row, ["summary"])
    ].join(" ")
  );

  return keywords.some(
    (keyword) =>
      haystack.includes(staticNormalise(keyword))
  );
}

function staticUkResearchScope(row) {
  const scope = staticValue(
    row,
    [
      "country",
      "country_name",
      "jurisdiction",
      "region",
      "location",
      "location_text",
      "office",
      "office_name"
    ]
  );

  if (!scope) {
    const title = staticNormalise(
      staticValue(
        row,
        [
          "section_key",
          "section_title",
          "title"
        ]
      )
    );

    if (
      (title.includes("global") ||
        title.includes("international")) &&
      !/(?:^|\\s)(?:uk|u k|united kingdom|great britain|england|scotland|wales|northern ireland)(?:\\s|$)/.test(title)
    ) {
      return false;
    }

    return true;
  }

  const country = staticCanonicalCountry(scope);

  if (country === "United Kingdom") {
    return true;
  }

  const text = staticGeoKey(scope);

  return /(?:^|\\s)(?:uk|u k|united kingdom|great britain|england|scotland|wales|northern ireland|london|birmingham|manchester|leeds|bristol|edinburgh|glasgow|belfast|cardiff)(?:\\s|$)/.test(text);
}

function replaceStaticContainer(html, id, content) {
  if (!content) {
    return html;
  }

  const pattern = new RegExp(
    `(<div[^>]*id="${id}"[^>]*>)[\\s\\S]*?(</div>)`,
    "i"
  );

  if (!pattern.test(html)) {
    return html;
  }

  return html.replace(
    pattern,
    `$1${content}$2`
  );
}

function replaceStaticElementContent(html, id, content) {
  const pattern = new RegExp(
    `(<([a-z0-9]+)[^>]*\\bid="${id}"[^>]*>)[\\s\\S]*?(</\\2>)`,
    "i"
  );

  return html.replace(
    pattern,
    (full, opening, tag, closing) =>
      `${opening}${content}${closing}`
  );
}

function removeStaticElement(html, id) {
  const pattern = new RegExp(
    `<([a-z0-9]+)[^>]*\\bid="${id}"[^>]*>[\\s\\S]*?</\\1>`,
    "i"
  );

  return html.replace(pattern, "");
}

function hideStaticElement(html, id) {
  const pattern = new RegExp(
    `<([a-z0-9]+)([^>]*\\bid="${id}"[^>]*)>`,
    "i"
  );

  return html.replace(
    pattern,
    (full, tag, attributes) => {
      if (/\bhidden\b/i.test(attributes)) {
        return full;
      }

      return `<${tag}${attributes} hidden>`;
    }
  );
}

function revealStaticElement(html, id) {
  const pattern = new RegExp(
    `<([a-z0-9]+)([^>]*\\bid="${id}"[^>]*)>`,
    "i"
  );

  return html.replace(
    pattern,
    (full, tag, attributes) => {
      let updated = attributes.replace(
        /class="([^"]*)"/i,
        (classFull, classes) => {
          const result = classes
            .split(/\s+/)
            .filter(
              (className) =>
                className &&
                className !== "hidden"
            )
            .join(" ");

          return `class="${result}"`;
        }
      );

      updated = updated.replace(
        /\s+hidden(?:="[^"]*")?/gi,
        ""
      );

      return `<${tag}${updated}>`;
    }
  );
}

function buildStaticAtGlance(firm, data) {
  const programmes = (data.career_opportunities_public_view || []).filter(
    row => String(row.provider_id || "") === String(firm.organisation_id || firm.id || "")
  );

  const locations = [
    ...staticRowsForFirm(
      data,
      "organisation_locations",
      firm
    ),
    ...staticRowsForFirm(
      data,
      "locations",
      firm
    )
  ];

  const practiceAreas = staticRowsForFirm(
    data,
    "practice_areas",
    firm
  );

  const headOffice =
    staticValue(firm, ["head_office"]) ||
    [
      staticValue(firm, ["head_office_city"]),
      staticValue(firm, ["head_office_country"])
    ].filter(Boolean).join(", ");

  const routeTypes = new Set(
    programmes
      .map(
        (row) =>
          staticValue(
            row,
            [
              "programme_type",
              "opportunity_level"
            ]
          )
      )
      .filter(Boolean)
  );

  const cards = [
    headOffice
      ? [
          "Head office",
          headOffice
        ]
      : null,

    locations.length
      ? [
          "Locations",
          `${locations.length} office records`
        ]
      : null,

    practiceAreas.length
      ? [
          "Practice areas",
          `${practiceAreas.length} listed`
        ]
      : null,

    routeTypes.size
      ? [
          "Student routes",
          `${routeTypes.size} route ${routeTypes.size === 1 ? "type" : "types"}`
        ]
      : null
  ].filter(Boolean);

  return cards.map(
    ([label, value]) => `
      <article class="glance-card">
        <span class="glance-card-label">
          ${escapeHtml(label)}
        </span>
        <strong>${escapeHtml(value)}</strong>
      </article>
    `
  ).join("");
}

function preRenderFirmResearchContent(
  html,
  firm,
  data
) {
  const programmes = (data.career_opportunities_public_view || []).filter(
    row => String(row.provider_id || "") === String(firm.organisation_id || firm.id || "")
  )
    .map(
      (programme) =>
        staticProgrammeView(programme, data)
    )
    .filter(staticOpportunityIsCurrent);

  const opportunities = programmes
    .map(renderStaticOpportunity)
    .filter(Boolean)
    .join("");

  const practiceAreas = staticRowsForFirm(
    data,
    "practice_areas",
    firm
  )
    .map(renderStaticPracticeArea)
    .filter(Boolean)
    .join("");

  const locations = renderStaticLocations([
    ...staticRowsForFirm(
      data,
      "organisation_locations",
      firm
    ),
    ...staticRowsForFirm(
      data,
      "locations",
      firm
    )
  ]);

  let roleRows = staticRowsForFirm(
    data,
    "firm_roles_public_view",
    firm
  );

  if (!roleRows.length) {
    roleRows = staticRowsForFirm(
      data,
      "firm_roles",
      firm
    );
  }

  const roles = roleRows
    .map(renderStaticRole)
    .filter(Boolean)
    .join("");

  const researchSections = staticRowsForFirm(
    data,
    "firm_research_sections",
    firm
  );

  const applications = researchSections
    .filter(
      (row) =>
        staticResearchMatches(
          row,
          [
            "application",
            "assessment",
            "eligibility",
            "academic",
            "recruitment"
          ]
        )
    )
    .map(
      (row) =>
        renderStaticResearchItem(
          row,
          "Applications and assessments"
        )
    )
    .filter(Boolean)
    .join("");

  const canonicalOrganisation = (
    data.legal_organisations || []
  ).find(
    (row) =>
      String(row.id || "") ===
      String(firm.organisation_id || firm.id || "")
  );

  const canonicalVisa = canonicalOrganisation?.uk_visa_summary
    ? renderStaticResearchItem(
        {
          section_title: "UK visa sponsorship and right to work",
          title: "UK visa sponsorship and right to work",
          summary: canonicalOrganisation.uk_visa_summary,
          content: canonicalOrganisation.uk_visa_summary,
          source_url: canonicalOrganisation.uk_visa_source_url,
          source_title: canonicalOrganisation.uk_visa_source_title,
          research_checked_on: canonicalOrganisation.uk_visa_checked_on
        },
        "UK visa sponsorship and right to work"
      )
    : "";

  const fundingResearch = researchSections
    .filter(
      (row) =>
        staticUkResearchScope(row) &&
        staticResearchMatches(
          row,
          [
            "funding",
            "course fees",
            "qualification funding",
            "maintenance",
            "grant",
            "bursary",
            "scholarship",
            "sqe",
            "lpc",
            "pgdl",
            "gdl",
            "study support"
          ]
        )
    )
    .map(
      (row) =>
        renderStaticResearchItem(
          row,
          "UK funding and financial support"
        )
    )
    .filter(Boolean);

  const ukVisaFunding = [
    canonicalVisa,
    ...fundingResearch
  ].filter(Boolean).join("");

  const inclusionRows = [
    ...staticRowsForFirm(
      data,
      "firm_inclusion_initiatives",
      firm
    ),
    ...staticRowsForFirm(
      data,
      "firm_disability_support",
      firm
    )
  ];

  const inclusion = inclusionRows
    .map((row) => {
      const isResearchFinding =
        staticNormalise(
          staticValue(row, ["support_type"])
        ) === "research_finding";

      return renderStaticResearchItem(
        row,
        isResearchFinding
          ? "Disability support information"
          : "EDI"
      );
    })
    .filter(Boolean)
    .join("");

  const proBono = staticRowsForFirm(
    data,
    "firm_pro_bono",
    firm
  )
    .map(
      (row) =>
        renderStaticResearchItem(
          row,
          "Pro bono"
        )
    )
    .filter(Boolean)
    .join("");

  const highlights = [
    ...staticRowsForFirm(
      data,
      "firm_awards",
      firm
    ),
    ...staticRowsForFirm(
      data,
      "firm_sectors",
      firm
    ),
    ...staticRowsForFirm(
      data,
      "firm_matters",
      firm
    )
  ]
    .map(
      (row) =>
        renderStaticResearchItem(
          row,
          "Firm highlight"
        )
    )
    .filter(Boolean)
    .join("");

  const links = staticRowsForFirm(
    data,
    "firm_official_sources",
    firm
  )
    .map((row) => {
      const title = staticValue(
        row,
        [
          "source_title",
          "platform"
        ]
      ) || "Official source";

      const description = staticValue(
        row,
        [
          "public_description"
        ]
      );

      const url = staticValue(
        row,
        [
          "source_url"
        ]
      );

      if (!url) {
        return "";
      }

      return `
        <article class="profile-card static-seo-card">
          <h3>${escapeHtml(title)}</h3>

          ${description
            ? `<p>${escapeHtml(description)}</p>`
            : ""}

          ${staticOfficialLink(
            url,
            `Visit ${title}`
          )}
        </article>
      `;
    })
    .filter(Boolean)
    .join("");

  const atGlance = buildStaticAtGlance(
    firm,
    data
  );

  if (atGlance) {
    html = replaceStaticContainer(
      html,
      "atGlanceGrid",
      atGlance
    );

    html = revealStaticElement(
      html,
      "atGlancePanel"
    );

    html = removeStaticElement(
      html,
      "atGlanceLoading"
    );
  } else {
    html = removeStaticElement(
      html,
      "atGlanceLoading"
    );
  }

  const sections = [
    {
      content: opportunities,
      container: "opportunitiesList",
      loading: "opportunitiesLoading",
      empty: "opportunitiesEmpty"
    },
    {
      content: applications,
      container: "applicationsList",
      loading: "applicationsLoading",
      empty: "applicationsEmpty"
    },
    {
      content: ukVisaFunding,
      container: "payFundingVisasList",
      loading: "payFundingVisasLoading",
      empty: "payFundingVisasEmpty"
    },
    {
      content: practiceAreas,
      container: "practiceAreasList"
    },
    {
      content: locations,
      container: "locationsList"
    },
    {
      content: roles,
      container: "rolesList"
    },
    {
      content: inclusion,
      container: "inclusionDisabilityList",
      loading: "inclusionDisabilityLoading",
      empty: "inclusionDisabilityEmpty"
    },
    {
      content: proBono,
      container: "proBonoList",
      loading: "proBonoLoading",
      empty: "proBonoEmpty"
    },
    {
      content: highlights,
      container: "firmHighlightsList",
      loading: "firmHighlightsLoading",
      empty: "firmHighlightsEmpty"
    },
    {
      content: links,
      container: "linksSocialsList",
      loading: "linksSocialsLoading",
      empty: "linksSocialsEmpty"
    }
  ];

  for (const section of sections) {
    if (section.loading) {
      html = removeStaticElement(
        html,
        section.loading
      );
    }

    if (section.content) {
      html = replaceStaticContainer(
        html,
        section.container,
        section.content
      );

      if (section.empty) {
        html = removeStaticElement(
          html,
          section.empty
        );
      }

      continue;
    }

    if (section.empty) {
      html = replaceStaticElementContent(
        html,
        section.empty,
        "Verified information for this section is being checked."
      );

      html = revealStaticElement(
        html,
        section.empty
      );
    }
  }

  html = removeStaticElement(
    html,
    "opportunitiesFilterEmpty"
  );

  return html;
}


async function generateFirmPages(firms, data) {
  const template = await readFile("firm-profile.html", "utf8");

  const usedSlugs = new Map();

  for (const firm of firms) {
    const name =
      firstFirmValue(firm, ["name", "short_name"]) ||
      String(firm.id);

    const slug =
      firmSlug(firstFirmValue(firm, ["slug"])) ||
      firmSlug(name);

    if (!slug) {
      throw new Error(
        `Could not generate a clean URL slug for firm ${firm.id}.`
      );
    }

    if (usedSlugs.has(slug)) {
      throw new Error(
        `Duplicate firm slug "${slug}" for "${name}" and "${usedSlugs.get(slug)}".`
      );
    }

    usedSlugs.set(slug, name);

    const directory = join(
      OUTPUT_DIRECTORY,
      "firms",
      slug
    );

    await mkdir(directory, {
      recursive: true
    });

    let html = preRenderFirmTemplate(
      template,
      firm,
      slug
    );

    html = preRenderFirmResearchContent(
      html,
      firm,
      data
    );

    html = injectCanonicalSiteShell(
      html,
      `firms/${slug}/index.html`
    );

    const result = await minifyHtmlSource(
      html,
      `firms/${slug}/index.html`
    );

    await writeFile(
      join(directory, "index.html"),
      result,
      "utf8"
    );

    const legacySlug = firmSlug(name);

    if (legacySlug && legacySlug !== slug && !usedSlugs.has(legacySlug)) {
      const legacyDirectory = join(
        OUTPUT_DIRECTORY,
        "firms",
        legacySlug
      );

      await mkdir(legacyDirectory, {
        recursive: true
      });

      const redirectTarget = `/firms/${slug}/`;
      const redirectHtml = await minifyHtmlSource(
        `<!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${escapeHtml(name)} moved — Vacatory</title>
            <link rel="canonical" href="${SITE_URL}${redirectTarget}">
            <meta http-equiv="refresh" content="0; url=${redirectTarget}">
            <script>window.location.replace(${jsonForHtml(redirectTarget)});</script>
          </head>
          <body>
            <p>
              This firm profile has moved to
              <a href="${redirectTarget}">${escapeHtml(name)} on Vacatory</a>.
            </p>
          </body>
        </html>`,
        `firms/${legacySlug}/index.html`
      );

      await writeFile(
        join(legacyDirectory, "index.html"),
        redirectHtml,
        "utf8"
      );
    }
  }

  return usedSlugs;
}

async function syncGeneratedRootDirectory(directoryName) {
  const sourceDirectory = join(OUTPUT_DIRECTORY, directoryName);

  await rm(directoryName, {
    recursive: true,
    force: true
  });

  await cp(
    sourceDirectory,
    directoryName,
    {
      recursive: true,
      force: true
    }
  );
}

async function generateSitemap(firms) {
  let sitemap = await readFile("sitemap.xml", "utf8");
  const firmTabs = ["opportunities", "pay-funding-visas", "practice-areas", "locations", "roles", "inclusion-disability", "pro-bono", "firm-highlights", "links-socials"];
  const chamberTabs = ["opportunities", "practice-areas", "locations", "pupillage-tenancy", "funding", "edi", "highlights", "links-socials"];

  sitemap = sitemap
    .replace(/\s*<url>\s*<loc>https:\/\/vacatory\.com\/firm-profile\.html\?id=[^<]+<\/loc>\s*<\/url>/g, "")
    .replace(/\s*<url>\s*<loc>https:\/\/vacatory\.com\/firms\/[^/]+\/(?:\?tab=[^<]+)?<\/loc>\s*<\/url>/g, "")
    .replace(/\s*<url>\s*<loc>https:\/\/vacatory\.com\/chamber-profile\.html\?id=[^<&]+&amp;tab=[^<]+<\/loc>\s*<\/url>/g, "");

  const firmEntries = firms.flatMap((firm) => {
    const name = firstFirmValue(firm, ["name", "short_name"]) || String(firm.id);
    const slug =
      firmSlug(firstFirmValue(firm, ["slug"])) ||
      firmSlug(name);
    const base = `${SITE_URL}/firms/${slug}/`;
    return [
      `  <url>\n    <loc>${base}</loc>\n  </url>`,
      ...firmTabs.map((tab) => `  <url>\n    <loc>${base}?tab=${tab}</loc>\n  </url>`)
    ];
  }).join("\n");

  const chamberIds = [...new Set([...sitemap.matchAll(/chamber-profile\.html\?id=([^<&]+)/g)].map((match) => match[1]))];
  const chamberEntries = chamberIds.flatMap((id) =>
    chamberTabs.map((tab) => `  <url>\n    <loc>${SITE_URL}/chamber-profile.html?id=${id}&amp;tab=${tab}</loc>\n  </url>`)
  ).join("\n");

  if (!sitemap.includes("</urlset>")) throw new Error("sitemap.xml does not contain </urlset>.");
  sitemap = sitemap.replace("</urlset>", `${firmEntries}\n${chamberEntries}\n</urlset>`);
  await writeFile(join(OUTPUT_DIRECTORY, "sitemap.xml"), sitemap, "utf8");
}

async function build() {
  console.log("Preparing Vacatory production files…");

  await prepareOutputDirectory();

  for (const fileName of PUBLIC_FILES) {
    console.log(`Processing ${fileName}`);
    await buildFile(fileName);
  }

  for (const directoryName of PUBLIC_DIRECTORIES) {
    console.log(`Copying ${directoryName}/`);
    await copyPublicDirectory(directoryName);
  }

  console.log("Fetching public firms for static SEO pages…");
  const firms = await fetchPublicFirms();

  if (!firms.length) {
    throw new Error(
      "No public firms were returned. Static firm generation stopped."
    );
  }

  const staticData = await fetchStaticFirmData();

  /* VACATORY_CANONICAL_CRAWLABLE_PROFILE_BUILD_20260818
     Static research remains crawlable while the browser lazily refreshes each
     visible tab from the same canonical public data source. */
  console.log(
    `Generating ${firms.length} canonical crawlable firm profile pages…`
  );

  await generateFirmPages(firms, staticData);

  await syncGeneratedRootDirectory("firms");

  await generateSitemap(firms);

  console.log(
    `Generated ${firms.length} firm pages under /firms/<slug>/.`
  );

  console.log(
    `Build complete. Minified files are in /${OUTPUT_DIRECTORY}.`
  );
}

build().catch((error) => {
  console.error("Build failed.");
  console.error(error);
  process.exitCode = 1;
});
