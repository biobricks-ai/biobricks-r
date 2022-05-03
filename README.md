# biobrickr
R package for biobricks

```R
remotes::install_github("biobricks-ai/biobrickr")
```

Load tables from [ncbi.nlm.nih.gov/clinvar](https://www.ncbi.nlm.nih.gov/clinvar/)
```R
library(dplyr)
Sys.setenv(bblib="/mnt/biobricks")
biobrickr::install("https://github.com/biobricks-ai/clinvar.git")
cv <- biobrickr::bake("clinvar")
ds <- biobrickr::lazy(cv)
```

View the table names:  
```R
names(ds)
# [1] "allele_gene" "cross_references" "gene_specific_summary"                 
# [4] "hgvs4variation" "organization_summary" "submission_summary"                    
# [7] "summary_of_conflicting_interpretations" "var_citations"                         
# [9] "variant_summary" "variation_allele"
```

Each table is a lazy table that can be loaded into memory:
```R
ds$allele_gene |> head() |> collect()
# AlleleID GeneID Symbol  Name                  GenesPerAlleleID Category Source
#    <dbl>  <dbl> <chr>   <chr>                            <dbl> <chr>    <chr> 
#    15041   9907 AP5Z1   adaptor related prot…                1 within … submi…
#    15042   9907 AP5Z1   adaptor related prot…                1 within … submi…
#    15043   9640 ZNF592  zinc finger protein …                1 within … submi…
#    15044  55572 FOXRED1 FAD dependent oxidor…                1 within … submi…
#    15045  55572 FOXRED1 FAD dependent oxidor…                1 within … submi…
#    15046  80224 NUBPL   NUBP iron-sulfur clu…                1 within … submi…
```
