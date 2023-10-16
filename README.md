
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

## Usage

``` r
library(idmlr)
```

This is a basic example which shows you how to read an IDML file:

``` r
idml <- read_idml(system.file("idml/letter_portrait_standard.idml", package = "idmlr"))

idml
#> <idml[3]>
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        file 
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               letter_portrait_standard.idml 
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        path 
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  /var/folders/3f/50m42dx1333_dfqb5772j6_40000gn/T//RtmpCr945k/letter_portrait_standard.idml 
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    contents 
#> <pointer: 0x140e93220>, <pointer: 0x140e92f00>, <pointer: 0x140e94bd0>, <pointer: 0x140e94840>, <pointer: 0x140ebe840>, <pointer: 0x140ebe580>, <pointer: 0x140ec8070>, <pointer: 0x140ec1ac0>, <pointer: 0x120213a40>, <pointer: 0x1202136f0>, <pointer: 0x1202275b0>, <pointer: 0x120213830>, <pointer: 0x12028b150>, <pointer: 0x12028aee0>, <pointer: 0x1202ffdc0>, <pointer: 0x1202ffad0>, <pointer: 0x1203087d0>, <pointer: 0x120308470>, <pointer: 0x12030a040>, <pointer: 0x120309cf0>, <pointer: 0x12030b430>, <pointer: 0x12030b0e0>, <pointer: 0x12030c370>, <pointer: 0x12030c0a0>, application/vnd.adobe.indesign-idml-package
```

You can then get the styles from the `idml` object as a list or in a
`xml_document` format:

``` r
get_idml_styles(idml)
#> {xml_document}
#> <Styles DOMVersion="18.5" xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging">
#> [1] <RootCharacterStyleGroup Self="u7f">\n  <CharacterStyle Self="CharacterSt ...
#> [2] <RootParagraphStyleGroup Self="u7e">\n  <ParagraphStyle Self="ParagraphSt ...
#> [3] <TOCStyle Self="TOCStyle/$ID/DefaultTOCStyleName" TitleStyle="ParagraphSt ...
#> [4] <RootCellStyleGroup Self="u8e">\n  <CellStyle Self="CellStyle/$ID/[None]" ...
#> [5] <RootTableStyleGroup Self="u90">\n  <TableStyle Self="TableStyle/$ID/[No  ...
#> [6] <RootObjectStyleGroup Self="u99">\n  <ObjectStyle Self="ObjectStyle/$ID/[ ...
#> [7] <TrapPreset Self="TrapPreset/$ID/k[No Trap Preset]" Name="$ID/k[No Trap P ...
#> [8] <TrapPreset Self="TrapPreset/$ID/kDefaultTrapStyleName" Name="$ID/kDefaul ...
```

You can also get fonts and other resources or metadata:

``` r
get_idml_fonts(idml)
#> {xml_document}
#> <Fonts DOMVersion="18.5" xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging">
#> [1] <FontFamily Self="di3f" Name="Minion Pro">\n  <Font Self="di3fFontnMinion ...
#> [2] <FontFamily Self="di9d" Name="Myriad Pro">\n  <Font Self="di9dFontnMyriad ...
#> [3] <FontFamily Self="diaa" Name="Kozuka Mincho Pr6N">\n  <Font Self="diaaFon ...
#> [4] <FontFamily Self="di222" Name="Courier New">\n  <Font Self="di222FontnCou ...
#> [5] <CompositeFont Self="CompositeFont/$ID/[No composite font]" Name="$ID/[No ...
```
