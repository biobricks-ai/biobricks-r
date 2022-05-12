#' Generate and stores data from a biobrick in your `bblib()`
#' This is a wrapper for dvc repro.
#' @param brick the brick you would like to generate
#' @param env "docker" for using a docker image & "system" for your local machine (must have dvc)
#' @param image if "docker" env which docker image to use
#' @export
#' @examples
#' \dontrun{
#' biobricks::install("https://github.com/biobricks-ai/clinvar.git")
#' biobricks::brick_repro("clinvar")
#' }
brick_repro <- function(brick,env="docker",image="insilica/biobricks:latest"){
  check_init()
  brickdir <- brick_path(brick)
  sys      <- sprintf("(cd %s; dvc repro)",brickdir)

  mnt   <- sprintf("-v %s:%s -w %s", bblib(), bblib(), brickdir)
  dkr   <- sprintf("docker run --rm %s %s dvc repro", mnt, image)
  
  purrr::when(env,
    .=="docker" ~ system(dkr,intern=T),
    .=="system" ~ system(sys,intern=T),
    T           ~ stop("`env` must be 'docker' or 'system'"))
}

#' pull data for a brick from biobricks.ai
#' @param brick pull data from this brick
#' @export
#' @examples
#' \dontrun{
#' biobricks::brickpull("clinvar")
#' }
brick_pull <- function(brick){
  c(check_init(),check_brick_exists(brick))
  systemf("cd %s; dvc pull",brick_path(brick))
}

#' Finds all the bricks in `bblib()` matching @param brick
#' @param brick the brick you want to find 
#' @export
#' @examples
#' \dontrun{
#' biobricks::resolve("clinvar")
#' }
brick_path <- function(brick){
  bdvc <- fs::path(brick,"dvc.yaml")
  fs::dir_ls(bblib(),recurse=T,regexp=bdvc) |> fs::path_dir()
}