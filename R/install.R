#' Update a brick
#' #TODO #4 add a test for update_brick
#' @param brick the brick to update
update_brick <- function(brick){
  stopifnot(initialized())
  cmd <- sprintf('cd %s ; git pull origin master',resolve(brick))
  system(cmd)
}

#' Installs a brick from a github repo
#' #TODO #2 `install` needs cleaning. Maybe use brick.install instead?
#' #TODO #3 when installing an already installed brick suggest update instead?
#' @param url a url like https://github.com/biobricks-ai/clinvar.git
#' @param repo string with owner/repo eg. "biobricks-ai/clinvar"
#' @export
install <- function(url,repo){
  stopifnot(initialized())
  if(!grepl("https://.*.git",url)){ stop("url must be https://.../owner/repo.git") }
  
  systemf <- \(...){ system(sprintf(...)) }
  result  <- systemf("cd $bblib; git submodule add %s %s",url,repo)
  if (result != 0) { stop("Could not add brick to git repo $bblib") }
  
  systemf('cd $bblib ; git commit -m "added %s"',repo)
}

#' Installs a brick from a github repo
#' @param repo string with owner/repo eg. "biobricks-ai/clinvar"
#' @export
install_gh <- function(repo){
  url <- sprintf("https://github.com/%s.git", repo)
  install(url, repo)
}
