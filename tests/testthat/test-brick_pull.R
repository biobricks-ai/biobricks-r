#' #todo this had an error on `dvc pull`` that was fixed by updating pip 
test_that("install-and-brick_pull", {
  local_bblib()
  install_brick_gh("biobricks-ai/hello-brick")
  brick_pull("hello-brick")
  hellotbl <- brick_load_arrow("hello-brick")$mtcars.parquet |> dplyr::collect()
  rownames(mtcars) <- 1:32
  expect_equal(hellotbl,mtcars)
})
