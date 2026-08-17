# gt-itwd.R -------------------------------------------------------------------
#
#   gt_itwd() is to tables what theme_itwd() is to figures: one style, stated
#   once, instead of the same three tab_options() repeated at every call site.
#   Before this file the book had fifteen gt tables carrying nine different
#   combinations of font size, padding and width, and no header styling at all.
#
#   THE PROBLEM IT SOLVES. gt's default column labels are #333333 normal-weight
#   text on white at 100% size, bounded by 2px #D3D3D3 rules — the same rules
#   that bound the table body. Nothing distinguishes the header row from a body
#   row except its position. A reader meeting a table fresh has to stop and work
#   out whether the top row is a label row or the first row of an unlabelled
#   table, and the faint zebra striping makes "white row" mean nothing.
#
#   THE SIGNAL. Pine type over a pine rule, which is exactly how base.css styles
#   an h2: `color: var(--brand-primary)` above `border-bottom: 2px solid
#   var(--brand-primary)`. A table header is a heading, so it gets the heading
#   treatment the book already uses. Nothing is invented here.
#
#   WHY NOT BOLD. These column labels are long — "Hogi Yogi does not advertise"
#   — and already near wrapping. Measured against the current labels, bold costs
#   about 8% width and uppercase 32% (12% even shrunk to 85%, because sans-serif
#   capitals are much wider than lowercase). Colour and rules cost nothing, so
#   the signal is carried entirely by things that do not reflow the table.
#
#   Note on striping: the zebra rows come from Bootstrap's .table-striped, which
#   Quarto adds to every gt table, NOT from gt. gt's row.striping.* options have
#   no effect here; changing the stripe means CSS. It must also not use
#   --brand-bg-tint, which is already the background of .callout-note and
#   .definition — striped rows would read as callouts.

if (!exists("itwd_pine")) source("R/theme-itwd.R")

#' The book's table style
#'
#' @param data       a gt object
#' @param font_size  point size for the table body (13 for the game payoff
#'                   matrices, 12 for everything else)
#' @param padding    data_row.padding in px
#' @param width      table width as a percentage of the text column
#' @param align      default column alignment; override single columns by
#'                   chaining cols_align() afterwards, which still wins
gt_itwd <- function(data,
                    font_size = 12,
                    padding   = 6,
                    width     = 100,
                    align     = c("center", "left", "right")) {

  align <- match.arg(align)

  data |>
    gt::tab_options(
      table.font.size  = font_size,
      data_row.padding = gt::px(padding),
      table.width      = gt::pct(width),

      # The header, and the only heavy rule in the table.
      column_labels.background.color    = "white",
      column_labels.font.weight         = "normal",
      column_labels.border.top.style    = "none",
      column_labels.border.bottom.style = "solid",
      column_labels.border.bottom.width = gt::px(2),
      column_labels.border.bottom.color = itwd_pine,
      column_labels.padding             = gt::px(max(padding, 6)),

      # Everything else recedes, so the header rule is the one that reads.
      table.border.top.style         = "none",
      table.border.bottom.style      = "none",
      table_body.border.top.style    = "none",
      table_body.border.bottom.width = gt::px(1),
      table_body.border.bottom.color = itwd_rule,
      table_body.hlines.width        = gt::px(1),
      table_body.hlines.color        = itwd_rule,

      footnotes.font.size    = "85%",
      source_notes.font.size = "85%"
    ) |>
    gt::tab_style(
      style     = gt::cell_text(color = itwd_pine),
      locations = gt::cells_column_labels()
    ) |>
    # Spanners sit above the column labels and are headings of headings, so
    # they take the deeper pine, the way base.css gives h3 --brand-secondary.
    # Safe on tables with no spanners: gt treats the location as empty.
    gt::tab_style(
      style     = gt::cell_text(color = itwd_pine_deep),
      locations = gt::cells_column_spanners(spanners = gt::everything())
    ) |>
    gt::cols_align(align)
}
