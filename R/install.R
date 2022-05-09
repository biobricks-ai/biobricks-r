#' Update a brick
#' #TODO #4 add a test for update.biobricks, make force actually work 
#' @param brick the brick to update
#' @param force throw out local changes
update.biobricks <- function(brick,force=F){
  stopifnot(initialized())
  cmd <- sprintf('cd %s ; git pull origin master',resolve(brick))
  system(cmd)
}

#' Installs a biobricks-ai maintained brick
#' @param brick a brick from biobricks-ai, see https://github.com/biobricks-ai/{brick}
#' @export
install.biobricks <- function(brick){
  repo <- sprintf("biobricks-ai/%s",brick)
  url  <- sprintf("https://github.com/%s.git",repo)
  install_url(url,repo)
}

#' Installs a brick from a github repo
#' TODO #7 better error message when remote doesn't exist
#' @param url a url like https://github.com/biobricks-ai/clinvar.git
#' @param repo string with owner/repo eg. "biobricks-ai/clinvar"
#' @export
install_url <- function(url,repo){
  stopifnot(initialized())
  if(!grepl("https://.*.git",url)){ stop("url must be https://.../owner/repo.git") }

  empty <- resolve(strsplit(repo,"/")[[1]][2]) |> purrr::is_empty()
  if(!empty){ stop(repo,"already installed. Use update"); }

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
  install_url(url, repo)
}
