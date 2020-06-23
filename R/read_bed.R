#' Read a .bed file
#'
#' @param file the name of the file which the data are to be read from.
#'
#' @return A [tibble][tibble::tibble-package] with 5 columns; "chr", "start",
#' "end", "beta" and "coverage".
#' @export
read_bed <- function(file) {
  res <- utils::read.delim(
    file,
    col.names = c("chr", "start", "end", "beta", "coverage"),
    stringsAsFactors = FALSE
    )
  tibble::as_tibble(res)
}
