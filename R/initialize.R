#' is biobricks initialized?
#' @export
initialized <- function(){ 
  all(file.exists(bblib(".git")), bblib()!="")
}

#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  if(!file.exists(bblib(".git"))){ systemf("(cd %s; git init)",bblib()) }
  cat("initialized biobricks to",bblib(),"\n")
}