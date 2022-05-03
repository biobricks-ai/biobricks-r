#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  bdir <- bblib()
  fs::dir_create(bdir)
  if(!file.exists(fs::path(bdir,".git"))){
    system(sprintf("(cd %s; git init)",bdir))
  }
  if(!file.exists(fs::path(bdir,".dvc"))){
    system(sprintf("(cd %s; dvc init)",bdir))
  }
  cat(sprintf("initialized biobricks to %s\n",bdir))
}