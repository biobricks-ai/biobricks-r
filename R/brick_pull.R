#' pull data for a brick from biobricks.ai
#' @param brick pull data from this brick
#' @export
#' @examples
#' \dontrun{
#' biobricks::brickpull("clinvar")
#' }
brick_pull <- function(brick){
  c(check_init(),check_brick_exists(brick))
  cmd <- sprintf("cd %s; dvc pull",brick_path(brick))
  system(cmd,ignore.stdout = F, ignore.stderr = T)
}