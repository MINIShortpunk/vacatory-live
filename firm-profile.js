const params=new URLSearchParams(window.location.search),firmId=window.__VACATORY_FIRM_ID__||params.get("id");let sharedResearchPromise=null;let sharedLocationPromise=null;const roleGroupDefinitions=[{key:"early-career",title:"Early-career routes",description:"Student, school-leaver and graduate routes into the firm.",contextLabel:"Application routes"},{key:"legal-careers",title:"Legal careers",description:"Core lawyer roles and common progression levels after qualification.",contextLabel:"Career progression"},{key:"knowledge-innovation",title:"Knowledge and innovation",description:"Knowledge, legal technology, innovation and legal-operations careers.",contextLabel:"Specialist careers"},{key:"legal-support",title:"Legal support",description:"Roles supporting lawyers, matters and legal service delivery.",contextLabel:"Support careers"},{key:"leadership-specialist",title:"Leadership and specialist titles",description:"Senior leadership, consultancy and qualification or status titles. These are shown for context, not as student application routes.",contextLabel:"Context only"},{key:"other",title:"Other professional roles",description:"Additional roles that do not fit neatly into the main groups.",contextLabel:"Additional roles"}];function showError(){document.getElementById("loadingState")?.classList.add("hidden"),document.getElementById("profileContent")?.classList.add("hidden"),document.getElementById("errorState")?.classList.remove("hidden")}async function loadFirmProfile(){if("undefined"==typeof client)return console.error("The Supabase client is unavailable."),void showError();let e;try{const{data:t,error:n}=await client.from("firms").select("*").eq("id",firmId).maybeSingle();if(n)throw n;if(!t)return console.error("Firm record not found:",firmId),void showError();e=t}catch(e){return console.error("Unable to load firm record:",e),void showError()}renderFirmHeader(e),document.getElementById("loadingState")?.classList.add("hidden"),document.getElementById("errorState")?.classList.add("hidden"),document.getElementById("profileContent")?.classList.remove("hidden");const t=await Promise.allSettled([loadAtAGlance(e),loadOpportunities(e),loadApplications(),loadPayFundingVisas(),loadPracticeAreas(),loadLocations(e),loadRoles(),loadInclusionDisability(),loadProBono(),loadFirmHighlights(e),loadLinksAndSocials(e)]),n=["At a glance","Opportunities","Applications","Pay, funding & visas","Practice areas","Locations","Roles","EDI","Pro bono","Firm highlights","Links & Socials"];t.forEach((e,t)=>{"rejected"===e.status&&console.error(`Unable to load ${n[t]}:`,e.reason)})}async function getSharedResearchData(){
  if(!sharedResearchPromise){
    sharedResearchPromise=(async()=>{
      const api=vacatoryCanonicalApi();
      const [firmResult,allOpportunities,researchSections,disabilityRows]=await Promise.all([
        client.from("firms").select("id,organisation_id").eq("id",firmId).maybeSingle(),
        api.loadOpportunities({client}),
        readOptionalRows("firm_research_sections","firm_id",firmId),
        readOptionalRows("firm_disability_support","firm_id",firmId)
      ]);
      if(firmResult.error)throw firmResult.error;
      const firm=firmResult.data||{},providerId=String(firm.organisation_id||firm.id||firmId);
      const opportunities=api.opportunitiesForProvider(allOpportunities,providerId);

      if(typeof vacatoryRecordFreshness==="function"){
        vacatoryRecordFreshness(
          "career_opportunities_public_view",
          opportunities
        );
      }

      return{opportunities,researchSections,disabilityRows,providerId};
    })().catch(error=>{sharedResearchPromise=null;throw error});
  }
  return sharedResearchPromise;
}async function getSharedLocationRows(firm){
  if(!sharedLocationPromise){
    sharedLocationPromise=(async()=>{
      const organisationPromise=
        firm?.organisation_id
          ? readOptionalRows(
              "organisation_locations",
              "organisation_id",
              firm.organisation_id
            )
          : Promise.resolve([]);

      const [
        legacyLocations,
        organisationLocations
      ]=await Promise.all([
        readOptionalRows(
          "locations",
          "firm_id",
          firmId
        ),
        organisationPromise
      ]);

      return deduplicateLocations([
        ...organisationLocations,
        ...legacyLocations
      ])
    })()
  }

  return sharedLocationPromise
}

