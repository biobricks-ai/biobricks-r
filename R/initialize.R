#' is biobricks initialized?
#' @export
initialized <- function(){ 
  all(file.exists(bblib(".git")), bblib()!="")
}

#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  systemf("cd %s; git init",bblib())
  systemf("cd %s; mkdir cache",bblib())
  message("initialized biobricks to",bblib())
}