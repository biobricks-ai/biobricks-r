#' pull data for a brick from biobricks.ai
#' @param brick pull data from this brick
#' @export
#' @examples
#' \dontrun{
#' biobricks::brickpull("clinvar")
#' }
brick_pull <- function(brick,stage){
  c(check_init(),check_brick_exists(brick))
  if(missing(stage)){
    cmd <- sprintf("cd %s; dvc pull",brick_path(brick))
  }
  else {
    cmd <- sprintf("cd %s; dvc pull %s",brick_path(brick),stage)
  }
  system(cmd, ignore.stdout = F, ignore.stderr = F)
}