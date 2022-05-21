
test_that("readme passes", {
  local_bblib()
  lines <- readLines(test_path("testdata","README.md"))

  beg  <-  1 + which(grepl("^```R",lines,ignore.case = T))
  end  <- -1 + which(grepl("^```([^R]|$)", lines))
  lns  <- purrr::map2(beg,end,~ lines[.x:.y]) |> purrr::flatten_chr()

  script <- withr::local_tempdir() |> fs::path("tmp.R")
  writeLines(lns,script)
  
  res <- purrr::safely(source)(script)$error
  err <- if(is.null(res$error)){ "no error" }else{ as.character(res$error) }
  expect_equal(err,"no error")
})

