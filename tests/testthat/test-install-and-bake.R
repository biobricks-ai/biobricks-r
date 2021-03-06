test_that("install-and-brick_repro-system", {
  local_bblib()
  biobricks::brick_install_gh("biobricks-ai/hello-brick")
  biobricks::brick_repro("hello-brick", env="system")
  hellotbl <- brick_load_arrow("hello-brick")$mtcars.parquet |> dplyr::collect()
  rownames(mtcars) <- 1:32
  expect_equal(hellotbl,mtcars)
})


test_that("install-and-brick_repro-docker", {
  testthat::skip_on_ci()
  local_bblib()
  biobricks::brick_install_gh("biobricks-ai/hello-brick")
  biobricks::brick_repro("hello-brick", env="docker")

  hellotbl <- brick_load_arrow("hello-brick")$mtcars |> dplyr::collect()
  rownames(mtcars) <- 1:32
  expect_equal(hellotbl,mtcars)
})

test_that("install-and-remove-and-install works",{
  local_bblib()
  
  install_and_test_hello_brick <- \(){
    biobricks::brick_install_gh("biobricks-ai/hello-brick")
    biobricks::brick_repro("hello-brick", env="system")
    
    hellotbl <- brick_load_arrow("hello-brick")$mtcars |> dplyr::collect()
    rownames(mtcars) <- 1:32
    expect_equal(hellotbl,mtcars)
  }

  install_and_test_hello_brick()
  
  biobricks::brick_remove("hello-brick")
  expect(purrr::is_empty(brick_path("hello-brick")),"hello-brick was not removed")
  
  install_and_test_hello_brick()
})

test_that("install-hello-1.0-and-update",{
  local_bblib()
  brick_install("hello-brick")
  brick <- brick_path("hello-brick")
  
  # RESET to 1.0, brick_repro, and look for hello.txt
  systemf("(cd %s; git reset --hard 1.0)",brick)
  brick_repro("hello-brick",env="system")
  expect_equal(brick_ls("hello-brick") |> fs::path_file(),c("hello.txt"))

  # update hello-brick, check that it has mtcars.parquet
  update_brick("hello-brick")
  brick_repro("hello-brick",env="system")
  expect_equal(
    brick_ls("hello-brick") |> fs::path_rel(brick_path(brick)) |> as.character(),
    c("data/hello.txt","data/iris.sqlite","data/mtcars.parquet","data/rtbls","data/rtbls/iris.parquet","data/rtbls/mtcars.parquet"))
})

test_that("graceful error from missing remote",{
  local_bblib()
  safe.install <- purrr::safely(brick_install)("k@_-.")
  expect_equal(
    safe.install$error$message,
    "https://github.com/biobricks-ai/k@_-. is not a git repo")
})
