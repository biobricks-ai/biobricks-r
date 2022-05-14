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
  stop("missing brick ", brick, " try `brick_install(brick)`")
}

check_brick_has_data <- \(brick){
  bp <- brick_path(brick,"data")
  if(dir.exists(bp) && !purrr::is_empty(fs::dir_ls(bp))){ return(T) }
  stop("no data for ", brick, " do you need to `brick_pull` or `brick_repro`?")
}

check_init <- \(){
  if(initialized()){ return(T) }
  stop("bblib is not initialized") 
}