# Known defects — fix when next editing

Short list of things found while working elsewhere in the family and not fixed on the spot.
Delete each entry when it is fixed.

The three entries recorded on 23 Sep 2026 — the Stage 2 zero-WTP rule, the Stage 3 yes/no sigmoid
claim, and the Stage C3 negative-R² claim — were fixed the same day.

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
