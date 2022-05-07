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
  bdir   <- resolve(brick)
  brel   <- fs::path(bdir) |> fs::path_rel(bblib())
  result <- docker_run(
    "dvc repro",
    wd = sprintf("/biobricks/bricks/%s", brel))

  # if (system(sprintf("cd %s ; git diff --exit-code",bblib())) != 0) {
  #   warning("Warning: Changes to the repo should not happen!")
  # }
  fs::path(bdir,"data") |> fs::dir_ls(recurse=TRUE)
}

#' Finds all the bricks in `bblib()` matching @param brick
#' @param brick the brick you want to find 
#' @export
#' @example
#' \dontrun{
#' biobricks::resolve("clinvar")
#' }
resolve <- function(brick){
  bd   <- bblib()
  dirs <- fs::dir_ls(bd,recurse=T,regexp=fs::path(brick,"dvc.yaml"))
  fs::path_dir(dirs)
}
