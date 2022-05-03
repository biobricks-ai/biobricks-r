#' attempts to parse a data directory into dplyr lazy tables
#' @param files an array of files to parse 
#' @export
lazy <- function(files){
  pqt <- files |> purrr::keep(~ fs::path_ext(.) == "parquet")
  nm  <- fs::path_file(pqt) |> fs::path_ext_remove()
  purrr::map(pqt,~arrow::read_parquet(.,as_data_frame=F)) |> purrr::set_names(nm)
}
