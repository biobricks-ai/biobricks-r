#' @keywords internal
systemf <- function(...,intern=FALSE,ignore.stdout=TRUE,ignore.stderr=TRUE){
  system(sprintf(...),intern=intern,ignore.stdout=ignore.stdout,ignore.stderr=ignore.stderr)
}

#' @keywords internal
url_is_git_repo <- function(url){
  systemf("git ls-remote %s",url) == 0
}

#' @keywords internal
local_bblib <- function(env=parent.frame()){
  bblib <- withr::local_tempdir(.local_envir = env)
  withr::local_envvar(list(bblib=bblib),.local_envir = env)
  biobricks::initialize()
}

#' @keywords internal
set_git_config <- function(){
  if (systemf("cd %s ; git config user.name", bblib()) != 0) {
    message("Setting git user.name")
    systemf("cd %s ; git config user.name 'Biobricks'", bblib())
  }

  if (systemf("cd % s ; git config user.email", bblib()) != 0) {
    message("Setting git user.email")
    systemf("cd %s ; git config user.email '<biobricks@insilica.co>'", bblib())
  }
}