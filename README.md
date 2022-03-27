
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

## Example

This is a minimal example of how to add the statistics to a plot. In
this example we use the `PlantGrowth` dataset.

``` r
library(ggplot2)
library(ggsimplestats)

theme_set(ggthemes::theme_few())

ggplot(PlantGrowth, aes(group, weight, fill=group)) +
  geom_boxplot()  +
  stat_kwAllPairsDunnTest()
#> Warning in kwAllPairsDunnTest.default(x = data$y, g = data$x): Ties are present.
#> z-quantiles were corrected for ties.
```

<img src="man/figures/README-example-1.png" width="100%" />

### Change format of p-value

If wanted, the format of the p value / label can be changed. The default
uses `scales::pvalue`. To format the p values as ‘stars’ we can.
e.g. use the `stars.pval` function from `gtools`

``` r
ggplot(PlantGrowth, aes(group, weight, fill=group)) +
  geom_boxplot()  +
  stat_kwAllPairsDunnTest(format.fun = gtools::stars.pval, 
                          size = 15,
                          vjust = .3)
#> Warning in kwAllPairsDunnTest.default(x = data$y, g = data$x): Ties are present.
#> z-quantiles were corrected for ties.
```

<img src="man/figures/README-change p value format-1.png" width="100%" />

Or you can pass a lambda function to create a custom label.

``` r
ggplot(PlantGrowth, aes(group, weight, fill=group)) +
  geom_boxplot()  +
  stat_kwAllPairsDunnTest(format.fun = \(x) {glue::glue('my p-value {scales::pvalue(x)}')},
                          vjust = -.2)
#> Warning in kwAllPairsDunnTest.default(x = data$y, g = data$x): Ties are present.
#> z-quantiles were corrected for ties.
```

<img src="man/figures/README-p value lambda function-1.png" width="100%" />

### Use with facets

The statistics are calculated for each panel in the plot.

``` r
ggplot(na.omit(palmerpenguins::penguins), aes(species, bill_length_mm, fill=species)) +
  geom_boxplot()  +
  stat_kwAllPairsDunnTest(vjust = -.2) +
  facet_grid(~sex)
#> Warning in kwAllPairsDunnTest.default(x = data$y, g = data$x): Ties are present.
#> z-quantiles were corrected for ties.

#> Warning in kwAllPairsDunnTest.default(x = data$y, g = data$x): Ties are present.
#> z-quantiles were corrected for ties.
```

<img src="man/figures/README-facet-1.png" width="100%" />

### Parametric test

Use a Anova with TukeyHSD as a parametric alternative.

``` r
ggplot(PlantGrowth, aes(group, weight, fill=group)) +
  geom_boxplot()  +
  stat_tukeyHSD()
```

<img src="man/figures/README-TukeyHSD-1.png" width="100%" /> Again, this
works with facets too.

``` r
ggplot(na.omit(palmerpenguins::penguins), aes(species, bill_length_mm, fill=species)) +
  geom_boxplot()  +
  stat_tukeyHSD(vjust = -.2) +
  facet_grid(~sex)
```

<img src="man/figures/README-tukey and facet-1.png" width="100%" />

`step.increase` changes the space between two brackets.

``` r
ggplot(na.omit(palmerpenguins::penguins), aes(species, bill_length_mm, fill=species)) +
  geom_boxplot()  +
  stat_tukeyHSD(vjust = -.2,
                step.increase = 0.2,
                format.fun = \(x) {glue::glue('parametric p-value\n{scales::pvalue(x)}')}) +
  facet_grid(~sex) +
  scale_y_continuous(expand = expansion(mult = c(0,0.15)))
```

<img src="man/figures/README-step.increase-1.png" width="100%" />
