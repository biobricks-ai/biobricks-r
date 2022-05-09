#' Get the files in a brick
#' @param brick the brick to get files for
brickfiles <- function(brick) {
  resolve(brick) |> fs::path("data") |> fs::dir_ls(recurse=TRUE)
}

#' Return a list of tables for a brick
#' TODO #1 improve loading. How do we handle sqlite? other loading functions?
#' @param brick the name of the brick to import
#' @param load how should files be loaded in R?
#' @export
bricktables <- function(brick,load=arrow::open_dataset) {
  file  <- brickfiles(brick)
  name  <- fs::path_file(file) |> fs::path_ext_remove()
  purrr::map(file,load) |> purrr::set_names(name)
}
