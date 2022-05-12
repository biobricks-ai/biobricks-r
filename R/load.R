#' Get the files in a brick
#' @param brick the brick to get files for
#' @param regex the brick to get files for
#' @export
brick_ls <- function(brick,regex) {
  files <- brick_path(brick) |> fs::path("data") |> fs::dir_ls(recurse=TRUE)
  names <- fs::path_file(files) |> fs::path_ext_remove()
  purrr::set_names(files,names)
}

#' Return a list of tables for a brick
#' @param brick the name of the brick to load
#' @param .p which files should be loaded this way?
#' @param .l which loading function should be used?
#' @param env some loading functions use .env to manage connections
#' @export
brick_load <- function(brick, .p, .l, env=parent.frame()) {
  brick_ls(brick) |> purrr::keep(.p) |> purrr::map(.l) 
}

#' A helper to use brick_load with the arrow package
#' @param brick the name of the brick to load
#' @param .p default to grepl on tabular names like parquet, arrow, csv, tsv, etc.
#' @importFrom purrr partial
#' @export
brick_load_arrow <- \(brick,.p=partial(grepl,pat="(parquet|arrow|ipc|feather|csv|tsv|text)$",i=T)){
  brick_load(brick, .p=.p, .l=arrow::open_dataset)
}

#' A helper to use brick_load with a custom sqlite loader. opens a sqlite connection
#' and closes it when parent exits.
#' @param brick the name of the brick to load
#' @param .p default to grepl on sqlite names like .db and .sqlite
#' @param env when @param env exits, biobricks closes the sqlite connection
#' @importFrom purrr partial
#' @export
brick_load_sqlite <- \(brick, .p=partial(grepl,pat="(\\.db$|\\.sqlite)",i=T), env=parent.frame()){
  
  sqlite_load <- function(file,env=parent.frame()){
    con <- DBI::dbConnect(RSQLite::SQLite(),file)
    withr::defer(DBI::dbDisconnect(con), envir=env)
    
    tbls <- DBI::dbListTables(con)
    tbls <- tbls |> purrr::set_names(tbls) |> purrr::map(~ dplyr::tbl(src=con,.))
    warning("opened sqlite con. 
      * auto close on parent exit. 
      * manual close with withr::deferred_run()")
    tbls
  }
  
  brick_load(brick, .p=.p, .l=sqlite_load)
}