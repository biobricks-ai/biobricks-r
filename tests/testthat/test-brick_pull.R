test_that("install-and-brick_pull", {
  local_bblib()
  brick_install("hello-brick")
  brick_pull("hello-brick")
  hellotbl <- brick_load_arrow("hello-brick")$mtcars.parquet |> dplyr::collect()
  rownames(mtcars) <- 1:32
  expect_equal(hellotbl,mtcars)
})
