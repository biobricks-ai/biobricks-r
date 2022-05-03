#' Generate and stores data from a biobrick in your `bblib()`
#' @param brick the brick you would like to generate
#' @export
#' @example 
#' \dontrun{
#' biobricks::install("https://github.com/biobricks-ai/clinvar.git")
#' biobricks::bake("clinvar")
#' }
bake <- function(brick){
  rbrick <- resolve(brick)
  dvc    <- fs::path(rbrick,"dvc.yaml") |> fs::path_rel(bblib())
  mnt    <- sprintf("-v %s:/biobricks/bricks",bblib())
  dkr    <- sprintf("docker run --rm %s insilica/biobricks:latest",mnt)
  cmd    <- sprintf("%s dvc repro %s",dkr,dvc)
  system(cmd)
  fs::path(rbrick,"data") |> fs::dir_ls()
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
