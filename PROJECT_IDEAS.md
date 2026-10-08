# Project Ideas: Jira/Confluence Automation

## 1. Automated Stale Ticket Escalation

**Problem it solves:** Tickets sit in "In Progress" or "Blocked" status for weeks without anyone noticing, causing missed deadlines and surprise status-update requests right before releases. Managers currently rely on manually scanning boards to catch this.

**Data needed:**
- Jira issue status and the timestamp of the last status transition (via Jira's changelog/history API)
- Issue priority and due date
- Assignee and reporting manager mapping
- A configurable staleness threshold per status (e.g., 5 business days for "In Progress", 2 days for "Blocked")

**How it would work:** A scheduled job queries Jira for issues exceeding the threshold, then posts a comment tagging the assignee, sends a Slack/email notification to the manager, and optionally adds a "stale" label for visibility on the board.

## 2. Release Notes Generator from Jira to Confluence

**Problem it solves:** Before each release, someone manually compiles a list of completed tickets, rewrites titles into customer-friendly language, and formats a Confluence page. This is repetitive and error-prone, and tickets are sometimes missed.

**Data needed:**
- Jira issues filtered by fixVersion/release and status = Done
- Issue type (Bug, Story, Task) to group notes into sections
- Issue summary and a "customer-facing description" custom field (if available) or the summary as fallback
- Target Confluence space and parent page ID for publishing

**How it would work:** Triggered manually or on release-version creation, the automation pulls matching issues, groups them by type, formats them into a release notes template, and publishes or updates a Confluence page under the release's documentation space.

## 3. Cross-Project Dependency Dashboard

**Problem it solves:** When multiple teams work on interdependent epics (e.g., "Team A's API" blocking "Team B's feature"), managers lack a single view of which dependencies are at risk, leading to late-stage surprises during planning or status meetings.

**Data needed:**
- Jira issue links of type "blocks"/"is blocked by" across projects
- Linked issue status, due date, and assignee team/project
- Epic/initiative grouping to roll dependencies up to a program level

**How it would work:** A scheduled automation traverses issue links to build a dependency graph, flags any blocking issue that is overdue or unassigned, and publishes a summary table to a Confluence dashboard page (or posts a digest to a manager's Slack channel) highlighting at-risk dependencies.
