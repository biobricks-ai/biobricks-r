#' Update a brick
#' @param repo
update_brick <- function(repo){
  if (docker_run("git diff --exit-code") != 0) {
    stop(sprintf("Error: git diff should have no results, check with the owner of %s.",repo))
  }
  docker_run('git submodule update --init --recursive')
  docker_run('git submodule update --recursive --remote')
}

#' Generate and stores data from a biobrick in your `bblib()`
#' @param repo the brick you would like to generate
#' @export
#' @example 
#' \dontrun{
#' biobricks::install("https://github.com/biobricks-ai/clinvar.git")
#' biobricks::bake("clinvar")
#' }
bake <- function(repo){
  update_brick(repo)
  result <- docker_run(
    "dvc repro",
    wd = sprintf("/biobricks/bricks/%s", repo))

  if (docker_run("git diff --exit-code") != 0) {
    stop("Warning: Changes to the repo should not happen!")
  }
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
