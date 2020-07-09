test_that("multiplication works", {

  ex_data <- tibble(group = rep(c("a", "b"), times = c(5, 10)),
                    x = 1:15,
                    y = 16:30)

  res <- bed_group(data = ex_data, vars = c("x", "y"),
                   funs = list(length, nrow, mean),
                   group = group)

  expect_equal(
    res$group,
    c("a", "b")
  )

  expect_equal(
    res$length,
    c(10, 20)
  )

  expect_equal(
    res$nrow,
    c(5, 10)
  )

  expect_equal(
    res$mean,
    c(mean(c(1:5, 16:20)), mean(c(6:15, 21:30)))
  )
})
