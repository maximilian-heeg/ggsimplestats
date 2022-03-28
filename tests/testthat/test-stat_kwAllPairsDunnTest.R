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
