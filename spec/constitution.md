# Project Constitution: Jira/Confluence Automation

## Project Context

Build an internal sprint-progress web application for the Team ROL13 WebApp team. The initial product scope is an at-a-glance view of current sprint issue status and historical velocity for a single Scrum board. The team has 9 people and uses one-week sprints.

## Scope Decision

This constitution adopts the requested custom web application stack: React 18 with Vite, Node.js with Express, PostgreSQL 15, and Docker. This supersedes the Module 08 specification's native-Jira-dashboard-only approach and its assumption that no custom application or database is needed. Reconcile `project_spec.md` with this architecture before implementation begins.

## Core Principles

### 1. Jira Is the Source of Truth

- Read sprint, issue status, and story-point data from Jira through its REST API.
- Do not silently change Jira issues or workflows; this application is initially read-only.
- Preserve Jira issue keys and link displayed records back to their Jira issue pages.
- Treat missing or inconsistent story-point data as unavailable; do not infer estimates or velocity.

### 2. Protect Credentials and Data

- Keep Jira credentials on the Express backend; never expose tokens to React/browser code.
- Load secrets from environment variables or an approved secret store; never commit secrets or write them to logs.
- Request only the Jira permissions needed for read-only sprint reporting.
- Validate and constrain all API inputs; do not allow a client-supplied URL to become an unrestricted server-side request.

### 3. Keep the Initial Product Focused

- Support one configured Scrum board: Team ROL13.
- The first release shows an issue status breakdown for the active sprint and a velocity chart across recent sprints.
- Do not add burndown, blocked-issue tracking, created-versus-resolved trends, multi-board rollups, scheduled jobs, or external stakeholder sharing without an approved specification change.

### 4. Keep Clear Application Boundaries

- React 18 and Vite provide the user interface and communicate only with the Express API.
- Express owns Jira authentication, Jira API calls, validation, error handling, and response shaping.
- PostgreSQL 15 stores only data the application needs to persist, such as board configuration or explicitly justified cached snapshots; Jira remains authoritative for Jira-owned data.
- Use Docker for reproducible local development of the application and PostgreSQL; keep secrets outside images and source control.

### 5. Make Data Freshness and Failures Visible

- Show when Jira data was last fetched and identify the selected board and sprint.
- Handle Jira authentication failures, rate limits, unavailable services, and incomplete sprint data with clear user-facing messages.
- Do not present stale or partial data as current; expose its freshness or mark it unavailable.
- Avoid background polling or scheduled refresh unless a later specification requires it; refresh on page load or explicit user action.

### 6. Verify Behavior with Automated Tests

- Unit-test calculations, data mapping, input validation, and error handling.
- Integration-test Express routes using mocked Jira API responses and an isolated test database where needed.
- Test the UI for loading, success, empty, stale, and error states.
- Never require production Jira credentials for automated tests.
- A feature is complete only when its acceptance criteria are met and its relevant tests pass.

### 7. Maintainability and Accessibility

- Use consistent formatting, linting, and type checking for JavaScript/TypeScript code.
- Keep modules focused and interfaces explicit; avoid abstractions without a concrete need.
- Provide accessible labels, keyboard navigation, readable contrast, and clear chart legends.
- Document environment variables, local Docker setup, database migrations, and Jira permission requirements.

## Technology Baseline

- Frontend: React 18 + Vite.
- Backend: Node.js + Express.
- Database: PostgreSQL 15.
- Local infrastructure: Docker.
- Jira integration: read-only Jira REST API access for Team ROL13 sprint and issue data.

## Change Governance

- Update the project specification and this constitution when product scope, data handling, or architecture changes.
- Record new integrations, data persistence, permissions, or external sharing in the specification before implementation.
- Prefer the smallest implementation that satisfies approved acceptance criteria.
