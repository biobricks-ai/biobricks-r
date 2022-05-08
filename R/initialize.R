#' is biobricks initialized?
#' @export
initialized <- function(){ 
  all(file.exists(bblib(".git")), file.exists(bblib(".dvc")), bblib()!="")
}

#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  if(!file.exists(bblib(".git"))){ system("(cd $bblib; git init)") }
  if(!file.exists(bblib(".dvc"))){ system("(cd $bblib; dvc init)") }
  cat("initialized biobricks to",bblib(),"\n")
}