function renderFirmHeader(e){document.title=`${e.name||"Firm"} | Vacatory`;applyFirmProfileSeo(e);const t=document.getElementById("firmLogo"),n=document.getElementById("firmName"),a=document.getElementById("firmType"),i=document.getElementById("firmOverview"),r=document.getElementById("firmMeta");if(t){const n=(e.short_name||e.name||"V").trim().charAt(0).toUpperCase();t.innerHTML=e.logo_url?`\n        <img\n          src="${escapeHtml(e.logo_url)}"\n          alt="${escapeHtml(e.name||"Firm")} logo"\n        >\n      `:escapeHtml(n)}if(n&&(n.textContent=e.name||"Law firm"),a&&(a.textContent="",a.hidden=!0),i&&(i.textContent=e.overview||"A detailed overview has not yet been added."),r){const t=[],n=e.head_office||[e.head_office_city,e.head_office_country].filter(Boolean).join(", ");n&&t.push(metaPill(locationIcon(),n)),null!==e.uk_rank&&void 0!==e.uk_rank&&""!==e.uk_rank&&t.push(metaPill(rankIcon(),`UK rank #${e.uk_rank}`));const a=firmOfficialWebsite(e);a&&t.push(metaLink(linkIcon(),"Official website",a)),r.innerHTML=t.join("")}}function firmSlugForUrl(e){return String(e||"law-firm").normalize("NFKD").replace(/[\u0300-\u036f]/g,"").replace(/&/g,"").replace(/['’]/g,"").toLowerCase().replace(/[^a-z0-9]+/g,"-").replace(/^-+|-+$/g,"").replace(/-{2,}/g,"-")}function firmCleanProfileUrl(e){const t=firmSlugForUrl(e.name||e.short_name||"law-firm");return`https://vacatory.com/firms/${t}/`}function upsertFirmSeoMeta(e,t,n){let a=document.head.querySelector(`meta[${e}="${t}"]`);a||(a=document.createElement("meta"),a.setAttribute(e,t),document.head.appendChild(a)),a.setAttribute("content",n)}function upsertFirmCanonical(e){let t=document.head.querySelector('link[rel="canonical"]');t||(t=document.createElement("link"),t.setAttribute("rel","canonical"),document.head.appendChild(t)),t.setAttribute("href",e)}function upsertFirmStructuredData(e,t){let n=document.getElementById("firmOrganizationSchema");n||(n=document.createElement("script"),n.id="firmOrganizationSchema",n.type="application/ld+json",document.head.appendChild(n));const a=firmOfficialWebsite(e),i=[a,e.linkedin_url||e.linkedin,e.instagram_url||e.instagram,e.youtube_url||e.youtube,e.facebook_url||e.facebook,e.x_url||e.twitter_url||e.x||e.twitter].map(normaliseExternalUrl).filter(Boolean),r={"@context":"https://schema.org","@type":"Organization","@id":`${t}#organization`,name:String(e.name||e.short_name||"Law firm").trim(),url:a||t};i.length&&(r.sameAs=[...new Set(i)]);const s=normaliseExternalUrl(e.logo_url);s&&(r.logo=s),n.textContent=JSON.stringify(r)}function applyFirmProfileSeo(e){const t=String(e.name||e.short_name||"Law firm").trim(),n=firmCleanProfileUrl(e),a=`${t} law firm profile with practice areas, locations, student opportunities, application information and official links on Vacatory.`,i=`https://vacatory.com/assets/social/firm-${firmSlugForUrl(t)}.png`,s=`${t} firm profile on Vacatory`;document.title=`${t} | Vacatory`,upsertFirmCanonical(n),upsertFirmSeoMeta("name","description",a),upsertFirmSeoMeta("property","og:type","website"),upsertFirmSeoMeta("property","og:site_name","Vacatory"),upsertFirmSeoMeta("property","og:title",`${t} | Vacatory`),upsertFirmSeoMeta("property","og:description",a),upsertFirmSeoMeta("property","og:url",n),upsertFirmSeoMeta("property","og:image",i),upsertFirmSeoMeta("property","og:image:alt",s),upsertFirmSeoMeta("property","og:image:width","1200"),upsertFirmSeoMeta("property","og:image:height","630"),upsertFirmSeoMeta("property","og:image:type","image/png"),upsertFirmSeoMeta("name","twitter:card","summary_large_image"),upsertFirmSeoMeta("name","twitter:title",`${t} | Vacatory`),upsertFirmSeoMeta("name","twitter:description",a),upsertFirmSeoMeta("name","twitter:image",i),upsertFirmSeoMeta("name","twitter:image:alt",s),upsertFirmStructuredData(e,n);const r=new URLSearchParams(window.location.search).get("id");r&&window.location.pathname.endsWith("/firm-profile.html")&&history.replaceState(history.state,"",`/firms/${firmSlugForUrl(t)}/${window.location.hash||""}`)}function setupTabs(){const e=document.querySelectorAll(".tab-btn"),t=document.querySelectorAll(".tab-panel");e.forEach(n=>{const a=n.classList.contains("active");n.setAttribute("aria-selected",String(a)),n.addEventListener("click",()=>{const a=n.dataset.tab;e.forEach(e=>{e.classList.remove("active"),e.setAttribute("aria-selected","false")}),t.forEach(e=>{e.classList.remove("active")}),n.classList.add("active"),n.setAttribute("aria-selected","true"),document.getElementById(`tab-${a}`)?.classList.add("active")})})}async function loadAtAGlance(firm){
  const loading=document.getElementById("atGlanceLoading"),panel=document.getElementById("atGlancePanel"),grid=document.getElementById("atGlanceGrid"),evidence=document.getElementById("atGlanceEvidence"),routes=document.getElementById("atGlanceRoutes");
  if(!grid||!panel)return;
  const{opportunities,researchSections,disabilityRows}=await getSharedResearchData(),next=vacatoryCanonicalNextDeadline(opportunities),routeLinks=vacatoryCanonicalRoutes(opportunities),applicationSummary=vacatoryCanonicalApplicationSummary(opportunities),officeSummary=buildOfficeSummary(firm),visaSummary=vacatoryCanonicalVisaSummary(opportunities,researchSections),disabilitySummary=buildDisabilitySummary(disabilityRows),lastChecked=latestResearchDate([firm.research_checked_on,...researchSections.map(x=>x.research_checked_on),...disabilityRows.map(x=>x.research_checked_on),...opportunities.map(x=>x.lastVerifiedOn)]);
  grid.innerHTML=[
    glanceCard("Next deadline",next?formatDate(next.closesOn):"No upcoming date published",next?next.publicTitle:"See Opportunities for rolling and date-TBC routes.",next?"confirmed":"unpublished","opportunities"),
    glanceCard("Applications",applicationSummary.value,applicationSummary.note,applicationSummary.status,"opportunities"),
    glanceCard("Global reach",officeSummary.value,officeSummary.note,officeSummary.status,"locations"),
    glanceCard("Student routes",routeLinks.length?`${routeLinks.length} route ${routeLinks.length===1?"type":"types"}`:"No current routes listed",routeLinks.length?routeLinks.map(x=>x.name).join(", "):"See Opportunities for newly published routes.",routeLinks.length?"confirmed":"unpublished","opportunities"),
    glanceCard("Visa sponsorship",visaSummary.value,visaSummary.note,visaSummary.status,"pay-funding-visas"),
    glanceCard("Disability support",disabilitySummary.value,disabilitySummary.note,disabilitySummary.status,"inclusion-disability")
  ].join("");
  if(evidence)evidence.innerHTML=`<span class="evidence-badge confirmed">Official-source research</span><span class="evidence-date">Last checked: <strong>${lastChecked?escapeHtml(formatDate(lastChecked)):"Not recorded"}</strong></span>`;
  if(routes)routes.innerHTML=routeLinks.length?routeLinks.map(x=>x.url?`<a class="route-chip" href="${escapeHtml(x.url)}" aria-label="${escapeHtml(`${x.name} official opportunity page (opens in new tab)`)}" target="_blank" rel="noopener noreferrer">${escapeHtml(x.name)}</a>`:`<span class="route-chip muted">${escapeHtml(x.name)}</span>`).join(""):'<span class="route-chip muted">No current route categories are published</span>';
  document.getElementById("importantGaps")?.classList.add("hidden");loading?.classList.add("hidden");panel.classList.remove("hidden");
}function buildRouteCategories(e){const t=new Map;return e.forEach(e=>{const n=classifyProgrammeRoute(e);if(!n)return;const a=String(readField(e,["application_url","application_link","official_url","source_url"])||"");t.has(n)?!t.get(n).url&&a&&t.set(n,{name:n,url:a}):t.set(n,{name:n,url:a})}),[...t.values()].sort((e,t)=>e.name.localeCompare(t.name))}function classifyProgrammeRoute(e){const t=normaliseText(`${programmeName(e)} ${programmeType(e)}`);return t.includes("apprent")?"Apprenticeships":t.includes("vacation")||t.includes("summer scheme")||t.includes("winter scheme")?"Vacation schemes":t.includes("training contract")||t.includes("trainee solicitor")?"Training contracts":t.includes("insight")||t.includes("open day")||t.includes("first year")||t.includes("first-year")?"Insight programmes":t.includes("work experience")?"Work experience":t.includes("graduate")||t.includes("law tech")||t.includes("legal operations")?"Graduate programmes":t.includes("intern")?"Internships":"Other opportunities"}function buildApplicationSummary(e){const t=startOfToday(),n=e.filter(e=>{const n=e.opens_on&&isValidDate(e.opens_on)?startOfDate(e.opens_on):null,a=e.closes_on&&isValidDate(e.closes_on)?startOfDate(e.closes_on):null;return!(!a||a<t)&&(!n||n<=t)});if(n.length)return{value:`${n.length} currently open`,note:"Open the Opportunities tab for dates and programme details.",status:"confirmed"};const a=e.filter(e=>e.closes_on&&isValidDate(e.closes_on)&&startOfDate(e.closes_on)>=t);return a.length?{value:`${a.length} upcoming ${1===a.length?"deadline":"deadlines"}`,note:"Some programmes may not be open yet.",status:"programme-dependent"}:{value:"No live dates published",note:"Programmes without dates remain available in the Opportunities tab.",status:"unpublished"}}function buildVisaSummary(e,t,n){const a=firstMeaningfulText([...e.filter(e=>sectionMatches(e,["visa","sponsorship","right to work","immigration"])).map(researchSectionContent),...n.map(e=>readField(e,["visa_sponsorship","visa_information","right_to_work"])),...t.map(e=>readField(e,["visa_sponsorship","visa_information","right_to_work"]))]);return a?{value:shortenText(a,105),note:"Sponsorship can differ by programme, role and location.",status:"programme-dependent"}:{value:"Check each programme",note:"A single firm-wide sponsorship position is not listed.",status:"unpublished"}}function buildDisabilitySummary(e){const t=e.filter(e=>{const t=normaliseText(e.current_status);return!1!==e.active&&"not_identified"!==t&&!t.includes("not found")});if(!t.length)return{value:"Contact early careers",note:"No detailed adjustment process is currently displayed on Vacatory.",status:"unpublished"};const n=uniqueSorted(t.map(e=>disabilitySupportOverviewLabel(e)));return{value:n.slice(0,2).join(" and ")||"Published disability support",note:n.length>2?`Also includes ${n.slice(2).join(", ")}.`:"See the Inclusion & disability tab for full details and how to request support.",status:"confirmed"}}function disabilitySupportOverviewLabel(e){const t=normaliseText(e.support_type),n={recruitment_adjustments:"Recruitment adjustments",application_mitigation:"Mitigating circumstances",disability_programme:"Disability-specific programmes",workplace_adjustments:"Workplace adjustments",accessibility:"Accessibility support"};return n[t]?n[t]:disabilitySupportTitle(e)||"Disability support"}function disabilitySupportTitle(e){const t=readField(e,["support_name","programme_name","title","name"]);return t?String(t):{recruitment_adjustments:"Recruitment adjustments",application_mitigation:"Mitigating-circumstances support",disability_programme:"Disability-specific programme",workplace_adjustments:"Workplace adjustments",accessibility:"Accessibility support"}[normaliseText(e.support_type)]||readableLabel(e.support_type||"Disability support")}function renderImportantGaps({programmes:e,cycles:t,researchSections:n,nextCycle:a}){const i=document.getElementById("importantGaps"),r=document.getElementById("importantGapsList");if(!i||!r)return;const s=[];!a&&e.length&&s.push("Upcoming application deadlines have not yet been published for the listed programmes.");const o=e.filter(e=>!t.filter(t=>t.programme_id===e.id).some(e=>e.closes_on));o.length&&s.push(`Application dates are not yet listed for ${o.length} ${1===o.length?"programme":"programmes"}.`),n.some(e=>sectionMatches(e,["visa","sponsorship","right to work","immigration"]))||t.some(e=>readField(e,["visa_sponsorship","visa_information","right_to_work"]))||s.push("Visa sponsorship information is not published consistently across all programmes."),t.some(e=>{const t=e.funding;return!(!t||"object"!=typeof t)&&Object.values(t).some(e=>{const t=normaliseText(e);return t.includes("not stated")||t.includes("not published")})})&&s.push("Some course-fee or maintenance-support amounts are not yet published.");const l=[...new Set(s)];if(!l.length)return i.classList.add("hidden"),void(r.innerHTML="");r.innerHTML=l.map(e=>`<li>${escapeHtml(e)}</li>`).join(""),i.classList.remove("hidden")}function glanceCard(e,t,n,a,i){const r=i?"a":"article",s=i?` href="#tab-${escapeHtml(i)}" data-profile-tab-target="${escapeHtml(i)}"`:"";return`
    <${r} class="glance-card${i?" glance-card-link":""}"${s}>
      <div class="glance-card-heading">
        <h3>${escapeHtml(e)}</h3>

        <span class="evidence-badge ${escapeHtml(a)}">
          ${escapeHtml(evidenceLabel(a))}
        </span>
      </div>

      <p class="glance-value">
        ${escapeHtml(t)}
      </p>

      ${n?`
        <p class="glance-note">
          ${escapeHtml(n)}
        </p>
      `:""}
    </${r}>
  `}function evidenceLabel(e){return{confirmed:"Confirmed",unpublished:"Check source","programme-dependent":"Varies by programme"}[e]||"Checked"}function buildOfficeSummary(e){const t=e.office_count||e.number_of_offices,n=e.country_count||e.number_of_countries;if(t&&n)return{value:`${t} offices`,note:`Across ${n} countries.`,status:"confirmed"};if(t)return{value:`${t} offices`,note:e.country_count_text||"International office network.",status:"confirmed"};if(e.office_count_text)return{value:e.office_count_text,note:e.country_count_text||"International office network.",status:"confirmed"};if(e.country_count_text)return{value:e.country_count_text,note:"See the Locations tab for published offices.",status:"confirmed"};const a=e.head_office_city||e.head_office;return a?{value:a,note:"See the Locations tab for the wider office network.",status:"programme-dependent"}:{value:"See locations",note:"Office records are listed in the Locations tab.",status:"unpublished"}}function findNextPublishedCycle(e,t){const n=startOfToday();return e.filter(e=>!(!e.closes_on||!isValidDate(e.closes_on))&&startOfDate(e.closes_on)>=n).map(e=>({cycle:e,programme:t.get(e.programme_id)})).filter(e=>e.programme).sort((e,t)=>dateValue(e.cycle.closes_on)-dateValue(t.cycle.closes_on))[0]||null}async function loadProgrammeCycles(){return[]}async function loadOpportunities(firm){
  const list=document.getElementById("opportunitiesList"),loading=document.getElementById("opportunitiesLoading"),empty=document.getElementById("opportunitiesEmpty"),controls=document.getElementById("opportunityControls"),filterEmpty=document.getElementById("opportunitiesFilterEmpty");if(!list)return;
  const{opportunities}=await getSharedResearchData();vacatoryOpportunityRows=vacatoryCanonicalViews(opportunities).sort(sortOpportunitiesByClosingDate);
  loading?.classList.add("hidden");filterEmpty?.classList.add("hidden");
  if(!vacatoryOpportunityRows.length){controls?.classList.add("hidden");empty?.classList.remove("hidden");list.innerHTML="";if(firm?.careers_url&&empty)empty.innerHTML=`No current or upcoming student opportunities are published for this firm at the moment. ${profileLink(firm.careers_url,"Visit the official careers page",`Official careers page — ${firm.name||firm.firm_name||"this firm"}`)}`;return}
  empty?.classList.add("hidden");controls?.classList.remove("hidden");vacatoryPopulateOpportunityFilters();vacatoryApplyOpportunityFilters();
}

function deduplicateOpportunities(e){const t=new Map;return e.forEach(e=>{if(!e||!e.name)return;e.name=cleanPublicOpportunityName(e.name);const n=normaliseText([e.name,e.location,e.closingDate||"no-date"].join("|"));if(!t.has(n))return void t.set(n,e);const a=t.get(n);t.set(n,{...e,...a,applicationUrl:a.applicationUrl||e.applicationUrl,eligibility:a.eligibility||e.eligibility,applicationProcess:a.applicationProcess||e.applicationProcess,assessments:a.assessments||e.assessments,sponsorship:a.sponsorship||e.sponsorship,visaInformation:a.visaInformation||e.visaInformation,disabilityInformation:a.disabilityInformation||e.disabilityInformation,additionalDetails:a.additionalDetails||e.additionalDetails})}),[...t.values()]}function isActiveOpportunityForDisplay(row){return Boolean(row&&row._canonicalVisible!==false)}

function sortOpportunitiesByClosingDate(e,t){const n=closingDateGroup(e.closingDate),a=closingDateGroup(t.closingDate);if(n!==a)return n-a;const i=dateValue(e.closingDate),r=dateValue(t.closingDate);return 2===n?r-i:i!==r?i-r:e.name.localeCompare(t.name)}function closingDateGroup(e){return e&&isValidDate(e)?startOfDate(e)>=startOfToday()?0:2:1}function renderOpportunity(e,t){const n=buildOpportunityDateBox(e),a=formatOpportunityStart(e)||"Not announced",i=buildOpportunityDetailSections(e),r=buildOpportunityFacts(e);return`\n    <details\n      class="opportunity-item"\n      data-opportunity-index="${t}"\n    >\n      <summary class="opportunity-summary">\n\n        <div class="opportunity-deadline">\n          <span>${escapeHtml(n.label)}</span>\n          <strong>${escapeHtml(n.value)}</strong>\n        </div>\n\n        <div class="opportunity-summary-main">\n          <h3>${escapeHtml(vacatoryPublicOpportunityTitle(e))}</h3>\n\n          <div class="opportunity-summary-meta">\n            <span>\n              <strong>Type:</strong>\n              ${escapeHtml(readableLabel(e.type)||"Opportunity")}\n            </span>\n\n            <span>\n              <strong>Location:</strong>\n              ${escapeHtml(e.location)}\n            </span>\n\n            <span>\n              <strong>Starts:</strong>\n              ${escapeHtml(a)}\n            </span>\n          </div>\n        </div>\n\n        <span class="opportunity-chevron" aria-hidden="true">\n          <svg\n            viewBox="0 0 24 24"\n            fill="none"\n            stroke="currentColor"\n            stroke-width="2"\n          >\n            <path d="M6 9l6 6 6-6"></path>\n          </svg>\n        </span>\n\n      </summary>\n\n      <div class="opportunity-expanded">\n\n        ${e.evidenceStatus?`\n          <div class="evidence-strip">\n            <span class="evidence-badge confirmed">\n              ${escapeHtml(e.evidenceStatus)}\n            </span>\n\n            ${e.researchCheckedOn?`\n              <span class="evidence-date">\n                Last checked:\n                <strong>\n                  ${escapeHtml(formatDate(e.researchCheckedOn))}\n                </strong>\n              </span>\n            `:""}\n          </div>\n        `:""}\n\n        ${r?`\n          <div class="opportunity-facts">\n            ${r}\n          </div>\n        `:""}\n\n        ${i.length?`\n          <div class="opportunity-detail-sections">\n            ${i.join("")}\n          </div>\n        `:'\n          <p class="opportunity-no-details">\n            Further details have not yet been added.\n          </p>\n        '}\n\n        ${e.applicationUrl?`\n          <div class="opportunity-link-panel">\n            ${profileLink(e.applicationUrl,`View official opportunity page - ${e.name||e.title||e.opportunity_name||"Opportunity"} (opens in new tab)`,`Official opportunity page — ${e.name||e.title||e.opportunity_name||"Opportunity"}`)}\n          </div>\n        `:""}\n\n      </div>\n    </details>\n  `}function buildOpportunityDateBox(e){
  const today=startOfToday();

  if(e.closingDate&&isValidDate(e.closingDate)&&startOfDate(e.closingDate)>=today){
    return{label:"Closing",value:formatDate(e.closingDate)};
  }

  if(e.openingDate&&isValidDate(e.openingDate)&&startOfDate(e.openingDate)>today){
    return{label:"Opens",value:formatDate(e.openingDate)};
  }

  const timing=formatDisplayValue(e.programmeDates);

  const applicationMatch=timing.match(
    /\b(?:applications?|recruitment)\s+(?:are\s+|is\s+|during\s+|from\s+)?((?:January|February|March|April|May|June|July|August|September|October|November|December)(?:\s+(?:to|through|until|–|-)\s+(?:January|February|March|April|May|June|July|August|September|October|November|December))?\s+\d{4})/i
  );

  if(applicationMatch){
    return{
      label:"Applications",
      value:compactApplicationTiming(applicationMatch[1])
    };
  }

  const status=normaliseText(e.status);

  if(
    status==="evergreen"||
    status.includes("throughout_year")||
    status.includes("year_round")
  ){
    return{label:"Applications",value:"Year-round"};
  }

  if(
    status==="open"||
    status==="rolling"||
    status.includes("current_vacancy")
  ){
    return{label:"Applications",value:"Open"};
  }

  if(e.startDate&&isValidDate(e.startDate)){
    return{label:"Starts",value:formatDate(e.startDate)};
  }

  if(timing){
    return{label:"Timing",value:timing};
  }

  return{label:"Timing",value:"Not announced"};
}

function compactApplicationTiming(value){
  const months={
    january:"Jan",february:"Feb",march:"Mar",april:"Apr",
    may:"May",june:"Jun",july:"Jul",august:"Aug",
    september:"Sep",october:"Oct",november:"Nov",december:"Dec"
  };

  return String(value)
    .replace(
      /\b(january|february|march|april|may|june|july|august|september|october|november|december)\b/gi,
      month=>months[month.toLowerCase()]
    )
    .replace(/\s+(?:to|through|until|-)\s+/gi," - ")
    .replace(/\s+/g," ")
    .trim();
}

function publicOpportunityStatus(value){return vacatoryCanonicalStatusLabel(value)}function buildOpportunityFacts(e){return[fact("Applications open",formatDate(e.openingDate)),fact("Closing date",formatDate(e.closingDate)),fact("Start date",formatDate(e.startDate)),fact("Programme dates",e.programmeDates),fact("Duration",e.duration),fact("Application status",publicOpportunityStatus(e.status)),fact("Pay",e.salary),fact("First-year salary",formatMoney(e.firstYearSalary)),fact("Second-year salary",formatMoney(e.secondYearSalary)),fact("NQ salary",formatMoney(e.nqSalary)),fact("Places",e.seats)].filter(Boolean).join("")}function buildOpportunityDetailSections(e){const t=[];return addBulletSection(t,"Eligibility",e.eligibility),addBulletSection(t,"Academic requirements",e.academicRequirements),addBulletSection(t,"Degree and study-stage requirements",e.degreeRequirements),addBulletSection(t,"Application process",e.applicationProcess),addBulletSection(t,"Assessments",e.assessments),addBulletSection(t,"Funding and study support",e.sponsorship),addBulletSection(t,"Visa and right-to-work information",e.visaInformation),addBulletSection(t,"Disability support and adjustments",e.disabilityInformation),addBulletSection(t,"Further information",e.additionalDetails),t}function addBulletSection(e,t,n){const a=splitIntoBulletPoints(n);a.length&&e.push(`\n    <section class="opportunity-detail-section">\n      <h4>${escapeHtml(t)}</h4>\n\n      <ul class="opportunity-bullets">\n        ${a.map(e=>`<li>${escapeHtml(e)}</li>`).join("")}\n      </ul>\n    </section>\n  `)}function formatOpportunityStart(e){return e.startDate?formatDate(e.startDate):formatDisplayValue(e.programmeDates)}async function loadApplications(){
  const loading=document.getElementById("applicationsLoading"),empty=document.getElementById("applicationsEmpty"),list=document.getElementById("applicationsList");if(!list)return;
  const{opportunities,researchSections}=await getSharedResearchData(),items=[];
  (opportunities||[]).filter(vacatoryCanonicalVisible).forEach(o=>{
    const facts=[researchFact("Application status",vacatoryCanonicalStatusLabel(o.publicApplicationStatus)),researchFact("Applications open",formatDate(o.opensOn)),researchFact("Closing date",formatDate(o.closesOn)),researchFact("Application timing",o.applicationDatesText)].filter(Boolean),sections=[];
    addResearchSection(sections,"Published application and programme dates",vacatoryCanonicalCycleTiming(o));addResearchSection(sections,"Who can apply",[o.audienceText,o.studyStageText,o.eligibilityText]);addResearchSection(sections,"Academic requirements",o.academicCriteria);addResearchSection(sections,"Application process",o.applicationProcessText);addResearchSection(sections,"Assessments",o.assessmentsText);addResearchSection(sections,"Progression route",o.progressionRouteText);
    if(facts.length||sections.length)items.push(renderResearchAccordion({title:o.publicTitle,label:o.opportunityTypeLabel||"Opportunity",summary:o.applicationDatesText||vacatoryCanonicalStatusLabel(o.publicApplicationStatus),facts,sections,sourceUrl:o.applicationUrl||o.officialUrl,checkedOn:o.lastVerifiedOn}));
  });
  researchSections.filter(x=>sectionMatches(x,["application","assessment","eligibility","academic","recruitment process"])).map(renderResearchItem).filter(Boolean).forEach(x=>items.push(x));
  const final=deduplicateRenderedItems(items);loading?.classList.add("hidden");if(!final.length){empty?.classList.remove("hidden");list.innerHTML="";return}empty?.classList.add("hidden");list.innerHTML=final.join("");
}function renderApplicationProgramme(e,t){const n=collectProgrammeApplicationValues(e,t);return n.sections.length||n.facts.length?renderResearchAccordion({title:programmeName(e),label:programmeType(e)||"Application route",summary:n.summary,facts:n.facts,sections:n.sections,sourceUrl:readField(e,["application_url","application_link","official_url","source_url"]),checkedOn:readField(e,["research_checked_on","last_checked_on"])}):""}function collectProgrammeApplicationValues(e,t){const n=[e,...t],a=uniqueSorted(n.map(e=>readField(e,["opens_on","application_open","application_open_date"])).filter(Boolean).map(formatDate)),i=uniqueSorted(n.map(e=>readField(e,["closes_on","deadline","application_deadline","application_close_date"])).filter(Boolean).map(formatDate)),r=[researchFact("Applications open",a.join(", ")),researchFact("Closing date",i.join(", ")),researchFact("Application model",firstMeaningfulText(n.map(e=>readField(e,["application_model","application_status","status"]))))].filter(Boolean),s=[];return addResearchSection(s,"Eligibility",n.map(e=>readField(e,["eligibility","eligibility_details","full_eligibility"]))),addResearchSection(s,"Academic requirements",n.map(e=>readField(e,["academic_requirements","academic_requirement"]))),addResearchSection(s,"Degree and study-stage requirements",n.map(e=>readField(e,["degree_requirements","degree_requirement","year_of_study"]))),addResearchSection(s,"Application stages",n.map(e=>readField(e,["application_process","selection_process","application_stages","process"]))),addResearchSection(s,"Assessments",n.map(e=>readField(e,["assessments","assessment_details","online_tests","interview_details"]))),addResearchSection(s,"Additional application guidance",n.map(e=>readField(e,["application_notes","additional_details","notes"]))),{summary:firstMeaningfulText([readField(e,["summary","description","details"]),firstMeaningfulText(t.map(e=>readField(e,["summary","description","details"])))]),facts:r,sections:s}}async function loadPayFundingVisas(){
  const loading=document.getElementById("payFundingVisasLoading"),empty=document.getElementById("payFundingVisasEmpty"),list=document.getElementById("payFundingVisasList");if(!list)return;
  const{opportunities,researchSections}=await getSharedResearchData(),items=[];
  (opportunities||[]).filter(vacatoryCanonicalVisible).forEach(o=>{
    const pay=vacatoryCanonicalCompensation(o),facts=[researchFact("Pay",pay),researchFact("Application status",vacatoryCanonicalStatusLabel(o.publicApplicationStatus))].filter(Boolean),sections=[];
    addResearchSection(sections,"Course fees, grants and funding",o.fundingText);addResearchSection(sections,"Expenses",o.expensesText);addResearchSection(sections,"Travel and accommodation support",[o.travelSupportText,o.accommodationSupportText]);addResearchSection(sections,"Visa sponsorship and right to work",o.rightToWorkText);
    if(facts.length||sections.length)items.push(renderResearchAccordion({title:o.publicTitle,label:o.opportunityTypeLabel||"Opportunity",summary:pay||o.fundingText||o.rightToWorkText||"Published financial and eligibility information.",facts,sections,sourceUrl:o.applicationUrl||o.officialUrl,checkedOn:o.lastVerifiedOn}));
  });
  researchSections.filter(x=>sectionMatches(x,["visa","sponsorship","right to work","immigration","funding","salary","pay"])).map(renderResearchItem).filter(Boolean).forEach(x=>items.push(x));
  const final=deduplicateRenderedItems(items);loading?.classList.add("hidden");if(!final.length){empty?.classList.remove("hidden");list.innerHTML="";return}empty?.classList.add("hidden");list.innerHTML=final.join("");
}function renderProgrammeFinance(e,t){const n=[e,...t],a=[],i=[],r=uniqueSorted(n.map(buildSalaryText).filter(Boolean)),s=firstMeaningfulText(n.map(e=>readField(e,["salary_first_year","first_year_salary"]))),o=firstMeaningfulText(n.map(e=>readField(e,["salary_second_year","second_year_salary"]))),l=firstMeaningfulText(n.map(e=>readField(e,["salary_qualification","nq_salary"])));a.push(researchFact("Programme pay",r.join(", ")),researchFact("First-year trainee salary",formatMoney(s)),researchFact("Second-year trainee salary",formatMoney(o)),researchFact("Newly qualified salary",formatMoney(l))),addResearchSection(i,"Course fees and qualification funding",n.map(e=>readField(e,["funding","course_funding","sqe_funding","sponsorship","study_support"]))),addResearchSection(i,"Maintenance support",n.map(e=>readField(e,["maintenance_grant","maintenance_support","living_allowance","stipend"]))),addResearchSection(i,"Visa sponsorship and right to work",n.map(e=>readField(e,["visa_sponsorship","visa_information","right_to_work"]))),addResearchSection(i,"Additional financial support",n.map(e=>readField(e,["additional_compensation","financial_support","benefits","notes"])));const c=a.filter(Boolean);return c.length||i.length?renderResearchAccordion({title:programmeName(e),label:programmeType(e)||"Programme",summary:"Published pay, funding and sponsorship information for this route.",facts:c,sections:i,sourceUrl:readField(e,["application_url","official_url","source_url"]),checkedOn:readField(e,["research_checked_on","last_checked_on"])}):""}function buildSalaryText(e){if(!e||"object"!=typeof e)return"";const t=readField(e,["salary","payment","pay","salary_text"]);if(t)return formatDisplayValue(t);const n=readField(e,["salary_amount","pay_amount","amount"]);if(null==n||""===n)return"";const a=readField(e,["salary_currency","currency"]),i=readField(e,["salary_period","pay_period","period"]),r=Number(n);return`${"GBP"===a?"£":a?`${a} `:"£"}${Number.isNaN(r)?String(n):r.toLocaleString("en-GB")}${i?` per ${i}`:""}`}async function loadInclusionDisability(){const e=document.getElementById("inclusionDisabilityLoading"),t=document.getElementById("inclusionDisabilityEmpty"),n=document.getElementById("inclusionDisabilityList");if(!n)return;const[{disabilityRows:a,researchSections:i},r]=await Promise.all([getSharedResearchData(),readOptionalRows("firm_inclusion_initiatives","firm_id",firmId)]),s=a.filter(e=>!1!==e.active).map(e=>renderDisabilityItem(e)).filter(Boolean),o=r.filter(e=>!1!==e.active&&!1!==e.published&&!1!==e.is_public).map(e=>renderInclusionInitiative(e)).filter(Boolean),l=o.length?[]:i.filter(e=>sectionMatches(e,["edi","equality","diversity","inclusion","disability","accessibility","social mobility","race","racial","gender","lgbt","neurodiversity"])).map(e=>renderResearchItem(e)).filter(Boolean),c=deduplicateRenderedItems([...s,...o,...l]);if(e?.classList.add("hidden"),!c.length)return t?.classList.remove("hidden"),void(n.innerHTML="");t?.classList.add("hidden"),n.innerHTML=c.join("")}function renderDisabilityItem(e){const t=disabilitySupportTitle(e),n=[];addResearchSection(n,"What is offered",readField(e,["support_offered","support_details","details","description","summary"])),addResearchSection(n,"Who it is for",readField(e,["eligibility","eligibility_details","who_it_is_for"])),addResearchSection(n,"How to request support",readField(e,["application_or_request_process","how_to_request","request_process","application_process","contact_details"])),addResearchSection(n,"Additional information",readField(e,["additional_details","notes"]));const a=[];return!0===e.disability_specific_programme&&a.push("Disability-specific programme"),e.current_status&&a.push(readableLabel(e.current_status)),renderResearchAccordion({title:t,label:readableLabel(e.support_type||"Disability support"),summary:firstMeaningfulText([readField(e,["summary","description","support_offered","support_details"]),"Published disability support and recruitment-adjustment information."]),facts:a.map(e=>researchFact("Status",e)).filter(Boolean),sections:n,sourceUrl:readField(e,["source_url","official_url","page_url"]),checkedOn:readField(e,["research_checked_on","last_checked_on"])})}function renderInclusionInitiative(e){const t=String(readField(e,["initiative_name","title","name"])||"Inclusion initiative"),n=readField(e,["description","summary","details"]),a=[];return addResearchSection(a,"Initiative details",n),addResearchSection(a,"Target or commitment",readField(e,["target_or_commitment","target","commitment"])),renderResearchAccordion({title:t,label:readableLabel(readField(e,["initiative_type","category","type"])||"Inclusion"),summary:firstMeaningfulText([firstSentence(n),"Published equality, diversity and inclusion information."]),facts:[],sections:a,sourceUrl:readField(e,["source_url","official_url","page_url"]),checkedOn:readField(e,["research_checked_on","last_checked_on"])})}async function loadProBono(){const e=document.getElementById("proBonoLoading"),t=document.getElementById("proBonoEmpty"),n=document.getElementById("proBonoList");if(!n)return;const[{researchSections:a},i]=await Promise.all([getSharedResearchData(),readOptionalRows("firm_pro_bono","firm_id",firmId)]),r=i.filter(e=>!1!==e.active&&!1!==e.published&&!1!==e.is_public).map(e=>renderProBonoItem(e)).filter(Boolean),s=r.length?[]:a.filter(e=>sectionMatches(e,["pro bono","access to justice","legal clinic","community legal","volunteering"])).map(e=>renderResearchItem(e)).filter(Boolean),o=deduplicateRenderedItems([...r,...s]);if(e?.classList.add("hidden"),!o.length)return t?.classList.remove("hidden"),void(n.innerHTML="");t?.classList.add("hidden"),n.innerHTML=o.join("")}function renderProBonoItem(e){const t=String(readField(e,["programme_name","initiative_name","title","name"])||"Pro bono programme"),n=readField(e,["description","summary","details"]),a=[];addResearchSection(a,"Programme details",n),addResearchSection(a,"Published impact",readField(e,["impact_figures","impact","outcomes"])),addResearchSection(a,"Partner organisations",readField(e,["partner_organisations","partners"]));const i=[researchFact("Reporting period",readField(e,["reporting_period","period"]))].filter(Boolean);return renderResearchAccordion({title:t,label:readableLabel(readField(e,["programme_type","initiative_type","type"])||"Pro bono"),summary:firstMeaningfulText([firstSentence(n),"Published pro bono and community-impact information."]),facts:i,sections:a,sourceUrl:readField(e,["source_url","official_url","page_url"]),checkedOn:readField(e,["research_checked_on","last_checked_on"])})}async function loadFirmHighlights(e){const t=document.getElementById("firmHighlightsLoading"),n=document.getElementById("firmHighlightsEmpty"),a=document.getElementById("firmHighlightsList");if(!a)return;const[{researchSections:i},r,s,o]=await Promise.all([getSharedResearchData(),readOptionalRows("firm_awards","firm_id",firmId),readOptionalRows("firm_sectors","firm_id",firmId),readOptionalRows("firm_matters","firm_id",firmId)]),l=r.filter(e=>!1!==e.active&&!1!==e.published&&!1!==e.is_public).sort(sortAwardsNewestFirst).map(e=>renderAwardItem(e)).filter(Boolean),c=s.filter(e=>!1!==e.active&&!1!==e.published&&!1!==e.is_public).map(e=>renderSectorItem(e)).filter(Boolean),d=o.filter(e=>!1!==e.active&&!1!==e.published&&!1!==e.is_public).sort(sortMattersNewestFirst).map(e=>renderMatterItem(e)).filter(Boolean),u=l.length?"":renderLegacyAwardsItem(e),p=["application","assessment","eligibility","academic","visa","sponsorship","right to work","funding","salary","pay","edi","equality","diversity","inclusion","disability","accessibility","social mobility","race","racial","gender","lgbt","neurodiversity","pro bono","access to justice","legal clinic"],m=["award","recognition","ranking","sector","industry","client","notable","matter","deal","culture","values","history","innovation","technology","responsible business","sustainability","environment","strategy","international"],f=i.filter(e=>!sectionMatches(e,p)&&(!l.length||!sectionMatches(e,["award","recognition","ranking"]))&&(!c.length||!sectionMatches(e,["sector","industry"]))&&(!d.length||!sectionMatches(e,["client","notable","matter","deal"]))&&sectionMatches(e,m)).map(e=>renderResearchItem(e)).filter(Boolean),g=deduplicateRenderedItems([...l,u,...c,...d,...f]);if(t?.classList.add("hidden"),!g.length)return n?.classList.remove("hidden"),void(a.innerHTML="");n?.classList.add("hidden"),a.innerHTML=g.join("")}function renderSectorItem(e){const t=String(readField(e,["sector_name","industry_name","title","name"])||"Sector"),n=readField(e,["description","summary","details"]),a=[];return addResearchSection(a,"Sector information",n),renderResearchAccordion({title:t,label:"Sector",summary:firstMeaningfulText([firstSentence(n),"Published sector information for this firm."]),facts:[],sections:a,sourceUrl:readField(e,["source_url","official_url","page_url"]),checkedOn:readField(e,["research_checked_on","last_checked_on"])})}function renderMatterItem(e){const t=String(readField(e,["matter_name","deal_name","title","name"])||"Notable work"),n=readField(e,["description","summary","details"]),a=[researchFact("Client",readField(e,["client_name","client"])),researchFact("Date",formatDate(readField(e,["matter_date","deal_date","date"]))),researchFact("Practice area",readField(e,["practice_area","service","team"]))].filter(Boolean),i=[];return addResearchSection(i,"Matter details",n),renderResearchAccordion({title:t,label:"Notable work",summary:firstMeaningfulText([firstSentence(n),"Published client or matter information."]),facts:a,sections:i,sourceUrl:readField(e,["source_url","official_url","page_url"]),checkedOn:readField(e,["research_checked_on","last_checked_on"])})}function sortMattersNewestFirst(e,t){return dateValue(readField(t,["matter_date","deal_date","date"]))-dateValue(readField(e,["matter_date","deal_date","date"]))}function renderLegacyAwardsItem(e){const t=readField(e,["awards","awards_and_recognition","award_highlights","recognition"]);if(!t)return"";const n=[];return addResearchSection(n,"Awards and recognition",t),renderResearchAccordion({title:"Awards and recognition",label:"Firm recognition",summary:"Published awards and recognition recorded for this firm.",facts:[],sections:n,sourceUrl:readField(e,["awards_source_url","recognition_source_url","website"]),checkedOn:readField(e,["research_checked_on","updated_at"])})}function renderAwardItem(e){const t=String(readField(e,["award_name","recognition_name","award_title","title","name"])||"Firm award"),n=readField(e,["awarding_body","awarded_by","publication","organisation","ranking_body"]),a=formatAwardYear(readField(e,["award_year","year","awarded_on","award_date","date"])),i=readField(e,["award_category","category","practice_area","sector","award_type"]),r=readField(e,["result","rank","position","recognition"]),s=firstMeaningfulText([readField(e,["recognition_details","award_details","description","details","summary","notes"]),n&&a?`Recognised by ${n} in ${a}.`:n?`Recognised by ${n}.`:a?`Published recognition from ${a}.`:""]),o=[researchFact("Awarding body",n),researchFact("Year",a),researchFact("Category",i),researchFact("Result",r)].filter(Boolean),l=[];return addResearchSection(l,"Award details",readField(e,["recognition_details","award_details","description","details","summary","notes"])),o.length||l.length||s?renderResearchAccordion({title:t,label:"Award",summary:s,facts:o,sections:l,sourceUrl:readField(e,["source_url","official_url","page_url","url"]),checkedOn:readField(e,["research_checked_on","last_checked_on","checked_on"])}):""}function sortAwardsNewestFirst(e,t){const n=awardYearValue(readField(e,["award_year","year","awarded_on","award_date","date"])),a=awardYearValue(readField(t,["award_year","year","awarded_on","award_date","date"]));if(n!==a)return a-n;const i=String(readField(e,["award_name","recognition_name","award_title","title","name"])||""),r=String(readField(t,["award_name","recognition_name","award_title","title","name"])||"");return i.localeCompare(r)}function awardYearValue(e){if(!e)return 0;const t=String(e).match(/\b(19|20)\d{2}\b/);if(t)return Number(t[0]);const n=new Date(e);return Number.isNaN(n.getTime())?0:n.getFullYear()}function formatAwardYear(e){const t=awardYearValue(e);return t?String(t):""}async function loadPracticeAreas(){const e=document.getElementById("practiceAreasList");if(!e)return;const t=(await readOptionalRows("practice_areas","firm_id",firmId)).map(e=>({name:readField(e,["practice_area","practice_name","service_name","name"]),description:readField(e,["description","summary"])||"",featured:Boolean(e.featured)})).filter(e=>e.name).sort((e,t)=>e.featured!==t.featured?e.featured?-1:1:e.name.localeCompare(t.name));t.length?e.innerHTML=t.map(e=>`\n      <article class="profile-card">\n        <h3>\n          ${escapeHtml(e.name)}\n\n          ${e.featured?'\n            <span class="featured-tag">Featured</span>\n          ':""}\n        </h3>\n\n        ${e.description?`\n          <p>${escapeHtml(e.description)}</p>\n        `:""}\n      </article>\n    `).join(""):e.innerHTML=emptyMessage("No practice areas have been listed yet.")}function splitPracticeAreaContent(e){if(!e)return{summary:"",capabilities:[]};const t=String(e).replace(/\r/g,"").trim(),n="Official capabilities listed by the firm include:";if(!t.includes(n))return{summary:t,capabilities:[]};const[a,i]=t.split(n),r=i.split(/[•\n]/).map(e=>e.replace(/^[\s:;,.-]+/,"").replace(/\s+/g," ").trim()).filter(Boolean);return{summary:a.trim(),capabilities:[...new Set(r)]}}async function loadRoles(){const e=document.getElementById("rolesList");if(!e)return;let t=await readOptionalRows("firm_roles_public_view","firm_id",firmId);t.length||(t=await readOptionalRows("firm_roles","firm_id",firmId));const n=normaliseRoleRows(t);if(!n.length)return void(e.innerHTML=emptyMessage("No role information has been listed yet."));const a=groupRoles(n),i=roleGroupDefinitions.map(e=>{const t=a.get(e.key)||[];return t.length?renderRoleGroup(e,t):""}).filter(Boolean).join("");e.innerHTML=`\n    <div class="roles-context-note" role="note">\n      <strong>How to read this section</strong>\n      <span>\n        Roles are grouped by career stage and function. Senior and specialist titles are kept for useful firm context, but are not presented as student application routes.\n      </span>\n    </div>\n\n    <div class="role-groups">\n      ${i}\n    </div>\n  `}function normaliseRoleRows(e){const t=new Map;return e.filter(e=>!1!==e.active).forEach(e=>{const n=String(readField(e,["role_name","canonical_name","official_role_title","role_title","name"])||"").trim();if(!n)return;const a=normaliseRoleTitle(n);if(!a)return;const i={title:n,roleGroup:readField(e,["role_group","role_category"])||"",careerStage:e.career_stage||"",studentRelevance:e.student_relevance||"",relationshipType:e.relationship_type||"",description:e.description||"",displayOrder:Number.isFinite(Number(e.display_order))?Number(e.display_order):500};if(!t.has(a))return void t.set(a,i);const r=t.get(a);t.set(a,{...r,roleGroup:r.roleGroup||i.roleGroup,careerStage:r.careerStage||i.careerStage,studentRelevance:r.studentRelevance||i.studentRelevance,relationshipType:r.relationshipType||i.relationshipType,description:r.description||i.description,displayOrder:Math.min(r.displayOrder,i.displayOrder)})}),[...t.values()]}function groupRoles(e){const t=new Map(roleGroupDefinitions.map(e=>[e.key,[]]));return e.forEach(e=>{const n=classifyRole(e);t.get(n)?.push(e)}),t.forEach((e,t)=>{e.sort((e,n)=>{const a=roleSortWeight(e,t),i=roleSortWeight(n,t);return a!==i?a-i:e.displayOrder!==n.displayOrder?e.displayOrder-n.displayOrder:e.title.localeCompare(n.title)})}),t}function classifyRole(e){const t=normaliseRoleTitle(e.title),n=normaliseRoleTitle(e.roleGroup),a=normaliseRoleTitle(e.relationshipType);return matchesAnyRolePattern(t,["trainee","trainee solicitor","solicitor apprentice","apprentice solicitor","legal apprentice","paralegal apprentice","graduate","school leaver","intern","internship","placement","vacation scheme","work experience","insight programme","insight scheme","first year scheme","spring scheme"])||"entry route"===n||"programme"===n||"entry route"===a||"programme"===a?"early-career":matchesAnyRolePattern(t,["global managing partner","managing partner","senior partner","regional managing partner","office managing partner","global head","practice head","head of","chief ","chair","chairperson","king's counsel","kings counsel","queen's counsel","queens counsel","barrister","solicitor advocate","special attorney","of counsel","consultant","consulting lawyer","legal consultant","specialist counsel"])?"leadership-specialist":matchesAnyRolePattern(t,["knowledge lawyer","professional support lawyer","psl","legal tech","law tech","legal technology","innovation","legal operations","legal ops","legal project","practice development","solutions lawyer","knowledge management","knowledge counsel"])||"knowledge innovation"===n?"knowledge-innovation":matchesAnyRolePattern(t,["legal practice assistant","practice assistant","legal assistant","paralegal","caseworker","case worker","legal secretary","secretary","legal administrator","document specialist","document production","legal support","matter support"])||"business services"===n?"legal-support":matchesAnyRolePattern(t,["associate","counsel","partner","solicitor","lawyer","attorney"])||"legal role"===n?"legal-careers":"leadership"===n||"senior legal title"===n||"qualification status"===n||"leadership title"===a||"qualification or status"===a?"leadership-specialist":"other"}function matchesAnyRolePattern(e,t){return t.some(t=>{const n=normaliseRoleTitle(t);return e===n||e.includes(n)})}function roleSortWeight(e,t){const n=normaliseRoleTitle(e.title),a={"early-career":["trainee solicitor","trainee","solicitor apprentice","apprentice solicitor","law tech and operations graduate","graduate","paralegal apprentice","legal apprentice","internship","intern","placement","work experience"],"legal-careers":["associate","senior associate","managing associate","counsel","senior counsel","partner"],"knowledge-innovation":["knowledge lawyer","professional support lawyer","psl","legal tech","law tech","innovation","legal operations"],"legal-support":["legal practice assistant","practice assistant","legal assistant","paralegal","legal secretary"],"leadership-specialist":["global managing partner","managing partner","senior partner","king's counsel","of counsel","special attorney","solicitor advocate","barrister qualified lawyer","consultant","legal consultant","consulting lawyer"],other:[]}[t]||[],i=a.findIndex(e=>n===normaliseRoleTitle(e));if(-1!==i)return i;const r=a.findIndex(e=>n.includes(normaliseRoleTitle(e)));return-1===r?500:r}function renderRoleGroup(e,t){const n=1===t.length?"role":"roles";return`\n    <section\n      class="role-group role-group--${escapeHtml(e.key)}"\n      aria-labelledby="role-group-${escapeHtml(e.key)}"\n    >\n      <div class="role-group-heading">\n        <div class="role-group-copy">\n          <span class="role-group-label">\n            ${escapeHtml(e.contextLabel)}\n          </span>\n\n          <h3 id="role-group-${escapeHtml(e.key)}">\n            ${escapeHtml(e.title)}\n          </h3>\n\n          <p>${escapeHtml(e.description)}</p>\n        </div>\n\n        <span class="role-count">\n          ${t.length} ${n}\n        </span>\n      </div>\n\n      <ul class="role-list">\n        ${t.map(e=>`\n            <li class="role-list-item">\n              <span class="role-list-marker" aria-hidden="true"></span>\n              <span class="role-name">\n                ${escapeHtml(e.title)}\n              </span>\n            </li>\n          `).join("")}\n      </ul>\n    </section>\n  `}function normaliseRoleTitle(e){return String(e||"").toLowerCase().replace(/[’‘]/g,"'").replace(/&/g," and ").replace(/[^a-z0-9']+/g," ").replace(/\s+/g," ").trim()}async function loadLocations(firm){
  const container=
    document.getElementById("locationsList");

  if(!container)return;

  const rows=
    await getSharedLocationRows(firm);

  if(!rows.length){
    container.innerHTML=
      emptyMessage(
        "No office locations have been listed yet."
      );
    return
  }

  const grouped=
    groupLocationsByCountry(rows);

  container.innerHTML=`
    <div class="location-country-list">
      ${grouped
        .map(group=>renderLocationCountryGroup(group))
        .join("")}
    </div>
  `
}

function groupLocationsByCountry(e){const t=new Map;return e.forEach(e=>{const n=locationCountry(e)||"Country not stated";t.has(n)||t.set(n,[]),t.get(n).push(e)}),[...t.entries()].map(([e,t])=>({country:e,offices:t.sort((e,t)=>locationCity(e).localeCompare(locationCity(t)))})).sort((e,t)=>{const n=isUnitedKingdom(e.country);return n!==isUnitedKingdom(t.country)?n?-1:1:e.country.localeCompare(t.country)})}function renderLocationCountryGroup(e){const t=uniqueSorted(e.offices.map(locationCity).filter(Boolean)),n=e.offices.length,a=1===n?"office":"offices";return`\n    <details class="location-country-group">\n      <summary class="location-country-summary">\n        <div class="location-country-heading">\n          <span class="location-country-label">\n            Country\n          </span>\n\n          <h3>${escapeHtml(e.country)}</h3>\n        </div>\n\n        <div class="location-country-overview">\n          <strong>\n            ${escapeHtml(t.join(", ")||"Office details")}\n          </strong>\n\n          <span>\n            ${n} ${a}\n          </span>\n        </div>\n\n        <span class="location-country-action" aria-hidden="true">\n          View offices\n        </span>\n      </summary>\n\n      <div class="location-country-expanded">\n        ${e.offices.map(e=>renderLocationOffice(e)).join("")}\n      </div>\n    </details>\n  `}function renderLocationOffice(e){const t=locationCity(e)||"Office",n=locationCountry(e),a=readField(e,["region","state","province"]),i=readField(e,["office_type","location_type","type"]),r=locationAddress(e),s=locationPhone(e),o=locationOfficeUrl(e),l=locationCareersUrl(e),c=locationStudentRecruitment(e),d=[isTrue(e.offers_vacation_scheme)?'<span class="status-pill">Vacation scheme</span>':"",isTrue(e.offers_training_contract)?'<span class="status-pill">Training contract</span>':"",isTrue(readField(e,["offers_apprenticeship","offers_solicitor_apprenticeship"]))?'<span class="status-pill">Apprenticeship</span>':""].filter(Boolean).join("");return`\n    <article class="location-office-card">\n      <div class="location-office-copy">\n        <span class="location-office-label">\n          ${escapeHtml(i?readableLabel(i):"Office")}\n        </span>\n\n        <h4>${escapeHtml(t)}</h4>\n\n        ${a?`\n          <p class="location-office-region">\n            ${escapeHtml(a)}\n            ${n?`, ${escapeHtml(n)}`:""}\n          </p>\n        `:""}\n\n        ${r?`\n          <p class="location-office-address">\n            ${escapeHtml(r)}\n          </p>\n        `:""}\n\n        ${s?`\n          <p class="location-office-phone">\n            <strong>Telephone:</strong>\n            ${escapeHtml(s)}\n          </p>\n        `:""}\n\n        ${c?`\n          <p class="location-office-recruitment">\n            <strong>Student recruitment:</strong>\n            ${escapeHtml(c)}\n          </p>\n        `:""}\n\n        ${d?`\n          <div class="location-tags">\n            ${d}\n          </div>\n        `:""}\n      </div>\n\n      ${o||l?`\n        <div class="location-office-links">\n          ${o?profileLink(o,"Office page",`Office page — ${t}${n?`, ${n}`:""}`):""}\n\n          ${l?profileLink(l,"Student careers",`Student careers — ${t}${n?`, ${n}`:""}`):""}\n        </div>\n      `:""}\n    </article>\n  `}function locationCity(e){return String(readField(e,["city","location_name","office_name","name"])||"").trim()}function locationCountry(e){
  const raw=String(
    readField(
      e,
      [
        "country",
        "country_name",
        "jurisdiction"
      ]
    )||""
  ).trim();

  return vacatoryCanonicalCountry(raw)||raw
}function locationAddress(e){const t=readField(e,["full_address","address","office_address","address_text"]);return t?formatDisplayValue(t):[readField(e,["address_line_1","address1"]),readField(e,["address_line_2","address2"]),readField(e,["address_line_3","address3"]),readField(e,["city"]),readField(e,["postcode","postal_code","zip_code"])].filter(Boolean).map(e=>String(e).trim()).join(", ")}function locationPhone(e){return String(readField(e,["telephone","phone","phone_number","office_phone"])||"").trim()}function locationOfficeUrl(e){return String(readField(e,["office_url","location_url","official_url","website","website_url","source_url"])||"").trim()}function locationCareersUrl(e){return String(readField(e,["careers_url","student_careers_url","early_careers_url","recruitment_url","application_url"])||"").trim()}function locationStudentRecruitment(e){const t=readField(e,["student_recruitment","student_recruitment_status","student_opportunities","recruitment_notes"]);if(t)return formatDisplayValue(t);const n=[];return isTrue(e.offers_vacation_scheme)&&n.push("vacation scheme"),isTrue(e.offers_training_contract)&&n.push("training contract"),isTrue(readField(e,["offers_apprenticeship","offers_solicitor_apprenticeship"]))&&n.push("apprenticeship"),n.length?`Published ${n.join(", ")} recruitment`:!1===e.student_recruitment||!1===e.offers_student_recruitment?"No office-specific student route identified":"Check the office or regional careers page"}function isUnitedKingdom(e){const t=normaliseText(e);return["united kingdom","uk","u k","great britain","england","scotland","wales","northern ireland"].includes(t)}function deduplicateLocations(e){const t=new Map;return e.filter(e=>!1!==e.active).forEach(e=>{const n=normaliseText(`${locationCity(e)}|${locationCountry(e)}`);if(!n||"|"===n)return;if(!t.has(n))return void t.set(n,e);const a=t.get(n),i={...a};Object.entries(e).forEach(([e,t])=>{null!==i[e]&&void 0!==i[e]&&""!==i[e]||null==t||""===t||(i[e]=t)}),i.offers_vacation_scheme=isTrue(a.offers_vacation_scheme)||isTrue(e.offers_vacation_scheme),i.offers_training_contract=isTrue(a.offers_training_contract)||isTrue(e.offers_training_contract),i.offers_apprenticeship=isTrue(a.offers_apprenticeship)||isTrue(e.offers_apprenticeship)||isTrue(a.offers_solicitor_apprenticeship)||isTrue(e.offers_solicitor_apprenticeship),t.set(n,i)}),[...t.values()]}async function loadLinksAndSocials(e){const t=document.getElementById("linksSocialsLoading")||document.getElementById("sourcesLoading"),n=document.getElementById("linksSocialsEmpty")||document.getElementById("sourcesEmpty"),a=document.getElementById("linksSocialsList")||document.getElementById("sourcesList");if(!a)return;const i=await readOptionalRows("firm_official_sources","firm_id",firmId),r=deduplicateFirmLinks([...buildFirmLinkRows(e),...i.filter(isPublicFirmLink).map(normaliseOfficialLinkRow)]).sort(sortFirmLinks);if(t?.classList.add("hidden"),!r.length)return n?.classList.remove("hidden"),void(a.innerHTML="");n?.classList.add("hidden");const s=groupFirmLinks(r);a.innerHTML=`\n    <div class="firm-link-groups">\n      ${s.map(e=>renderFirmLinkGroup(e)).join("")}\n    </div>\n  `}function buildFirmLinkRows(e){return[{fields:["website","website_url","official_website","official_url"],title:"Official firm website",category:"Official websites",platform:"Website",description:"The firm’s main official website."},{fields:["uk_website_url","uk_website"],title:"United Kingdom website",category:"Official websites",platform:"Website",description:"The firm’s official United Kingdom website."},{fields:["careers_url","careers_website"],title:"Careers",category:"Careers and applications",platform:"Careers",description:"The firm’s main careers website."},{fields:["early_careers_url","graduate_careers_url","student_careers_url"],title:"Early careers",category:"Careers and applications",platform:"Early careers",description:"Official student and graduate recruitment information."},{fields:["application_portal_url","applications_url","apply_url"],title:"Application portal",category:"Careers and applications",platform:"Applications",description:"The official portal used to submit applications."},{fields:["office_directory_url","locations_url","global_coverage_url"],title:"Offices and locations",category:"Official websites",platform:"Locations",description:"The firm’s official office or global coverage directory."},{fields:["linkedin_url","linkedin"],title:"LinkedIn",category:"Social media",platform:"LinkedIn",description:"Official LinkedIn page."},{fields:["instagram_url","instagram"],title:"Instagram",category:"Social media",platform:"Instagram",description:"Official Instagram account."},{fields:["youtube_url","youtube"],title:"YouTube",category:"Social media",platform:"YouTube",description:"Official YouTube channel."},{fields:["tiktok_url","tiktok"],title:"TikTok",category:"Social media",platform:"TikTok",description:"Official TikTok account."},{fields:["facebook_url","facebook"],title:"Facebook",category:"Social media",platform:"Facebook",description:"Official Facebook page."},{fields:["x_url","twitter_url","x","twitter"],title:"X",category:"Social media",platform:"X",description:"Official X account."}].map(t=>{const n=readField(e,t.fields);return n?{title:t.title,url:n,category:t.category,platform:t.platform,description:t.description,verified:!0}:null}).filter(Boolean)}function isPublicFirmLink(e){if(!1===e.active||!1===e.published||!1===e.is_public)return!1;const t=sourceUrl(e);if(!t)return!1;const n=normaliseText([sourceTitle(e),readField(e,["source_type","category","source_category","page_type","platform"]),t].join(" "));return["website","home page","homepage","careers","career","early careers","graduate","student","application portal","apply","office","location","global coverage","linkedin","instagram","youtube","tiktok","facebook","twitter","x.com"].some(e=>n.includes(normaliseText(e)))}function normaliseOfficialLinkRow(e){const t=sourceTitle(e),n=sourceUrl(e),a=readField(e,["source_type","category","source_category","page_type","platform"]),i=identifyLinkPlatform(`${t} ${a} ${n}`);return{title:t,url:n,category:linkCategoryForPlatform(i,a),platform:i,description:readField(e,["public_description","description","summary","notes"]),verified:!1!==e.verified_official&&!1!==e.is_official,checkedOn:readField(e,["research_checked_on","last_checked_on","checked_on","accessed_on"])}}function identifyLinkPlatform(e){const t=normaliseText(e);return t.includes("linkedin.com")||t.includes("linkedin")?"LinkedIn":t.includes("instagram.com")||t.includes("instagram")?"Instagram":t.includes("youtube.com")||t.includes("youtu.be")||t.includes("youtube")?"YouTube":t.includes("tiktok.com")||t.includes("tiktok")?"TikTok":t.includes("facebook.com")||t.includes("facebook")?"Facebook":t.includes("twitter.com")||t.includes("x.com")||t.includes("twitter")?"X":t.includes("application")||t.includes("apply")?"Applications":t.includes("early career")||t.includes("graduate")||t.includes("student")?"Early careers":t.includes("career")?"Careers":t.includes("office")||t.includes("location")||t.includes("global coverage")?"Locations":"Website"}function linkCategoryForPlatform(e,t){if(["LinkedIn","Instagram","YouTube","TikTok","Facebook","X"].includes(e))return"Social media";if(["Careers","Early careers","Applications"].includes(e))return"Careers and applications";const n=normaliseText(t);return n.includes("regional")||n.includes("jurisdiction")?"Regional and student links":"Official websites"}function deduplicateFirmLinks(e){const t=new Map;return e.forEach(e=>{if(!e||!e.url)return;const n=normaliseExternalUrl(e.url);if(!n)return;const a=normaliseText(n.replace(/\/$/,""));if(!t.has(a))return void t.set(a,{...e,url:n});const i=t.get(a);t.set(a,{...e,...i,title:i.title||e.title,category:i.category||e.category,platform:i.platform||e.platform,description:i.description||e.description,checkedOn:i.checkedOn||e.checkedOn,verified:!1!==i.verified&&!1!==e.verified})}),[...t.values()]}function groupFirmLinks(e){const t=["Official websites","Careers and applications","Regional and student links","Social media"],n=new Map;return e.forEach(e=>{const t=e.category||"Official websites";n.has(t)||n.set(t,[]),n.get(t).push(e)}),[...n.entries()].map(([e,t])=>({title:e,items:t})).sort((e,n)=>{const a=t.indexOf(e.title),i=t.indexOf(n.title),r=-1===a?t.length:a,s=-1===i?t.length:i;return r!==s?r-s:e.title.localeCompare(n.title)})}function renderFirmLinkGroup(e){return`\n    <section class="firm-link-group">\n      <div class="firm-link-group-heading">\n        <h3>${escapeHtml(e.title)}</h3>\n\n        <span>\n          ${e.items.length}\n          ${1===e.items.length?"link":"links"}\n        </span>\n      </div>\n\n      <div class="firm-link-list">\n        ${e.items.map(e=>renderFirmLinkCard(e)).join("")}\n      </div>\n    </section>\n  `}function renderFirmLinkCard(e){return`\n    <article class="firm-platform-card">\n      <div class="firm-platform-copy">\n        <div class="firm-platform-heading">\n          <span class="firm-platform-label">\n            ${escapeHtml(e.platform||"Official link")}\n          </span>\n\n          ${!1!==e.verified?'\n            <span class="verified-link-badge">\n              Verified official\n            </span>\n          ':""}\n        </div>\n\n        <h4>${escapeHtml(e.title||e.platform||"Official link")}</h4>\n\n        ${e.description?`\n          <p>\n            ${escapeHtml(shortenText(formatDisplayValue(e.description),180))}\n          </p>\n        `:""}\n\n        ${e.checkedOn?`\n          <span class="source-checked-date">\n            Last checked:\n            ${escapeHtml(formatDate(e.checkedOn))}\n          </span>\n        `:""}\n      </div>\n\n      ${profileLink(e.url,`Open ${e.platform||"official link"}`,`Open ${e.platform||"official link"} — ${e.title||e.platform||"Official link"}${e.description?` — ${shortenText(formatDisplayValue(e.description),90)}`:""}`)}\n    </article>\n  `}function sortFirmLinks(e,t){const n=["Website","Locations","Careers","Early careers","Applications","LinkedIn","Instagram","YouTube","TikTok","Facebook","X"],a=n.indexOf(e.platform),i=n.indexOf(t.platform),r=-1===a?n.length:a,s=-1===i?n.length:i;return r!==s?r-s:String(e.title||"").localeCompare(String(t.title||""))}function sourceTitle(e){return String(readField(e,["source_title","page_title","title","name"])||"Official link")}function sourceUrl(e){return String(readField(e,["source_url","page_url","official_url","url","link"])||"")}function renderResearchItem(e){const t=researchSectionContent(e),n=researchSectionTitle(e);if(!n||!t||containsInternalResearchCommentary(n,t))return"";const a=[];return addResearchSection(a,"Details",t),renderResearchAccordion({title:n,label:readableLabel(readField(e,["section_key","research_key","category","section_type"])||"Firm research"),summary:firstMeaningfulText([e.summary,firstSentence(t)]),facts:[],sections:a,sourceUrl:readField(e,["source_url","official_url","page_url"]),checkedOn:readField(e,["research_checked_on","last_checked_on"])})}function containsInternalResearchCommentary(...e){const t=normaliseText(e.filter(Boolean).join(" "));return["stored in detailed tables","stored in structured tables","stored in the database","structured records are stored","complete structured records","database table","database tables","internal record","internal records"].some(e=>t.includes(normaliseText(e)))}function renderResearchAccordion({title:e,label:t,summary:n,facts:a=[],sections:i=[],sourceUrl:r,checkedOn:s}){const o=a.filter(Boolean),l=i.filter(Boolean);return e&&(n||o.length||l.length)?`\n    <details class="research-item">\n      <summary class="research-item-summary">\n        <div class="research-item-copy">\n          ${t?`\n            <span class="research-item-label">\n              ${escapeHtml(t)}\n            </span>\n          `:""}\n\n          <h3>${escapeHtml(e)}</h3>\n\n          ${n?`\n            <p>${escapeHtml(shortenText(n,260))}</p>\n          `:""}\n        </div>\n\n        <span class="research-item-action">\n          View details\n        </span>\n      </summary>\n\n      <div class="research-item-expanded">\n        ${o.length?`\n          <div class="research-facts">\n            ${o.join("")}\n          </div>\n        `:""}\n\n        ${l.length?`\n          <div class="research-detail-sections">\n            ${l.join("")}\n          </div>\n        `:""}\n\n        ${r||s?`\n          <div class="research-source-row">\n            ${s?`\n              <span class="evidence-date">\n                Last checked:\n                <strong>${escapeHtml(formatDate(s))}</strong>\n              </span>\n            `:""}\n\n            ${r?profileLink(r,"View official source",`Official source — ${e}`):""}\n          </div>\n        `:""}\n      </div>\n    </details>\n  `:""}function addResearchSection(e,t,n){const a=splitIntoBulletPoints(n);a.length&&e.push(`\n    <section class="research-detail-section">\n      <h4>${escapeHtml(t)}</h4>\n\n      <ul class="research-bullet-list">\n        ${a.map(e=>`<li>${escapeHtml(e)}</li>`).join("")}\n      </ul>\n    </section>\n  `)}function researchFact(e,t){const n=formatDisplayValue(t);return n?`\n    <div class="research-fact">\n      <span>${escapeHtml(e)}</span>\n      <strong>${escapeHtml(n)}</strong>\n    </div>\n  `:""}function researchSectionTitle(e){const t=readField(e,["section_title","title","name","heading"]);if(t)return String(t);const n=readField(e,["section_key","research_key","category","section_type"]);return n?readableLabel(n):"Firm research"}function researchSectionContent(e){return firstMeaningfulText([readField(e,["content","full_text","details","findings"]),e.summary,e.description,e.notes])}function sectionMatches(e,t){const n=normaliseText([readField(e,["section_key","research_key","category","section_type"]),readField(e,["section_title","title","name","heading"])].filter(Boolean).join(" "));return t.some(e=>n.includes(normaliseText(e)))}function deduplicateRenderedItems(e){return[...new Set(e.filter(Boolean))]}async function readOptionalRows(e,t,n){try{const{data:a,error:i}=await client.from(e).select("*").eq(t,n);return i?(console.warn(`Unable to read ${e}:`,i.message),[]):a||[]}catch(t){return console.warn(`Unable to read ${e}:`,t),[]}}function readField(e,t){if(!e||"object"!=typeof e)return"";for(const n of t){const t=e[n];if(null!=t&&""!==t)return t}return""}function cleanPublicOpportunityName(e){
  let t=String(e||"Opportunity")
    .replace(/[—–]/g," - ")
    .replace(/\s+/g," ")
    .trim();

  t=t
    .replace(
      /\s+-\s+(?:current\s*\/\s*next\s*cycle|current cycle|next cycle)\s*$/i,
      ""
    )
    .trim();

  const parts=t.split(/\s+-\s+/);

  if(
    parts.length>=3 &&
    parts[parts.length-1].toLowerCase()===
      parts[parts.length-2].toLowerCase()
  ){
    parts.pop();
  }

  return parts.join(" - ");
}function programmeName(e){return cleanPublicOpportunityName(readField(e,["programme_name","opportunity_name","scheme_name","name","title"])||"Opportunity")}function programmeType(e){return readableLabel(readField(e,["programme_type","opportunity_type","scheme_type","category","route_type"])||"")}function programmeLocation(e){return String(readField(e,["location","location_text","office","locations"])||"")}function firstMeaningfulText(e){for(const t of e.flat(1/0)){const e=formatDisplayValue(t).trim();if(e)return e}return""}function firstSentence(e){const t=formatDisplayValue(e).trim();if(!t)return"";const n=t.match(/^.*?[.!?](?:\s|$)/);return n?n[0].trim():t}function shortenText(e,t){const n=formatDisplayValue(e).replace(/\s+/g," ").trim();return n.length<=t?n:`${n.slice(0,t-1).trimEnd()}…`}function splitIntoBulletPoints(e){if(null==e||""===e)return[];if(Array.isArray(e))return uniqueCleanPoints(e.flatMap(splitIntoBulletPoints));if("object"==typeof e)return uniqueCleanPoints(Object.entries(e).flatMap(([e,t])=>null==t||""===t?[]:"object"==typeof t?splitIntoBulletPoints(t).map(t=>`${readableLabel(e)}: ${t}`):[`${readableLabel(e)}: ${formatDisplayValue(t)}`]));let t=String(e).replace(/\r/g,"\n").replace(/[•●▪◦]/g,"\n").replace(/\s+-\s+/g,"\n").replace(/;\s+/g,"\n").replace(/\n{2,}/g,"\n").trim().split("\n").map(cleanBulletPoint).filter(Boolean);return 1===t.length&&t[0].length>240&&(t=t[0].split(/(?<=[.!?])\s+(?=[A-Z0-9])/).map(cleanBulletPoint).filter(Boolean)),uniqueCleanPoints(t)}function cleanBulletPoint(e){return String(e||"").replace(/^[\s\-–—:;,.]+/,"").replace(/\s+/g," ").trim()}function uniqueCleanPoints(e){return[...new Set(e.map(cleanBulletPoint).filter(e=>e&&!isInternalImplementationPoint(e)))]}function isInternalImplementationPoint(e){const t=String(e||"");return/\b(?:firm|organisation|training_contract|vacation_scheme|practice_area|staff_role|career_role|opportunity)_[a-z0-9_]+\b/i.test(t)||/\bsupabase\b/i.test(t)||/\binternal database\b/i.test(t)||/\bdatabase table\b/i.test(t)}function fact(e,t){const n=formatDisplayValue(t);return n?`\n    <div class="fact">\n      <span class="fact-label">\n        ${escapeHtml(e)}\n      </span>\n\n      <span class="fact-value">\n        ${escapeHtml(n)}\n      </span>\n    </div>\n  `:""}function firmOfficialWebsite(e){return firstMeaningfulText([readField(e,["website","website_url","official_website","official_url"]),e.official_domain])}function normaliseExternalUrl(e){const t=String(e||"").trim();return t?/^(mailto:|tel:)/i.test(t)||/^https?:\/\//i.test(t)?t:/^\/\//.test(t)?`https:${t}`:/^https?:\/(?!\/)/i.test(t)?t.replace(/^(https?):\//i,"$1://"):`https://${t.replace(/^\/+/,"")}`:""}function metaLink(e,t,n){const a=normaliseExternalUrl(n),i=`${t} (opens in new tab)`;return a?`\n    <a\n      href="${escapeHtml(a)}"\n      aria-label="${escapeHtml(i)}"\n      target="_blank"\n      rel="noopener noreferrer"\n      class="profile-meta-pill profile-meta-link"\n    >\n      ${e}\n      ${escapeHtml(t)}\n    </a>\n  `:metaPill(e,t)}function profileLink(e,t,a=t){const n=normaliseExternalUrl(e),i=/opens in new tab/i.test(String(a))?String(a):`${a} (opens in new tab)`;return n?`\n    <a\n      href="${escapeHtml(n)}"\n      aria-label="${escapeHtml(i)}"\n      target="_blank"\n      rel="noopener noreferrer"\n      class="firm-link profile-external-link"\n    >\n      ${escapeHtml(t)}\n\n      <svg\n        viewBox="0 0 24 24"\n        fill="none"\n        stroke="currentColor"\n        stroke-width="2"\n        aria-hidden="true"\n      >\n        <path\n          d="M7 17L17 7"\n        ></path>\n\n        <path\n          d="M7 7h10v10"\n        ></path>\n      </svg>\n    </a>\n  `:""}function emptyMessage(e){return`\n    <p class="loading">\n      ${escapeHtml(e)}\n    </p>\n  `}function metaPill(e,t){return`\n    <span class="profile-meta-pill">\n      ${e}\n      ${escapeHtml(t)}\n    </span>\n  `}function formatDate(e){if(!e)return"";const t=String(e),n=t.match(/^(\d{4})-(\d{2})-(\d{2})$/);let a;return a=n?new Date(Number(n[1]),Number(n[2])-1,Number(n[3])):new Date(e),Number.isNaN(a.getTime())?t:a.toLocaleDateString("en-GB",{day:"numeric",month:"short",year:"numeric"})}function formatDisplayValue(e){return null==e||""===e?"":Array.isArray(e)?e.map(formatDisplayValue).filter(Boolean).join(", "):"object"==typeof e?formatStructuredValue(e):!0===e?"Yes":!1===e?"No":String(e)}function formatStructuredValue(e){return Object.entries(e).filter(([,e])=>null!=e&&""!==e).map(([e,t])=>{const n=readableLabel(e),a=formatDisplayValue(t);return a?`${n}: ${a}`:""}).filter(Boolean).join("; ")}function readableLabel(e){const t=String(e||"").replace(/[_-]+/g," ").replace(/\s+/g," ").trim();if(!t)return"";const n={edi:"EDI",lgbt:"LGBT+",sqe:"SQE",nq:"NQ",gcses:"GCSEs",llm:"LL.M.",llb:"LLB",gdl:"GDL",pgdl:"PGDL",lpc:"LPC"};return t.split(" ").map((e,t)=>{const a=e.toLowerCase();return n[a]?n[a]:0===t?a.charAt(0).toUpperCase()+a.slice(1):a}).join(" ")}function formatMoney(e){if(null==e||""===e)return"";if("string"==typeof e&&/[£$€]/.test(e))return e;const t=Number(e);return Number.isNaN(t)?String(e):`£${t.toLocaleString("en-GB")}`}function latestResearchDate(e){return e.filter(e=>e&&isValidDate(e)).sort((e,t)=>dateValue(t)-dateValue(e))[0]||""}function dateValue(e){if(!e)return Number.POSITIVE_INFINITY;const t=new Date(e).getTime();return Number.isNaN(t)?Number.POSITIVE_INFINITY:t}function isValidDate(e){return!Number.isNaN(new Date(e).getTime())}function startOfToday(){const e=new Date;return e.setHours(0,0,0,0),e.getTime()}function startOfDate(e){const t=String(e||"").match(/^(\d{4})-(\d{2})-(\d{2})$/),n=t?new Date(Number(t[1]),Number(t[2])-1,Number(t[3])):new Date(e);return n.setHours(0,0,0,0),n.getTime()}function isTrue(e){return!0===e||"true"===e||1===e||"1"===e}function uniqueSorted(e){return[...new Set(e.filter(Boolean).map(e=>String(e).trim()).filter(Boolean))].sort((e,t)=>e.localeCompare(t))}function normaliseText(e){return String(e||"").trim().toLowerCase()}function escapeHtml(e){return String(e??"").replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll('"',"&quot;").replaceAll("'","&#039;")}function locationIcon(){return'\n    <svg\n      viewBox="0 0 24 24"\n      fill="none"\n      stroke="currentColor"\n      stroke-width="2"\n      aria-hidden="true"\n    >\n      <path d="M12 21s7-6.2 7-11a7 7 0 1 0-14 0c0 4.8 7 11 7 11z"></path>\n      <circle cx="12" cy="10" r="2.4"></circle>\n    </svg>\n  '}function rankIcon(){return'\n    <svg\n      viewBox="0 0 24 24"\n      fill="none"\n      stroke="currentColor"\n      stroke-width="2"\n      aria-hidden="true"\n    >\n      <path d="M12 2l2.9 6.6 7.1.6-5.4 4.7 1.7 7-6.3-3.8-6.3 3.8 1.7-7-5.4-4.7 7.1-.6z"></path>\n    </svg>\n  '}function linkIcon(){return'\n    <svg\n      viewBox="0 0 24 24"\n      fill="none"\n      stroke="currentColor"\n      stroke-width="2"\n      aria-hidden="true"\n    >\n      <path d="M10 13a5 5 0 0 0 7.1 0l2.1-2.1a5 5 0 0 0-7.1-7.1L11 4.9"></path>\n      <path d="M14 11a5 5 0 0 0-7.1 0L4.8 13.1a5 5 0 0 0 7.1 7.1L13 19.1"></path>\n    </svg>\n  '}document.addEventListener("DOMContentLoaded",()=>{setupTabs(),firmId?loadFirmProfile():showError()});

function enhanceFirmProfileTabsAccessibility(){
  const tablist=document.querySelector("#profileTabs .profile-tabs-inner");
  if(!tablist)return;

  const tabs=Array.from(tablist.querySelectorAll(".tab-btn"));

  function syncTabs(){
    tabs.forEach(tab=>{
      const key=tab.dataset.tab;
      const panel=document.getElementById(`tab-${key}`);
      const selected=tab.classList.contains("active");

      tab.setAttribute("role","tab");
      tab.setAttribute("aria-selected",String(selected));
      tab.setAttribute("tabindex",selected?"0":"-1");

      if(panel){
        panel.setAttribute("role","tabpanel");
        panel.setAttribute("aria-labelledby",tab.id);
        panel.hidden=!selected;
      }
    });
  }

  tablist.addEventListener("click",event=>{
    if(event.target.closest(".tab-btn")){
      syncTabs();
    }
  });

  tablist.addEventListener("keydown",event=>{
    const current=event.target.closest(".tab-btn");
    if(!current)return;

    const currentIndex=tabs.indexOf(current);
    let nextIndex=currentIndex;

    if(event.key==="ArrowRight"){
      nextIndex=(currentIndex+1)%tabs.length;
    }else if(event.key==="ArrowLeft"){
      nextIndex=(currentIndex-1+tabs.length)%tabs.length;
    }else if(event.key==="Home"){
      nextIndex=0;
    }else if(event.key==="End"){
      nextIndex=tabs.length-1;
    }else{
      return;
    }

    event.preventDefault();
    tabs[nextIndex].focus();
    tabs[nextIndex].click();
  });

  syncTabs();
}

document.addEventListener(
  "DOMContentLoaded",
  enhanceFirmProfileTabsAccessibility
);


/* VACATORY_FIRM_PROFILE_STUDENT_UX_20260813 */

const vacatoryTabFreshnessByTable=new Map;
let vacatoryFreshnessRenderQueued=false;

function vacatoryFreshnessDateValue(e){
  return e&&(
    e.research_checked_on||
    e.last_verified_on||
    e.lastVerifiedOn||
    e.source_checked_on||
    e.checked_on||
    e.updated_at
  )||null;
}

function vacatoryRecordFreshness(e,t){
  if(!e||!Array.isArray(t))return;

  let n=vacatoryTabFreshnessByTable.get(e)||null;

  t.forEach(e=>{
    const t=vacatoryFreshnessDateValue(e);

    if(!t)return;

    const a=new Date(t);

    if(Number.isNaN(a.getTime()))return;

    if(!n||a.getTime()>n.getTime())n=a
  });

  n&&vacatoryTabFreshnessByTable.set(e,n);
  vacatoryQueueFreshnessRender()
}

function vacatoryQueueFreshnessRender(){
  if(vacatoryFreshnessRenderQueued)return;

  vacatoryFreshnessRenderQueued=true;

  queueMicrotask(()=>{
    vacatoryFreshnessRenderQueued=false;
    vacatoryRenderAllTabFreshness()
  })
}

function vacatoryLatestFreshness(e){
  const t=e
    .map(e=>vacatoryTabFreshnessByTable.get(e))
    .filter(Boolean);

  if(!t.length)return null;

  return new Date(
    Math.max(...t.map(e=>e.getTime()))
  )
}

function vacatoryFormatFreshnessDate(e){
  if(!e)return"Not recorded";

  return e.toLocaleDateString(
    "en-GB",
    {
      day:"numeric",
      month:"long",
      year:"numeric"
    }
  )
}

function vacatorySetTabFreshness(e,t){
  const n=document.getElementById(e);

  if(!n)return;

  let a=n.querySelector(":scope > .tab-last-checked");

  if(!a){
    a=document.createElement("p");
    a.className="tab-last-checked";
    a.setAttribute("role","status");

    const e=n.querySelector(
      ".tab-heading, .opportunities-heading-row"
    );

    e?e.insertAdjacentElement("afterend",a):n.prepend(a)
  }

  a.innerHTML=`Last checked: <strong>${escapeHtml(
    vacatoryFormatFreshnessDate(t)
  )}</strong>`
}

function vacatoryRenderAllTabFreshness(){
  [
    [
      "tab-opportunities",
      [
        "career_opportunities_public_view",
        "firm_research_sections"
      ]
    ],
    [
      "tab-pay-funding-visas",
      [
        "career_opportunities_public_view",
        "firm_research_sections"
      ]
    ],
    ["tab-practice-areas",["practice_areas"]],
    [
      "tab-locations",
      ["locations","organisation_locations"]
    ],
    [
      "tab-roles",
      ["firm_roles_public_view","firm_roles"]
    ],
    [
      "tab-inclusion-disability",
      [
        "firm_disability_support",
        "firm_inclusion_initiatives",
        "firm_research_sections"
      ]
    ],
    [
      "tab-pro-bono",
      ["firm_pro_bono","firm_research_sections"]
    ],
    [
      "tab-firm-highlights",
      [
        "firm_awards",
        "firm_sectors",
        "firm_matters",
        "firm_research_sections"
      ]
    ],
    [
      "tab-links-socials",
      ["firm_official_sources","firms"]
    ]
  ].forEach(([tab,tables])=>{
    vacatorySetTabFreshness(
      tab,
      vacatoryLatestFreshness(tables)
    );
  });
}

function vacatoryAddTabGuidance(e,t){
  const n=document.getElementById(e);

  if(!n||n.querySelector(":scope > .tab-guidance-note"))return;

  const a=document.createElement("p");

  a.className="tab-guidance-note";
  a.setAttribute("role","note");
  a.textContent=t;

  const i=n.querySelector(
    ".tab-heading, .opportunities-heading-row"
  );

  i?i.insertAdjacentElement("afterend",a):n.prepend(a)
}

function vacatoryApplyStudentGuidance(){
  vacatoryAddTabGuidance(
    "tab-pay-funding-visas",
    "If a salary, funding or visa detail is not shown, it means the firm has not yet published or confirmed it in the official sources Vacatory has checked."
  );

  vacatoryAddTabGuidance(
    "tab-practice-areas",
    "Why this matters for applications: use the firm’s actual practice areas to show informed motivation and connect your interests to its work."
  );

  vacatoryAddTabGuidance(
    "tab-locations",
    "Why this matters for applications: office location can affect which programmes you can apply for, where you may train and the work available to you."
  );

  vacatoryAddTabGuidance(
    "tab-roles",
    "Why this matters for applications: use this section to understand the firm’s career structure and distinguish student entry routes from later-career roles."
  )
}

function vacatoryActivateLinkedTab(e){
  const t=document.querySelector(
    `.tab-btn[data-tab="${e}"]`
  );

  if(!t)return;

  t.click();

  const n=document.getElementById(`tab-${e}`);

  n&&n.scrollIntoView({
    behavior:"smooth",
    block:"start"
  })
}

document.addEventListener("click",e=>{
  const t=e.target.closest("[data-profile-tab-target]");

  if(!t)return;

  const n=t.getAttribute("data-profile-tab-target");

  if(!n)return;

  e.preventDefault();
  vacatoryActivateLinkedTab(n)
});

const vacatoryOriginalReadOptionalRows=readOptionalRows;

readOptionalRows=async function(e,...t){
  const n=await vacatoryOriginalReadOptionalRows(e,...t);

  vacatoryRecordFreshness(
    e,
    Array.isArray(n)?n:[]
  );

  return n
};



const vacatoryOriginalRenderFirmHeader=renderFirmHeader;

renderFirmHeader=function(e){
  vacatoryRecordFreshness(
    "firms",
    e?[e]:[]
  );

  return vacatoryOriginalRenderFirmHeader(e)
};

document.addEventListener("DOMContentLoaded",()=>{
  vacatoryApplyStudentGuidance();
  vacatoryRenderAllTabFreshness()
});



/* VACATORY_COUNTRY_TYPE_FILTERS_20260813 */

let vacatoryOpportunityRows=[];let vacatoryOpportunityFilterOfficeRows=[];

function publicOpportunityCountryLabel(e){
  const t=String(e||"")
    .replace(/\s+/g," ")
    .trim();

  if(!t)return"";

  const n={
    "uk":"United Kingdom",
    "u.k.":"United Kingdom",
    "united_kingdom":"United Kingdom",
    "united states":"United States",
    "united_states":"United States",
    "uae":"United Arab Emirates",
    "united_arab_emirates":"United Arab Emirates",
    "hong_kong":"Hong Kong",
    "new_zealand":"New Zealand",
    "south_africa":"South Africa",
    "republic_of_ireland":"Ireland"
  };

  const a=t.toLowerCase();

  if(n[a])return n[a];

  if(t.includes("_")){
    return t
      .split("_")
      .filter(Boolean)
      .map((e,t)=>{
        const n=e.toLowerCase();

        if(t>0&&["and","of","the"].includes(n))return n;

        return n.charAt(0).toUpperCase()+n.slice(1)
      })
      .join(" ")
  }

  return t
}




const vacatoryCountryCodes=(
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

function vacatoryCountryKey(value){
  return String(value||"")
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g,"")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g," ")
    .replace(/\s+/g," ")
    .trim()
}

const vacatoryCountryLookup=(()=>{
  const map=new Map();

  if(
    typeof Intl!=="undefined" &&
    Intl.DisplayNames
  ){
    const names=new Intl.DisplayNames(
      ["en-GB"],
      {type:"region"}
    );

    vacatoryCountryCodes.forEach(code=>{
      const name=names.of(code);

      if(name){
        map.set(
          vacatoryCountryKey(name),
          name
        )
      }
    })
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

  return map
})();

function vacatoryCanonicalCountry(value){
  return vacatoryCountryLookup.get(
    vacatoryCountryKey(value)
  )||""
}

function vacatoryOpportunityCountry(row){const x=Array.isArray(row?.countries)?row.countries:[];return String(x[0]||row?.country||"").trim()}


function vacatoryOpportunityCityLabel(row){return (Array.isArray(row?.cities)?row.cities:[]).filter(Boolean).join(", ")}

function vacatoryFilterCityOnly(value){
  const parts=String(value||"")
    .replace(/\s+/g," ")
    .trim()
    .split(",")
    .map(part=>part.trim())
    .filter(Boolean);

  if(!parts.length)return"";

  if(
    parts.length>1 &&
    /^d\.?\s*c\.?$/i.test(parts[1])
  ){
    return `${parts[0]} DC`
  }

  return parts[0]
}

function vacatoryBuildFilterOfficeRows(rows){
  const seen=new Set();
  const result=[];

  (rows||[]).forEach(row=>{
    const country=locationCountry(row);

    /*
     * Only the structured city field is trusted.
     */
    const city=vacatoryFilterCityOnly(
      readField(row,["city"])
    );

    if(!country||!city)return;

    const key=
      `${vacatoryCountryKey(country)}|`+
      `${vacatoryCountryKey(city)}`;

    if(seen.has(key))return;

    seen.add(key);

    result.push({
      country,
      city
    })
  });

  return result
}

function vacatoryFilterLocationLabel(
  country,
  city
){
  if(!country||!city)return"";

  if(
    vacatoryCountryKey(country)===
    vacatoryCountryKey(city)
  ){
    return country
  }

  return `${country}, ${city}`
}

function vacatoryLocationTextContainsCity(
  locationText,
  city
){
  const haystack=
    ` ${vacatoryCountryKey(locationText)} `;

  const needle=
    ` ${vacatoryCountryKey(city)} `;

  return Boolean(
    needle.trim() &&
    haystack.includes(needle)
  )
}

function vacatoryLooksLikeNonCity(value){
  return /(?:\d|\b(?:building|tower|street|road|avenue|boulevard|square|wharf|district|quarter|campus|office|centre|center|quay|harbour|harbor|docklands|business park|industrial park|manhattan|zuidas|canary wharf|city of london|la défense|la defense)\b)/i
    .test(String(value||""))
}

function vacatoryOpportunityFilterLocations(row){
  const country=
    vacatoryOpportunityCountry(row);

  const rawLocation=
    String(row?.location||"")
      .replace(/\s+/g," ")
      .trim();

  const eligibleOffices=
    country
      ? vacatoryOpportunityFilterOfficeRows
          .filter(office=>
            office.country===country
          )
      : vacatoryOpportunityFilterOfficeRows;

  const matched=
    eligibleOffices.filter(office=>
      vacatoryLocationTextContainsCity(
        rawLocation,
        office.city
      )
    );

  if(matched.length){
    return [
      ...new Set(
        matched
          .map(office=>
            vacatoryFilterLocationLabel(
              office.country,
              office.city
            )
          )
          .filter(Boolean)
      )
    ]
  }

  /*
   * Fallback only when no structured office match
   * is possible. Choose one city component only.
   */
  const fallbackText=
    vacatoryOpportunityCityLabel(
      row,
      country
    );

  const candidates=
    String(fallbackText||"")
      .split(",")
      .map(part=>part.trim())
      .filter(Boolean)
      .filter(part=>
        !country ||
        vacatoryCountryKey(part)!==
          vacatoryCountryKey(country)
      );

  let city=
    candidates.find(candidate=>
      !vacatoryLooksLikeNonCity(candidate)
    )||"";

  city=vacatoryFilterCityOnly(city);

  const label=
    vacatoryFilterLocationLabel(
      country,
      city
    );

  return label
    ? [label]
    : []
}

function vacatoryEscapeOpportunityGeo(e){
  return String(e||"")
    .replace(/[.*+?^${}()|[\]\\]/g,"\\$&")
}

function vacatoryOpportunityCoreName(row){return String(row?.name||"Opportunity").trim()}

function vacatoryPublicOpportunityTitle(row){return String(row?.name||"Opportunity").trim()}

function vacatoryOpportunityType(row){return String(row?.type||"Opportunity").trim()||"Opportunity"}

function vacatoryPopulateFilter(e,t,n){
  const a=document.getElementById(e);

  if(!a)return;

  const i=a.value;

  a.replaceChildren();

  const r=document.createElement("option");
  r.value="";
  r.textContent=n;
  a.appendChild(r);

  t.forEach(e=>{
    const t=document.createElement("option");
    t.value=e;
    t.textContent=e;
    a.appendChild(t)
  });

  if(t.includes(i))a.value=i
}

function vacatoryPopulateOpportunityFilters(){
  const countrySelect=document.getElementById("opportunityCountryFilter")||document.getElementById("opportunityLocationFilter"),typeSelect=document.getElementById("opportunityTypeFilter");
  if(countrySelect){const old=countrySelect.value,countries=[...new Set(vacatoryOpportunityRows.flatMap(x=>Array.isArray(x.countries)?x.countries:[vacatoryOpportunityCountry(x)]).filter(Boolean))].sort((a,b)=>a.localeCompare(b,"en-GB"));countrySelect.replaceChildren();const all=document.createElement("option");all.value="";all.textContent="All countries";countrySelect.appendChild(all);countries.forEach(c=>{const o=document.createElement("option");o.value=c;o.textContent=c;countrySelect.appendChild(o)});if(countries.includes(old))countrySelect.value=old}
  if(typeSelect){const old=typeSelect.value,types=[...new Set(vacatoryOpportunityRows.map(vacatoryOpportunityType).filter(Boolean))].sort((a,b)=>a.localeCompare(b,"en-GB"));typeSelect.replaceChildren();const all=document.createElement("option");all.value="";all.textContent="All types";typeSelect.appendChild(all);types.forEach(t=>{const o=document.createElement("option");o.value=t;o.textContent=t;typeSelect.appendChild(o)});if(types.includes(old))typeSelect.value=old}
  vacatoryUpdateOpportunityReset();
}

function vacatoryUpdateOpportunityReset(){
  const e=document.getElementById(
    "opportunityLocationFilter"
  );

  const t=document.getElementById(
    "opportunityTypeFilter"
  );

  const n=document.getElementById(
    "opportunityFilterReset"
  );

  if(!n)return;

  n.hidden=!Boolean(
    e?.value||
    t?.value
  )
}

function vacatoryApplyOpportunityFilters(){
  const countrySelect=document.getElementById("opportunityCountryFilter")||document.getElementById("opportunityLocationFilter"),typeSelect=document.getElementById("opportunityTypeFilter"),list=document.getElementById("opportunitiesList"),empty=document.getElementById("opportunitiesFilterEmpty");if(!list)return;
  const country=countrySelect?.value||"",type=typeSelect?.value||"";
  const rows=vacatoryOpportunityRows.filter(row=>{if(country){const countries=Array.isArray(row.countries)?row.countries:[vacatoryOpportunityCountry(row)];if(!countries.includes(country))return false}if(type&&vacatoryOpportunityType(row)!==type)return false;return true}).sort(sortOpportunitiesByClosingDate);
  list.innerHTML=rows.map((row,index)=>renderOpportunity(row,index)).join("");empty?.classList.toggle("hidden",rows.length!==0);vacatoryUpdateOpportunityReset();
}

function vacatoryResetOpportunityFilters(){
  const e=document.getElementById(
    "opportunityLocationFilter"
  );

  const t=document.getElementById(
    "opportunityTypeFilter"
  );

  if(e)e.value="";
  if(t)t.value="";

  vacatoryApplyOpportunityFilters();

  e?.focus()
}

function vacatoryBindOpportunityControls(){
  document.getElementById(
    "opportunityLocationFilter"
  )?.addEventListener(
    "change",
    vacatoryApplyOpportunityFilters
  );

  document.getElementById(
    "opportunityTypeFilter"
  )?.addEventListener(
    "change",
    vacatoryApplyOpportunityFilters
  );

  document.getElementById(
    "opportunityFilterReset"
  )?.addEventListener(
    "click",
    vacatoryResetOpportunityFilters
  )
}

document.addEventListener(
  "DOMContentLoaded",
  vacatoryBindOpportunityControls
);

/* VACATORY_CANONICAL_FIRM_PROFILE_FOUNDATION_20260816
   Canonical opportunity presentation helpers. No legacy opportunity tables. */
function vacatoryCanonicalApi(){
  const api=window.VacatoryOpportunityData;
  if(!api)throw new Error("Load opportunity-data.js before firm-profile.js.");
  return api;
}
function vacatoryCanonicalDateValue(value){
  if(!value)return Number.POSITIVE_INFINITY;
  const m=String(value).match(/^(\d{4})-(\d{2})-(\d{2})$/);
  const d=m?new Date(Number(m[1]),Number(m[2])-1,Number(m[3])):new Date(value);
  if(Number.isNaN(d.getTime()))return Number.POSITIVE_INFINITY;
  d.setHours(0,0,0,0);return d.getTime();
}
function vacatoryCanonicalVisible(o){
  if(!o)return false;

  // career_opportunities_public_view is the publication boundary. Retain
  // closed programmes so firm profiles preserve their latest confirmed dates;
  // only dated one-off events expire in this consumer.
  if(!o.isEvent)return true;

  const today=startOfToday();
  if(o.programmeEndsOn&&vacatoryCanonicalDateValue(o.programmeEndsOn)<today)return false;
  if(!o.programmeEndsOn&&o.programmeStartsOn&&vacatoryCanonicalDateValue(o.programmeStartsOn)<today)return false;
  return true;
}
function vacatoryCanonicalStatusLabel(value){
  const api=vacatoryCanonicalApi(),status=String(value||"").toLowerCase();
  if(status==="open")return "Applications open now";
  return api.formatApplicationStatus(status)||"Application status not confirmed";
}
function vacatoryCanonicalCompensation(o){
  const api=vacatoryCanonicalApi();
  return [...new Set((o?.compensation||[]).map(x=>api.formatCompensation(x)).filter(Boolean))].join(" · ");
}
function vacatoryCanonicalCycleVisible(c){
  // Preserve canonical cycle history for a published programme, including
  // closed cycles whose dates explain the most recently confirmed window.
  return Boolean(c);
}
function vacatoryCanonicalCycleTiming(o){
  const api=vacatoryCanonicalApi(),lines=[];
  (o?.cycles||[]).filter(vacatoryCanonicalCycleVisible).forEach(c=>{
    const app=c.applicationDatesText||[
      c.opensOn?`Applications open ${api.formatDate(c.opensOn)}`:"",
      c.closesOn?`close ${api.formatDate(c.closesOn)}${c.closesAt?` at ${c.closesAt}`:""}${c.closesTimezone?` ${c.closesTimezone}`:""}`:""
    ].filter(Boolean).join("; ");
    const programme=c.programmeDatesText||api.formatDateRange(c.programmeStartsOn,c.programmeEndsOn);
    if(app)lines.push(app);
    if(programme)lines.push(`Programme: ${programme}`);
  });
  return [...new Set(lines)].join("\n");
}
function vacatoryCanonicalView(o){
  const api=vacatoryCanonicalApi();
  const countries=[...(o?.countries||[])],cities=[...(o?.cities||[])];
  return {
    opportunityId:o.opportunityId, sourceType:o.opportunityTypeSlug,
    name:o.publicTitle, type:o.opportunityTypeLabel||"Opportunity",
    countries,cities,country:countries[0]||"",city:cities[0]||"",
    location:o.locationSummary||api.locationLabel(o)||"Location not stated",
    openingDate:o.opensOn,openingAt:o.opensAt,openingTimezone:o.opensTimezone,
    closingDate:o.closesOn,closingAt:o.closesAt,closingTimezone:o.closesTimezone,
    applicationDatesText:o.applicationDatesText,
    startDate:o.programmeStartsOn,endDate:o.programmeEndsOn,
    programmeDates:o.programmeDatesText||api.formatDateRange(o.programmeStartsOn,o.programmeEndsOn),
    duration:o.durationText,status:o.publicApplicationStatus,salary:vacatoryCanonicalCompensation(o),
    firstYearSalary:"",secondYearSalary:"",nqSalary:"",seats:o.placesText,
    eligibility:o.eligibilityText||o.audienceText,academicRequirements:o.academicCriteria,
    degreeRequirements:o.studyStageText,applicationProcess:o.applicationProcessText,
    assessments:o.assessmentsText,sponsorship:o.fundingText,visaInformation:o.rightToWorkText,
    disabilityInformation:o.disabilitySupportText,
    additionalDetails:[o.applicationDatesText,vacatoryCanonicalCycleTiming(o),o.progressionRouteText,o.programmeStructureText,o.expensesText,o.travelSupportText,o.accommodationSupportText,o.additionalDetailsText].filter(Boolean).join("\n"),
    applicationUrl:o.applicationUrl||o.officialUrl,evidenceStatus:"Official-source research",
    researchCheckedOn:o.lastVerifiedOn,isEvent:Boolean(o.isEvent),canonicalOpportunity:o,_canonicalVisible:vacatoryCanonicalVisible(o)
  };
}
function vacatoryCanonicalViews(rows){return (rows||[]).filter(vacatoryCanonicalVisible).map(vacatoryCanonicalView)}
function vacatoryCanonicalNextDeadline(rows){
  const api=vacatoryCanonicalApi();
  const today=api.todayDateOnly();
  const deadlines=[];

  (rows||[])
    .filter(vacatoryCanonicalVisible)
    .forEach(opportunity=>{
      (opportunity.cycles||[]).forEach(cycle=>{
        const closesOn=String(cycle.closesOn||"").trim();

        if(
          !cycle.hasExactApplicationDeadline||
          !/^\d{4}-\d{2}-\d{2}$/.test(closesOn)||
          closesOn<today
        ){
          return;
        }

        deadlines.push({
          closesOn,
          publicTitle:opportunity.publicTitle||opportunity.officialName||"Student opportunity"
        });
      });
    });

  return deadlines.sort((first,second)=>
    first.closesOn.localeCompare(second.closesOn)||
    first.publicTitle.localeCompare(second.publicTitle,"en-GB")
  )[0]||null;
}
function vacatoryCanonicalRoutes(rows){
  const map=new Map();
  (rows||[]).filter(vacatoryCanonicalVisible).forEach(o=>{const name=o.opportunityTypeLabel||"Opportunity";if(!map.has(name))map.set(name,{name,url:o.applicationUrl||o.officialUrl||""})});
  return [...map.values()].sort((a,b)=>a.name.localeCompare(b.name,"en-GB"));
}
function vacatoryCanonicalApplicationSummary(rows){
  const v=(rows||[]).filter(vacatoryCanonicalVisible),open=v.filter(x=>x.publicApplicationStatus==="open").length,rolling=v.filter(x=>x.publicApplicationStatus==="rolling").length,upcoming=v.filter(x=>x.publicApplicationStatus==="upcoming").length;
  if(open)return{value:`${open} open now`,note:rolling?`${rolling} additional rolling route${rolling===1?"":"s"}.`:"See Opportunities for details.",status:"confirmed"};
  if(rolling)return{value:`${rolling} rolling`,note:upcoming?`${upcoming} additional upcoming route${upcoming===1?"":"s"}.`:"See Opportunities for details.",status:"confirmed"};
  if(upcoming)return{value:`${upcoming} upcoming`,note:"Published future routes are listed in Opportunities.",status:"confirmed"};
  return{value:"See opportunities",note:"No open or upcoming application window is currently published.",status:"unpublished"};
}
function vacatoryCanonicalVisaSummary(rows,research){
  if((rows||[]).filter(vacatoryCanonicalVisible).some(x=>x.rightToWorkText))return{value:"Published by route",note:"Visa and right-to-work wording varies by opportunity.",status:"confirmed"};
  if((research||[]).some(x=>sectionMatches(x,["visa","right to work","immigration","sponsorship"])))return{value:"Firm guidance available",note:"See Pay, funding & visas.",status:"confirmed"};
  return{value:"Not published",note:"No firm-wide visa commitment is inferred.",status:"unpublished"};
}


/* VACATORY_CANONICAL_PROFILE_LAZY_TABS_20260817
   Render each profile tab once, on first activation, and keep the active tab
   in a shareable ?tab= URL without changing the canonical profile URL. */
const vacatoryFirmLazyTabs = new Set([
  "overview",
  "opportunities",
  "pay-funding-visas",
  "practice-areas",
  "locations",
  "roles",
  "inclusion-disability",
  "pro-bono",
  "firm-highlights",
  "links-socials"
]);
const vacatoryFirmLoadedTabs = new Set();
let vacatoryFirmLazyRecord = null;

function vacatoryFirmTabFromUrl() {
  const requested = new URLSearchParams(window.location.search).get("tab");
  return vacatoryFirmLazyTabs.has(requested) ? requested : "overview";
}

function vacatoryFirmUpdateTabUrl(tab, mode = "push") {
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

async function vacatoryFirmEnsureTab(tab) {
  if (!vacatoryFirmLazyRecord || vacatoryFirmLoadedTabs.has(tab)) return;

  const loaders = {
    overview: () => loadAtAGlance(vacatoryFirmLazyRecord),
    opportunities: () => loadOpportunities(vacatoryFirmLazyRecord),
    "pay-funding-visas": () => loadPayFundingVisas(),
    "practice-areas": () => loadPracticeAreas(),
    locations: () => loadLocations(vacatoryFirmLazyRecord),
    roles: () => loadRoles(),
    "inclusion-disability": () => loadInclusionDisability(),
    "pro-bono": () => loadProBono(),
    "firm-highlights": () => loadFirmHighlights(vacatoryFirmLazyRecord),
    "links-socials": () => loadLinksAndSocials(vacatoryFirmLazyRecord)
  };

  const loader = loaders[tab];
  if (!loader) return;

  const panel = document.getElementById(`tab-${tab}`);
  vacatoryFirmLoadedTabs.add(tab);
  panel?.setAttribute("aria-busy", "true");

  try {
    await loader();
  } catch (error) {
    vacatoryFirmLoadedTabs.delete(tab);
    console.error(`Unable to load ${tab} tab:`, error);
  } finally {
    panel?.removeAttribute("aria-busy");
    if (typeof vacatoryRenderAllTabFreshness === "function") {
      vacatoryRenderAllTabFreshness();
    }
  }
}

function vacatoryFirmSelectTab(tab, options = {}) {
  const selected = vacatoryFirmLazyTabs.has(tab) ? tab : "overview";
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

  vacatoryFirmUpdateTabUrl(selected, options.historyMode || "push");
  void vacatoryFirmEnsureTab(selected);
}

setupTabs = function () {
  const tabs = Array.from(document.querySelectorAll(".tab-btn"));
  tabs.forEach(tab => {
    tab.addEventListener("click", () => {
      vacatoryFirmSelectTab(tab.dataset.tab, { historyMode: "push" });
    });
  });
};

loadFirmProfile = async function () {
  if (typeof client === "undefined") {
    console.error("The Supabase client is unavailable.");
    showError();
    return;
  }

  const requestedTab = vacatoryFirmTabFromUrl();
  let firm;

  try {
    const { data, error } = await client
      .from("firms")
      .select("*")
      .eq("id", firmId)
      .maybeSingle();

    if (error) throw error;
    if (!data) throw new Error("Firm record not found.");
    firm = data;
  } catch (error) {
    console.error("Unable to load firm record:", error);
    showError();
    return;
  }

  vacatoryFirmLazyRecord = firm;
  renderFirmHeader(firm);
  document.getElementById("loadingState")?.classList.add("hidden");
  document.getElementById("errorState")?.classList.add("hidden");
  document.getElementById("profileContent")?.classList.remove("hidden");
  vacatoryFirmSelectTab(requestedTab, { historyMode: "replace" });
};

window.addEventListener("popstate", () => {
  if (!vacatoryFirmLazyRecord) return;
  vacatoryFirmSelectTab(vacatoryFirmTabFromUrl(), { historyMode: "none" });
});

/* VACATORY_CANONICAL_PROFILE_SEO_TABS_20260817
   Make every tab a crawlable URL, keep per-tab metadata accurate, and expose
   truthful page/list schema without misclassifying student opportunities. */
const vacatoryFirmTabSeo = {
  overview: ["Overview", "firm profile, student routes and official research"],
  opportunities: ["Opportunities", "current and upcoming student opportunities, application dates and official links"],
  "pay-funding-visas": ["Pay, funding & visas", "student pay, funding, sponsorship and visa information"],
  "practice-areas": ["Practice areas", "practice areas and sector research"],
  locations: ["Locations", "UK and global office locations"],
  roles: ["Roles", "student entry routes and career pathways"],
  "inclusion-disability": ["EDI", "equality, diversity, inclusion and disability support"],
  "pro-bono": ["Pro bono", "pro bono programmes and community work"],
  "firm-highlights": ["Firm highlights", "awards, matters and firm highlights"],
  "links-socials": ["Links & Socials", "official websites, student careers pages and social channels"]
};

function vacatoryFirmTabUrl(tab) {
  const base = vacatoryFirmLazyRecord
    ? firmCleanProfileUrl(vacatoryFirmLazyRecord)
    : new URL(window.location.href).origin + window.location.pathname;
  const url = new URL(base);
  if (tab !== "overview") url.searchParams.set("tab", tab);
  return url.href;
}

function vacatoryFirmTabHref(tab) {
  const url = new URL(window.location.href);
  if (tab === "overview") url.searchParams.delete("tab");
  else url.searchParams.set("tab", tab);
  return `${url.pathname}${url.search}${url.hash}`;
}

function vacatoryFirmRefreshTabLinks() {
  document.querySelectorAll(".tab-btn").forEach(tab => {
    tab.setAttribute("href", vacatoryFirmTabHref(tab.dataset.tab || "overview"));
  });
}

function vacatoryFirmPageSchema(tab) {
  if (!vacatoryFirmLazyRecord) return;
  const firm = vacatoryFirmLazyRecord;
  const name = String(firm.name || firm.short_name || "Law firm").trim();
  const baseUrl = firmCleanProfileUrl(firm);
  const pageUrl = vacatoryFirmTabUrl(tab);
  const label = vacatoryFirmTabSeo[tab]?.[0] || "Overview";
  const description = `${name} ${vacatoryFirmTabSeo[tab]?.[1] || "firm research"} on Vacatory.`;
  const breadcrumbs = [
    { "@type": "ListItem", position: 1, name: "Vacatory", item: "https://vacatory.com/" },
    { "@type": "ListItem", position: 2, name: "Firms", item: "https://vacatory.com/firms.html" },
    { "@type": "ListItem", position: 3, name, item: baseUrl }
  ];
  if (tab !== "overview") {
    breadcrumbs.push({ "@type": "ListItem", position: 4, name: label, item: pageUrl });
  }
  const page = {
    "@type": "CollectionPage",
    "@id": `${pageUrl}#webpage`,
    url: pageUrl,
    name: tab === "overview" ? `${name} | Vacatory` : `${name} ${label} | Vacatory`,
    description,
    isPartOf: { "@type": "WebSite", "@id": "https://vacatory.com/#website", name: "Vacatory", url: "https://vacatory.com/" },
    about: { "@id": `${baseUrl}#organization` }
  };
  if (tab === "opportunities" && Array.isArray(vacatoryOpportunityRows)) {
    page.mainEntity = {
      "@type": "ItemList",
      name: `${name} student opportunities`,
      numberOfItems: vacatoryOpportunityRows.length,
      itemListElement: vacatoryOpportunityRows.map((row, index) => {
        const item = {
          "@type": "ListItem",
          position: index + 1,
          name: vacatoryPublicOpportunityTitle(row)
        };
        const url = normaliseExternalUrl(row.applicationUrl || row.officialUrl || row.sourceUrl);
        if (url) item.url = url;
        return item;
      })
    };
  }
  let script = document.getElementById("firmProfilePageSchema");
  if (!script) {
    script = document.createElement("script");
    script.id = "firmProfilePageSchema";
    script.type = "application/ld+json";
    document.head.appendChild(script);
  }
  script.textContent = JSON.stringify({
    "@context": "https://schema.org",
    "@graph": [
      page,
      { "@type": "BreadcrumbList", "@id": `${pageUrl}#breadcrumb`, itemListElement: breadcrumbs }
    ]
  });
}

function vacatoryFirmApplyTabSeo(tab) {
  if (!vacatoryFirmLazyRecord) return;
  const firm = vacatoryFirmLazyRecord;
  const name = String(firm.name || firm.short_name || "Law firm").trim();
  const label = vacatoryFirmTabSeo[tab]?.[0] || "Overview";
  const description = `${name} ${vacatoryFirmTabSeo[tab]?.[1] || "firm research"} on Vacatory.`;
  const url = vacatoryFirmTabUrl(tab);
  const title = tab === "overview" ? `${name} | Vacatory` : `${name} ${label} | Vacatory`;
  const shareImage = `https://vacatory.com/assets/social/firm-${firmSlugForUrl(name)}.png`;
  const shareImageAlt = `${name} firm profile on Vacatory`;
  document.title = title;
  upsertFirmCanonical(url);
  upsertFirmSeoMeta("name", "description", description);
  upsertFirmSeoMeta("property", "og:title", title);
  upsertFirmSeoMeta("property", "og:description", description);
  upsertFirmSeoMeta("property", "og:url", url);
  upsertFirmSeoMeta("property", "og:image", shareImage);
  upsertFirmSeoMeta("property", "og:image:alt", shareImageAlt);
  upsertFirmSeoMeta("property", "og:image:width", "1200");
  upsertFirmSeoMeta("property", "og:image:height", "630");
  upsertFirmSeoMeta("property", "og:image:type", "image/png");
  upsertFirmSeoMeta("name", "twitter:card", "summary_large_image");
  upsertFirmSeoMeta("name", "twitter:title", title);
  upsertFirmSeoMeta("name", "twitter:description", description);
  upsertFirmSeoMeta("name", "twitter:image", shareImage);
  upsertFirmSeoMeta("name", "twitter:image:alt", shareImageAlt);
  vacatoryFirmPageSchema(tab);
}

const vacatoryFirmEnsureTabSeoBase = vacatoryFirmEnsureTab;
vacatoryFirmEnsureTab = async function (tab) {
  await vacatoryFirmEnsureTabSeoBase(tab);
  vacatoryFirmApplyTabSeo(tab);
};

const vacatoryFirmSelectTabSeoBase = vacatoryFirmSelectTab;
vacatoryFirmSelectTab = function (tab, options = {}) {
  vacatoryFirmSelectTabSeoBase(tab, options);
  const selected = vacatoryFirmLazyTabs.has(tab) ? tab : "overview";
  vacatoryFirmRefreshTabLinks();
  vacatoryFirmApplyTabSeo(selected);
};

setupTabs = function () {
  vacatoryFirmRefreshTabLinks();
  document.querySelectorAll(".tab-btn").forEach(tab => {
    tab.addEventListener("click", event => {
      event.preventDefault();
      vacatoryFirmSelectTab(tab.dataset.tab, { historyMode: "push" });
    });
  });
};
