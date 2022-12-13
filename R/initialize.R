#' create the git repo for the biobricks library
#' @export
initialize <- function(){
  c(check_has_dvc(),check_has_git(),check_dir_access(bblib()))
  
  if (!fs::is_dir(Sys.getenv("BBLIB"))){
    stop(
      "BBLIB must be directory\n",
      "* use `Sys.setenv(BBLIB='...')`")
  }

  systemf("cd %s; git init",bblib())
  systemf("cd %s; mkdir cache",bblib())
  message("initialized biobricks to ",bblib())
}