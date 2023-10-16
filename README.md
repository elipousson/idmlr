
<!-- README.md is generated from README.Rmd. Please edit that file -->

# idmlr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

The goal of idmlr is to read and (eventually) modify and write InDesign
Markup Language (IDML) files.

## Installation

You can install the development version of idmlr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pkg_install("elipousson/idmlr")
```

## Example

This is a basic example which shows you how to read an IDML file:

``` r
library(idmlr)


read_idml(system.file("idml/letter_portrait_standard.idml", package = "idmlr"))
#> <idml[3]>
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        file 
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               letter_portrait_standard.idml 
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        path 
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  /var/folders/3f/50m42dx1333_dfqb5772j6_40000gn/T//RtmpfmpL6W/letter_portrait_standard.idml 
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    contents 
#> <pointer: 0x14460d810>, <pointer: 0x14463bad0>, <pointer: 0x144635d90>, <pointer: 0x144635aa0>, <pointer: 0x144661740>, <pointer: 0x144661470>, <pointer: 0x14466aeb0>, <pointer: 0x144664900>, <pointer: 0x1446b27f0>, <pointer: 0x14466aca0>, <pointer: 0x1446c6370>, <pointer: 0x1446b25e0>, <pointer: 0x107c2df00>, <pointer: 0x107c2dc10>, <pointer: 0x1346d6b00>, <pointer: 0x1346d6830>, <pointer: 0x1346dad10>, <pointer: 0x1346dac00>, <pointer: 0x1346e0ad0>, <pointer: 0x1346e0860>, <pointer: 0x1346e53d0>, <pointer: 0x1346e5160>, <pointer: 0x1346e6460>, <pointer: 0x1346e6130>, application/vnd.adobe.indesign-idml-package
```
