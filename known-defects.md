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


## `method-layer.qmd`, Stage 3 — the yes/no sigmoid claim is too strong

**Current text:**

> "Expect the sigmoid to fit well under how-many demand and to fail under yes/no ... a solver will
> either refuse to converge or return an asymptote far above any observed quantity with an
> inflection outside the price range."

**On `muscle_cola_wqq.csv` it converges and fits respectably (R² 0.957), and its asymptote lands
*below* the observed maximum, not far above it: 39.6 against 46 respondents at a price of zero.**
The failure is real but it is in the opposite direction from the one predicted — it understates
the low-price end by eight buyers, where the method layer warns about an inflated ceiling.

**Suggested replacement:** keep the reasoning about the missing shoulder, drop the prediction about
non-convergence and an inflated asymptote, and say instead that the sigmoid is poorly identified on
a staircase and will describe the low-price end badly in whichever direction the solver lands. The
code layer reports the observed numbers.


## `method-layer-competition.qmd`, Stage C3 — the negative R² claim does not reproduce

**Current text:**

> "on both shipped competitive datasets the linear form returns a *negative* R², meaning it predicts
> worse than the sample mean, while the sigmoid reaches 0.97 and 0.99. A negative R² is not a close
> call and should be reported as a disqualification rather than a ranking."

**Measured 23 Sep 2026, fitting the summed surface the way the layer and the app both specify:**

| dataset | linear R², A | linear R², B | sigmoid R², A | sigmoid R², B |
|---|---|---|---|---|
| `fresh-prep_fast-food.csv` | 0.895 | 0.731 | 0.985 | 0.988 |
| `dp_vp.csv` | 0.955 | 0.900 | — | — |

Tested under four conventions on FreshPrep — zero-WTP respondents kept or filtered out as the app
filters them, price grid with and without a zero — and the linear R² stayed between 0.708 and 0.916
in every one.

**It cannot be negative as the app computes it.** `helpers_fit.R` fits `lm(Q ~ P_own + P_rival)` and
reports `summary(model)$r.squared`, which for an OLS fit with an intercept cannot fall below zero on
the data it was fitted to. A negative pseudo-R² is possible for the exponential and sigmoid, since
those are scored out of sample of their own estimation scale, but not for the linear form.

**The sigmoid figures are right** — 0.985 and 0.988 against the quoted 0.97 and 0.99.

**Suggested fix:** keep the instruction to report all three and let behaviour decide, and replace
the disqualification claim with what the data shows: the sigmoid fits materially better on both
shipped datasets, and the linear form's own-price slope is the one that propagates into the
equilibrium, so the gap matters more here than in the single-firm case. If a negative R² was
observed at some point, it came from a fitting route that is no longer the one specified.
