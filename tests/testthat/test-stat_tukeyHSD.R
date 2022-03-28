test_that("stat_tukeyHSD requires a discrete x axis", {
  library(ggplot2)

  expect_warning({
    print(ggplot(mpg, aes(cty, cty)) +
      stat_tukeyHSD())
  })
})



test_that("stat_tukeyHSD works", {
  library(ggplot2)

  data <- data.frame(
    x = c("a", "a", "a", "b", "b", "c", "c", "c", "c"),
    y = c(1, 2, 3, 4, 5, 6, 7, 8, 9)
  )

  # I expect a warning since there are ties in the dataset
  plot <- ggplot(data, aes(x, y)) +
    geom_boxplot() +
    stat_tukeyHSD()

  vdiffr::expect_doppelganger("TukeyHSD", {
    plot
  })
})


test_that("stat_tukeyHSD facet works", {
  library(ggplot2)

  plot <- ggplot(na.omit(palmerpenguins::penguins), aes(species, bill_length_mm, fill = species)) +
    geom_boxplot() +
    stat_tukeyHSD(vjust = -.2) +
    facet_grid(~sex)

  vdiffr::expect_doppelganger("TukeyHSD facet", {
    plot
  })
})

test_that("stat_tukeyHSD colors works", {
  library(ggplot2)

  data <- data.frame(
    x = c("a", "a", "a", "b", "b", "c", "c", "c", "c"),
    y = c(1, 2, 3, 4, 5, 6, 7, 8, 9)
  )

  # set seed for jitter
  set.seed(42)
  plot <- ggplot(data, aes(x, y, color=x)) +
    geom_jitter() +
    stat_tukeyHSD(colour = 'darkgreen')

  vdiffr::expect_doppelganger("stat_tukeyHSD_color", {
    plot
  })
})
