test_that("brick_ls_remote", {
  local_bblib()
  install_brick("hello-brick")
  a <- brick_ls_remote("hello-brick") |> purrr::transpose()
  
  expect_setequal(a$outs,  c("data/iris.sqlite","data/mtcars.parquet","data/rtbls/"))
  expect_setequal(a$remote,c(
    "https://ins-dvc.s3.amazonaws.com/insdvc/91/9a165fe605e7084168aafe3542c099",
    "https://ins-dvc.s3.amazonaws.com/insdvc/cc/1ba147effafe2e0aa844f598a7c30d",
    "https://ins-dvc.s3.amazonaws.com/insdvc/a0/038a50e44a720cd151365e5877bf48.dir"
  ))
})
