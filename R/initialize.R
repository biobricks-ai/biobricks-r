#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  if(fs::file_exists(bblib(".git"))){ return("already init") }
  system2("git","init",bblib(".git"))
  cat("initialized biobricks to",bblib(),"\n")
}
