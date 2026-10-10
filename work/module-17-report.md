# Module 17 Completion Report

## Specification Contents
```markdown
# Feature Specification: Jira Sprint Progress Dashboard

**Feature Branch**: `not created — specification phase`  
**Created**: 2026-10-09  
**Status**: Draft  
**Input**: Module 08 project specification and requested React/Node/PostgreSQL/Docker stack

## User Scenarios & Testing

### User Story 1 — Review sprint velocity (Priority: P1)

As the Engineering Manager of the Team ROL13 WebApp team, I want to compare committed and completed story points across recent one-week sprints so that I can see delivery trends during weekly reviews.

**Why this priority**: Velocity was selected as the first dashboard feature to build and helps the team understand delivery over time.

**Independent Test**: With representative sprint and story-point data available from a mocked Jira API, open the dashboard and verify the chart shows committed and completed points for each displayed sprint.

**Acceptance Scenarios**:

1. **Given** the configured Team ROL13 board is a Scrum board and Jira returns estimated sprint data, **When** the manager opens the dashboard, **Then** the velocity chart displays committed and completed story points by sprint.
2. **Given** a sprint has missing or inconsistent story-point estimates, **When** its velocity is displayed, **Then** the dashboard identifies the data as incomplete or unavailable and does not invent a value.

### User Story 2 — View active sprint status (Priority: P2)

As the Engineering Manager, I want to see the active sprint's issue counts by status so that I can understand where current work is concentrated.

**Why this priority**: A status breakdown complements the velocity trend with a current snapshot of sprint work.

**Independent Test**: With mocked active-sprint issues in To Do, In Progress, and Done states, open the dashboard and verify the status groups and counts match the source data.

**Acceptance Scenarios**:

1. **Given** the active Team ROL13 sprint contains issues in multiple statuses, **When** the manager opens the dashboard, **Then** the status breakdown shows issue counts grouped by Jira status.
2. **Given** the active sprint has no issues, **When** the dashboard loads, **Then** it displays a clear empty state rather than misleading counts.

### User Story 3 — Refresh and assess data freshness (Priority: P2)

As a dashboard user, I want to know when sprint data was last retrieved and refresh it on demand so that I can judge whether the displayed information is current.

**Why this priority**: The product goal is a live, reliable at-a-glance view without scheduled jobs.

**Independent Test**: Load the dashboard with a mocked Jira API, refresh it, and verify the displayed data and last-fetched time update.

**Acceptance Scenarios**:

1. **Given** Jira is available, **When** a user opens or refreshes the dashboard, **Then** the application retrieves current data and displays its last-fetched time.
2. **Given** Jira is unavailable or rejects authentication, **When** a user opens or refreshes the dashboard, **Then** the application shows a clear error state and does not present stale data as current.

### Edge Cases

- No active sprint is configured for the Team ROL13 board.
- The board is not a Scrum board or is inaccessible to the configured Jira account.
- Jira returns an empty issue list, an unknown status, missing story points, a rate-limit response, or a partial response.
- Jira credentials are missing, expired, or lack read permission.
- The database is unavailable during application startup or while loading persisted configuration.
- A user requests a board other than Team ROL13; multi-board support is not part of this feature.

## Requirements

### Functional Requirements

- **FR-001**: The system MUST provide an internal web dashboard for the Team ROL13 WebApp team.
- **FR-002**: The system MUST retrieve Jira sprint, issue status, and story-point data through the Jira REST API using read-only access.
- **FR-003**: The system MUST display counts of issues by Jira status for the active sprint on the configured board.
- **FR-004**: The system MUST display committed and completed story points for recent sprints on the configured Scrum board.
- **FR-005**: The system MUST identify when data was last fetched and allow refresh on page load or explicit user action; it MUST NOT require a scheduled refresh job.
- **FR-006**: The system MUST communicate through a Node.js/Express backend; Jira credentials MUST NOT be sent to or stored in browser code.
- **FR-007**: The React 18/Vite frontend MUST show clear loading, success, empty, stale, and error states.
- **FR-008**: The system MUST restrict dashboard access to the requester and the Team ROL13 team.
- **FR-009**: The system MUST use PostgreSQL 15 only for application data that needs persistence; Jira remains authoritative for Jira-owned issue and sprint data.
- **FR-010**: The system MUST support local development with Docker, including PostgreSQL 15.
- **FR-011**: The initial release MUST NOT include sprint burndown, blocked/flagged issue tracking, created-versus-resolved trends, multi-board rollups, or external stakeholder access.

### Key Entities

- **Board**: The configured Jira Scrum board for Team ROL13; its stable Jira board identifier is not yet specified.
- **Sprint**: A one-week iteration associated with the configured board, including sprint identity and lifecycle dates/state as returned by Jira.
- **Issue**: A Jira work item associated with a sprint, including issue key, summary, status, and story-point estimate when available.
- **Velocity data point**: The committed and completed story-point totals for a sprint, derived from Jira data without replacing Jira as the source of truth.
- **Application configuration**: The minimum persisted settings required to identify the board and connect to Jira; secrets are held outside the database and source control.

### Technical Constraints

- Frontend: React 18 with Vite.
- Backend: Node.js with Express.
- Database: PostgreSQL 15, run locally through Docker.
- Jira integration: Jira REST API, read-only for this dashboard.
- No custom scheduler is required; data is refreshed on page load or user request.

## Success Criteria

### Measurable Outcomes

- **SC-001**: The dashboard is used in at least two consecutive weekly team reviews.
- **SC-002**: In a representative test dataset, displayed status counts and velocity totals match the source Jira data exactly.
- **SC-003**: Team members report improved visibility into sprint health after the dashboard trial. **[NEEDS CLARIFICATION: define the feedback method and success threshold.]**

## Assumptions

- Team ROL13 is the name of a single Jira Scrum board and its data is accessible to a service account with read-only permissions.
- Jira issues use a consistent story-point field for velocity calculations.
- The dashboard is for the requester and the Team ROL13 team; external stakeholders do not need access in the initial release.
- The requested custom application stack supersedes the earlier Module 08 native-Jira-dashboard-only approach.

## Clarifications Needed

- **[NEEDS CLARIFICATION]** What is the exact Jira board ID and Jira project key for Team ROL13?
- **[NEEDS CLARIFICATION]** How should users authenticate to this internal application, and what Jira authentication method will the backend use?
- **[NEEDS CLARIFICATION]** How many completed sprints should the velocity chart display?
- **[NEEDS CLARIFICATION]** What data, if any, should PostgreSQL persist given that Jira is the source of truth and no scheduled jobs are planned?
- **[NEEDS CLARIFICATION]** What measurable feedback threshold should satisfy SC-003?
```

