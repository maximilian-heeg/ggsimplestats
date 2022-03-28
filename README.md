
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggsimplestats

<!-- badges: start -->

[![R-CMD-check](https://github.com/maximilian-heeg/ggsimplestats/workflows/R-CMD-check/badge.svg)](https://github.com/maximilian-heeg/ggsimplestats/actions)
<!-- badges: end -->

The goal of ggsimplestats is to provide an easy interface to add
statistics to boxplot created with ggplot2

## Installation

You can install the development version of ggsimplestats like so:

``` r
# install.packages("devtools")
devtools::install_github("maximilian-heeg/ggsimplestats")
```

## Minimal Example

This is a minimal example of how to add the statistics to a plot. In
this example we use the `PlantGrowth` dataset.

``` r
library(ggplot2)
library(ggsimplestats)

theme_set(ggthemes::theme_few())

ggplot(PlantGrowth, aes(group, weight, fill=group)) +
  geom_boxplot()  +
  stat_kwAllPairsDunnTest()
```

![](man/figures/README-example-1.png)<!-- -->

## Test types

Currently, four different tests are supported.

-   Two parametric tests
    -   `stat_tukeyHSD` performes a TukeyHSD posthoc test on a anova.
    -   `stat_mixedModel` creates a mixed model with `lmer` using
        `y ~ x + (1|group)`.  
        In a second step, significanes are calcuated using
        `pairs(emmeans(model ~ x))`.
-   Two non-parametric tests
    -   `stat_kwAllPairsDunnTest` uses `PMCMRplus::kwAllPairsDunnTest()`
        to perform Dunn’s non-parametric all-pairs comparison test for
        Kruskal-type ranked data
    -   `stat_frdAllPairsNemenyiTest` uses
        `PMCMRplus::frdAllPairsNemenyiTest()` to perform Nemenyi’s
        all-pairs comparisons tests of Friedman-type ranked data

## Further reading

For further information please see the `vignette("ggsimplestats")`.
