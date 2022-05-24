#' Find urls for brick outs
#' @param brick the brick to get files for
#' @param .p a predicate to filter returned files (must return true on file path)
#' @export
brick_ls_remote <- \(brick){
  ori <- git2r::remote_url(brick_path(brick),remote="origin")
  dvc <- partial(reticulate::import("dvc.api")$get_url,repo=ori)
  
  stg <- yaml::read_yaml(brick_path(brick,"dvc.lock"))$stages
  out <- stg |> map("outs") |> flatten() |> map("path")
  map(out,~ list(outs=., remote=dvc(.)))
}

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
#' @param p filesytem paths to nest and use for names
#' @param pd 'path_dir' used for recursion
#' @param pr 'path_rel' used for recursion
#' @keyword internal
ptree <- \(x,p=names(x),pd=fs::path_dir(p),pr=purrr::map2(p,pd,fs::path_rel)){
  a <- purrr::set_names(x,pr) |> split(pd) 
  c(a[["."]], purrr::map(a[which(names(a)!=".")],ptree))
}

#' Return a list of tables for a brick
#' @param brick the name of the brick to load
#' @param .p which files should be loaded this way?
#' @param .l which loading function should be used?
#' @export
brick_load <- function(brick, .p, .l) {
  relpath <- brick_ls(brick,.p) |> fs::path_rel(brick_path(brick,"data"))
  brick_ls(brick,.p) |> purrr::map(.l) |> ptree(p=relpath)
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
    con      <- DBI::dbConnect(RSQLite::SQLite(),file)
    tbls     <- DBI::dbListTables(con)
    tbls     <- tbls |> purrr::set_names(tbls) |> purrr::map(~ dplyr::tbl(src=con,.))
    tbls$con <- con
    tbls
  }
  
  message("opened sqlite connection.\n* DBI::dbDisconnect(.$...$con) to close.")

  .p <- \(file){ grepl(pat="(\\.db$|\\.sqlite)", file, i=T) }
  brick_load(brick, .p=.p, .l=sqlite_load)
}