#' Get the files in a brick
#' @param brick the brick to get files for
#' @param .p a predicate to filter returned files (must return true on file path)
#' @export
brick_ls <- \(brick,.p=NULL) { 
  check_brick_has_data(brick)
  res <- brick_path(brick,"data") |> fs::dir_ls(recurse = T)
  if(is.null(.p)){ res }else{ purrr::keep(res,.p) }
}

#' creates a nested list of values by path
#' @param x a set of values to make into nested list
#' @param path filesytem paths to nest
#' @importFrom purrr map
#' @keyword internal
fs_recurse <- \(x,path=names(x)){
  if(all(fs::path_dir(path)==".")){ return(set_names(x,path)) }
  split(x, fs::path_dir(path)) |> purrr::imap( ~ fs_recurse(.x,fs::path_rel(names(.x),.y)))
}

#' Return a list of tables for a brick
#' @param brick the name of the brick to load
#' @param .p which files should be loaded this way?
#' @param .l which loading function should be used?
#' @param recurse return a nested list of values
#' @export
brick_load <- function(brick, .p, .l, recurse=T) {
  rp <- brick_ls(brick,.p) |> fs::path_rel(brick_path(brick,"data"))
  v  <- brick_ls(brick,.p) |> purrr::map(.l) |> purrr::set_names(rp)
  if(recurse){ fs_recurse(v,rp) }else{ v }
}

#' A helper to use brick_load with the arrow package
#' @param brick the name of the brick to load
#' @importFrom purrr partial
#' @export
brick_load_arrow <- \(brick){
  is_tab  <- \(f){ fs::path_ext(f) %in% c("parquet","arrow","ipc","feather","csv","tsv","text") }
  is_part <- \(f){ grepl("/.*parquet/",f) } # datasets should be dirs with tab ext
  brick_load(brick, .p=\(f){ is_tab(f) && !is_part(f) }, .l=arrow::open_dataset)
}

#' A helper to use brick_load with a custom sqlite loader. opens a sqlite connection
#' and closes it when parent exits.
#' @param brick the name of the brick to load
#' @param env when @param env exits, biobricks closes the sqlite connection
#' @export
brick_load_sqlite <- \(brick, env=parent.frame()){
  
  sqlite_load <- function(file){
    con <- DBI::dbConnect(RSQLite::SQLite(),file)
    withr::defer(DBI::dbDisconnect(con), envir=env)

    tbls <- DBI::dbListTables(con)
    tbls <- tbls |> purrr::set_names(tbls) |> purrr::map(~ dplyr::tbl(src=con,.))
    tbls$close <- \(){ DBI::dbDisconnect(con) }
    
    tbls
  }
  
  message("opened sqlite connection 
      * auto closes on parent exit
      * manual close with .$close() or `withr::deferred_run()`")

  .p  <- \(file){ grepl(pat="(\\.db$|\\.sqlite)", file, i=T) }
  res <- brick_load(brick, .p=.p, .l=sqlite_load)
}