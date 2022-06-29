test_that("build_shell works", {
  local_bblib()
  sh  <- build_shell(bblib())
  res <- sh("ls")
  expect_equal(sh("ls"),"cache")

  brick_install("hello-brick")
  res <- sh("tree -L 1") |> paste0(collapse="\n")
  expect_equal(res,".\n├── biobricks-ai\n└── cache\n\n2 directories, 0 files")
})