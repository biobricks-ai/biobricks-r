#' Get the files in a brick
#' @param brick the brick to get files for
files <- function(brick) {
  bdir <- resolve(brick)
  fs::path(bdir,"data") |> fs::dir_ls(recurse=TRUE)
}

#' attempts to parse a data directory into dplyr lazy tables
#' @param files an array of files to parse 
#' @export
lazy <- function(files){
  pqt <- files |> purrr::keep(~ fs::path_ext(.) == "parquet")
  nm  <- fs::path_file(pqt) |> fs::path_ext_remove()
  purrr::map(pqt,~arrow::read_parquet(.,as_data_frame=F)) |> purrr::set_names(nm)
}

#' Return a list of tables for a brick
#' @param brick
#' @export
bricktables <- function(brick) {
  bfiles <- files(brick)
  lazy(bfiles)
}
