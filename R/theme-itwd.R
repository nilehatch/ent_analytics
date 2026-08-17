# theme-itwd.R — the house look for every figure in this book.
#
# Sourced from each document's setup chunk:  source("R/theme-itwd.R")
# All .qmd files live in the project root, so the relative path resolves
# whatever Quarto's execute-dir is set to.
#
# Two things live here, and the split matters.
#
#   The PALETTE is semantic and family-wide. Blue means demand, red-orange
#   means cost, green means profit, in this book and in its siblings. A reader
#   moving between books must never have to relearn what a color means, so
#   these values are not a styling choice and should not be changed casually.
#   They were validated together: inside the lightness band, above the chroma
#   floor, adjacent-pair separation of deutan dE 8.6 against a threshold of 8
#   and 24.5 for normal vision.
#
#   The THEME is furniture, and furniture should recede. Built on
#   theme_minimal, it drops the panel fill, keeps one hairline horizontal grid
#   for reading quantity across, and puts every piece of text in the book's
#   own ink and muted grays so figures look like they belong to these pages.
#   It replaced theme_hc(), whose gray panel and white gridlines competed with
#   the data they sat behind.

# ---- semantic palette ------------------------------------------------------
# One value per role. Before this file the book used six different blues for
# "demand", three oranges for "cost" and two greens for "profit".

itwd_demand       <- "#2563EB"  # demand, quantity, the customer side
itwd_demand_light <- "#93B4F5"  # a second demand line (rival, before/after)
itwd_demand_dark  <- "#1E3A8A"  # the dark end of the demand ramp (see below)
itwd_cost         <- "#C2410C"  # cost, variable and total
itwd_cost_light   <- "#FB923C"  # a second cost line
itwd_profit       <- "#2F855A"  # profit, surplus, the good outcome
itwd_accent       <- "#E3A008"  # gold: highlight only, never a data series

# ---- the demand ramp -------------------------------------------------------
# The rule above is one color per role, which breaks down when a figure shows
# several curves that are all the same role: three functional forms of one
# demand curve, say. Three hues would claim they are different things. The
# answer is one hue at three lightnesses, which reads as three of the same
# thing, and which survives grayscale printing and red-green color deficiency
# because the signal is lightness rather than hue.
#
#   itwd_demand_dark   L* 27    itwd_demand   L* 46    itwd_demand_light  L* 73
#
# Use it only for same-role curves, in that order, and label such figures in
# itwd_ink rather than in the curve colors: at 2pt a line carries the light
# end fine, but text at L* 73 is 2.1:1 on white, under the 3:1 contrast bar.
itwd_demand_ramp <- c(itwd_demand_dark, itwd_demand, itwd_demand_light)

# ---- neutrals, taken from the book's brand variables -----------------------
itwd_ink   <- "#1F2937"  # --brand-text: axis titles, annotations, points
itwd_muted <- "#6B7280"  # --brand-muted: tick labels, captions
itwd_rule  <- "#E1E6E3"  # gridlines and the baseline
itwd_ghost <- "#9CA8A2"  # reference/"before" lines that must recede

# ---- the two players -------------------------------------------------------
# Rival firms are an IDENTITY, not a role, and the palette above has no color
# for identity: a firm is not "demand" or "cost". These figures were borrowing
# itwd_demand and itwd_cost to tell two firms apart, which worked and said
# something false.
#
# The values are unchanged because the pair is already the right one. Blue and
# orange is the canonical colorblind-safe two-category pair, and these two sit
# at 5.17:1 and 5.18:1 on white — near-identical weight, which matters when the
# players are symmetric and neither should look more important than the other.
# Pine and gold were considered and rejected: gold is 2.26:1, under the 3:1
# floor for graphics, and pine now means structure (see below).
itwd_player_a <- "#2563EB"  # the row player — Smart Cookie in the game chapters
itwd_player_b <- "#C2410C"  # the column player — Hogi Yogi

# ---- brand pine, for structure rather than data ----------------------------
# Never a data series. These are the colors base.css gives headings, and they
# are here so R output can carry the same structural signal as the page: see
# gt_itwd() in R/gt-itwd.R, which heads a table the way base.css heads an h2.
itwd_pine      <- "#146B45"  # --brand-primary:   h2 color and h2 rule
itwd_pine_deep <- "#0D4F33"  # --brand-secondary: h3

# ---- the theme -------------------------------------------------------------

theme_itwd <- function(base_size = 12, base_family = "", grid = c("y", "xy", "none")) {
  grid <- match.arg(grid)

  gy <- if (grid %in% c("y", "xy")) {
    ggplot2::element_line(color = itwd_rule, linewidth = 0.3)
  } else ggplot2::element_blank()

  gx <- if (grid == "xy") {
    ggplot2::element_line(color = itwd_rule, linewidth = 0.3)
  } else ggplot2::element_blank()

  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # ground: no panel fill, so the figure sits on the page rather than in a box
      plot.background    = ggplot2::element_rect(fill = "white", color = NA),
      panel.background   = ggplot2::element_blank(),
      panel.border       = ggplot2::element_blank(),

      # grid: hairline, horizontal by default. Read quantity across; read price
      # off an explicit guide segment, which is more precise than a gridline.
      panel.grid.major.y = gy,
      panel.grid.major.x = gx,
      panel.grid.minor   = ggplot2::element_blank(),

      # axes: one baseline, no ticks, labels in muted gray
      axis.line.x        = ggplot2::element_line(color = itwd_rule, linewidth = 0.4),
      axis.line.y        = ggplot2::element_blank(),
      axis.ticks         = ggplot2::element_blank(),
      axis.text          = ggplot2::element_text(color = itwd_muted,
                                                 size = ggplot2::rel(0.9)),
      axis.title         = ggplot2::element_text(color = itwd_ink,
                                                 size = ggplot2::rel(0.95)),
      axis.title.x       = ggplot2::element_text(margin = ggplot2::margin(t = 8)),
      axis.title.y       = ggplot2::element_text(margin = ggplot2::margin(r = 8)),

      # text
      plot.title         = ggplot2::element_text(color = itwd_ink, face = "bold",
                                                 size = ggplot2::rel(1.05),
                                                 margin = ggplot2::margin(b = 6)),
      plot.subtitle      = ggplot2::element_text(color = itwd_muted,
                                                 margin = ggplot2::margin(b = 10)),
      plot.caption       = ggplot2::element_text(color = itwd_muted, hjust = 0,
                                                 size = ggplot2::rel(0.8)),

      # legend: below the plot, unboxed, no redundant title
      legend.position    = "bottom",
      legend.title       = ggplot2::element_blank(),
      legend.text        = ggplot2::element_text(color = itwd_ink),
      legend.key         = ggplot2::element_blank(),

      plot.margin        = ggplot2::margin(6, 10, 6, 6)
    )
}

# Make it the default for every plot in the document that sources this file,
# so a figure has to opt out rather than opt in.
ggplot2::theme_set(theme_itwd())
