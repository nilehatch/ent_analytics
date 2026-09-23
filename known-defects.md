# Known defects — fix when next editing

Short list of things found while working elsewhere in the family and not fixed on the spot.
Delete each entry when it is fixed.

## `method-layer.qmd`, Stage 2 — the zero-WTP rule is wrong

**Current text, in the validate-and-prepare bullets:**

> "Under how-many, zero WTP alongside a positive quantity is incoherent and should be flagged."

**It is not incoherent. It is the free-only respondent**, and the Profit Analytics app treats it
correctly and deliberately — `helpers`/`server.R` carries a comment explaining that a respondent
who would take some units when the product is free but will pay nothing for it is a coherent
answer, contributes their free quantity at a price of zero, and carries no slope. The code layer
now documents the same treatment.

**What the text should say instead, in three parts:**

1. **Zero WTP with a positive free quantity is coherent** — "I would take three if you gave them
   away and will not pay for them." Keep the respondent; they belong in the curve at a price of
   zero and nowhere above it.
2. **The genuinely incoherent pattern is quantity at the maximum price exceeding quantity at a
   price of zero** — buying more as the price rises. That one is already flagged a line earlier and
   should be the only thing this bullet names.
3. **Anchor 3 is redundant when the maximum is zero, and should be branched past.** The anchors are
   asked in order — free quantity, then maximum, then quantity at that maximum. A respondent who
   says three when free and then says they would pay nothing has already answered the third
   question: at a price of zero the quantity is the free quantity. Asking again invites a
   contradiction the analysis then has to adjudicate. Stage 1 should instruct the instrument to
   branch past anchor 3 when the maximum is zero, and to set it equal to the free quantity.

**Why it matters beyond tidiness.** The instruction to flag these respondents pushes a careful
reader toward dropping them, and they are exactly the rows that keep a demand curve honest at the
low-price end.

**Related, and already handled elsewhere:** the course's competence-check key and the estimation
assignment were corrected on 23 Sep 2026 to say that a blank is not a zero — a typed zero is an
answer, an optional skip is missing, and a branch implies zero.
