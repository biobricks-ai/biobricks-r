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
  withr::local_envvar(list(bblib=""))
  expect_error(check_init(),"No bblib. Use `Sys.setenv(bblib='...')`",fixed=T)
  
  local_bblib()
  install_brick("hello-brick")
  expect_error(check_brick_has_data("hello-brick"),
  "no data for hello-brick\n`brick_pull` to pull data\n`brick_repro` to build data",fixed=T)
  
  brick_repro("hello-brick",env="system")
  expect_true(check_brick_has_data("hello-brick"))
})

test_that("check_init", {
  withr::local_envvar(list(bblib=""))
  expect_error(check_init(),"No bblib. Use `Sys.setenv(bblib='...')`",fixed=T)

  bblib <- withr::local_tempdir()
  withr::local_envvar(list(bblib=bblib))
  expect_error(check_init(),"bblib is not initialized",fixed=T)
  
  initialize()
  expect_true(check_init())
})

test_that("check has git and has dvc", {
  expect_true(check_has_git())
  expect_error(check_has_git(fail = T),"git must be installed. See https://github.com/git-guides/install-git")
  expect_true(check_has_dvc())
  expect_error(check_has_dvc(fail = T),"dvc must be installed. See https://dvc.org/doc/install")
})
