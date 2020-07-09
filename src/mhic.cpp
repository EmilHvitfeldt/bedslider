#include <Rcpp.h>
using namespace Rcpp;

//' Calculate MHIC metric for matrix
//'
//' @param x Numeric matrix
//' @param lower Numeric determining the lower bound.
//' @param upper Numeric determining the upper bound.
//' @export
//' @examples
//' mat <- matrix(seq(0.1, 0.9, by = 0.1), ncol = 3)
//' metric_mhic(mat)
// [[Rcpp::export]]
double metric_mhic(NumericMatrix x, double lower = 0.2, double upper = 0.8) {

  int size = x.size();
  double total = 0.0;

  for (int i = 0; i < size; ++i) {
    total += (x[i] > lower) & (x[i] < upper);
  }

  total = total / size;

  return total;
}
