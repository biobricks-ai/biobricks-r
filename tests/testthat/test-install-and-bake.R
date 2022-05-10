local_bblib <- function(env=parent.frame()){
  bblib <- withr::local_tempdir(.local_envir = env)
  withr::local_envvar(list(bblib=bblib),.local_envir = env)
  biobricks::initialize()
}

test_that("install-and-bake-system", {
  local_bblib()
  biobricks::install_gh("biobricks-ai/hello-brick")
  biobricks::bake("hello-brick", env="system")
  
  hellotbl <- bricktables("hello-brick")$mtcars |> dplyr::collect()
  rownames(mtcars) <- 1:32
  expect_equal(hellotbl,mtcars)
})

test_that("install-and-bake-docker", {
  has_docker = suppressWarnings(system("docker"))
  testthat::skip_if(has_docker!=0) # need docker for test

  local_bblib() 
  biobricks::install_gh("biobricks-ai/hello-brick")
  biobricks::bake("hello-brick", env="docker")

  hellotbl <- bricktables("hello-brick")$mtcars |> dplyr::collect()
  rownames(mtcars) <- 1:32
  expect_equal(hellotbl,mtcars)
})

test_that("install-and-remove-and-install works",{
  local_bblib()
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

# test_that("bricks-with-dependencies-work", {
#   # TODO #8 make a test for bricks with dependencies
#   biobricks::install_gh("biobricks-ai/hello-brick")
#   biobricks::bake("hello-brick", env="docker")
# })  