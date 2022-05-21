test_that("check_has_bblib", {
  expect_equal(2 * 2, 4) # TODO write this test, maybe remove `check_init` function
})

test_that("check_is_git_repo", {
  expect_error(check_is_git_repo("snoop"),"snoop is not a git repo",fixed=T)
  expect_error(check_is_git_repo("https://github.com/biobricks-ai/aQWsdf"),
    "https://github.com/biobricks-ai/aQWsdf is not a git repo", fixed=T)
  expect_true(check_is_git_repo("https://github.com/biobricks-ai/biobricks-r"))
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
