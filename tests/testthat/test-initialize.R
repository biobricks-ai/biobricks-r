test_that("initialize-without-BBLIB", {
  withr::local_envvar(list(BBLIB=""))
  expect_error(initialize(),
  "BBLIB must be directory\n* use `Sys.setenv(BBLIB='...')`",fixed=T)

  lib  <- local_bblib()
  emsg <- vglu("initialized biobricks to <dir>",dir=lib)
  expect_message(initialize(), emsg)
})
