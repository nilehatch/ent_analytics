# simulate-dp-vp.R — generates data/dp_vp.csv
#
# WHAT THIS REPLACES. The previous file was rescaled and relabelled from a
# student class assignment. The students were asked about using their data and
# no record of that permission survives, which is a thin basis for shipping it
# in a published book. This generator removes the question by removing the
# borrowed data, and it reproduces the behaviour the file was there to provide.
#
# WHAT THE FILE IS FOR. Two differentiated travel backpacks, Dorsal Pack and
# Versa Pack, yes/no elicitation. Each respondent names a maximum for each. It
# is the practice case for the competitive method layer's net-surplus choice
# rule, and its job is to produce a demand system whose two substitution terms
# are clearly identified and NOT equal -- that asymmetry being, as the layer
# says, the most decision-relevant thing the method produces.
#
# THE MODEL. Three components, in the order they matter.
#
#   1. A preference dimension. Dorsal Pack's differentiator is security, and a
#      respondent's stated security preference (0-10) drives what they will pay
#      for it. This is by far the strongest relationship in the file and it is
#      deliberate: the dataset exists partly so a reader can discover that
#      segmenting on a single attitudinal variable explains most of one
#      product's demand and almost none of the other's.
#
#   2. A shared taste for good luggage, small. Both products get a little of
#      it, which is behaviourally right -- somebody who will not spend on a bag
#      will not spend on either -- and it is kept small because the file being
#      replaced showed the two maxima essentially uncorrelated (r = -0.06).
#      Substitution here is driven by prices meeting overlapping distributions,
#      not by correlated tastes.
#
#   3. Focal-value reporting. Same two-stage treatment as simulate-dorsal.R:
#      a continuous latent value, then a rounding granularity that coarsens as
#      the number grows. The file being replaced carried this pattern already
#      (93% of nonzero maxima were multiples of 5) and losing it would have
#      flattened the cliffs the choice rule turns into real steps.
#
# Targets, taken from the file being replaced:
#   dp   mean 126.5  sd 70.4  max 325     vp   mean 94.5  sd 50.1  max 211
#   cor(security, dp)  0.94               cor(dp, vp)  -0.06
#   fitted DP: b 0.364  d 0.146           fitted VP: b 0.458  d 0.163
#
# Reproducible: seeded and deterministic.
# Run:  Rscript data/simulate-dp-vp.R

set.seed(20260824)
n <- 110

# ---- 1. the preference dimension --------------------------------------------
# Mildly U-shaped, as an attitude item usually is: people cluster at the ends
# and at the neutral midpoint.
w_s <- c(3, 6, 7, 10, 10, 16, 15, 8, 9, 10, 16)
s   <- sample(0:10, n, replace = TRUE, prob = w_s / sum(w_s))

# ---- 2. latent maxima --------------------------------------------------------
shared <- rnorm(n, 0, 1)          # taste for good luggage, common to both

dp_lat <- -42 + 27.0 * s + 8 * shared + rnorm(n, 0, 33)
vp_lat <-  95      +  6 * shared + rnorm(n, 0, 45)

dp_lat <- pmax(0, dp_lat)
vp_lat <- pmax(0, vp_lat)

# ---- 3. focal-value reporting -------------------------------------------------
grid_for <- function(x) {
  if (x <  30)      list(g = c(1,  5),           w = c(0.30, 0.70))
  else if (x < 100) list(g = c(1,  5, 10, 25),   w = c(0.06, 0.30, 0.42, 0.22))
  else if (x < 200) list(g = c(5, 10, 25, 50),   w = c(0.10, 0.32, 0.40, 0.18))
  else              list(g = c(10, 25, 50, 100), w = c(0.12, 0.34, 0.38, 0.16))
}
report <- function(x) {
  if (x <= 0) return(0)
  if (runif(1) < 0.07) return(round(x))     # a few report to the dollar
  gr <- grid_for(x)
  g  <- sample(gr$g, 1, prob = gr$w)
  max(g, round(x / g) * g)
}
dp <- vapply(dp_lat, report, numeric(1))
vp <- vapply(vp_lat, report, numeric(1))

write.csv(data.frame(dp = dp, vp = vp, security_preference = s),
          "data/dp_vp.csv", row.names = FALSE, quote = FALSE)

# ---- diagnostics ---------------------------------------------------------------
d <- data.frame(dp = dp, vp = vp, s = s)
for (v in c("dp", "vp")) {
  x <- d[[v]]; nz <- x[x > 0]
  cat(sprintf("%s  mean %6.1f  sd %5.1f  median %5.1f  max %3.0f  zeros %d\n",
              v, mean(x), sd(x), median(x), max(x), sum(x == 0)))
  cat(sprintf("    mult of 5 %3.0f%%   of 10 %3.0f%%   of 25 %3.0f%%   distinct %d\n",
              100*mean(nz %% 5 == 0), 100*mean(nz %% 10 == 0),
              100*mean(nz %% 25 == 0), length(unique(nz))))
}
cat(sprintf("\ncor(security, dp) %6.3f      cor(security, vp) %6.3f\n",
            cor(d$s, d$dp), cor(d$s, d$vp)))
cat(sprintf("cor(dp, vp)       %6.3f      both > 0: %d\n", cor(d$dp, d$vp),
            sum(d$dp > 0 & d$vp > 0)))

# The demand system, exactly as the competitive method layer builds it: the
# net-surplus choice rule evaluated on the grid of prices respondents named.
gd <- sort(unique(dp)); gv <- sort(unique(vp))
G  <- expand.grid(p_dp = gd, p_vp = gv)
qd <- qv <- numeric(nrow(G))
for (i in seq_len(nrow(G))) {
  so <- dp - G$p_dp[i]; sr <- vp - G$p_vp[i]
  qd[i] <- sum(so > 0 & so >  sr) + 0.5 * sum(so > 0 & so == sr)
  qv[i] <- sum(sr > 0 & sr >  so) + 0.5 * sum(sr > 0 & sr == so)
}
cat("\nfitted demand system (linear, on the summed surface):\n")
for (side in c("dp", "vp")) {
  y   <- if (side == "dp") qd else qv
  own <- if (side == "dp") G$p_dp else G$p_vp
  riv <- if (side == "dp") G$p_vp else G$p_dp
  m <- lm(y ~ own + riv); co <- summary(m)$coefficients
  cat(sprintf("  %s   a %7.2f   b %.4f (p=%.1g)   d %.4f (p=%.1g)   R2 %.3f\n",
      toupper(side), co[1,1], -co[2,1], co[2,4], co[3,1], co[3,4], summary(m)$r.squared))
}
