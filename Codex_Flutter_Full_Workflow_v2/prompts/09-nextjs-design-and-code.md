# 09 — Future Next.js/React website screen (different repository)

Website repository: [EXACT_PATH]
TARGET PAGE/STATE: [PATH/STATE]
APPROVED DESIGN PNG/Figma COMPONENT REFERENCE: [EXISTING REAL SOURCE]
DESIGN SYSTEM/TOKENS: [REAL PATH]
ACCEPTANCE: [LAYOUT + SEMANTIC/INTERACTION/RESPONSIVE CHECKS]

Use existing Next.js/React architecture, routing, data-fetching and tokens. Read only directly relevant files; use official upstream `vercel-react-best-practices` and `web-design-guidelines` if installed. Do not add heavy dependencies without clear need.

Implement one route/state and its working interactions. Verify with actual browser at reference viewport and at small/large widths; use Playwright (or the browser MCP if actually installed) for route interactions, keyboard navigation, console errors and screenshots. Compare the APPROVED image against the real screenshot; fix top five differences only, at most two rounds. Audit a11y labels, keyboard/focus, contrast and text wrapping. Run repo-standard lint/typecheck/tests (discover actual scripts; do not assume names).

Provide changed files, test results, reference screenshot, actual screenshot, remaining differences and human approval status. No deployment unless separately requested.
