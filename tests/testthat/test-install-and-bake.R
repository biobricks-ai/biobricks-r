test_that("install-and-bake-system", {
  local_bblib()
  set_git_config()
  biobricks::install_gh("biobricks-ai/hello-brick")
  biobricks::bake("hello-brick", env="system")
  hellotbl <- bricktables("hello-brick")$mtcars |> dplyr::collect()
  rownames(mtcars) <- 1:32
  expect_equal(hellotbl,mtcars)
})

test_that("install-and-bake-docker", {
  testthat::skip_on_ci()
  local_bblib()
  biobricks::install_gh("biobricks-ai/hello-brick")
  biobricks::bake("hello-brick", env="docker")

  hellotbl <- bricktables("hello-brick")$mtcars |> dplyr::collect()
  rownames(mtcars) <- 1:32
  expect_equal(hellotbl,mtcars)
})

test_that("install-and-remove-and-install works",{
  local_bblib()
  set_git_config()
  install_and_test_hello_brick <- \(){
    biobricks::install_gh("biobricks-ai/hello-brick")
    biobricks::bake("hello-brick", env="system")
    
    hellotbl <- bricktables("hello-brick")$mtcars |> dplyr::collect()
    rownames(mtcars) <- 1:32
    expect_equal(hellotbl,mtcars)
  }

  install_and_test_hello_brick()
  
  biobricks::remove.biobricks("hello-brick")
  expect(purrr::is_empty(resolve("hello-brick")),"hello-brick was not removed")
  
  install_and_test_hello_brick()
})

test_that("install-hello-1.0-and-update",{
  local_bblib()
  skip_on_ci()
  install.biobricks("hello-brick")
  brick <- resolve("hello-brick")
  
  # RESET to 1.0, bake, and look for hello.txt
  systemf("(cd %s; git reset --hard 1.0)",brick)
  bake("hello-brick")
  expect_equal(brickfiles("hello-brick") |> fs::path_file(),c("hello.txt"))

  # update hello-brick, check that it has mtcars.parquet
  update.biobricks("hello-brick")
  bake("hello-brick")
  expect_equal(brickfiles("hello-brick") |> fs::path_file(),c("mtcars.parquet"))
})

test_that("graceful error from missing remote",{
  local_bblib()
  safe.install <- purrr::safely(install.biobricks)("k@_-.")
  expect_equal(
    safe.install$error$message,
    "https://github.com/biobricks-ai/k@_-..git is not a git repo")
})

# test_that("bricks-with-dependencies-work", {
#   # TODO #8 make a test for bricks with dependencies
#   biobricks::install_gh("biobricks-ai/hello-brick")
#   biobricks::bake("hello-brick", env="docker")
# })