## Prototype Implementation
- Frontend: `frontend/src/App.jsx`, `frontend/src/main.jsx`, and `frontend/src/styles.css` provide the React 18/Vite sprint dashboard.
- Backend: `backend/src/server.js` provides Express `/api/dashboard` and `/healthz` endpoints; `backend/src/demo-data.js` supplies explicitly labeled illustrative fixture data.
- This is a demo-mode prototype; it is not connected to Jira or PostgreSQL because the board ID, authentication, and persistence decisions remain unresolved.
- Editor diagnostics report no errors. Runtime verification was not possible because Node.js, npm, and Docker are unavailable in the environment.

## Commit History
```text
3290639 (HEAD -> main) Add React sprint dashboard demo
b073e10 Add demo sprint dashboard API
ea4ae41 Add implementation plan and task backlog
bf48452 Add Spec Kit constitution and specification
6356514 Commit all current changes
32dd207 Add compound interest tool and instructions
7a856e5 Clarify status report section routing
0b089ad Add weekly status report formatting instruction
c4e1d34 Add project instructions and reports
d4f498e Add implementation backlog for Jira sprint dashboard
d972119 Add Jira sprint dashboard project specification
2c0132c Add weekly status report template
36946bf Add sprint and status report templates
e9315a8 Committing new changes
d2e29ac Committing one new change
d389253 initial commit: add README.md with project overview and folder structure
```

## Commit Count
16

## Project Files
```text
.github/copilot-instructions.md
.github/prompts/to-create-status-report.prompt.md
.gitignore
.vscode/mcp.json
.vscode/settings.json
PROJECT_IDEAS.md
README.md
TODO.md
backend/package.json
backend/src/demo-data.js
backend/src/server.js
backlog.md
calculator/main.py
calculator/operations.py
compound_interest.py
engineering-manager-sprint-status-template.md
frontend/index.html
frontend/package.json
frontend/src/App.jsx
frontend/src/main.jsx
frontend/src/styles.css
frontend/vite.config.js
hello.txt
instructions/.gitkeep
instructions/calculate-compound-interest.agent.md
instructions/create-status-report.agent.md
instructions/creating-instructions.agent.md
instructions/format-weekly-status-report.agent.md
instructions/main.agent.md
instructions/use-calculate-compound-interest.agent.md
jira-dashboard-requirements.md
jira-sprint-status-report-template.md
project_spec.md
reports/example.md
reports/instructions.md
reports/template.md
requirements.txt
spec/constitution.md
spec/plan.md
spec/specification.md
spec/tasks.md
status-report-template.md
tools/compound_interest.py
tools/mcp-demo-server.ps1
tools/mcp-echo.ps1
validation-rules.md
work/module-03-report.md
work/module-08-report.md
work/module-09-report.md
work/module-10-report.md
work/module-12-report.md
work/module-13-report.md
work/module-14-report.md
work/module-15-report.md
work/module03-task
```
