#' @keywords internal
systemf <- function(...,intern=FALSE,ignore.stdout=TRUE,ignore.stderr=TRUE){
  system(sprintf(...),intern=intern,ignore.stdout=ignore.stdout,ignore.stderr=ignore.stderr)
}

#' @keywords internal
url_is_git_repo <- function(url){
  systemf("git ls-remote %s",url) == 0
}

#' creates a biobricks library in a temporary directory. Useful for development
#' @param env environment in which to create a temporary biobicks library
#' @export 
local_bblib <- function(env=parent.frame()){
  bblib <- withr::local_tempdir(.local_envir = env)
  withr::local_envvar(list(bblib=bblib),.local_envir = env)
  biobricks::initialize()
  bblib
}

# vglu or `varargs glue` a lightweight glue function to sub varargs into a string
#' @param txt the text to modify
#' @param ... named arguments to replace <arg> in @txt
#' @keywords internal
vglu <- function(txt,...){
  args <- list(...) |> purrr::imap(~ list(arg=.x,pat=sprintf("<%s>",.y)))
  args |> purrr::reduce(\(txt,pa){ gsub(pa$pat,pa$arg,txt) },.init=txt)
}

# create shell that runs commands in working directory
#' @param wd the working directory to run in
#' @keywords internal
build.sh <- function(wd){
  \(txt,...){ 
    cmd <- vglu("cd <wd>;<t> <a>",wd=wd,t=txt,a=paste(...,collapse=""))
    system(cmd)
  }
}