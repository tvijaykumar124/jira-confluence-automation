import { useEffect, useState } from "react";

const numberFormat = new Intl.NumberFormat("en-US");

function App() {
  const [dashboard, setDashboard] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  async function loadDashboard() {
    setLoading(true);
    setError("");

    try {
      const response = await fetch("/api/dashboard");
      if (!response.ok) {
        throw new Error(`Dashboard API returned ${response.status}.`);
      }
      setDashboard(await response.json());
    } catch (requestError) {
      setError(requestError.message || "Could not load sprint data.");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void loadDashboard();
  }, []);

  const statusTotal = dashboard?.statusBreakdown.reduce(
    (total, item) => total + item.count,
    0,
  ) ?? 0;
  const committedTotal = dashboard?.velocity.reduce(
    (total, sprint) => total + sprint.committed,
    0,
  ) ?? 0;
  const completedTotal = dashboard?.velocity.reduce(
    (total, sprint) => total + sprint.completed,
    0,
  ) ?? 0;
  const maxVelocity = Math.max(
    1,
    ...(dashboard?.velocity.flatMap((sprint) => [sprint.committed, sprint.completed]) ?? [1]),
  );
  const completionRate = committedTotal
    ? Math.round((completedTotal / committedTotal) * 100)
    : 0;
  const fetchedAt = dashboard?.fetchedAt
    ? new Date(dashboard.fetchedAt).toLocaleString()
    : "Not available";

  return (
    <div className="app-shell">
      <header className="topbar">
        <a className="brand" href="#overview" aria-label="Team ROL13 dashboard home">
          <span className="brand-mark" aria-hidden="true">R</span>
          <span className="brand-copy">
            <span className="brand-name">ROL13</span>
            <span className="brand-caption">ENGINEERING</span>
          </span>
        </a>
        <div className="topbar-right">
          <span className="demo-pill"><span className="demo-dot" /> DEMO DATA</span>
          <button className="refresh-button" onClick={loadDashboard} disabled={loading}>
            {loading ? "Refreshing..." : "Refresh data"}
          </button>
        </div>
      </header>

      <main id="overview" className="main-content">
        <section className="page-heading">
          <div>
            <p className="eyebrow">TEAM ROL13 <span>/</span> WEBAPP</p>
            <h1>Sprint progress</h1>
            <p className="subtitle">A weekly view of delivery, work in flight, and team capacity.</p>
          </div>
          <div className="sprint-meta">
            <span className="meta-label">SPRINT</span>
            <strong>{dashboard?.sprint.name ?? "Active sprint"}</strong>
            <span>{dashboard?.sprint.length ?? "1 week"}</span>
          </div>
        </section>

        <aside className="demo-notice" role="note">
          <span className="notice-mark" aria-hidden="true">i</span>
          <p><strong>Prototype preview.</strong> Values below are illustrative demo fixtures, not live Jira data.</p>
        </aside>

        {error && (
          <div className="error-notice" role="alert">
            <span>{error}</span>
            <button className="text-button" onClick={loadDashboard}>Retry</button>
          </div>
        )}

        <section className="metric-strip" aria-label="Sprint summary metrics">
          <div className="metric-item">
            <span className="metric-label">Issues in sprint</span>
            <strong>{loading && !dashboard ? "—" : numberFormat.format(statusTotal)}</strong>
            <span className="metric-footnote">across all statuses</span>
          </div>
          <div className="metric-item metric-complete">
            <span className="metric-label">Completed</span>
            <strong>{loading && !dashboard ? "—" : numberFormat.format(dashboard?.statusBreakdown.find((item) => item.status === "Done")?.count ?? 0)}</strong>
            <span className="metric-footnote">issues marked done</span>
          </div>
          <div className="metric-item metric-points">
            <span className="metric-label">Points delivered</span>
            <strong>{loading && !dashboard ? "—" : `${completedTotal} / ${committedTotal}`}</strong>
            <span className="metric-footnote">completed / committed</span>
          </div>
          <div className="metric-item metric-rate">
            <span className="metric-label">Recent completion</span>
            <strong>{loading && !dashboard ? "—" : `${completionRate}%`}</strong>
            <span className="metric-footnote">across displayed sprints</span>
          </div>
        </section>

        <div className="data-stamp">
          <span className="live-dot" aria-hidden="true" />
          <span>{dashboard?.sourceLabel ?? "Waiting for dashboard API"}</span>
          <span className="stamp-divider">/</span>
          <span>Fetched {fetchedAt}</span>
        </div>

        <div className="visual-grid">
          <section className="report-section status-section" aria-labelledby="status-title">
            <div className="section-heading">
              <div>
                <p className="section-kicker">CURRENT SPRINT</p>
                <h2 id="status-title">Issue status</h2>
              </div>
              <span className="section-total">{loading && !dashboard ? "—" : statusTotal} issues</span>
            </div>
            <div className="status-list">
              {(dashboard?.statusBreakdown ?? []).map((item) => {
                const percent = statusTotal ? Math.round((item.count / statusTotal) * 100) : 0;
                return (
                  <div className="status-row" key={item.status}>
                    <div className="status-row-top">
                      <span className={`status-name status-${item.status.toLowerCase().replaceAll(" ", "-")}`}>
                        <span className="status-dot" />{item.status}
                      </span>
                      <span className="status-numbers">{item.count}<span>{percent}%</span></span>
                    </div>
                    <div className="status-track" aria-label={`${item.status}: ${item.count} issues, ${percent}%`}>
                      <span
                        className={`status-fill status-${item.status.toLowerCase().replaceAll(" ", "-")}`}
                        style={{ width: `${percent}%` }}
                      />
                    </div>
                  </div>
                );
              })}
              {!loading && !error && dashboard?.statusBreakdown.length === 0 && (
                <p className="empty-state">No issues are assigned to the active sprint.</p>
              )}
              {loading && !dashboard && <p className="empty-state">Loading sprint status…</p>}
            </div>
            <div className="section-footnote">Counts are grouped by Jira issue status.</div>
          </section>

          <section className="report-section velocity-section" aria-labelledby="velocity-title">
            <div className="section-heading">
              <div>
                <p className="section-kicker">DELIVERY TREND</p>
                <h2 id="velocity-title">Sprint velocity</h2>
              </div>
              <span className="section-total">{dashboard?.velocity.length ?? 0} sprints</span>
            </div>
            <div className="chart-legend" aria-label="Chart legend">
              <span><i className="legend-swatch committed" />Committed</span>
              <span><i className="legend-swatch completed" />Completed</span>
            </div>
            <div className="velocity-chart" role="img" aria-label="Committed and completed story points by sprint">
              {(dashboard?.velocity ?? []).map((sprint) => (
                <div className="velocity-column" key={sprint.sprint}>
                  <div className="bar-pair">
                    <div className="bar bar-committed" style={{ height: `${Math.max(6, (sprint.committed / maxVelocity) * 100)}%` }} title={`Committed: ${sprint.committed} points`}>
                      <span>{sprint.committed}</span>
                    </div>
                    <div className="bar bar-completed" style={{ height: `${Math.max(6, (sprint.completed / maxVelocity) * 100)}%` }} title={`Completed: ${sprint.completed} points`}>
                      <span>{sprint.completed}</span>
                    </div>
                  </div>
                  <span className="sprint-label">{sprint.sprint}</span>
                </div>
              ))}
              {loading && !dashboard && <p className="empty-state">Loading velocity data…</p>}
            </div>
            <div className="chart-axis-note">Story points per sprint</div>
            <div className="section-footnote">Values are illustrative until Jira is connected.</div>
          </section>
        </div>
      </main>
    </div>
  );
}

export default App;
