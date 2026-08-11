# CLAUDE.md — book-is-this-worth-doing

*Is This Worth Doing? How to Evaluate Profit Before Revenue Exists.* Quarto book, the
reading for ENT 402. Published at ea.nilehatch.com. Companion apps: Profit Analytics
(`../app-profit-analytics`) and Competition Analytics (`../app-competition-analytics`).
Completely rewritten in the current semester; core is solid, still being refined.

Core premise: profit = (P − c)·Q − f. The firm sets P, c, and f; only Q (demand) is unknown,
and it is estimated from willingness-to-pay survey data.

## Open revision opportunities (found July 2026)

1. **The core transformation is missing from the book — strongest revision opportunity.**
   The move that makes WTP data into a legitimate demand curve — sort WTP descending,
   cumulative-count so quantity at price P = the number of respondents with WTP ≥ P (the
   survival function of a reservation-price distribution) — appears ONLY in
   `../app-profit-analytics/server.R:338-346`. ch8 explains estimation philosophically and
   defers to the app ("handled automatically"). This is the most intuitive AND most rigorous
   part of the method ("line everyone up by what they'd pay, count who's still standing") and
   it belongs in the book, worked, not hidden in app code.

2. **The novelty claim needs to be located precisely.** The yes/no path (WTP survival
   function) is standard — adjacent to open-ended contingent valuation / Van Westendorp — do
   NOT claim it as novel. What is genuinely hard to place in the stated-preference literature:
   the three-anchor how-many elicitation (Q at permanent \$0, max WTP, Q at that max →
   per-respondent linear demand → horizontal summation) and its four-scenario competitive
   extension using each respondent's own WTPs as price levels (see `tk11`). Build any novelty
   claim there. This read is from an LLM, not a literature search — verify in Zotero before
   asserting "novel" in print.

## Conventions

Per global CLAUDE.md: preserve the author's voice; cite when changing facts or claims;
this is book content (the .qmd files here), not vault notes.
