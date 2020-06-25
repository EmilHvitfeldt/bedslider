
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bedslider

<!-- badges: start -->

<!-- badges: end -->

The goal of bedslider is to allow calculating metrics in a sliding
fashion over .bed files.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("EmilHvitfeldt/bedslider")
```

## Example

bedslider includes a randomized dataset `bed_sample` we will use in
examples.

``` r
library(bedslider)
bed_sample
#> # A tibble: 10,000 x 9
#>    chr    start    end coverage beta1 beta2 beta3 beta4 beta5
#>    <fct>  <int>  <int>    <int> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 chr19 433511 433512        3     1  0     1     1     0.33
#>  2 chr19 433519 433520        3     1  0.67  0     0     0.67
#>  3 chr19 433531 433532        3     1  1     0.67  0     0.67
#>  4 chr19 433554 433555        3     1  0     1     0.33  0.33
#>  5 chr19 433565 433566        3     1  0.67  0.33  0.67  1   
#>  6 chr19 433573 433574        3     1  0.67  1     1     0   
#>  7 chr19 433608 433609        1     1  0     0     1     1   
#>  8 chr19 433623 433624        2     1  1     0.5   1     0   
#>  9 chr19 433631 433632        2     1  1     1     0     1   
#> 10 chr19 433666 433667        1     1  1     1     0     1   
#> # … with 9,990 more rows
```

This dataset has chromosome information, start positions and methylation
values for different measures in the beta columns.

The `bed_slide()` Allows you to calculate metrics in a sliding fashion
around each data point. The `vars` argument is used to specify the
columns that contain the values. If multiple columns are selected then
they are converted to a matrix before calculations begin. The funs
argument is a list of functions that take a single matrix as input and
returns a single numeric value. the `.i` argument specifies the position
variables that we are sliding over. `size` determines the size of the
window of observations we are including, centered around the point. A
`size = 100` would mean all points between 50 units before the point and
50 units after the point.

``` r
bed_slide(bed_sample,
          vars = list(beta3),
          funs = list(metric_mhic),
          .i = start, size = 100)
#> # A tibble: 10,000 x 10
#>    chr    start    end coverage beta1 beta2 beta3 beta4 beta5 metric_mhic
#>    <fct>  <int>  <int>    <int> <dbl> <dbl> <dbl> <dbl> <dbl>       <dbl>
#>  1 chr19 433511 433512        3     1  0     1     1     0.33       0.25 
#>  2 chr19 433519 433520        3     1  0.67  0     0     0.67       0.4  
#>  3 chr19 433531 433532        3     1  1     0.67  0     0.67       0.333
#>  4 chr19 433554 433555        3     1  0     1     0.33  0.33       0.333
#>  5 chr19 433565 433566        3     1  0.67  0.33  0.67  1          0.333
#>  6 chr19 433573 433574        3     1  0.67  1     1     0          0.5  
#>  7 chr19 433608 433609        1     1  0     0     1     1          0.4  
#>  8 chr19 433623 433624        2     1  1     0.5   1     0          0.2  
#>  9 chr19 433631 433632        2     1  1     1     0     1          0.2  
#> 10 chr19 433666 433667        1     1  1     1     0     1          0.333
#> # … with 9,990 more rows
```

The functions return the beginning data.frame with a column added on for
each function with the name of the function.

You can pass multiple functions in the `funs` list to have multiple
metrics calculated at once. This is more efficient than calculating them
one by one.

``` r
bed_slide(bed_sample,
          vars = list(beta3),
          funs = list(metric_mhic, metric_pwd, metric_sample_var),
          .i = start, size = 100)
