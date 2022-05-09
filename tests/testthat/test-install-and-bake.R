 test_that("install-and-bake-system", {
  biobricks::install_gh("biobricks-ai/hello-brick")
  biobricks::bake("hello-brick", env="system")
  test_df <- biobricks::bricktables("hello-brick") |>
  purrr::pluck('mtcars') |> dplyr::collect()
  row_count <- nrow(test_df)
  expect_gt(row_count,1)
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