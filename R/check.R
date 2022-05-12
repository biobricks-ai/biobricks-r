check_is_git_repo <- \(url){
  if(url_is_git_repo(url)){ return(T) }
  stop(url, " is not a git repo") 
}

check_empty_repo <- \(repo){
  if(purrr::is_empty(brick_path(repo))){ return(T) }
  stop(repo, " already exists, can't install")
}

check_brick_exists <- \(brick){
  if(!purrr::is_empty(brick_path(brick))){ return(T) }
  stop("missing brick ", brick, " try install.biobricks?")
}

check_init <- \(){
  if(initialized()){ return(T) }
  stop("bblib is not initialized") 
}