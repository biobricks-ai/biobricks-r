#' Update a brick
#' @param brick
update_brick <- function(brick){
  bdir <- resolve(brick)
  # if (system(sprintf("cd %s ; git diff --exit-code",bdir)) != 0) {
  #   stop(sprintf("Error: git diff should have no results, check with the owner of %s.",brick))
  # }
  system(sprintf('cd %s ; git pull origin master',bdir))
}

#' Generate and stores data from a biobrick in your `bblib()`
#' @param brick the brick you would like to generate
#' @export
#' @example 
#' \dontrun{
#' biobricks::install("https://github.com/biobricks-ai/clinvar.git")
#' biobricks::bake("clinvar")
#' }
bake <- function(brick){
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
  dirs <- fs::dir_ls(bblib(),recurse=T,regexp=fs::path(brick,"dvc.yaml"))
  fs::path_dir(dirs) |> fs::path_rel(start=rel)
}
