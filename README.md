
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
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(ggplot2)
library(ggsimplestats)
ggplot(mpg, aes(class, cty)) +
  geom_boxplot()  +
  stat_kwAllPairsDunnTest()
#> Warning in kwAllPairsDunnTest.default(x = data$y, g = data$x): Ties are present.
#> z-quantiles were corrected for ties.
```

<img src="man/figures/README-example-1.png" width="100%" />
