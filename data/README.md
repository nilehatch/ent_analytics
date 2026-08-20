# Practice data

Four datasets from real student and founder projects, kept here so a reader can run
the method before they have evidence of their own. They are **somebody else's ventures**.
The numbers you get from them are that venture's numbers, not yours, and the point of
running them is to see what correct output looks like at each stage.

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
for one. n = 107.

**`muscle_cola_wqq.csv`** — a protein cola sold through gyms. The three anchors are
`quantity_at_P0` (units per month if permanently free), `wtp` (the most they would ever
pay for one), and `quantity` (units per month at that price). Remaining columns are
segmentation. n = 46, of whom 11 would take none even at zero.

**`dp_vp.csv`** — two travel backpacks, Dorsal Pack and Versa Pack. `dp` and `vp` are the
respondent's maximum for each. n = 110.

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
