#' Update a brick in 3 steps:
#' 1. stashes all local changes 
#' 2. installs the most recent from origin
#' 3. drops the stash
#' @param brick the brick to update
#' @export
update_brick <- function(brick){
  c(check_init(), check_brick_exists(brick))
  systemf("cd %s; git stash",      brick_path(brick))
  systemf('cd %s; git pull origin',brick_path(brick))
  systemf("cd %s; git stash drop", brick_path(brick))
}

#' Installs a biobricks-ai maintained brick
#' @param brick a brick from biobricks-ai, see https://github.com/biobricks-ai/{brick}
#' @export
install_brick <- function(brick){
  repo <- sprintf("biobricks-ai/%s",brick)
  url  <- sprintf("https://github.com/%s",repo)
  install_brick_url(url,repo)
}

#' removes biobrick from bblib
#' removes biobrick org if no other bricks under org
#' removes git submodule 
#' @param brick the brick to remove
#' @export
brick_remove <- function(brick){
  c(check_init(), check_brick_exists(brick))
  
  brickdir <- brick_path(brick) 
  brick    <- fs::path_rel(brickdir,bblib())
  systemf("(cd $bblib; git rm -f %s)",brick)
  systemf("(cd $bblib; rm -rf .git/modules/%s)",brick)
  unlink(brickdir)
  
  brickorg <- fs::path_dir(brickdir)
  if(fs::dir_ls(brickorg) |> purrr::is_empty()){ unlink(brickorg) } 
}

#' Installs a brick from a github repo
#' @param url a url like https://github.com/biobricks-ai/clinvar.git
#' @param repo string with owner/repo eg. "biobricks-ai/clinvar"
#' @export
install_brick_url <- function(url,repo){
  c(check_is_git_repo(url), check_can_install(repo), check_init())

  # add submodule
  result  <- systemf("cd %s; git submodule add %s %s",bblib(),url,repo)
  if (result != 0) { stop(sprintf("Could not add brick to git repo %s",bblib()))}
  
  # config dvc cache
  systemf('cd %s; dvc cache dir ../../cache',     bblib(repo))
  systemf('cd %s; dvc config cache.shared group', bblib(repo))
  systemf('cd %s; dvc config cache.type symlink', bblib(repo))

  systemf('cd %s ; git commit -m "added %s"',bblib(),repo)
}

#' Installs a brick from a github repo
#' @param repo string with owner/repo eg. "biobricks-ai/clinvar"
#' @export
install_brick_gh <- function(repo){
  install_brick_url(sprintf("https://github.com/%s", repo), repo)
}
