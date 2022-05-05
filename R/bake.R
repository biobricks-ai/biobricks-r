#' Generate and stores data from a biobrick in your `bblib()`
#' @param repo the brick you would like to generate
#' @export
#' @example 
#' \dontrun{
#' biobricks::install("https://github.com/biobricks-ai/clinvar.git")
#' biobricks::bake("clinvar")
#' }
bake <- function(repo){
  docker_run(
    "dvc repro",
    wd = sprintf("/biobricks/bricks/%s", repo))
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
