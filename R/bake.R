#' Generate and stores data from a biobrick in your `bblib()`
#' @param brick the brick you would like to generate
#' @export
#' @example 
#' \dontrun{
#' biobricks::install("https://github.com/biobricks-ai/clinvar.git")
#' biobricks::bake("clinvar")
#' }
bake <- function(brick,image="insilica/biobricks:latest"){
  bdir   <- resolve(brick,rel=bblib())
  result <- docker_run("dvc repro",wd=bdir)
  fs::path(bdir,"data") |> fs::dir_ls(recurse=TRUE)
}

#' Finds all the bricks in `bblib()` matching @param brick
#' @param brick the brick you want to find 
#' @param rel resolve relative to what path
#' @export
#' @example
#' \dontrun{
#' biobricks::resolve("clinvar")
#' }
resolve <- function(brick,rel="/"){
  bdvc <- fs::path(brick,"dvc.yaml")
  dirs <- fs::dir_ls(bblib(),recurse=T,regexp=bdvc) |> fs::path_dir()
  if(rel=="/"){ dirs }else{ fs::path_rel(dirs, start=rel) }
}
