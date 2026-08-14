# CLAUDE.md — book-is-this-worth-doing

*Is This Worth Doing? How to Evaluate Profit Before Revenue Exists.* Quarto book, the
reading for ENT 402. Published at ea.nilehatch.com. Companion apps: Profit Analytics
(`../app-profit-analytics`) and Competition Analytics (`../app-competition-analytics`).
Completely rewritten in the current semester; core is solid, still being refined.

Core premise: profit = (P − c)·Q − f. The firm sets P, c, and f; only Q (demand) is unknown,
and it is estimated from willingness-to-pay survey data.

## Open revision opportunities (found July 2026)

1. ~~**The core transformation is missing from the book.**~~ **Done 14 Aug 2026**, in
   `estimating-demand.qmd`. Worked by hand on twelve respondents: raw table, sorted table with
   a running count, and a step-function figure, followed by the how-many case as horizontal
   summation. The chapter now separates **counting** (nearly assumption-free, produces the
   empirical staircase) from **fitting** (where every behavioural assumption enters), which was
   the conflation underneath the old version. A `.for-curious` names the survival function and
   reservation prices. Both elicitations are unified: yes/no is how-many where nobody buys more
   than one.

2. **The novelty claim needs to be located precisely.** The yes/no path (WTP survival
   function) is standard — adjacent to open-ended contingent valuation / Van Westendorp — do
   NOT claim it as novel. What is genuinely hard to place in the stated-preference literature:
   the three-anchor how-many elicitation (Q at permanent \$0, max WTP, Q at that max →
   per-respondent linear demand → horizontal summation) and its four-scenario competitive
   extension using each respondent's own WTPs as price levels (see `tk11`). Build any novelty
   claim there. This read is from an LLM, not a literature search — verify in Zotero before
   asserting "novel" in print.

## The real defect is the prose, not the content (Nile, 11 Aug 2026)

Both the current and previous versions were drafted with ChatGPT, and it shows. Nile's own
assessment: **confident in what is underneath, not in the reader's experience.** The draft
adopted a wrong voice and is full of vapid paragraphs. In some ways it improves on the previous
version and in a few ways it is worse.

So the revision is **re-voicing, not restructuring**. The architecture, the method, and the
analytics are sound and twenty years in the making. Treat any proposal to reorganize the
argument with suspicion; treat generic prose as the thing to hunt.

Note the tension with the May 2026 audit (`~/notes/10-Books/ent-analytics-itwd/audit.md`),
which localizes the voice fracture to Part 5 and praises ch1–ch18 ("ch11–ch12 sound like you").
Nile's judgment is broader than that. Do not assume the audit's boundary is correct — it was
one read, in May, and the chapters it praised have not been re-tested since.

### Game theory: rewrite from the old chapters, not the docx

`~/Documents/teaching/ent-analytics-book/Chapters 19-22.docx` is a colleague's ChatGPT-assisted
attempt to speed up the writing. **Do not use it and do not bring it into this repo.** Its
audit was good; its development of game theory content was mediocre. The ch19–ch22 rewrite has
to be done from the older chapters — `game_theory.qmd`, `simultaneous_games.qmd`,
`sequential_games.qmd`, `strategic_commitment.qmd` — which are mechanically complete and hold
the real content under generic prose.

ch19–ch22 and those four legacy files are **both currently in the TOC**. That is one unfinished
migration, not two problems.

## The class is the first pass of the revision

This book is the required text for **ENTP 5771** at the University of Utah
(`../class-uu-bus-model-innovation`), online asynchronous, opening 24 Aug 2026, ~40 students.
Building the course means close-reading ch1–ch12 on a schedule, which is the re-voicing pass
for those chapters whether or not it is billed as one. Separate sessions; one priority queue.

| Class week | Opens | Book material |
|---|---|---|
| 6–7 | 28 Sep | ch5–ch7, tk2, tk3 |
| 8 | 19 Oct | ch8, tk4, tk5 — **see revision opportunity 1 above** |
| 9–11 | 26 Oct | ch9–ch12, tk6–tk10 |
| 12–14 | 16 Nov | ch13–ch22 — **ch19–ch22 must be finished by ~25 Nov** |

Revision opportunity 1 — the WTP survival-function transformation, missing from ch8 and living
only in `../app-profit-analytics/server.R` — lands in class week 8. Writing it into the book
and building that week are the same task. Do it once.

## Build and deploy — one rule that will bite you

`.github/workflows/publish.yml` renders and deploys `_book/` to Netlify on every push to `main`.
The runner has **no R**, so it relies entirely on the committed `_freeze/`, with
`execute: freeze: auto` in `_quarto.yml`.

**Always `quarto render` the whole project before committing. Never render named files.**

Quarto applies `freeze` only during a *project* render. `quarto render some-chapter.qmd` always
executes the chunks and **does not write `_freeze/`**, so a targeted render leaves the freeze
stale while the working tree looks fine and the local HTML is correct. Push that and CI fails at
the first changed document containing R.

That is the design working rather than a defect — `auto` was chosen over `true` precisely so a
stale freeze fails loudly instead of silently publishing old figures (see the comment in
`_quarto.yml`). It happened once, on 14 Aug 2026, to `what-demand-is.qmd`; the next commit's full
render fixed it. Twenty-two documents here carry R chunks, so the exposure is wide.

Before any commit that touches a `.qmd` with an R chunk:

```
quarto render && git status --short _freeze    # expect changes; commit them with the prose
```

## Repo history

This directory had **no `.git` until 11 Aug 2026.** It was copied from
`~/Documents/teaching/ent-analytics-book/ent_analytics` by a method that dropped dotfiles, so
both `.git` and `.gitignore` were lost; the stale `site-url`/`repo-url` pointing at *Before You
Build* came from an even earlier copy out of the EI project. The repo was restored from the
original, whose `.git` is now renamed `.git.retired` so it cannot be committed to by accident.
Remote is `git@github.com:nilehatch/ent_analytics.git`; **nothing has been pushed since
11 Mar 2026.**

`_book/` is no longer tracked. Source images (`cover.png`, `images/`) deliberately are — do not
copy the sibling books' blanket `*.png` ignore rule into this repo.

## Conventions

Per global CLAUDE.md: preserve the author's voice; cite when changing facts or claims;
this is book content (the .qmd files here), not vault notes.
