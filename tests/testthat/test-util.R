test_that("build.sh works", {
  local_bblib()
  sh  <- build.sh(bblib())
  res <- sh("ls")
  expect_equal(sh("ls"),"cache")

  install_brick("hello-brick")
  res <- sh("tree -L 1") |> paste0(collapse="\n")
  expect_equal(res,".\n├── biobricks-ai\n└── cache\n\n2 directories, 0 files")
})