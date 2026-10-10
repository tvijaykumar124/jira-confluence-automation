# Module 18 Completion Report

## Target Application
- URL: http://127.0.0.1:5173/

## QA Findings
| # | Category | Finding | Severity | MCP Tool Used |
|---|----------|---------|----------|---------------|
| 1 | UI / data presentation | Status percentages display as 52%, 30%, and 19%, totaling 101% for 27 issues. | Low | `mcp_chrome_devtoo_take_snapshot` |
| 2 | Network / missing resource | The page requests `/favicon.ico`, which returns HTTP 404 and appears as a console error. | Low | `mcp_chrome_devtoo_list_console_messages`, `mcp_chrome_devtoo_evaluate_script` |

## MCP Tools Used
- `mcp_chrome_devtoo_list_pages`
- `mcp_chrome_devtoo_navigate_page`
- `mcp_chrome_devtoo_take_snapshot`
- `mcp_chrome_devtoo_list_console_messages`
- `mcp_chrome_devtoo_evaluate_script`
