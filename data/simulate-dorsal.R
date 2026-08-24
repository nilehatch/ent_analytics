# simulate-dorsal.R — generates data/dorsal.csv
#
# WHAT THIS IS. Dorsal Pack is a real student venture; its willingness-to-pay
# data is not. The founders never recorded what respondents told them, so this
# file is simulated to stand in for evidence that was collected and lost.
#
# WHY IT WAS REGENERATED (24 Aug 2026). The previous simulation had a
# fingerprint no human data carries: of 93 nonzero values, NONE was a multiple
# of 25 and only twelve were multiples of 5. The sorted values stepped by 3
# inside clusters sitting at unrelated offsets. People do not price that way.
# Asked to price something, they say fifty, or a hundred, or two hundred and
# fifty -- and the resulting pile-ups are not noise to be smoothed away. They
# put real cliffs in an empirical demand curve, and reading those cliffs
# correctly is one of the things this book teaches. A practice dataset that
# lacks them teaches the wrong lesson twice: it hides the artifact, and it makes
# the staircase look better behaved than any real one will.
#
# THE MODEL. Two stages, because stating a price is two acts.
#
#   1. A latent reservation value. What the respondent would actually pay,
#      which is continuous and which they never say out loud. Lognormal, so
#      it is positive and right-skewed -- a few people value a good pack far
#      above the median and nobody values it below zero.
#
#   2. A reporting granularity. Almost nobody reports the latent value. They
#      round it, and how coarsely they round scales with how large it is:
#      someone thinking "about ninety" says 90, and someone thinking "about
#      two hundred and seventy" says 250 or 300. A minority report precisely.
#
# Reproducible: seeded, deterministic. Re-running gives the same file, and the
# latent values -- the truth the stated values are a rounded view of -- can be
# recovered by running it with keep_truth = TRUE.

set.seed(20260824)

n            <- 107    # matches the original file
p_zero       <- 0.13   # would not buy at any price
p_precise    <- 0.15   # report the latent value to the dollar
median_buyer <- 95     # dollars, among those who would buy
sdlog        <- 0.52   # sets the right tail: 99th pct near $320

keep_truth <- FALSE    # TRUE also writes dorsal-latent.csv

# ---- stage 1: latent reservation values -------------------------------------
n_zero  <- round(n * p_zero)
n_buyer <- n - n_zero
latent  <- rlnorm(n_buyer, meanlog = log(median_buyer), sdlog = sdlog)

# ---- stage 2: reporting granularity -----------------------------------------
# The grid a person rounds to depends on the size of the number they are
# holding. Weights favour the coarser options as the value grows.
grid_for <- function(x) {
  if (x <  30) list(g = c(1,  5),          w = c(0.35, 0.65))
  else if (x < 100) list(g = c(1,  5, 10, 25), w = c(0.10, 0.34, 0.40, 0.16))
  else if (x < 200) list(g = c(5, 10, 25, 50), w = c(0.12, 0.34, 0.36, 0.18))
  else              list(g = c(10, 25, 50, 100), w = c(0.14, 0.34, 0.36, 0.16))
}

report <- function(x) {
  if (runif(1) < p_precise) return(round(x))
  gr <- grid_for(x)
  g  <- sample(gr$g, 1, prob = gr$w)
  max(g, round(x / g) * g)          # never round a real buyer down to zero
}

stated <- vapply(latent, report, numeric(1))
wtp    <- sample(c(rep(0, n_zero), stated))   # shuffle so zeros are not blocked

# ---- write -------------------------------------------------------------------

# Paths are relative to the repo root. Run with:  Rscript data/simulate-dorsal.R
write.csv(data.frame(wtp = wtp), "data/dorsal.csv", row.names = FALSE, quote = FALSE)

if (keep_truth) {
  write.csv(data.frame(latent = c(rep(0, n_zero), latent)),
            "data/dorsal-latent.csv", row.names = FALSE)
}

# ---- diagnostics -------------------------------------------------------------
nz <- wtp[wtp > 0]
cat("n                ", length(wtp), "\n")
cat("zeros            ", sum(wtp == 0), sprintf("(%.0f%%)", 100 * mean(wtp == 0)), "\n")
cat("mean             ", sprintf("$%.2f", mean(wtp)), "\n")
cat("median           ", sprintf("$%.2f", median(wtp)), "\n")
cat("median (buyers)  ", sprintf("$%.2f", median(nz)), "\n")
cat("max              ", sprintf("$%.0f", max(wtp)), "\n\n")
cat("multiples of  5  ", sum(nz %% 5  == 0), "of", length(nz),
    sprintf("(%.0f%%)", 100 * mean(nz %% 5 == 0)), "\n")
cat("multiples of 10  ", sum(nz %% 10 == 0), sprintf("(%.0f%%)", 100 * mean(nz %% 10 == 0)), "\n")
cat("multiples of 25  ", sum(nz %% 25 == 0), sprintf("(%.0f%%)", 100 * mean(nz %% 25 == 0)), "\n")
cat("distinct values  ", length(unique(nz)), "of", length(nz), "\n\n")
cat("most repeated:\n")
print(head(sort(table(nz), decreasing = TRUE), 8))
