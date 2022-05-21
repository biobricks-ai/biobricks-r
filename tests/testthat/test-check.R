test_that("check_has_bblib", {
  expect_equal(2 * 2, 4)
})

test_that("check_is_git_repo", {
  expect_equal(2 * 2, 4)
})

test_that("check_empty_repo", {
  expect_equal(2 * 2, 4)
})

test_that("check_brick_exists", {
  expect_equal(2 * 2, 4)
})

test_that("check_brick_has_data", {
  expect_error(check_init(),"No bblib. Use `Sys.setenv(bblib='???')`",fixed=T)
})

test_that("check_init", {
  expect_error(check_init(),"No bblib. Use `Sys.setenv(bblib='???')`",fixed=T)
  local_bblib()
  expect_true(check_init())
})
