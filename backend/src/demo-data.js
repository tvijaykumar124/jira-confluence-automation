export const dashboardDemo = {
  mode: "demo",
  sourceLabel: "Illustrative sample data; not connected to Jira",
  board: {
    key: "ROL13",
    name: "Team ROL13",
  },
  sprint: {
    name: "Active sprint",
    length: "1 week",
  },
  statusBreakdown: [
    { status: "Done", count: 14 },
    { status: "In Progress", count: 8 },
    { status: "To Do", count: 5 },
  ],
  velocity: [
    { sprint: "Sprint 18", committed: 28, completed: 24 },
    { sprint: "Sprint 19", committed: 30, completed: 27 },
    { sprint: "Sprint 20", committed: 32, completed: 29 },
    { sprint: "Sprint 21", committed: 34, completed: 21 },
  ],
};
