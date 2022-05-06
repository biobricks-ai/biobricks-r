#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  bdir <- bblib()
  if(!file.exists(fs::path(bdir,".git"))){
    system(sprintf("git init %s",bblib()))
  }
  set_git_config()
  cat(sprintf("initialized biobricks to %s\n",bdir))
}
