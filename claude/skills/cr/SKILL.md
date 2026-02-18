---
name: cr
description: Comprehensive code review skill. Use when reviewing a branch before merging to main. Checks for bugs, logical errors, unused code, simplification opportunities, and merge readiness.
---

# Code Review Guidelines

## Overview

Conduct a comprehensive code review of the current branch. The goal is to ensure the code is bug-free, logically sound, and ready to merge to main.

## Step 1: Establish Context

### Identify the Base Branch

The branch should be compared against the base branch it was created from, NOT the current main (which may contain unrelated changes).

```bash
# Find the merge-base (common ancestor) with main
git merge-base HEAD main

# Get the diff against the merge-base
git diff $(git merge-base HEAD main)..HEAD

# List commits unique to this branch
git log $(git merge-base HEAD main)..HEAD --oneline
```

### Get PR Information (if available)

Use the GitHub MCP to fetch PR context:

1. Get PR title and description - these explain the intent
2. Get any review comments or discussion on the PR
3. Check linked issues for requirements

```
Tools to use:
- mcp__github__list_pull_requests (to find the PR for current branch)
- mcp__github__pull_request_read with method "get" (for PR details)
- mcp__github__pull_request_read with method "get_comments" (for discussion)
- mcp__github__pull_request_read with method "get_review_comments" (for inline feedback)
```

### Understand the Purpose

Before reviewing code, clearly articulate:
- What problem is this branch solving?
- What is the expected behavior change?
- What are the acceptance criteria?

## Step 2: Review Checklist

Review in this priority order:

### 2.1 Correctness (HIGHEST PRIORITY)

- **Bugs**: Logic errors, off-by-one errors, null/undefined handling, race conditions
- **Hidden assumptions**: Code that assumes certain state, ordering, or input formats without validation
- **Edge cases**: Empty inputs, boundary values, error conditions
- **Type safety**: Incorrect type coercions, missing type checks
- **Error handling**: Unhandled exceptions, silent failures, incorrect error propagation

Questions to ask:
- What happens if this input is empty/null/malformed?
- What happens if this external call fails?
- Are there any assumptions about ordering or timing?
- Could this cause data corruption or loss?

### 2.2 Implementation vs Intent

- Does the implementation actually solve the stated problem?
- Are there gaps between what the PR claims to do and what the code does?
- Are there cases the implementation misses?
- Does it introduce unintended side effects?

### 2.3 Unused/Leftover Code

- Commented-out code that should be deleted
- Unused imports, variables, or functions
- Debug statements (console.log, print, etc.)
- TODO comments that should be addressed or tracked
- Dead code paths that can never execute
- Backwards-compatibility shims that aren't needed

### 2.4 Simplification Opportunities

Look for:
- Overly complex logic that could be simplified
- Repeated code that could be extracted
- Unnecessary abstractions or indirection
- Verbose patterns that have simpler alternatives
- Nested conditionals that could be flattened
- Complex state management that could be simplified

But also avoid:
- Suggesting premature abstractions
- Over-engineering for hypothetical futures
- Adding complexity in the name of "best practices"

### 2.5 Merge Readiness

- Are there merge conflicts?
- Are tests passing?
- Is the code consistent with the codebase style?
- Are there any security concerns?
- Is the change backwards compatible (if required)?
- Are there any performance regressions?

## Step 3: Output Format

Structure your review as follows:

```markdown
## Code Review: [Branch Name]

### Purpose
[1-2 sentence summary of what this branch does]

### Summary
[Overall assessment: Ready to merge / Needs changes / Major issues]

### Critical Issues
[Bugs or correctness problems that MUST be fixed]

### Suggestions
[Non-blocking improvements]

### Cleanup
[Unused code, leftover artifacts to remove]

### Questions
[Clarifications needed from the author]
```

## Review Principles

1. **Be specific**: Point to exact lines and explain why something is problematic
2. **Provide solutions**: Don't just identify problems, suggest fixes
3. **Prioritize**: Distinguish between blockers and nice-to-haves
4. **Be constructive**: The goal is to improve the code, not criticize the author
5. **Consider context**: A quick fix has different standards than a core feature

## Common Patterns to Flag

### Dangerous Patterns
- Unchecked array/object access
- String concatenation for SQL/commands (injection risk)
- Hardcoded secrets or credentials
- Missing input validation at system boundaries
- Async operations without proper error handling

### Code Smells
- Functions longer than ~50 lines
- More than 3 levels of nesting
- Boolean parameters that change behavior
- Magic numbers without constants
- Catch blocks that swallow errors silently

### Leftover Artifacts
- `// TODO` without tracking
- `console.log`, `print()`, `debugger`
- Commented-out code blocks
- Unused imports at file top
- Variables assigned but never read
