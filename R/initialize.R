#' create the git and dvc repos for the biobricks library
#' @export
initialize <- function(){
  has_git <- fs::path(bblib(),".git") |> fs::file_exists()
  if(!has_git){ system(sprintf("git init %s",bblib())) }
  
  sprintf("initialized biobricks to %s\n",bdir) |> cat()
}
