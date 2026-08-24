# Practice data

Published with the book. Fetch them directly, or hand a URL to an assistant:

- <https://ea.nilehatch.com/data/dorsal.csv>
- <https://ea.nilehatch.com/data/muscle_cola_wqq.csv>
- <https://ea.nilehatch.com/data/dp_vp.csv>
- <https://ea.nilehatch.com/data/fresh-prep_fast-food.csv>

The two generators are published alongside them — `simulate-dorsal.R` and
`simulate-dp-vp.R` — so that what is simulated can be inspected rather than taken on
trust.

Four datasets from student and founder projects, kept here so a reader can run the
method before they have evidence of their own. They are **somebody else's ventures**.
The numbers you get from them are that venture's numbers, not yours, and the point of
running them is to see what correct output looks like at each stage.

## Provenance, honestly

The ventures are real. Not all of the response data is, and a reader is owed the
difference.

| file | responses |
|---|---|
| `muscle_cola_wqq.csv` | **collected.** Real respondents, real answers |
| `fresh-prep_fast-food.csv` | **collected.** BYU undergraduates |
| `dp_vp.csv` | **simulated.** See `simulate-dp-vp.R` |
| `dorsal.csv` | **simulated.** See `simulate-dorsal.R` |

Both simulated files stand in for evidence that was never recorded. Dorsal Pack is a
real venture whose founders did not keep what respondents told them, which is a common
enough fate to be worth naming rather than hiding. `dp_vp.csv` previously held data
rescaled and relabelled from a student class assignment; the students were asked about
its use and no record of that permission survives, so it was replaced on 24 Aug 2026
with a generator that reproduces the behaviour without borrowing anyone's answers.

**Adapted and simulated data can teach a method. It cannot support a claim about the
world**, and nothing in this book rests on either file.

They were chosen because they match the current method exactly. Older datasets in the
teaching archive follow earlier versions of the elicitation and will not run cleanly.

| file | demand | market | what it exercises |
|---|---|---|---|
| `dorsal.csv` | yes/no | single firm | the simplest possible case: one WTP column |
| `muscle_cola_wqq.csv` | how-many | single firm | the three-anchor elicitation |
| `dp_vp.csv` | yes/no | competitive | two products, two WTPs |
| `fresh-prep_fast-food.csv` | how-many | competitive | the full four-scenario design |

## Columns

**`dorsal.csv`** — a technical travel backpack. `wtp` is the most a respondent would pay
for one. n = 107, of whom 14 would not buy at any price.

**Simulated, and regenerated 24 Aug 2026.** The earlier simulation had a fingerprint no
human data carries: of 93 nonzero values, none was a multiple of 25 and only twelve were
multiples of 5. People do not price that way. Asked what they would pay, they say fifty,
or a hundred, or a hundred and fifty, and those pile-ups are not noise — they put real
cliffs in an empirical demand curve, and reading a cliff correctly is one of the things
this book teaches. The current file is generated in two stages, a continuous latent
reservation value and a reporting granularity that coarsens as the number grows, which
puts 83% of nonzero answers on multiples of 5 and 35% on multiples of 25. `simulate-dorsal.R`
is seeded, so the file and the latent values behind it can both be reproduced.

**`muscle_cola_wqq.csv`** — a protein cola sold through gyms. The three anchors are
`quantity_at_P0` (units per month if permanently free), `wtp` (the most they would ever
pay for one), and `quantity` (units per month at that price). Remaining columns are
segmentation. n = 46, of whom **12 would take none even at zero**.

Eleven of those twelve also name a maximum of \$0. The twelfth names \$0.50 and still takes
none at any price, including free — a respondent who is internally consistent with the
validation rules and contributes nothing to the curve. Worth knowing before the arithmetic
disagrees with a hand count.

This is the one dataset that predates the settled elicitation. It was collected while the
question being tested was quantity at **half** the stated maximum; anchoring at a permanent
price of zero came later and replaced it, because zero is a price every respondent can
picture identically and wtp/2 is a different price for every respondent. The abandoned
`WTP_half` column was dropped from the file on 24 Aug 2026. The other three datasets were
collected after the design settled and never carried it.

**`dp_vp.csv`** — two travel backpacks, Dorsal Pack and Versa Pack. `dp` and `vp` are the
respondent's maximum for each, and `security_preference` is a 0–10 attitude item. n = 110.

**Simulated.** `simulate-dp-vp.R` builds it in three parts: a preference dimension, a
small shared taste for good luggage, and the same focal-value reporting used for
`dorsal.csv`. Security is Dorsal Pack's differentiator and drives what a respondent
will pay for it (r = 0.91) while explaining almost nothing about Versa Pack (r = −0.07),
so the file rewards a reader who segments on one attitudinal variable and shows that the
same variable can be decisive for one product and irrelevant for its rival. The two
maxima are close to uncorrelated, which means the substitution the choice rule produces
comes from overlapping price distributions rather than from correlated tastes.

Fitted on the summed surface it returns a demand system with both substitution terms
sharply identified and unequal — Versa Pack gains more from a Dorsal price rise than the
reverse, and loses customers faster to its own price. That asymmetry is what the file is
for.

**`fresh-prep_fast-food.csv`** — a prepared meal bowl against the respondent's usual
fast-food option, among BYU undergraduates. `wtpA` and `wtpB` are the two maxima; `wowA`
and `wowB` are appeal ratings out of 10. The eight quantity columns follow the pattern
`q{product}_{price of A}{price of B}`, where `0` means free and the letter means that
product's own WTP:

| column | price of A | price of B |
|---|---|---|
| `qA_00` | 0 | 0 |
| `qA_A0` | wtpA | 0 |
| `qA_0B` | 0 | wtpB |
| `qA_AB` | wtpA | wtpB |

and the same four for B. n = 53.

## Cost and scale

Demand is the only term these datasets carry. To finish the method you also need unit
cost, the commitment, and the reachable population — and those were never collected.
The figures below are **researched estimates, not measurements**: they are what the
method calls assumptions, they are stated as ranges, and every conclusion drawn with
them should be recomputed at both ends. Their derivations are in the project notes.

| case | period | c (unit cost) | f (commitment) | N (reachable) |
|---|---|---|---|---|
| dorsal | per purchase | \$40 – \$60 · mid \$48 | \$10k – \$16k · mid \$12k | 15,000 – 60,000 |
| muscle cola | per month | \$0.65 – \$0.95 · mid \$0.78 | \$10k – \$20k · mid \$14k | 8,000 – 25,000 |
| dp / vp | per purchase | DP \$40–\$60 · VP \$32–\$48 | \$10k – \$16k | 15,000 – 60,000 |
| fresh prep | per month | \$3.75 – \$5.00 · mid \$4.30 | \$4k – \$7k **per month** | 5,000 – 9,000 |

Two cautions carried over from the derivations. The backpack cases admit two defensible
framings depending on whether prepaid inventory is treated as commitment or as unit cost,
and mixing them double-counts. FreshPrep's commitment is monthly rather than one-off,
because a commissary lease renews; compare it against monthly demand, not annual.
