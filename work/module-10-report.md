# Module 10 Completion Report

## Instruction Files
```text
create-status-report.agent.md
creating-instructions.agent.md
format-weekly-status-report.agent.md
main.agent.md
```

## main.agent.md Contents
```text
- [`./instructions/create-status-report.agent.md`](./create-status-report.agent.md) — generate weekly team status reports with the agreed structure and style.
	+ Keywords: weekly status report, team update, accomplishments, blockers, next week
- [`./instructions/format-weekly-status-report.agent.md`](./format-weekly-status-report.agent.md) — format existing weekly notes or drafts into the standard report structure.
	+ Keywords: format weekly status report, format status update, polish report, reformat weekly notes
- [`./instructions/creating-instructions.agent.md`](./creating-instructions.agent.md) — create and maintain concise, reusable project instructions.
	+ Keywords: create an instruction, instruction file, update instructions, instruction catalog
```

## Sample Instruction
- File: format-weekly-status-report.agent.md
- Contents:

```text
- Use this instruction when asked to format, clean up, or reorganize weekly status notes or a draft report.
- Accept plain-text notes, bullet lists, or an existing Markdown draft as input.
- Extract only facts present in the input; preserve issue IDs, names, dates, metrics, ownership, and stated impacts accurately.
- Correct spelling and grammar, remove duplicate points, and make wording concise without changing meaning.
- Organize content under these sections in this order: Accomplishments, Blockers, Next Week.
- Put report content in bullet points; do not add prose paragraphs.
- If a section has no supplied information, ask for it or use a concise placeholder; do not assume there are no blockers.
- Output only the formatted report in Markdown, without commentary before or after it.
- Keep the complete report to no more than 20 lines, counting headings and blank lines.
- Use a professional tone and remove fluff words and filler phrases.
```
