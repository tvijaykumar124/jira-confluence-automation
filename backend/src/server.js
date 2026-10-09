import express from "express";
import { dashboardDemo } from "./demo-data.js";

const app = express();
const port = Number(process.env.PORT ?? 3001);

app.disable("x-powered-by");
app.get("/healthz", (_request, response) => {
  response.json({ status: "ok", mode: "demo" });
});

app.get("/api/dashboard", (_request, response) => {
  response.set("Cache-Control", "no-store").json({
    ...dashboardDemo,
    fetchedAt: new Date().toISOString(),
  });
});

app.listen(port, "127.0.0.1", () => {
  console.log(`Demo API listening at http://127.0.0.1:${port}`);
});
