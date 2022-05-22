test_that("check_has_bblib", {
  expect_equal(2 * 2, 4) # TODO write this test, maybe remove `check_init` function
})

test_that("check_is_git_repo", {
  expect_error(check_is_git_repo("snoop"),"snoop is not a git repo",fixed=T)
  expect_error(check_is_git_repo("https://github.com/biobricks-ai/aQWsdf"),
    "https://github.com/biobricks-ai/aQWsdf is not a git repo", fixed=T)
  expect_true(check_is_git_repo("https://github.com/biobricks-ai/biobricks-r"))
})

test_that("check_can_install", {
  local_bblib()
  expect_true(check_can_install("hello-brick"))
  install_brick("hello-brick")
  expect_error(check_can_install("hello-brick"),"hello-brick already exists, can't install",fixed=T)
})

test_that("check_brick_exists", {
  local_bblib()
  expect_error(check_brick_exists("hello-brick"),
  "missing brick hello-brick try `install_brick(brick)`",fixed=T)
  install_brick("hello-brick")
  expect_true(check_brick_exists("hello-brick"))
})

test_that("check_brick_has_data", {
  expect_error(check_init(),"No bblib. Use `Sys.setenv(bblib='???')`",fixed=T)
})

test_that("check_init", {
  expect_error(check_init(),"No bblib. Use `Sys.setenv(bblib='???')`",fixed=T)
  local_bblib()
  expect_true(check_init())
})

test_that("check has git and has dvc", {
  expect_true(check_has_git())
  expect_true(check_has_dvc())
})
