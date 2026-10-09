# QA Report: Sprint Progress Dashboard

**Date:** 2026-10-09  
**Result:** Passed for the tested demo-mode flow, with environment and dependency caveats below.

## Scope and Environment

Tested the Module 17 React/Vite frontend and Express API locally in Chrome. The application uses illustrative fixture data; Jira and PostgreSQL are not connected. The frontend and backend were started in separate development processes after installing their npm dependencies.

Docker Compose was not started: Docker is unavailable in the environment, and the repository has no Compose configuration. This demo does not require PostgreSQL to run.

## Pages and Endpoints Visited

- `http://127.0.0.1:5173/` — dashboard start page; returned HTTP 200.
- `http://127.0.0.1:3001/healthz` — returned `status: ok`, `mode: demo`.
- `http://127.0.0.1:3001/api/dashboard` — returned the active-sprint fixture data.

## Elements and Flow Tested

- Loaded the dashboard and confirmed the page title, `Sprint progress` heading, `DEMO DATA` indicator, and prototype notice.
- Confirmed the summary metrics: 27 issues, 14 completed, 101 / 124 points delivered, and 81% recent completion.
- Confirmed the issue-status breakdown: Done 14, In Progress 8, To Do 5.
- Confirmed the sprint velocity chart renders four sprints.
- Clicked **Refresh data**. The fetched timestamp updated, the dashboard remained populated, and the button returned to its ready state.
- No forms or submit button are present in this dashboard flow.

## Errors and Bugs

- No application console errors, page errors, or failed requests were observed during the refresh interaction.
- The semantic browser click helpers timed out while waiting for the refresh button to become actionable, despite inspection showing it visible and enabled. A coordinate-based browser click successfully triggered refresh. This appeared to be an automation-helper issue; no application failure was observed.
- No application bug requiring a code fix was found in the tested flow.

## Fixes Applied

No application code fixes were made during QA. npm dependencies were installed to start the app, generating `backend/package-lock.json` and `frontend/package-lock.json`.

## Caveats and Untested Areas

- The dashboard is demo-only; Jira authentication/data integration and PostgreSQL persistence remain untested and unimplemented.
- Empty, stale, API-error, and loading-failure states were not exercised.
- `npm install` reported two frontend dependency audit findings: one moderate and one high. They were not investigated or changed during this QA run.
- Docker Compose startup remains unverified because Docker and a Compose file are unavailable.

## Current Status

The frontend and backend were running at the end of testing at `127.0.0.1:5173` and `127.0.0.1:3001`, respectively. The tested demo dashboard load and refresh flow passed.
