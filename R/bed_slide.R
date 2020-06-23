#' Sliding application of functions over bed file
#'
#' @param data Data.frame
#' @param vars list of variable names. Must be supplied in the form
#'   list(a, b, d).
#' @param funs List of functions to be applied to the region. See details for
#'   more.
#' @param .i Name of the variable denoting the location.
#' @param size Size of the sliding window. The window will be centered around
#'  each site.
#'
#' @details
#' The region that the funs will be applied to is a matrix with a column for
#' each sample and a row for each row.
#'
#' @return The original data set with a column added for each fuction in funs.
#' @export
#'
#' @examples
#' bed_slide(bed_sample,
#'           vars = list(beta1, beta2, beta3, beta4, beta5),
#'           funs = list(length, mean),
#'           .i = start, size = 100)
bed_slide <- function(data, vars, funs, .i, size) {
  fff <- function(...) {
    x <- list(...)
    mat <- matrix(unlist(x), ncol = length(x))

    res <- lapply(funs, function(x) x(mat))
    names(res) <- names(funs)
    unlist(res)
  }

  if (is.function(funs)) {
    funs <- list(funs)
  }

  if (is.null(names(funs))) {
    funs_names <- deparse(substitute(funs))
    funs_names <- gsub("^list\\(", "", funs_names)
    funs_names <- gsub(")$", "", funs_names)
    funs_names <- strsplit(funs_names, ", *")
    names(funs) <- funs_names[[1]]
  }

  new_cols <-
    dplyr::transmute(
      data,
      slider::pslide_index_dfr(.l = {{vars}},
                               .i = {{.i}}, .f = fff,
                               .before = size/2, .after = size/2)
    )

  dplyr::bind_cols(data, as.list(new_cols))
}
