# Known defects — fix when next editing

Short list of things found while working elsewhere in the family and not fixed on the spot.
Delete each entry when it is fixed.

The three entries recorded on 23 Sep 2026 — the Stage 2 zero-WTP rule, the Stage 3 yes/no sigmoid
claim, and the Stage C3 negative-R² claim — were fixed the same day.

## `muscle_cola_wqq.csv` is labeled "collected" and one of its columns is manufactured

**`quantity_at_P0` is exactly 2 x `quantity` for all 34 respondents with a positive quantity.** No
exceptions; the only ratio in the file is 2.0. sum(quantity) = 701, sum(quantity_at_P0) = 1402.

**Cause, from Nile, 30 Sep 2026.** Early in developing the four-anchor method he had no real
four-anchor responses, so he generated that column by doubling `quantity` as scaffolding, to test
that the transformation and estimation code ran at all. Real data came later; the manufactured
column was never revisited. **The `wtp` figures are real. The free-quantity column is his.**

**Found by a student**, not by us — in ENTP 5771's Week 5 competence check, which uses the same
file. Thirty-three others described the curve's shape; one asked whether a ratio that ought to vary
between people actually varied.

### Why this is a book defect and not only a course one

`data/README.md:26` classifies it:

    | `muscle_cola_wqq.csv` | **collected.** Real respondents, real answers |

That is true of `wtp` and false of `quantity_at_P0`. The README puts the file on the wrong side of
its own stated line, twelve lines below: *"Adapted and simulated data can teach a method. It cannot
support a claim about the market."* The README also explains that the simulated files ship with
their generators "so that what is simulated can be inspected rather than taken on trust" — which is
exactly the standard this column fails.

There is precedent in the same README, at the *Dorsal* entry: **"Simulated, and regenerated 24 Aug
2026. The earlier simulation had a fingerprint no real data would have."** A constant ratio across
every respondent is the most obvious fingerprint available, and it sits in the file labeled
collected.

### What depends on it

`method-layer.qmd` and `code-layer.qmd` both compute their published Reference answers from this
file: 1402.0 at a price of zero, 997.9 at $1.00, 419.0 at $2.00, and the three fit statistics in the
code layer (linear R^2 0.970, exponential 0.607, sigmoid 0.993).

**The code is correct. The illustration is not innocent.** A sigmoid fits at 0.993 partly because
the bottom half of that curve is arithmetically twice the top half — the "flat shoulder at low
prices" the layer describes is produced by the doubling rule, not by respondents. The fit comparison
is being read off a shape that was partly manufactured.

### The fix

**A real candidate already exists: `app-data/donuts-2025.csv`.** 42 rows, 34 usable, and the
free-to-max quantity ratio takes **ten distinct values from 1.0 to 10.0** — which is what human
variation looks like. Test any candidate the same way: if `q_at_P0 / quantity` is constant, it was
generated.

In order: pick the replacement; recompute every published number in both layers and in the code
layer's Reference sections; correct the `data/README.md` provenance row; and re-check the sigmoid
claim, which may change once the low-price shoulder is real.

**Do not change the course's copy mid-semester** — 34 students submitted against the published key
and the exercise still did its job. See `ops/competence-check-key.R` in
`class-uu-bus-model-innovation`.

## Stage 3 says every assumption enters at step two. One enters at step one.

`method-layer.qmd`, Stage 3, opening line: *"Two steps, and never merge them. Step one is a
transformation and is fixed — run it exactly as written, do not improve it. Step two is an
estimation and is where every assumption enters."*

Step one carries an assumption of its own. `respondent_line()` gives each respondent "their own
linear demand: q_free at price 0, q_at_max at their max_wtp" — a straight line between two answers,
which commits that person to every price in between. You asked them about two prices; the line
answers for all of them.

It is a small assumption and a defensible one, and the distinction Stage 3 is reaching for still
holds. It is just not "no assumptions versus assumptions." **The line that holds is where the
assumption lives.** Step one keeps every assumption inside one respondent, so nobody's behaviour is
inferred from anybody else's. Step two imposes a functional form across the aggregate, letting one
respondent's answer move the predicted quantity at prices only other respondents named. That is the
real difference, and it is more defensible than the current claim.

Two things to write:

1. **Amend the Stage 3 opening** so step one is fixed *and carries one assumption that stays inside
   each respondent*, rather than assumption-free.
2. **Name the linearity assumption in the prose**, not only in a code docstring.
   `estimating-demand.qmd:227` already says "join the two points with a straight line," but the
   method layer is what someone executing the method reads, and it does not say it there.

Keep the asymmetry visible rather than flattening both cases: **yes/no demand genuinely is
assumption-free.** `yesno_demand()` counts respondents whose maximum clears the price, the curve
steps down at each stated maximum, and nothing between the steps is invented.

**Found 29 Sep 2026**, from a student in ENTP 5771. Asked to read four values off a summed
three-anchor curve and label each one counting or fitting, he labelled the interpolated ones
*fitting* — and was right by the letter of the definition he had been given. The course documents
(`assignments/estimation-competence-check.md` and `assignments/milestone-1-demand.md` in
`class-uu-bus-model-innovation`) were corrected the same day along the lines above. The book was not.

## `muscle_cola_wqq.csv` also contains one internally incoherent respondent

Separate from the manufactured `quantity_at_P0` column above. One row reads **wtp = 0.50,
quantity = 0, quantity_at_P0 = 0** — a respondent who would pay fifty cents for something they
would not take for free.

**It does not move any published number.** A respondent at zero quantity contributes zero to every
sum, so all seven reference values in `method-layer.qmd` and `code-layer.qmd` stand.

**Found by a student**, 30 Sep 2026, in ENTP 5771's week 5 check — by cross-tabulating `wtp`
against `quantity_at_P0`, which nothing asked him to do. A second student found the same gap from
the marginals (11 zero-wtp respondents against 12 who take none at a price of zero) and wrongly
attributed it to the doubling; the doubling maps 0 to 0 and so cannot create or remove a zero.

**Worth keeping deliberately.** Real survey data contains contradictions, and the stages that teach
validation are stronger with a live example than with a clean file. If the file is replaced, carry
one documented coherence violation into the replacement. Detail in
`ops/competence-check-key.R` in `class-uu-bus-model-innovation`.
