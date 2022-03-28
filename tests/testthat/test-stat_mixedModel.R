test_that("stat_mixedModel works", {
  library(ggplot2)

  df <- data.frame(patient=as.factor(rep(1:5, each=4)),
                   drug=as.factor(rep(1:4, times=5)),
                   response=c(30, 28, 16, 34,
                              14, 18, 10, 22,
                              24, 20, 18, 30,
                              38, 34, 20, 44,
                              26, 28, 14, 30))
  plot <- ggplot(df, aes(x=drug, y=response, color=patient)) +
    geom_point() +
    stat_mixedModel(aes(group = patient))

  vdiffr::expect_doppelganger("stat_mixedModel_Test", {
    plot
  })
})
