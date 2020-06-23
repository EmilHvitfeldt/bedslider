#include <Rcpp.h>
using namespace Rcpp;

//' Calculate sample variance metric for matrix
//'
//' @param x numeric matrix
//'
//' @export
//' @examples
//' mat <- matrix(1:9, ncol = 3)
//' metric_sample_var(mat)
// [[Rcpp::export]]
double metric_sample_var(NumericMatrix x) {
  int nrow = x.nrow();
  int ncol = x.ncol();

  double var = 0;
  double mean = 0;
  double var_temp = 0;

  for (int i = 0; i < ncol; ++i) {

    mean = 0;
    var_temp = 0;

    for (int j = 0; j < nrow; ++j) {
      mean += x(j, i);
    }

    mean = mean / nrow;

    for (int j = 0; j < nrow; ++j) {
      var_temp += (x(j, i) - mean) * (x(j, i) - mean);
    }

    var += var_temp / (nrow - 1);
  }
  var = var / ncol;

  return var;
}
