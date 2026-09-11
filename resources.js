/*
 * Vacatory
 * resources.js
 *
 * Controller for the Legal Resources page.
 *
 * ARCHITECTURE:
 * - legal-resources.html supplies only canonical shell mounts
 * - filter-shell.js owns resource filter controls
 * - results-shell.js owns result heading/count/states/list geometry
 * - this file owns resource data, filtering and result rendering only
 * - styles.css owns all visual presentation
 */
(() => {
  "use strict";

  const LEGAL_RESOURCES = {"england-wales":{"name":"England and Wales","intro":"Core official sources for legislation, judgments, courts, regulation, public legal information and qualification in England and Wales.","groups":[{"title":"Legislation","items":[{"name":"UK Legislation","url":"https://www.legislation.gov.uk/","type":"Official legislation","description":"Acts of Parliament, statutory instruments and legislation applying across the United Kingdom."}]},{"title":"Cases and judgments","items":[{"name":"Find Case Law","url":"https://caselaw.nationalarchives.gov.uk/","type":"Official case law","description":"Free official judgments and tribunal decisions published by The National Archives."},{"name":"UK Supreme Court","url":"https://www.supremecourt.uk/","type":"Official court","description":"Cases, judgments, hearings, rules and practice directions from the Supreme Court of the United Kingdom."}]},{"title":"Courts and tribunals","items":[{"name":"Judiciary of England and Wales","url":"https://www.judiciary.uk/","type":"Official judiciary","description":"Judicial information, judgments, speeches, court guidance and information about the judiciary."},{"name":"HM Courts and Tribunals Service","url":"https://www.gov.uk/government/organisations/hm-courts-and-tribunals-service","type":"Government","description":"Official information about courts, tribunals, forms, fees and court services."}]},{"title":"Regulators","items":[{"name":"Solicitors Regulation Authority","url":"https://www.sra.org.uk/","type":"Regulator","description":"Regulation, standards, professional rules and qualification information for solicitors."},{"name":"Bar Standards Board","url":"https://www.barstandardsboard.org.uk/","type":"Regulator","description":"Regulation, training requirements, professional standards and the barristers register."}]},{"title":"Professional bodies","items":[{"name":"The Law Society","url":"https://www.lawsociety.org.uk/","type":"Professional body","description":"Professional guidance, legal resources, career information and Find a Solicitor."},{"name":"The Bar Council","url":"https://www.barcouncil.org.uk/","type":"Professional body","description":"Information about the Bar, policy, careers, access to justice and professional resources."},{"name":"City of London Law Society","url":"https://clls.org/","type":"Professional body","description":"Represents solicitors and law firms in the City of London, with specialist committees, consultations, guidance and law reform work."}]},{"title":"Legal aid and public information","items":[{"name":"Civil Legal Advice","url":"https://www.gov.uk/civil-legal-advice","type":"Government","description":"Official information about civil legal aid and access to free and confidential legal advice for eligible people."}]},{"title":"Careers and qualification","items":[{"name":"Solicitors Qualifying Examination","url":"https://sqe.sra.org.uk/","type":"Official qualification","description":"Official SQE registration, assessment, policy, results and qualification guidance."},{"name":"Pupillage Gateway","url":"https://www.pupillagegateway.com/","type":"Official careers portal","description":"Bar Council portal for pupillage vacancies, applications, timetables and applicant guidance."},{"name":"City Century","url":"https://citycentury.co.uk/","type":"Solicitor apprenticeships","description":"City-focused solicitor degree apprenticeship information and opportunities linked to participating law firms."},{"name":"Legal Cheek","url":"https://www.legalcheek.com/","type":"Legal careers and news","description":"UK and Ireland legal careers news, events, virtual law fairs, application guidance and insight into firms and chambers."},{"name":"Aspiring Solicitors","url":"https://www.aspiringsolicitors.co.uk/","type":"Careers support and diversity","description":"Free careers support, coaching, mentoring, events and application guidance for aspiring solicitors from underrepresented backgrounds."}]}]},"scotland":{"name":"Scotland","intro":"Core sources for Scots law, Scottish courts, legal regulation, prosecution, legal aid and professional qualification.","groups":[{"title":"Legislation","items":[{"name":"UK Legislation","url":"https://www.legislation.gov.uk/","type":"Official legislation","description":"Acts of the Scottish Parliament, UK Acts and statutory instruments relevant to Scotland."}]},{"title":"Cases and judgments","items":[{"name":"Scottish Courts Judgments","url":"https://www.scotcourts.gov.uk/judgments/","type":"Official case law","description":"Searchable judgments and opinions from Scottish courts."},{"name":"Judiciary of Scotland","url":"https://www.judiciary.scot/","type":"Official judiciary","description":"Judicial information, sentencing statements, speeches and information about Scotland's judges."}]},{"title":"Courts and tribunals","items":[{"name":"Scottish Courts and Tribunals Service","url":"https://www.scotcourts.gov.uk/","type":"Official courts","description":"Court rolls, locations, judgments and information about Scottish courts and tribunals."}]},{"title":"Professional bodies and regulation","items":[{"name":"Law Society of Scotland","url":"https://www.lawscot.org.uk/","type":"Professional body","description":"Solicitor regulation, professional standards, careers and legal resources in Scotland."},{"name":"Faculty of Advocates","url":"https://www.advocates.org.uk/","type":"Professional body","description":"Information about advocates, training, professional standards and the Scottish Bar."},{"name":"Scottish Legal Complaints Commission","url":"https://www.scottishlegalcomplaints.org.uk/","type":"Complaints body","description":"Independent information about complaints concerning legal services in Scotland."}]},{"title":"Government and prosecution","items":[{"name":"Crown Office and Procurator Fiscal Service","url":"https://www.copfs.gov.uk/","type":"Official prosecution service","description":"Scotland's public prosecution service and death investigation authority."},{"name":"Scottish Government Justice","url":"https://www.gov.scot/policies/justice/","type":"Government","description":"Scottish Government policy and publications relating to justice and the legal system."}]},{"title":"Legal aid and public information","items":[{"name":"Scottish Legal Aid Board","url":"https://www.slab.org.uk/","type":"Legal aid body","description":"Legal aid guidance, eligibility information and resources for applicants and legal professionals."}]},{"title":"Careers and qualification","items":[{"name":"Legal Cheek","url":"https://www.legalcheek.com/","type":"Legal careers and news","description":"UK and Ireland legal careers news, events, virtual law fairs, application guidance and insight into firms and chambers."},{"name":"Aspiring Solicitors","url":"https://www.aspiringsolicitors.co.uk/","type":"Careers support and diversity","description":"Free careers support, coaching, mentoring, events and application guidance for aspiring solicitors from underrepresented backgrounds."}]}]},"northern-ireland":{"name":"Northern Ireland","intro":"Core official sources for Northern Ireland legislation, courts, legal professions, prosecution and legal aid.","groups":[{"title":"Legislation","items":[{"name":"UK Legislation","url":"https://www.legislation.gov.uk/","type":"Official legislation","description":"Northern Ireland Acts, Orders in Council, statutory rules and other UK legislation."}]},{"title":"Cases and judgments","items":[{"name":"Judiciary NI","url":"https://www.judiciaryni.uk/","type":"Official judiciary","description":"Judgments, judicial decisions, practice directions and information about the Northern Ireland judiciary."}]},{"title":"Courts and tribunals","items":[{"name":"Department of Justice: Courts and Tribunals","url":"https://www.justice-ni.gov.uk/topics/courts-and-tribunals","type":"Government","description":"Official information about Northern Ireland courts, tribunals and justice services."}]},{"title":"Professional bodies and regulation","items":[{"name":"Law Society of Northern Ireland","url":"https://lawsoc-ni.org/","type":"Professional and regulatory body","description":"Regulation, qualification and professional information for solicitors in Northern Ireland."},{"name":"Bar of Northern Ireland","url":"https://www.barofni.com/","type":"Professional body","description":"Information about barristers, the Bar, professional practice and qualification."}]},{"title":"Government and prosecution","items":[{"name":"Public Prosecution Service for Northern Ireland","url":"https://www.ppsni.gov.uk/","type":"Official prosecution service","description":"Prosecution policies, guidance, publications and information about criminal prosecutions."},{"name":"Department of Justice Northern Ireland","url":"https://www.justice-ni.gov.uk/","type":"Government","description":"Justice policy, legislation, consultations and public services."}]},{"title":"Legal aid and public information","items":[{"name":"Legal Services Agency Northern Ireland","url":"https://www.justice-ni.gov.uk/topics/legal-aid","type":"Legal aid body","description":"Official legal aid information, guidance, forms and services."}]},{"title":"Careers and qualification","items":[{"name":"Institute of Professional Legal Studies","url":"https://www.qub.ac.uk/schools/InstituteofProfessionalLegalStudies/","type":"Professional education","description":"Professional legal education and qualification information for prospective solicitors and barristers."},{"name":"Legal Cheek","url":"https://www.legalcheek.com/","type":"Legal careers and news","description":"UK and Ireland legal careers news, events, virtual law fairs, application guidance and insight into firms and chambers."},{"name":"Aspiring Solicitors","url":"https://www.aspiringsolicitors.co.uk/","type":"Careers support and diversity","description":"Free careers support, coaching, mentoring, events and application guidance for aspiring solicitors from underrepresented backgrounds."}]}]},"ireland":{"name":"Republic of Ireland","intro":"Core sources for Irish legislation, judgments, courts, regulation, professional bodies, legal aid and qualification.","groups":[{"title":"Legislation","items":[{"name":"electronic Irish Statute Book","url":"https://www.irishstatutebook.ie/eli/index.html","type":"Official legislation","description":"Acts of the Oireachtas, statutory instruments, the Constitution, amendment information and selected pre-1922 legislation."},{"name":"Oireachtas Bills and Acts","url":"https://www.oireachtas.ie/en/bills/","type":"Official parliament","description":"Bills, legislative stages, debates and enacted legislation from the Houses of the Oireachtas."}]},{"title":"Cases and judgments","items":[{"name":"Courts Service Judgments","url":"https://www.courts.ie/decisions","type":"Official case law","description":"Judgments and decisions from the Irish courts."}]},{"title":"Courts and tribunals","items":[{"name":"Courts Service","url":"https://www.courts.ie/","type":"Official courts","description":"Court information, legal diary, judgments, forms, rules and online court services."}]},{"title":"Regulators","items":[{"name":"Legal Services Regulatory Authority","url":"https://www.lsra.ie/","type":"Regulator","description":"Independent regulation of legal services provided by solicitors and barristers, including complaints and standards."}]},{"title":"Professional bodies","items":[{"name":"Law Society of Ireland","url":"https://www.lawsociety.ie/","type":"Professional body","description":"Solicitor education, regulation, professional resources and public legal information."},{"name":"The Bar of Ireland","url":"https://www.lawlibrary.ie/","type":"Professional body","description":"Information about barristers, the Law Library, professional practice and becoming a barrister."},{"name":"The Honorable Society of King's Inns","url":"https://www.kingsinns.ie/","type":"Professional education","description":"Professional education and qualification route for barristers in Ireland."}]},{"title":"Government and prosecution","items":[{"name":"Department of Justice","url":"https://www.gov.ie/en/department-of-justice-home-affairs-and-migration/","type":"Government","description":"Justice policy, legislation, consultations and public services."},{"name":"Office of the Director of Public Prosecutions","url":"https://www.dppireland.ie/","type":"Official prosecution service","description":"Prosecution guidance, policy, publications and information about the criminal prosecution process."}]},{"title":"Legal aid and public information","items":[{"name":"Legal Aid Board","url":"https://www.legalaidboard.ie/","type":"Legal aid body","description":"Civil legal aid, legal advice, family mediation and public information."},{"name":"FLAC","url":"https://www.flac.ie/","type":"Free legal information","description":"Free Legal Advice Centres provide public legal information, advocacy and access to legal advice."}]},{"title":"Careers and qualification","items":[{"name":"Legal Cheek","url":"https://www.legalcheek.com/","type":"Legal careers and news","description":"UK and Ireland legal careers news, events, virtual law fairs, application guidance and insight into firms and chambers."},{"name":"Aspiring Solicitors","url":"https://www.aspiringsolicitors.co.uk/","type":"Careers support and diversity","description":"Careers support, coaching, mentoring, events and application guidance for aspiring solicitors, including opportunities connected with UK and Ireland firms."}]}]},"eu":{"name":"European Union","intro":"Essential sources for European Union legislation, case law, institutions and judicial cooperation, with Council of Europe and European Convention on Human Rights materials clearly identified.","groups":[{"title":"Legislation","items":[{"name":"EUR-Lex","url":"https://eur-lex.europa.eu/","type":"Official EU law","description":"EU treaties, legislation, consolidated texts, preparatory documents and the Official Journal."}]},{"title":"Cases and judgments","items":[{"name":"CURIA","url":"https://curia.europa.eu/","type":"Official EU courts","description":"Case law, judgments, opinions and procedural information from the Court of Justice of the European Union."}]},{"title":"Courts and legal cooperation","items":[{"name":"European e-Justice Portal","url":"https://e-justice.europa.eu/","type":"Official EU portal","description":"Cross-border justice information, court systems, legal professions, forms and judicial cooperation."}]},{"title":"Institutions and policy","items":[{"name":"European Commission: Justice and Consumers","url":"https://commission.europa.eu/about/departments-and-executive-agencies/justice-and-consumers_en","type":"EU institution","description":"EU justice, fundamental rights, consumer law, equality and rule of law policy."},{"name":"European Parliament","url":"https://www.europarl.europa.eu/","type":"EU institution","description":"Legislative activity, committees, adopted texts, debates and parliamentary research."}]},{"title":"European human rights (Council of Europe)","items":[{"name":"HUDOC","url":"https://hudoc.echr.coe.int/","type":"Official case law","description":"Search judgments, decisions, communicated cases and other documents from the European Court of Human Rights."},{"name":"European Court of Human Rights","url":"https://www.echr.coe.int/","type":"Official court","description":"Court information, judgments, press releases, rules, practical guidance and case law resources."},{"name":"Council of Europe Treaty Office","url":"https://www.coe.int/en/web/conventions/","type":"Official treaty source","description":"Council of Europe conventions, protocols, signatures, ratifications and treaty status."},{"name":"European Convention on Human Rights","url":"https://www.echr.coe.int/european-convention-on-human-rights","type":"Official legal text","description":"Official Convention text, protocols and explanatory information."}]}]},"united-states":{"name":"United States","intro":"Core federal sources for legislation, case law, courts, legal administration and free legal research in the United States.","groups":[{"title":"Legislation","items":[{"name":"Congress.gov","url":"https://www.congress.gov/","type":"Official legislature","description":"Federal bills, laws, congressional records, committee materials and legislative activity."},{"name":"United States Code","url":"https://uscode.house.gov/","type":"Official legislation","description":"Official online source for the codified general and permanent laws of the United States."}]},{"title":"Cases and courts","items":[{"name":"Supreme Court of the United States","url":"https://www.supremecourt.gov/","type":"Official court","description":"Opinions, orders, dockets, rules, oral argument materials and court information."},{"name":"United States Courts","url":"https://www.uscourts.gov/","type":"Official judiciary","description":"Federal court structure, forms, rules, statistics and information about the federal judiciary."},{"name":"PACER","url":"https://pacer.uscourts.gov/","type":"Official court records","description":"Federal electronic court records and docket access. Some usage may involve fees."}]},{"title":"Government and justice","items":[{"name":"United States Department of Justice","url":"https://www.justice.gov/","type":"Government","description":"Federal justice policy, enforcement, legal opinions, prosecutions and agency information."}]},{"title":"Free legal research","items":[{"name":"Legal Information Institute","url":"https://www.law.cornell.edu/","type":"Free academic resource","description":"Free legal materials from Cornell Law School, including statutes, regulations, Supreme Court materials and Wex."}]},{"title":"Professional bodies","items":[{"name":"American Bar Association","url":"https://www.americanbar.org/","type":"Professional body","description":"Professional guidance, legal education, policy resources and information about the US legal profession."}]}]},"canada":{"name":"Canada","intro":"Core federal sources for Canadian legislation, judgments, courts, legal research and professional regulation.","groups":[{"title":"Legislation","items":[{"name":"Justice Laws Website","url":"https://laws-lois.justice.gc.ca/","type":"Official legislation","description":"Consolidated federal Acts and regulations from the Government of Canada."}]},{"title":"Cases and judgments","items":[{"name":"Supreme Court of Canada","url":"https://www.scc-csc.ca/","type":"Official court","description":"Judgments, case information, hearings, rules and Supreme Court resources."},{"name":"CanLII","url":"https://www.canlii.org/","type":"Free legal database","description":"Free Canadian case law and legislation from federal, provincial and territorial jurisdictions."}]},{"title":"Courts and justice","items":[{"name":"Federal Court","url":"https://www.fct-cf.gc.ca/","type":"Official court","description":"Federal Court decisions, rules, practice directions and case information."},{"name":"Department of Justice Canada","url":"https://www.justice.gc.ca/","type":"Government","description":"Federal justice policy, legal system information, legislation and public legal resources."}]},{"title":"Professional bodies and regulation","items":[{"name":"Federation of Law Societies of Canada","url":"https://flsc.ca/","type":"National regulatory federation","description":"National coordination of provincial and territorial law societies and legal profession standards."},{"name":"Canadian Bar Association","url":"https://www.cba.org/","type":"Professional body","description":"Professional resources, law reform, legal education and information about the Canadian legal profession."}]}]},"australia":{"name":"Australia","intro":"Core Commonwealth sources for Australian legislation, courts, free legal research and the legal profession.","groups":[{"title":"Legislation","items":[{"name":"Federal Register of Legislation","url":"https://www.legislation.gov.au/","type":"Official legislation","description":"Authorised Commonwealth Acts, legislative instruments and related legislative materials."}]},{"title":"Cases and judgments","items":[{"name":"High Court of Australia","url":"https://www.hcourt.gov.au/","type":"Official court","description":"Judgments, case information, transcripts, rules and High Court materials."},{"name":"Federal Court of Australia","url":"https://www.fedcourt.gov.au/","type":"Official court","description":"Federal Court judgments, forms, rules, practice notes and case information."},{"name":"AustLII","url":"https://www.austlii.edu.au/","type":"Free legal database","description":"Free Australian legislation, case law, journals and other legal materials."}]},{"title":"Government and legal system","items":[{"name":"Attorney-General's Department","url":"https://www.ag.gov.au/","type":"Government","description":"Commonwealth legal system policy, courts, access to justice and legal framework information."}]},{"title":"Professional bodies","items":[{"name":"Law Council of Australia","url":"https://lawcouncil.au/","type":"Professional body","description":"National representation, policy, law reform and professional information for the Australian legal profession."}]}]},"new-zealand":{"name":"New Zealand","intro":"Core official and free sources for New Zealand legislation, courts, justice, legal research and professional regulation.","groups":[{"title":"Legislation","items":[{"name":"New Zealand Legislation","url":"https://www.legislation.govt.nz/","type":"Official legislation","description":"Official Acts, Bills and secondary legislation maintained by the Parliamentary Counsel Office."}]},{"title":"Cases and judgments","items":[{"name":"Courts of New Zealand","url":"https://www.courtsofnz.govt.nz/","type":"Official judiciary","description":"Judgments, court information, judicial decisions and information about New Zealand's senior courts."},{"name":"NZLII","url":"https://www.nzlii.org/","type":"Free legal database","description":"Free New Zealand case law, legislation and legal materials."}]},{"title":"Government and justice","items":[{"name":"Ministry of Justice","url":"https://www.justice.govt.nz/","type":"Government","description":"Justice services, courts information, policy, tribunals and public legal information."},{"name":"Crown Law","url":"https://www.crownlaw.govt.nz/","type":"Government legal office","description":"The Government's principal legal adviser and information about Crown legal work."}]},{"title":"Professional bodies and regulation","items":[{"name":"New Zealand Law Society","url":"https://www.lawsociety.org.nz/","type":"Regulator and professional body","description":"Lawyer regulation, professional standards, public register, complaints and career information."}]},{"title":"Public legal information","items":[{"name":"Community Law","url":"https://communitylaw.org.nz/","type":"Community legal resource","description":"Free legal information, community law centres and public guidance on common legal issues."}]}]}};
  const englandWalesLegalAidResources = LEGAL_RESOURCES["england-wales"].groups.find(
    (group) => group.title === "Legal aid and public information",
  );

  englandWalesLegalAidResources.items.push({
    name: "Youth Justice Legal Centre",
    url: "https://yjlc.uk/",
    type: "Youth justice legal resource",
    description:
      "Specialist youth justice law guidance, legal updates, practical guides and advice information for England and Wales.",
  });

  const englandWalesCareersResources = LEGAL_RESOURCES["england-wales"].groups.find(
    (group) => group.title === "Careers and qualification",
  );

  englandWalesCareersResources.items.push({
    name: "LawCareers.Net",
    url: "https://www.lawcareers.net/",
    type: "Legal careers and guidance",
    description:
      "UK legal careers guidance, application advice, deadlines and searches for training contracts, vacation schemes and pupillages.",
  });

  const DEFAULT_JURISDICTION = "england-wales";

  const elements = {};

  function initialiseResources() {
    cacheElements();

    if (
      !elements.search ||
      !elements.jurisdiction ||
      !elements.category ||
      !elements.clear ||
      !elements.heading ||
      !elements.count ||
      !elements.loading ||
      !elements.error ||
      !elements.empty ||
      !elements.list
    ) {
      console.error("The canonical Resources page shells are unavailable.");
      showError();
      return;
    }

    bindFilters();
    populateCategoryOptions();
    applyFilters();
  }

  function cacheElements() {
    elements.search = document.getElementById("resourceSearch");
    elements.jurisdiction = document.getElementById("resourceJurisdiction");
    elements.category = document.getElementById("resourceCategory");
    elements.clear = document.getElementById("resourceClearFilters");
    elements.heading = document.getElementById("resources-list-title");
    elements.count = document.getElementById("resourceCount");
    elements.loading = document.getElementById("resourcesLoading");
    elements.error = document.getElementById("resourcesError");
    elements.empty = document.getElementById("resourcesEmpty");
    elements.list = document.getElementById("resourceGroups");
  }

  function bindFilters() {
    elements.search.addEventListener("input", applyFilters);

    elements.jurisdiction.addEventListener("change", () => {
      populateCategoryOptions();
      applyFilters();
    });

    elements.category.addEventListener("change", applyFilters);
    elements.clear.addEventListener("click", clearFilters);
  }

  function selectedJurisdiction() {
    const key = elements.jurisdiction.value;

    if (LEGAL_RESOURCES[key]) {
      return [key, LEGAL_RESOURCES[key]];
    }

    elements.jurisdiction.value = DEFAULT_JURISDICTION;
    return [DEFAULT_JURISDICTION, LEGAL_RESOURCES[DEFAULT_JURISDICTION]];
  }

  function populateCategoryOptions() {
    const [, jurisdiction] = selectedJurisdiction();
    const current = elements.category.value;
    const categories = jurisdiction.groups.map((group) => group.title);

    elements.category.replaceChildren();

    const allOption = document.createElement("option");
    allOption.value = "";
    allOption.textContent = "All categories";
    elements.category.appendChild(allOption);

    categories.forEach((category) => {
      const option = document.createElement("option");
      option.value = category;
      option.textContent = category;
      elements.category.appendChild(option);
    });

    elements.category.value = categories.includes(current) ? current : "";
  }

  function applyFilters() {
    try {
      const [, jurisdiction] = selectedJurisdiction();
      const search = normaliseText(elements.search.value);
      const category = elements.category.value;

      const groups = jurisdiction.groups
        .filter((group) => !category || group.title === category)
        .map((group) => {
          const items = group.items.filter((item) => {
            if (!search) {
              return true;
            }

            return normaliseText([
              group.title,
              item.name,
              item.type,
              item.description
            ].join(" ")).includes(search);
          });

          return {
            title: group.title,
            items
          };
        })
        .filter((group) => group.items.length > 0);

      const total = jurisdiction.groups.reduce(
        (sum, group) => sum + group.items.length,
        0
      );

      const visible = groups.reduce(
        (sum, group) => sum + group.items.length,
        0
      );

      renderResults(jurisdiction, groups, visible, total);
    } catch (error) {
      console.error("Unable to render legal resources:", error);
      showError();
    }
  }

  function renderResults(jurisdiction, groups, visible, total) {
    elements.loading.classList.add("hidden");
    elements.error.classList.add("hidden");

    // The selected jurisdiction is the results heading so users always know
    // which legal system they are viewing, including after filtering.
    elements.heading.textContent = jurisdiction.name;

    elements.count.textContent =
      visible === total
        ? `${total} curated resources`
        : `${visible} of ${total} curated resources`;

    if (!visible) {
      elements.list.replaceChildren();
      elements.empty.classList.remove("hidden");
      return;
    }

    elements.empty.classList.add("hidden");

    elements.list.innerHTML = `
      <div class="resources-context">
        <p>${escapeHtml(jurisdiction.intro)}</p>
      </div>

      <div class="canonical-section-list resource-group-list">
        ${groups.map((group, index) => renderGroup(group, index)).join("")}
      </div>

      <aside class="resources-disclaimer" aria-label="Resource information">
        <strong>Check the source before relying on it.</strong>
        <span>
          Vacatory links to external resources for research and orientation.
          Always check the source itself for the latest law, rules, deadlines
          and professional requirements.
        </span>
      </aside>
    `;
  }

  function renderGroup(group, index) {
    const headingId = `resource-group-${index + 1}`;

    return `
      <section class="canonical-section-group resource-group" aria-labelledby="${headingId}">
        <div class="canonical-section-header resource-group-header">
          <h3 id="${headingId}" class="canonical-section-title resource-group-title">${escapeHtml(group.title)}</h3>
          <span class="canonical-section-count resource-group-count" aria-label="${group.items.length} resources">${group.items.length}</span>
        </div>

        <div class="canonical-section-items resource-list">
          ${group.items.map(renderResource).join("")}
        </div>
      </section>
    `;
  }

  function renderResource(item) {
    const safeUrl = safeExternalUrl(item.url);
    const linkMarkup = safeUrl
      ? `<a
          class="resource-link"
          href="${escapeHtml(safeUrl)}"
          target="_blank"
          rel="noopener noreferrer"
        >
          Visit resource
          <span aria-hidden="true">↗</span>
          <span class="sr-only">(opens in a new tab)</span>
        </a>`
      : "";

    return `
      <article class="canonical-section-item resource-row">
        <div class="resource-copy">
          <div class="resource-name-line">
            <h4 class="resource-name">${escapeHtml(item.name)}</h4>
            <span class="canonical-meta-chip resource-type">${escapeHtml(item.type)}</span>
          </div>

          <p class="resource-description">${escapeHtml(item.description)}</p>
        </div>

        ${linkMarkup}
      </article>
    `;
  }

  function clearFilters() {
    elements.search.value = "";
    elements.jurisdiction.value = DEFAULT_JURISDICTION;
    populateCategoryOptions();
    elements.category.value = "";
    applyFilters();
    elements.search.focus();
  }

  function showError() {
    elements.loading?.classList.add("hidden");
    elements.empty?.classList.add("hidden");
    elements.error?.classList.remove("hidden");

    if (elements.count) {
      elements.count.textContent = "The legal resource library could not be loaded.";
    }
  }

  function safeExternalUrl(value) {
    try {
      const url = new URL(String(value || ""));

      if (url.protocol !== "https:" && url.protocol !== "http:") {
        return "";
      }

      return url.href;
    } catch {
      return "";
    }
  }

  function normaliseText(value) {
    return String(value || "").trim().toLowerCase();
  }

  function escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  document.addEventListener("DOMContentLoaded", initialiseResources);
})();
