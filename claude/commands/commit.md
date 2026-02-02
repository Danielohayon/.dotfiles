---
description: Generate a commit message for staged changes
allowed-tools: Bash(git diff:*), Bash(git status:*)
---

Generate a concise, professional commit message for the currently staged changes.

Steps:
1. Run `git diff --staged` to see what changes are staged
2. Run `git status` to understand the scope of changes

Commit message format:
- First line: type(scope): brief description (max 72 chars)
- Types: feat, fix, refactor, docs, style, test, chore
- Blank line, then bullet points for details if needed

Rules:
- Focus on WHY and WHAT, not HOW
- Be specific but concise
- No generic messages like "update files" or "fix bug"
- Use imperative mood ("add" not "added")

Output ONLY the commit message, nothing else. No explanations or markdown formatting.
