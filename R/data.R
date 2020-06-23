#' Sample bedfile
#'
#' @format A data frame with 10000 rows and 9 variables:
#' \describe{
#'   \item{chr}{Character, denoting the chromosome.}
#'   \item{start}{Integer, bp position of the CpG site.}
#'   \item{end}{Integer, always 1 + start.}
#'   \item{coverage}{Integer, number of reads at CpG site.}
#'   \item{beta1}{Numeric, percentage methylation.}
#'   \item{beta2}{Numeric, percentage methylation.}
#'   \item{beta3}{Numeric, percentage methylation.}
#'   \item{beta4}{Numeric, percentage methylation.}
#'   \item{beta5}{Numeric, percentage methylation.}
#' }
"bed_sample"
