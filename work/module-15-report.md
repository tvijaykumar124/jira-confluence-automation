# Module 15 Completion Report

## Script Metadata
- Filename: instructions/automate-jira-report/scripts/bulk_format_jira_reports.py
- Language: Python
- Purpose: Processes multiple JSON files containing Jira issue arrays and converts each file into a categorized Markdown status report.

## Script Contents
```python
"""Format every matching Jira issue JSON file in a directory as Markdown."""

import argparse
import json
from pathlib import Path

from format_jira_report import format_report


def process_files(input_dir, output_dir, pattern):
    output_dir.mkdir(parents=True, exist_ok=True)
    generated_files = []
    for input_path in sorted(input_dir.glob(pattern)):
        issues = json.loads(input_path.read_text(encoding="utf-8"))
        if not isinstance(issues, list):
            raise ValueError(f"Input must be a JSON array: {input_path}")
        output_path = output_dir / f"{input_path.stem}.md"
        output_path.write_text(format_report(issues), encoding="utf-8")
        generated_files.append(output_path)
    return generated_files


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input-dir", required=True, help="Directory containing Jira JSON files")
    parser.add_argument("--output-dir", required=True, help="Directory for generated Markdown files")
    parser.add_argument("--pattern", default="*.json", help="Input filename pattern")
    arguments = parser.parse_args()

    generated_files = process_files(
        Path(arguments.input_dir),
        Path(arguments.output_dir),
        arguments.pattern,
    )
    print(f"Processed {len(generated_files)} file(s).")
    for output_path in generated_files:
        print(f"- {output_path}")


if __name__ == "__main__":
    main()
```

## Parameters
| Parameter | Description | Default |
|-----------|-------------|---------|
| `--input-dir` | Directory containing Jira JSON files. | Required |
| `--output-dir` | Directory where generated Markdown files are written. | Required |
| `--pattern` | Glob pattern used to select input files. | `*.json` |

## Test Run Output
Command:
```text
python instructions/automate-jira-report/scripts/bulk_format_jira_reports.py --input-dir work/module15-test/input --output-dir work/module15-test/output
```

Output:
```text
Processed 2 file(s).
- work\module15-test\output\sprint-alpha.md
- work\module15-test\output\sprint-beta.md
```