#> # A tibble: 10,000 x 12
#>    chr    start    end coverage beta1 beta2 beta3 beta4 beta5 metric_mhic
#>    <fct>  <int>  <int>    <int> <dbl> <dbl> <dbl> <dbl> <dbl>       <dbl>
#>  1 chr19 433511 433512        3     1  0     1     1     0.33       0.25 
#>  2 chr19 433519 433520        3     1  0.67  0     0     0.67       0.4  
#>  3 chr19 433531 433532        3     1  1     0.67  0     0.67       0.333
#>  4 chr19 433554 433555        3     1  0     1     0.33  0.33       0.333
#>  5 chr19 433565 433566        3     1  0.67  0.33  0.67  1          0.333
#>  6 chr19 433573 433574        3     1  0.67  1     1     0          0.5  
#>  7 chr19 433608 433609        1     1  0     0     1     1          0.4  
#>  8 chr19 433623 433624        2     1  1     0.5   1     0          0.2  
#>  9 chr19 433631 433632        2     1  1     1     0     1          0.2  
#> 10 chr19 433666 433667        1     1  1     1     0     1          0.333
#> # … with 9,990 more rows, and 2 more variables: metric_pwd <dbl>,
#> #   metric_sample_var <dbl>
```

Using a named list will transfer those names to the output.

``` r
bed_slide(bed_sample,
          vars = list(beta3),
          funs = list(mhic = metric_mhic,
                      pwd = metric_pwd, 
                      sample_var = metric_sample_var),
          .i = start, size = 100)
#> # A tibble: 10,000 x 12
#>    chr    start    end coverage beta1 beta2 beta3 beta4 beta5  mhic   pwd
#>    <fct>  <int>  <int>    <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 chr19 433511 433512        3     1  0     1     1     0.33 0.25  0.555
#>  2 chr19 433519 433520        3     1  0.67  0     0     0.67 0.4   0.534
#>  3 chr19 433531 433532        3     1  1     0.67  0     0.67 0.333 0.489
#>  4 chr19 433554 433555        3     1  0     1     0.33  0.33 0.333 0.489
#>  5 chr19 433565 433566        3     1  0.67  0.33  0.67  1    0.333 0.556
#>  6 chr19 433573 433574        3     1  0.67  1     1     0    0.5   0.479
#>  7 chr19 433608 433609        1     1  0     0     1     1    0.4   0.534
#>  8 chr19 433623 433624        2     1  1     0.5   1     0    0.2   0.5  
#>  9 chr19 433631 433632        2     1  1     1     0     1    0.2   0.5  
#> 10 chr19 433666 433667        1     1  1     1     0     1    0.333 0.467
#> # … with 9,990 more rows, and 1 more variable: sample_var <dbl>
```

If you supply multiple columns to `vars` then they are combined in the
calculation.

``` r
bed_slide(bed_sample,
          vars = list(beta1, beta2, beta3, beta4, beta5),
          funs = list(mhic = metric_mhic,
                      pwd = metric_pwd, 
                      sample_var = metric_sample_var),
          .i = start, size = 100)
