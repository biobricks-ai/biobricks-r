#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  if(fs::file_exists(bblib(".git"))){ return("already init") }
  system(sprintf("git init %s",bblib()))
  sprintf("initialized biobricks to %s\n",bdir) |> cat()
}
