#' create the git repo for the biobricks library
#' @export
initialize <- function(){
  c(check_has_dvc(),check_has_git())
  
  if(!fs::is_dir(Sys.getenv("bblib"))){
    print("bblib must be a directory")
    print("use `Sys.setenv(bblib='{some-directory}')`")
  }

  systemf("cd %s; git init",bblib())
  systemf("cd %s; mkdir cache",bblib())
  message("initialized biobricks to",bblib())
}