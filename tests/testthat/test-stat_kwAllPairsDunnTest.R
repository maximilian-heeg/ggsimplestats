test_that("stat_kwAllPairsDunnTest requires a discrete x axis", {
  library(ggplot2)

  expect_warning({
    print(ggplot(mpg, aes(cty, cty)) +
      stat_kwAllPairsDunnTest())
  })
})



test_that("stat_kwAllPairsDunnTest works", {
  library(ggplot2)

  data <- data.frame(
    x = c("a", "a", "a", "b", "b", "c", "c", "c", "c"),
    y = c(1, 2, 3, 4, 5, 6, 7, 8, 9)
  )

  # I expect a warning since there are ties in the dataset
  plot <- ggplot(data, aes(x, y)) +
    geom_boxplot() +
    stat_kwAllPairsDunnTest()

  vdiffr::expect_doppelganger("Simple_Boxplot", {
    plot
  })
})


test_that("stat_kwAllPairsDunnTest colors works", {
  library(ggplot2)

  data <- data.frame(
    x = c("a", "a", "a", "b", "b", "c", "c", "c", "c"),
    y = c(1, 2, 3, 4, 5, 6, 7, 8, 9)
  )

  # set seed for jitter
  set.seed(42)
  plot <- ggplot(data, aes(x, y, color=x)) +
    geom_jitter() +
    stat_kwAllPairsDunnTest(colour = 'darkgreen')

  vdiffr::expect_doppelganger("stat_kwAllPairsDunnTest_color", {
    plot
  })
})


test_that("stat_kwAllPairsDunnTest bracket look good if scales not free", {
  library(ggplot2)




  df <- data.frame(
    value = c(1,2,3,4, 12,23,13,14),
    group = rep(c('a','b'), times=4),
    facet = c(rep(c('x'), times=4), rep(c('y'), times=4))
  )

  plot <- ggplot(df, aes(x=group, y=value)) +
    facet_grid(facet~.) +
    geom_point() +
    stat_kwAllPairsDunnTest(hide.ns = FALSE)

  vdiffr::expect_doppelganger("stat_kwAllPairsDunnTest_scales", {
    plot
  })
})
