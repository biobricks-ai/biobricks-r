test_that("load sqlite", {
  local_bblib()
  brick <- "hello-brick"
  install_brick(brick)

  brick_repro(brick,env="system")
  
  tbls <- brick_load_sqlite("hello-brick")
  expect_equal(names(tbls),"iris.sqlite")
  
  sql.iris <- tbls$iris.sqlite$iris |> dplyr::collect()
  sql.iris$Species <- as.factor(sql.iris$Species)
  sql.iris <- as.data.frame(sql.iris)
  expect_equal(sql.iris,iris)
})
