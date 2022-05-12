check_is_git_repo <- \(url){
  if(!url_is_git_repo(url)){ stop(url, " is not a git repo") }
}

check_empty_repo <- \(repo){
  if(!purrr::is_empty(resolve(repo))){ stop(repo, "already exists, can't install")}
}

check_brick_exists <- \(brick){
  if(purrr::is_empty(resolve(brick))){ stop("missing brick ",brick, " try install.biobricks?")}
}

check_init <- \(){
  if(!initialized()){ stop("bblib is not initialized") }
}