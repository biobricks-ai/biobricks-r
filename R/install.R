#' Installs a brick from a github repo
#' @param url a url like https://github.com/biobricks-ai/clinvar.git
#' @param repo string with owner/repo eg. "biobricks-ai/clinvar"
#' @export
install <- function(url,repo){
  
  if(!grepl("https://.*.git",url)){stop("url must be https://.../owner/repo.git")}

  git_cmd <- sprintf("git submodule add %s %s", url, repo)
  result  <- docker_run(git_cmd)
  if (result == 0) {
    docker_run(sprintf('git commit --author="biobricks <biobricks@insilica.co>" -m "added %s"', repo))
  }
}

#' Installs a brick from a github repo
#' @param repo string with owner/repo eg. "biobricks-ai/clinvar"
#' @export
install_gh <- function(repo){
  url      <- sprintf("https://github.com/%s.git", repo)
  install(url, repo)
}