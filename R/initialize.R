#' create the git repo for the biobricks library
#' @export
initialize <- function(){
  check_has_bblib()
  systemf("cd %s; git init",bblib())
  systemf("cd %s; mkdir cache",bblib())
  message("initialized biobricks to",bblib())
}