#> # A tibble: 10,000 x 12
#>    chr    start    end coverage beta1 beta2 beta3 beta4 beta5  mhic   pwd
#>    <fct>  <int>  <int>    <int> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1 chr19 433511 433512        3     1  0     1     1     0.33 0.35  0.390
#>  2 chr19 433519 433520        3     1  0.67  0     0     0.67 0.4   0.388
#>  3 chr19 433531 433532        3     1  1     0.67  0     0.67 0.367 0.387
#>  4 chr19 433554 433555        3     1  0     1     0.33  0.33 0.367 0.387
#>  5 chr19 433565 433566        3     1  0.67  0.33  0.67  1    0.333 0.409
#>  6 chr19 433573 433574        3     1  0.67  1     1     0    0.3   0.411
#>  7 chr19 433608 433609        1     1  0     0     1     1    0.2   0.413
#>  8 chr19 433623 433624        2     1  1     0.5   1     0    0.08  0.433
#>  9 chr19 433631 433632        2     1  1     1     0     1    0.04  0.46 
#> 10 chr19 433666 433667        1     1  1     1     0     1    0.1   0.42 
#> # … with 9,990 more rows, and 1 more variable: sample_var <dbl>
```

## Calculate metrics one column at a time

bedslider does not have the functionality to calculate metrics one
column at a time for multiple columns in the same function call. but
bedslider functions are easily pipeable so you can do comparative
analysis using pipes and named lists in the `funs` argument.

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

bed_sample %>% 
  bed_slide(vars = list(beta1),
            funs = list(beta1_mhic = metric_mhic, 
                        beta1_pwd = metric_pwd, 
                        beta1_sample_var = metric_sample_var),
            .i = start, size = 100) %>%
  bed_slide(vars = list(beta2),
            funs = list(beta2_mhic = metric_mhic, 
                        beta2_pwd = metric_pwd, 
                        beta2_sample_var = metric_sample_var),
            .i = start, size = 100)
#> # A tibble: 10,000 x 15
#>    chr    start    end coverage beta1 beta2 beta3 beta4 beta5 beta1_mhic
#>    <fct>  <int>  <int>    <int> <dbl> <dbl> <dbl> <dbl> <dbl>      <dbl>
#>  1 chr19 433511 433512        3     1  0     1     1     0.33          0
#>  2 chr19 433519 433520        3     1  0.67  0     0     0.67          0
#>  3 chr19 433531 433532        3     1  1     0.67  0     0.67          0
#>  4 chr19 433554 433555        3     1  0     1     0.33  0.33          0
#>  5 chr19 433565 433566        3     1  0.67  0.33  0.67  1             0
#>  6 chr19 433573 433574        3     1  0.67  1     1     0             0
#>  7 chr19 433608 433609        1     1  0     0     1     1             0
#>  8 chr19 433623 433624        2     1  1     0.5   1     0             0
#>  9 chr19 433631 433632        2     1  1     1     0     1             0
#> 10 chr19 433666 433667        1     1  1     1     0     1             0
#> # … with 9,990 more rows, and 5 more variables: beta1_pwd <dbl>,
#> #   beta1_sample_var <dbl>, beta2_mhic <dbl>, beta2_pwd <dbl>,
#> #   beta2_sample_var <dbl>
```

## Metric functions

bedslider comes builtin with a couple of optimized functions for
calculating metrics on matrices. These functions are all prefixed with
`metric_`.

  - `metric_mhic()`

Calculates the proportion of values that falls inside an interval, with
the defaults being (0.2, 0.8)

``` r
mat <- matrix(seq(0.1, 0.9, by = 0.1), ncol = 3)
mat
#>      [,1] [,2] [,3]
#> [1,]  0.1  0.4  0.7
#> [2,]  0.2  0.5  0.8
#> [3,]  0.3  0.6  0.9
```

``` r
mean(mat > 0.2 & mat < 0.8)
#> [1] 0.5555556

metric_mhic(mat)
#> [1] 0.5555556
```

  - `metric_pwd()`

Calculates the mean of the [distance
matrix](https://en.wikipedia.org/wiki/Distance_matrix) using the
Manhattan distance.

If multiple columns are present then the calculates are done column-wise
and averaged.

``` r
mat[, 1, drop = FALSE]
#>      [,1]
#> [1,]  0.1
#> [2,]  0.2
#> [3,]  0.3

metric_pwd(mat[, 1, drop = FALSE])
#> [1] 0.1333333
(abs(0.1 - 0.2) + abs(0.1 - 0.3) + abs(0.2 - 0.3)) / 3
#> [1] 0.1333333

metric_pwd(mat)
#> [1] 0.1333333
```

  - `metric_sample_var()`

Calculates the variances sample variance within each column.

If multiple columns are present then the calculates are done column-wise
and averaged.

``` r
var(mat[, 1])
#> [1] 0.01

metric_sample_var(mat[, 1, drop = FALSE])
#> [1] 0.01

metric_sample_var(mat)
#> [1] 0.01
```
