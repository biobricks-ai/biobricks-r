#' Finds all the bricks in `bblib()` matching @param brick
#' @param brick the brick you want to find 
#' @param path retrieve path relative to the brick directory
#' @export
#' @examples
#' \dontrun{
#' biobricks::resolve("clinvar")
#' }
brick_path <- function(brick,path=""){
  bdvc <- fs::path(brick,"dvc.yaml")
  fs::dir_ls(bblib(),recurse=T,regexp=bdvc) |> fs::path_dir() |> fs::path(path)
}