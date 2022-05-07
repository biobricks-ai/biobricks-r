#' Update a brick
#' @param brick the brick to update
update_brick <- function(brick){
  bdir <- resolve(brick)
  # if (system(sprintf("cd %s ; git diff --exit-code",bdir)) != 0) {
  #   stop(sprintf("Error: git diff should have no results, check with the owner of %s.",brick))
  # }
  system(sprintf('cd %s ; git pull origin master',bdir))
}

#' Installs a brick from a github repo
#' @param url a url like https://github.com/biobricks-ai/clinvar.git
#' @param repo string with owner/repo eg. "biobricks-ai/clinvar"
#' @export
install <- function(url,repo){
  
  if(!grepl("https://.*.git",url)){stop("url must be https://.../owner/repo.git")}

  git_cmd <- sprintf("cd %s ; git submodule add %s %s",bblib(),url,repo)
  result  <- system(git_cmd)
  if (result == 0) {
    system(sprintf('cd %s ; git commit -m "added %s"', bblib(),repo))
  } else {
    stop(sprintf("Could not add brick to git repo %s",bblib()))
  }
}

#' Installs a brick from a github repo
#' @param repo string with owner/repo eg. "biobricks-ai/clinvar"
#' @export
install_gh <- function(repo){
  url <- sprintf("https://github.com/%s.git", repo)
  install(url, repo)
}
