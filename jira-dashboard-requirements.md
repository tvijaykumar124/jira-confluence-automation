# Jira Sprint Dashboard — Requirements Document

## Overview
A dashboard to give visibility into the team's sprint progress, built as a native Jira dashboard.

## Requirements

### Platform
- **Native Jira Dashboard** — chosen for fast setup with no custom development required.

### Scope
- **Single board/project** — the dashboard covers one team's board.

### Metrics / Gadgets
- **Issue status breakdown** — visual of current issue counts by status (To Do / In Progress / Done).
- **Velocity chart** — story points completed per sprint, to track trends and forecast capacity.

### Audience
- **Internal use** — just the requester and their team. No external stakeholder sharing required at this stage.

### Review Cadence
- **Weekly** — reviewed in alignment with the team's sprint cadence. Gadgets refresh live, so no manual update process is needed.

## Out of Scope (for now)
- Multi-board/cross-project views
- Sprint burndown chart
- Blocked/flagged issue tracking
- Created vs. resolved trend chart
- Sharing with stakeholders who lack Jira access

## Next Steps
1. Create a new Jira dashboard scoped to the team's board.
2. Add an **Issue status breakdown** gadget (e.g., Two Dimensional Filter Statistics, grouped by Status) filtered to the active sprint.
3. Add a **Velocity Chart** gadget pointed at the same board.
4. Set sharing permissions to the team's Jira group only.
5. Review weekly alongside sprint check-ins.
