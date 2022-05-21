# biobricks
<!-- badges: start -->
[![codecov](https://codecov.io/gh/biobricks-ai/biobricks-r/branch/main/graph/badge.svg?token=J041MF0JKG)](https://codecov.io/gh/biobricks-ai/biobricks-r)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->
R package for biobricks

```R
remotes::install_github("biobricks-ai/biobricks-R")
biobricks::local_bblib() # OR set a permanent brick dir w/ Sys.setenv(bblib=...) 
biobricks::initialize()  # init the biobricks library
```

Load the HGNC namespace [github.com/biobricks.ai/HGNC](https://github.com/biobricks.ai/HGNC):
```R
library(biobricks)
install_brick("HGNC")
brick_pull("HGNC") # OR build it with brick_repro("HGNC")
```

Load the brick and view the table names:  
```R
tbls <- brick_load_arrow("HGNC")
names(tbls) # "hgnc_complete_set.parquet"
```

Each table is a lazy table that can be loaded into memory:
```R
tbls$hgnc_complete_set.parquet |> dplyr::collect()

# # A tibble: 43,147 × 54
#    hgnc_id    symbol  name  locus_group locus_type
#  * <chr>      <chr>   <chr> <chr>       <chr>     
#  1 HGNC:5     A1BG    alph… protein-co… gene with…
#  2 HGNC:37133 A1BG-A… A1BG… non-coding… RNA, long…
#  3 HGNC:24086 A1CF    APOB… protein-co… gene with…
#  4 HGNC:7     A2M     alph… protein-co… gene with…
#  5 HGNC:27057 A2M-AS1 A2M … non-coding… RNA, long…
#  6 HGNC:23336 A2ML1   alph… protein-co… gene with…
#  7 HGNC:41022 A2ML1-… A2ML… non-coding… RNA, long…
#  8 HGNC:41523 A2ML1-… A2ML… non-coding… RNA, long…
#  9 HGNC:8     A2MP1   alph… pseudogene  pseudogene
# 10 HGNC:30005 A3GALT2 alph… protein-co… gene with…
# # … with 43,137 more rows, and 49 more variables:
# #   status <chr>, location <chr>,
# #   location_sortable <chr>, alias_symbol <chr>,
# #   alias_name <chr>, prev_symbol <chr>,
# #   prev_name <chr>, gene_group <chr>,
# #   gene_group_id <chr>,
# #   date_approved_reserved <date>, …
```
