#' Get the files in a brick
#' @param brick the brick to get files for
#' @importFrom purrr set_names map_if is_empty
#' @export
brick_ls <- \(brick) { brick_path(brick,"data") |> fs::dir_ls(recurse = T) }

#' creates a nested list of values by path # TODO replace this with something simpler
#' @param x a set of values to make into nested list
#' @param path filesytem paths to nest
#' @importFrom purrr map
#' @keyword internal
fs_list <- \(x,path){
  splits <- fs::path_split(path) |> purrr::transpose() |> map(as.character) 
  rsplit <- function(v,splits){
    if(length(splits) == 0){ return(v[[1]]) }
    vsplit <- split(v,splits[[1]])
    isplit <- split(seq_along(v), splits[[1]])
    nsplit <- map(isplit, \(i){ map(splits[-1], ~ .[i]) })
    purrr::map2(vsplit, nsplit, ~ rsplit(.x,.y))
  }

  rsplit(x,splits)
}

#' Return a list of tables for a brick
#' @param brick the name of the brick to load
#' @param .p which files should be loaded this way?
#' @param .l which loading function should be used?
#' @param recurse return a nested list of values
#' @param env some loading functions use .env to manage connections
#' @export
brick_load <- function(brick, .p, .l, recurse=T, env=parent.frame()) {
  v <- brick_ls(brick) |> purrr::keep(.p) |> purrr::map(.l) 
  v <- purrr::set_names(v,~ fs::path_rel(.,brick_path(brick,"data")))
  if(recurse){ fs_list(v,names(v)) }else{ v }
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