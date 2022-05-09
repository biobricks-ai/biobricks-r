test_that("install-and-bake-system", {
  # TODO #5 need to make this test actually work
  # add fixtures (see https://testthat.r-lib.org/articles/test-fixtures.html) and belo
  # bblib <- withr::local_dir(tempdir(),getwd()) 
  # withr::with_envvar(new=c("bblib"=bblib),Sys.getenv("bblib"))
  
  biobricks::install_gh("biobricks-ai/hello-brick")
  biobricks::bake("hello-brick", env="system")
})

test_that("install-and-bake-docker", {
  # TODO make an skipped test for the docker env
  # add fixtures (see https://testthat.r-lib.org/articles/test-fixtures.html) and belo
  # bblib <- withr::local_dir(tempdir(),getwd()) 
  # withr::with_envvar(new=c("bblib"=bblib),Sys.getenv("bblib"))
  
  biobricks::install_gh("biobricks-ai/hello-brick")
  biobricks::bake("hello-brick", env="docker")
})