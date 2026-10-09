# Jira Sprint Progress Dashboard — Task Breakdown

Source: [specification.md](specification.md) and [plan.md](plan.md)

## Phase 0 — Resolve Inputs and Research

- [ ] **T001 — Confirm Jira project and board identifiers.** Record the Team ROL13 project key and stable Scrum board ID.  
  **Acceptance:** The approved project key and board ID are recorded in project configuration documentation.
- [ ] **T002 — Confirm Jira authentication.** Select the backend authentication method and approved read-only service identity.  
  **Acceptance:** A successful read-only Jira request is demonstrated without exposing credentials to the browser, logs, or repository.
- [ ] **T003 — Confirm story-point mapping.** Identify the Jira field used for story-point estimates and inspect sample historical sprint data.  
  **Acceptance:** The exact field and treatment of missing/inconsistent estimates are documented; no estimates are inferred.
- [ ] **T004 — Set velocity history range.** Decide how many completed sprints the chart should show.  
  **Acceptance:** A positive sprint count is approved and recorded in the specification.
- [ ] **T005 — Decide PostgreSQL persistence scope.** Identify which settings or snapshots need persistence, or document that no product data is stored.  
  **Acceptance:** Each persisted entity has a stated purpose; Jira-owned issue and sprint data remain authoritative.
- [ ] **T006 — Define application access control.** Select how access is restricted to the requester and Team ROL13 team.  
  **Acceptance:** The selected mechanism and authorization rule are documented before exposing the dashboard.
- [ ] **T007 — Set measurable service and feedback targets.** Define refresh/page-load expectations and the feedback collection method and threshold.  
  **Acceptance:** Targets and the SC-003 feedback threshold are added to the specification.

**Milestone M0:** T001–T007 are resolved or explicitly deferred with an owner; board access and read permissions are verified.

## Phase 1 — Design and Contracts

- [ ] **T008 — Document Jira data mapping.** Map board, sprint, issue, status, and story-point fields to application concepts.  
  **Acceptance:** The mapping names source fields and specifies behavior for missing or unknown values.
- [ ] **T009 — Define dashboard API contracts.** Specify request/response shapes for status breakdown, velocity history, refresh metadata, and errors.  
  **Acceptance:** Contracts cover successful, empty, partial, unauthorized, rate-limited, and unavailable-Jira responses.
- [ ] **T010 — Define UI state contracts.** Specify loading, success, empty, incomplete-estimate, stale, and error behavior.  
  **Acceptance:** Each state has a clear user-visible message and cannot be mistaken for current complete data.
- [ ] **T011 — Design persistence and migrations.** Create a minimal schema only for approved persistent data.  
  **Acceptance:** Every table/field traces to T005; otherwise document why no application schema is needed.
- [ ] **T012 — Review the design against the constitution.** Check read-only access, secret handling, scope, accessibility, and tests.  
  **Acceptance:** Constitution Gate 2 is recorded as pass or lists approved, bounded exceptions.

**Milestone M1:** Data mappings and contracts are approved; access, credential, and persistence decisions are explicit.

## Phase 2 — Foundation and Local Environment

- [ ] **T013 — Scaffold the React 18/Vite frontend.** Create the frontend app, entry point, scripts, and test location.  
  **Acceptance:** The frontend starts locally and renders a minimal app shell using the selected Node.js version.
- [ ] **T014 — Scaffold the Node.js/Express backend.** Create the server entry point, routing structure, and test location.  
  **Acceptance:** The backend starts locally and serves a health endpoint.
- [ ] **T015 — Add Docker Compose for PostgreSQL 15.** Configure the database service and health check.  
  **Acceptance:** The database starts and reports healthy with documented local commands.
- [ ] **T016 — Add safe environment configuration.** Create `.env.example` and backend configuration validation.  
  **Acceptance:** Required settings fail fast with actionable messages; the example contains placeholders only and no real secrets are committed.
- [ ] **T017 — Add service readiness behavior.** Connect backend readiness to required dependencies.  
  **Acceptance:** Health/readiness output distinguishes the API process from unavailable required database dependencies.
- [ ] **T018 — Document local development commands.** Record install, start, stop, reset, and test commands.  
  **Acceptance:** A developer can follow the documentation from a clean checkout without undocumented setup steps.

**Milestone M2:** The documented local stack starts successfully and contains no committed credentials.

## Phase 3 — Jira Backend Integration

- [ ] **T019 — Implement the server-only Jira client.** Centralize authentication, base URL, timeouts, and request handling.  
  **Acceptance:** Credentials are attached only on backend requests; timeout and Jira error responses are normalized.
- [ ] **T020 — Retrieve the active sprint and issues.** Query only the configured Team ROL13 board using read-only Jira endpoints.  
  **Acceptance:** A mocked response produces the expected active sprint and issue records; no Jira write endpoint is called.
- [ ] **T021 — Retrieve completed sprint velocity data.** Fetch the approved history range and committed/completed story points.  
  **Acceptance:** Returned data contains one entry per selected sprint and preserves missing estimates as unavailable.
