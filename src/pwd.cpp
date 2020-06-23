#include <Rcpp.h>
using namespace Rcpp;

//' Calculate Pairwise Distance metric for matrix
//'
//' @param x numeric matrix
//'
//' @export
//' @examples
//' mat <- matrix(1:9, ncol = 3)
//' metric_pwd(mat)
// [[Rcpp::export]]
double metric_pwd(NumericMatrix x) {
  int nrow = x.nrow();
  int ncol = x.ncol();
  double total = 0;

  for(int h = 0; h < ncol; ++h) {
    for(int i = 0; i < nrow; ++i) {
      for(int j = i + 1; j < nrow; ++j) {
        total += std::abs(x(i, h) - x(j, h));
      }
    }
  }

  double correction = ((nrow * nrow - nrow) / 2) * ncol;
  total = total / correction;
  return total;
}
