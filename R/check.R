check_has_bblib <- function(){
  if(Sys.getenv("bblib")!=""){ return(T) }
  if(interactive()){
    print("bblib env not set")
    print("bblib should be a large drive")
    res <- readline("set bblib now? y/n \n")
    if(res=="y"){
      value <- readline("what directory?\n")
      if(fs::is_dir(value)){
        Sys.setenv(bblib=value)
        print("bblib set to ",value)
      }else{
        print("bblib must be a directory")
      }
    }
  }
}

check_is_git_repo <- function(url){
  if(url_is_git_repo(url)){ return(T) }
  stop(url, " is not a git repo") 
}

check_can_install <- function(repo){
  if(purrr::is_empty(brick_path(repo))){ return(T) }
  stop(repo, " already exists, can't install")
}

check_brick_exists <- function(brick){
  if(!purrr::is_empty(brick_path(brick))){ return(T) }
  stop("missing brick ", brick, " try `install_brick(brick)`")
}

check_brick_has_data <- function(brick){
  bp <- brick_path(brick,"data")
  if(dir.exists(bp) && !purrr::is_empty(fs::dir_ls(bp))){ return(T) }
  stop("no data for ", brick, " do you need to `brick_pull` or `brick_repro`?")
}

check_init <- function(){
  init <- all(file.exists(bblib(".git")),bblib()!="")
  if(init){ return(T) }
  stop("bblib is not initialized") 
}