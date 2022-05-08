test_that("install-and-bake", {
  # TODO need to make this test actually work
  # add fixtures (see https://testthat.r-lib.org/articles/test-fixtures.html) and belo
  # bblib <- withr::local_dir(tempdir(),getwd()) 
  # withr::with_envvar(new=c("bblib"=bblib),Sys.getenv("bblib"))
  
  biobricks::install_gh("biobricks-ai/hello-brick")
  biobricks::bake("hello-brick")
})
