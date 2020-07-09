#' Groupwise application of functions over bed file
#'
#' @param data Data.frame
#' @param vars list of variable names. Must be supplied in the form
#'   list(a, b, d).
#' @param funs List of functions to be applied to the region. See details for
#'   more.
#' @param group Variable of denoting group
#'
#' @details
#' The region that the funs will be applied to is a matrix with a column for
#' each sample and a row for each row.
#'
#' @return The original data set with a column added for each fuction in funs.
#' @export
#'
#' @examples
#' library(dplyr)
#' bed_sample <- mutate(bed_sample, ggg = ceiling(row_number() / 10))

#' bed_group(bed_sample,
#'           vars = c("beta1", "beta2", "beta3", "beta4", "beta5"),
#'           funs = list(length, mean),
#'           group = ggg)
bed_group <- function(data, vars, funs, group) {
  fff <- function(x) {
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

  res <- data %>%
    dplyr::select({{group}}, {{vars}}) %>%
    dplyr::group_by({{group}}) %>%
    tidyr::nest() %>%
    dplyr::mutate(data = purrr::map_dfr(.data$data, fff))


  res <- dplyr::bind_cols(
    dplyr::select(res, -.data$data),
    dplyr::pull(res, .data$data)
  ) %>%
    dplyr::ungroup()

  return(res)
}