- [ ] **T022 — Normalize Jira status and estimate values.** Map source values without losing unknown statuses or fabricating estimates.  
  **Acceptance:** Unit tests cover known statuses, unknown statuses, missing points, and inconsistent point data.
- [ ] **T023 — Implement dashboard API routes.** Add status, velocity, and refresh-time routes from T009.  
  **Acceptance:** Route responses match the approved contracts and do not expose Jira credentials or raw sensitive configuration.
- [ ] **T024 — Handle Jira failure modes.** Add clear handling for auth failure, forbidden access, rate limits, outages, empty data, and partial responses.  
  **Acceptance:** Each failure mode maps to a documented status/response and actionable safe message.
- [ ] **T025 — Test the Jira integration with mocks.** Create representative fixtures and route/service tests.  
  **Acceptance:** Tests run without production Jira credentials and verify counts and velocity against fixture values.

**Milestone M3:** Mocked backend tests pass and the authorized read-only Jira smoke test succeeds.

## Phase 4 — Dashboard Frontend

- [ ] **T026 — Build the dashboard shell.** Show Team ROL13 and active-sprint context.  
  **Acceptance:** Board and sprint context are visible and consistent with API data.
- [ ] **T027 — Build the active-sprint status breakdown.** Group issue counts by Jira status.  
  **Acceptance:** Counts match API fixtures, including empty-sprint behavior.
- [ ] **T028 — Build the velocity chart.** Plot committed and completed story points by sprint.  
  **Acceptance:** Chart values match fixtures and incomplete estimates are visibly marked unavailable.
- [ ] **T029 — Add freshness and manual refresh UI.** Display last-fetched time and allow explicit refresh.  
  **Acceptance:** Refresh retrieves new data and updates the timestamp; no scheduled polling occurs.
- [ ] **T030 — Implement frontend loading and failure states.** Cover loading, empty, incomplete estimates, stale data, and API/Jira errors.  
  **Acceptance:** Each state is distinguishable and stale data is never presented as current.
- [ ] **T031 — Meet accessibility requirements.** Add labels, chart legends, keyboard access, and readable contrast.  
  **Acceptance:** Core dashboard interactions are keyboard-accessible and charts have text labels/legends.
- [ ] **T032 — Test frontend components and states.** Add tests for both charts and each required UI state.  
  **Acceptance:** Tests pass with mocked API data and cover success, empty, and error scenarios.

**Milestone M4:** Both charts and all specified UI states pass frontend tests using fixtures.

## Phase 5 — Integration, Security, and End-to-End Verification

- [ ] **T033 — Connect the React client only to Express APIs.** Remove any direct Jira calls from browser code.  
  **Acceptance:** Browser network inspection shows application API calls only; no Jira token or direct Jira API request is present.
- [ ] **T034 — Secure secrets and logs.** Load Jira credentials from approved environment/secret storage and redact sensitive values.  
  **Acceptance:** Automated checks and manual log review find no credentials in source, browser bundles, or logs.
- [ ] **T035 — Implement approved team access control.** Restrict the dashboard to the requester and Team ROL13 group.  
  **Acceptance:** Authorized users can access the dashboard; unauthorized users receive the agreed denial response.
- [ ] **T036 — Run end-to-end acceptance tests.** Verify dashboard load, refresh, empty sprint, missing points, auth failure, and Jira outage.  
  **Acceptance:** All scenarios pass in the test environment using non-production credentials or mocks.
- [ ] **T037 — Verify data parity.** Compare displayed status counts and velocity totals with source fixtures/API responses.  
  **Acceptance:** Values match exactly, and absent source values remain unavailable rather than fabricated.
- [ ] **T038 — Verify v1 scope boundaries.** Confirm excluded views and multi-board behavior are absent.  
  **Acceptance:** No burndown, blocked-issue, created-versus-resolved, cross-board, or external-sharing feature is exposed.

**Milestone M5:** Security, end-to-end, and source-data parity checks pass.

## Phase 6 — Pilot, Documentation, and Acceptance

- [ ] **T039 — Run one full one-week sprint pilot.** Use the Team ROL13 team and collect operational issues.  
  **Acceptance:** The dashboard remains usable throughout the sprint and pilot findings are recorded.
- [ ] **T040 — Use the dashboard in two consecutive weekly reviews.**  
  **Acceptance:** Both review dates and dashboard usage are recorded.
- [ ] **T041 — Collect and evaluate team feedback.** Apply the method and threshold defined in T007.  
  **Acceptance:** Feedback results are recorded and the approved success threshold is evaluated.
- [ ] **T042 — Resolve or disposition pilot findings.** Fix accepted issues or record owner and follow-up for deferred items.  
  **Acceptance:** No untracked pilot issue blocks v1 acceptance.
- [ ] **T043 — Complete operational documentation.** Document local setup, Jira permissions, environment variables, Docker, migrations, and troubleshooting.  
  **Acceptance:** A new developer can set up the app by following the docs; secrets are not included.
- [ ] **T044 — Verify final sharing permissions.** Confirm only requester and Team ROL13 team have access.  
  **Acceptance:** Permission configuration is inspected and recorded.

**Milestone M6:** The dashboard is used in two consecutive weekly reviews and meets the agreed success measures.
