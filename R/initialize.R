#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  bdir <- bblib()
  fs::dir_create(bdir)
  if(!file.exists(fs::path(bdir,".git"))){
    docker_run("git init")
  }
  set_git_config()
  cat(sprintf("initialized biobricks to %s\n",bdir))
}