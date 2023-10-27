test_that("biobricks can load hello-brick", {
  assets <- bbassets("hello-brick")
  mynames <- c("rtbls.mtcars.parquet","rtbls.iris.parquet","iris.sqlite","mtcars.parquet")
  expect_true(all(mynames %in% names(assets)))
})
