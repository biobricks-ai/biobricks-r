local_bblib <- function(env=parent.frame()){
  bblib <- withr::local_tempdir(.local_envir = env)
  withr::local_envvar(list(bblib=bblib),.local_envir = env)
  biobricks::initialize()
}

test_that("install-and-bake-system", {
  local_bblib()
  install_gh("biobricks-ai/hello-brick")
  bake("hello-brick", env="system")
  
  hellotbl <- bricktables("hello-brick")$mtcars |> dplyr::collect()
  rownames(mtcars) <- 1:32
  expect_equal(hellotbl,mtcars)
})

# test_that("install-and-bake-docker", {
#   # TODO #6 make an skipped test for the docker env
#   # add fixtures (see https://testthat.r-lib.org/articles/test-fixtures.html) and belo
#   # bblib <- withr::local_dir(tempdir(),getwd()) 
#   # withr::with_envvar(new=c("bblib"=bblib),Sys.getenv("bblib"))
  
#   biobricks::install_gh("biobricks-ai/hello-brick")
#   biobricks::bake("hello-brick", env="docker")
# })

# test_that("bricks-with-dependencies-work", {
#   # TODO #8 make a test for bricks with dependencies
#   biobricks::install_gh("biobricks-ai/hello-brick")
#   biobricks::bake("hello-brick", env="docker")
# })  