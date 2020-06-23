#' Calculate sample variance metric for matrix
#'
#' @param x Numeric matrix
#'
#' @return A numeric
#' @export
#'
#' @examples
#' mat <- matrix(seq(0.1, 0.9, by = 0.1), ncol = 3)
#' metric_sample_var(mat)
metric_sample_var <- function(x) {
  mean(apply(X = x, MARGIN = 1, FUN = stats::var))
}

