# Project Specification: Jira Sprint Progress Dashboard

## 1. Context
- **Role:** Engineering Manager
- **Team size:** 9
- **Project type:** WebApp
- **Jira board/project:** Team ROL13
- **Sprint length:** 1 week

## 2. Problem Statement
As an Engineering Manager for a 9-person WebApp team, there is currently no lightweight, always-current view of sprint progress. Status updates require manually checking Jira issue-by-issue, which is repetitive and makes it harder to spot risks early during weekly reviews.

## 3. Goals
- Provide a live, at-a-glance view of the current sprint's health.
- Reduce manual effort spent compiling sprint status for recurring reviews.
- Keep the solution lightweight — no custom application or external system to maintain.

## 4. Scope

### In Scope
- A **native Jira Dashboard** scoped to the **Team ROL13** board.
- **Issue status breakdown** gadget — counts of issues by status (e.g., To Do / In Progress / Done) for the active sprint.
- **Velocity chart** gadget — story points completed per sprint, tracked across recent 1-week sprints.
- Sharing restricted to the requester and their team (internal use only).
- Weekly review cadence, aligned with the team's 1-week sprint cycle.

### Out of Scope
- Sprint burndown chart
- Blocked/flagged issue tracking
- Created vs. resolved trend chart
- Multi-board or cross-project views
- Sharing with stakeholders who lack Jira access

## 5. Technical Approach
1. Create a new Jira Dashboard named (e.g.) "Sprint Progress — Team ROL13."
2. Add a **Two Dimensional Filter Statistics** (or equivalent "Pie Chart") gadget:
   - Filter: active sprint on the Team ROL13 board.
   - Group by: Status.
3. Add a **Velocity Chart** gadget:
   - Source: Team ROL13 board (Scrum).
   - Shows committed vs. completed story points per sprint.
4. Set dashboard sharing permissions to the requester + Team ROL13 group only.
5. No scheduled jobs or external scripts are required — both gadgets refresh live when viewed.

## 6. Data Requirements
- Jira issue status field (standard).
- Jira sprint field / active sprint association (standard, Scrum boards).
- Story point estimates on issues (required for the velocity chart to be meaningful).

## 7. Success Criteria
- Dashboard is live and used in at least 2 consecutive weekly reviews.
- Stakeholders (team members) report improved visibility into sprint health.

## 8. Risks / Assumptions
- Assumes the Team ROL13 board is a Scrum board (Velocity Chart gadget requires Jira Software Scrum boards).
- Assumes issues are consistently estimated with story points; otherwise the velocity chart will be inaccurate or empty.
- No external stakeholder access is needed at this stage — if that changes, a different distribution method (e.g., Confluence export) will need to be scoped separately.

## 9. Open Items for Future Iterations
- Decide whether to add a blocked/flagged issues view once the core dashboard is validated.
- Evaluate need for cross-project rollup if the manager's scope expands beyond one team.
