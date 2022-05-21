
test_that("readme passes", {
  lines <- readLines(here::here("README.md"))

  beg  <-  1 + which(grepl("^```R",lines,ignore.case = T))
  end  <- -1 + which(grepl("^```([^R]|$)", lines))
  lns  <- purrr::map2(beg,end,~ lines[.x:.y]) |> purrr::flatten_chr()

  script <- withr::local_tempdir() |> fs::path("tmp.R")
  writeLines(scriptln,script)
  
  expect_equal(system2("Rscript",script), 0)
})

