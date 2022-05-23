test_that("install-and-brick_pull", {
  withr::local_envvar(list(bblib=""))
  expect_error(initialize(),
  "bblib must be directory\n* use `Sys.setenv(bblib='...')`",fixed=T)

  lib  <- local_bblib()
  emsg <- vglu("initialized biobricks to <dir>",dir=lib)
  expect_message(initialize(), emsg)
})
