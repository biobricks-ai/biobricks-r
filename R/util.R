#' @keywords internal
systemf <- function(...,intern=F){
  system(sprintf(...),intern=intern)
}

#' @keywords internal
local_bblib <- function(env=parent.frame()){
  bblib <- withr::local_tempdir(.local_envir = env)
  withr::local_envvar(list(bblib=bblib),.local_envir = env)
  biobricks::initialize()
}