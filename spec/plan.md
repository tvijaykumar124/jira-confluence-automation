# Implementation Plan: Jira Sprint Progress Dashboard

**Branch**: `not created — planning phase` | **Date**: 2026-10-09 | **Spec**: [`specification.md`](specification.md)

**Input**: Feature specification in `spec/specification.md` and project principles in `spec/constitution.md`.

## Summary

Build an internal, read-only sprint-progress web application for the Team ROL13 WebApp team. The app will show active-sprint issue counts by Jira status and committed-versus-completed velocity across recent sprints. React 18/Vite will provide the UI; Node.js/Express will broker Jira REST API requests; PostgreSQL 15 will persist only explicitly approved application data; Docker will provide a repeatable local environment.

## Technical Context

- **Language/Version**: React 18; Node.js version and JavaScript-versus-TypeScript choice are **NEEDS CLARIFICATION**.
- **Primary Dependencies**: Vite, Express, PostgreSQL driver and charting library to be selected during design.
- **Storage**: PostgreSQL 15 in Docker; exact persisted data is **NEEDS CLARIFICATION**. Jira remains the source of truth for issues, sprints, statuses, and estimates.
- **Testing**: Test framework and browser-test framework are **NEEDS CLARIFICATION**; tests must use mocked Jira responses and must not require production credentials.
- **Target Platform**: Modern desktop browser for internal team use; local development on Windows through Docker Desktop.
- **Project Type**: Single-repository web application with separate frontend and backend applications.
- **Performance Goals**: **NEEDS CLARIFICATION** for page-load and refresh targets; the UI must show data freshness and must not label stale data as current.
- **Constraints**: Read-only Jira access; single Scrum board (Team ROL13); one-week sprints; no scheduled polling, external stakeholder access, or out-of-scope charts in v1.
- **Scale/Scope**: One team of 9 people, one configured Jira board, active sprint status, and a configurable number of recent completed sprints.

## Constitution Check

### Gate 1 — Before Research

- Keep Jira as the authoritative source and use read-only API permissions.
- Keep Jira credentials on the backend and outside source control, browser code, logs, and Docker images.
- Keep v1 limited to one board, status breakdown, and velocity chart.
- Use explicit loading, empty, stale, and error states; do not invent missing estimates.

**Result**: Pass, subject to resolving the open decisions below before implementation details are locked.

### Gate 2 — After Design

- Verify the API contract cannot write Jira issues or workflows.
- Verify the database stores only data justified by approved requirements.
- Verify test plans cover success, empty, stale, and failure states without production credentials.
- Verify the dashboard is restricted to the requester and Team ROL13 team.

**Result**: Pending Phase 1 design review.

## Project Structure

### Documentation

```text
spec/
├── constitution.md
├── specification.md
└── plan.md
```

### Source Code (proposed)

```text
frontend/
├── src/
│   ├── components/
│   │   ├── StatusBreakdown.jsx
│   │   └── VelocityChart.jsx
│   ├── services/apiClient.js
│   ├── App.jsx
│   └── main.jsx
└── tests/

backend/
├── src/
│   ├── config/
│   ├── routes/dashboard.js
│   ├── services/jiraClient.js
│   ├── services/dashboardService.js
│   └── server.js
└── tests/

database/
└── migrations/   # Add only if approved persistent data requires a schema

docker-compose.yml
.env.example
.gitignore
```

**Structure Decision**: Keep frontend and backend in one repository with separate directories. Do not add a shared package or database schema until concrete reuse or persistence requirements justify them.

## Phases and Milestones

### Phase 0 — Resolve Inputs and Research

- [ ] Confirm the Jira project key and stable board ID for Team ROL13.
- [ ] Confirm the Jira REST API authentication method and obtain an approved read-only service identity.
- [ ] Identify the Jira story-point field and verify recent sprints contain usable estimates.
- [ ] Decide how many completed sprints the velocity chart should show.
- [ ] Decide whether PostgreSQL stores board configuration, cached snapshots, or no product data; do not duplicate Jira records without a documented need.
- [ ] Define the application access-control method for the requester and Team ROL13 group.
- [ ] Set measurable page-load/refresh targets and a method/threshold for collecting visibility feedback.

**Milestone M0**: Open questions are answered or explicitly deferred with an owner; Jira board and read permissions are verified.

### Phase 1 — Design and Contracts

- [ ] Document the Jira data mapping for board, sprint, issue status, and story points.
- [ ] Define read-only backend API contracts for active-sprint status, velocity history, refresh metadata, and error responses.
- [ ] Define frontend states for loading, data available, empty sprint, incomplete estimates, stale data, and Jira/API failure.
- [ ] Decide the minimum PostgreSQL schema, or document why no schema is needed for v1.
- [ ] Review the design against Constitution Gate 2.

