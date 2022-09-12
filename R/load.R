#' Find urls for brick outs
#' @param brick the brick to get files for
#' @param remote the url remote, uses the biobricks.ai s3 remote by default
#' @importFrom purrr map flatten walk
#' @export
brick_ls_remote <- \(brick,remote="https://ins-dvc.s3.amazonaws.com/insdvc"){
  url  <- \(md5){ sprintf("%s/%s/%s",remote,substr(md5,1,2),substr(md5,3,nchar(md5))) }
  stg  <- yaml::read_yaml(brick_path(brick,"dvc.lock"))$stages
  out  <- stg |> map("outs") |> flatten() |> map("path")
  urls <- stg |> map("outs") |> flatten() |> map("md5") |> map(url)
  stat <- urls |> map(~httr::HEAD(.)$status)
  out[stat!=200] |> walk(~ stop(.," is not accessible on remote"))
  purrr::map2(out,urls,~ list(outs=.x, remote=.y))
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
  if(missing(.p) || missing(.l)){ return(brick_load_arrow(brick)) }
  relpath <- brick_ls(brick,.p) |> fs::path_rel(brick_path(brick,"data"))
  brick_ls(brick,.p) |> purrr::map(.l) |> ptree(p=relpath)
}

#' A helper to use brick_load with the arrow package
#' @param brick the name of the brick to load
#' @importFrom purrr partial
#' @export
brick_load_arrow <- \(brick){
  is_tab  <- \(f){ fs::path_ext(f) %in% c("parquet","arrow","ipc","feather","csv","tsv","text") }
  is_part <- \(f){ grepl("/.*\\.parquet/",f) } # datasets should be dirs with tab ext
  brick_load(brick, .p=\(f){ is_tab(f) && !is_part(f) }, .l=arrow::open_dataset)
}