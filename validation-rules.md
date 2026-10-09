# File Validation Rules

Apply these checks to every file, using tools appropriate to its format:

1. **Existence and readability:** Confirm the expected file exists at the intended path and can be read or opened without truncation or corruption.
2. **Encoding and format:** For text files, check for valid UTF-8 and consistent line endings; for structured or binary files, confirm the expected format and that it can be opened by its intended tool.
3. **Syntax validity:** Parse, compile, lint, or otherwise validate syntax with the appropriate parser for the file type; report when no suitable validator is available.
4. **Required structure:** Verify required sections, fields, metadata, declarations, or schema elements are present and correctly named.
5. **References and dependencies:** Check that relative paths, imports, links, identifiers, and referenced resources resolve and point to the intended targets.
6. **Content and hygiene:** Compare content against the request and source data; check applicable formatting conventions, remove unintended temporary artifacts, and ensure secrets are not exposed.
