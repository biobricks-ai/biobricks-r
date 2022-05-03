#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  if(!file.exists(fs::path(bblib(),".git"))){
    system("(cd $bblib; git init)")
  }
  if(!file.exists(fs::path(bblib(),".dvc"))){
    system("(cd $bblib; dvc init)")
  }
}