**Milestone M1**: Data mapping and API contracts are reviewed; no credential, write-access, or persistence decision remains implicit.

### Phase 2 — Foundation and Local Environment

- [ ] Create `frontend/` and `backend/` application scaffolds using the approved language version.
- [ ] Add Docker Compose configuration for PostgreSQL 15 and the local application services.
- [ ] Add `.env.example` containing variable names and safe placeholders only.
- [ ] Add backend configuration validation that fails clearly when required Jira settings are missing.
- [ ] Add health/readiness checks for the backend and database connection if PostgreSQL is required at startup.
- [ ] Document local start, stop, and reset commands.

**Milestone M2**: A developer can start the local stack from documented commands without committed secrets.

### Phase 3 — Jira Backend Integration

- [ ] Implement a backend-only Jira REST client with timeouts and safe error handling.
- [ ] Implement read-only retrieval of the active sprint and its issues for the configured Team ROL13 board.
- [ ] Implement retrieval of recent completed sprints and their committed/completed story points.
- [ ] Normalize Jira statuses and estimates without fabricating missing values.
- [ ] Add API routes for status breakdown, velocity data, and refresh timestamp.
- [ ] Handle authentication failure, forbidden board access, rate limiting, unavailable Jira, empty results, and partial data.
- [ ] Add unit and integration tests using mocked Jira responses.

**Milestone M3**: Backend contracts return correct mapped data and predictable errors using mock tests; a credentialed read-only smoke test succeeds when approved credentials are available.

### Phase 4 — Dashboard Frontend

- [ ] Build the dashboard shell with the Team ROL13 board and active-sprint context visible.
- [ ] Build the status breakdown from backend-provided issue counts grouped by Jira status.
- [ ] Build the velocity chart from committed/completed story-point totals by sprint.
- [ ] Display the last-fetched timestamp and provide an explicit refresh control.
- [ ] Implement loading, empty, missing-estimate, stale, and error states.
- [ ] Add accessible chart labels, legends, keyboard access, and readable contrast.
- [ ] Add component and UI tests for each required state.

**Milestone M4**: Both charts render accurately from fixtures, and all defined frontend states are verified.

### Phase 5 — Integration, Security, and End-to-End Verification

- [ ] Connect the React client only to the Express API; confirm the browser receives no Jira credentials.
- [ ] Verify Jira credentials are loaded from local environment/approved secret storage and redacted from logs.
- [ ] Verify access is limited to the requester and Team ROL13 group using the approved auth design.
- [ ] Run end-to-end tests for dashboard load, refresh, empty sprint, missing story points, and Jira/API failures.
- [ ] Verify displayed counts and velocity match source Jira fixtures exactly.
- [ ] Confirm unsupported views (burndown, blocked issues, cross-project rollups) are absent from v1.

**Milestone M5**: Security and acceptance checks pass; no credentials are exposed and dashboard data matches test source data.

### Phase 6 — Pilot, Documentation, and Acceptance

- [ ] Run the dashboard through one full one-week sprint with the Team ROL13 team.
- [ ] Review the dashboard in two consecutive weekly team reviews.
- [ ] Collect team feedback using the method and threshold defined in Phase 0.
- [ ] Resolve or document issues found during the pilot.
- [ ] Document setup, Jira permissions, environment variables, Docker commands, and troubleshooting.
- [ ] Confirm the dashboard is shared only with the requester and Team ROL13 team.

**Milestone M6**: The dashboard has been used in two consecutive weekly reviews and the agreed visibility success measure is met.

## Dependencies and Risks

- Work is blocked until the Jira board ID/project key, read-only access method, and story-point field are confirmed.
- The velocity chart will be incomplete or unavailable if Jira lacks consistent story-point estimates or historical sprint data.
- Authentication for application users is not yet specified; do not expose the internal dashboard until access control is selected and implemented.
- PostgreSQL adds operational complexity while the original product scope is live Jira data; its persistence purpose must be justified at M0/M1.
- The React/Node/PostgreSQL/Docker architecture supersedes the original Module 08 native-dashboard approach; both specification and constitution must remain aligned.

## Complexity Tracking

| Potential complexity | Justification / decision gate | Simpler alternative |
|---|---|---|
| PostgreSQL database | Required by the requested stack; retain only if Phase 0 identifies data that must persist | Keep Jira as sole data source and use no database for v1 |
| Separate React and Express applications | Required by the requested stack and clear browser/backend credential boundary | Use a native Jira dashboard, which conflicts with the updated stack decision |
| Cached Jira snapshots | Not approved; add only if a measured latency, rate-limit, or historical-data need is established | Fetch current data on page load or explicit refresh |
