#' Generate and stores data from a biobrick in your `bblib()`
#' @param brick the brick you would like to generate
#' @param env "docker" for using a docker image & "system" for your local machine (must have dvc)
#' @param image if "docker" env which docker image to use
#' @export
#' @example 
#' \dontrun{
#' biobricks::install("https://github.com/biobricks-ai/clinvar.git")
#' biobricks::bake("clinvar")
#' }
bake <- function(brick,env="docker",image="insilica/biobricks:latest"){
  bd  <- resolve(brick) |> fs::path_rel(bblib())
  sys <- sprintf("(cd $bblib/%s; dvc repro)",bd)

  dbd <- fs::path("/biobricks/bricks/",bd)
  dkr <- sprintf("docker run --rm -v $bblib:/biobricks/bricks -w %s %s dvc repro",dbd,image)

  purrr::when(env,
    .=="docker" ~ system(dkr,intern=T),
    .=="system" ~ system(sys,intern=T),
    T           ~ stop("`env` must be 'docker' or 'system'"))
}

#' Finds all the bricks in `bblib()` matching @param brick
#' @param brick the brick you want to find 
#' @export
#' @example
#' \dontrun{
#' biobricks::resolve("clinvar")
#' }
resolve <- function(brick){
  bdvc <- fs::path(brick,"dvc.yaml")
  fs::dir_ls(bblib(),recurse=T,regexp=bdvc) |> fs::path_dir()
}
