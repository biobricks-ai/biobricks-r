test_that("bblib matches bblib environmental variable", {
  tmp1 <- withr::local_tempdir()
  withr::local_envvar(list(bblib=tmp1))
  expect_equal(as.character(bblib()), tmp1)
})
