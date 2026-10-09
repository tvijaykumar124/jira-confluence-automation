# AI Hands-On

A workspace for hands-on AI experiments and learning projects.

## Folder structure

```text
AI Hands-On/
├── data/       # Datasets and other input files
├── scripts/    # Scripts for experiments and data processing
└── README.md   # Project overview and usage notes
```

Add project-specific instructions and experiment notes here as the workspace grows.

# jira-confluence-automation

## Sprint Dashboard Prototype

The React/Vite frontend and Express backend currently run in demo mode with clearly labeled sample data; they are not connected to Jira, and PostgreSQL persistence is not wired pending the decision in `spec/plan.md` T005.

After installing Node.js and npm, start the API and frontend in separate terminals:

```powershell
cd backend
npm install
npm run dev
```

```powershell
cd frontend
npm install
npm run dev
```

Open `http://127.0.0.1:5173`. The Vite development server proxies `/api` requests to the Express API at `http://127.0.0.1:3001`.
