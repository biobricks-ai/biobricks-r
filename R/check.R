check_has_git <- \(fail=F){
  if(!fail && suppressWarnings(system("command -v git >/dev/null 2>&1"))==0){return(T)}
  stop("git must be installed. See https://github.com/git-guides/install-git")
}

check_has_dvc <- \(fail=F){
  if(!fail && suppressWarnings(system("command -v dvc >/dev/null 2>&1"))==0){return(T)}
  stop("dvc must be installed. See https://dvc.org/doc/install")
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
  stop("no data for ", brick, "\n`brick_pull` to pull data\n`brick_repro` to build data")
}

check_init <- function(){
  init <- all(file.exists(bblib(".git")),bblib()!="")
  if(init){ return(T) }
  stop("bblib is not initialized") 
}