check_has_git <- \(fail=F){
  if(!fail && suppressWarnings(system("git version >/dev/null 2>&1"))==0){return(T)}
  stop("git must be installed. See https://github.com/git-guides/install-git")
}

check_has_dvc <- \(fail=F){
  if(!fail && suppressWarnings(system("dvc version >/dev/null 2>&1"))==0){return(T)}
  stop("dvc must be installed. See https://dvc.org/doc/install")
}

check_is_git_repo <- function(url){
  if(systemf("git ls-remote %s",url) == 0){ return(T) }
  stop(url, " is not a git repo") 
}

check_can_install <- function(repo){
  if(purrr::is_empty(brick_path(repo))){ return(T) }
  stop(repo, " already exists, can't install")
}

check_brick_exists <- function(brick){
  if(!purrr::is_empty(brick_path(brick))){ return(T) }
  stop("missing brick ", brick, " try `brick_install(brick)`")
}

# TODO #20 clean this up after migrating all bricks to the new 'brick' directory tree
check_brick_has_data <- function(brick){
  bp <- brick_path(brick,"data")
  datadir <- dir.exists(bp) && !purrr::is_empty(fs::dir_ls(bp))
  bp <- brick_path(brick,"brick")
  brickdir <- dir.exists(bp) && !purrr::is_empty(fs::dir_ls(bp))
  if(datadir || brickdir){ return(T) }
  stop("no data for ", brick, "\n`brick_pull` to pull data\n`brick_repro` to build data")
}

check_init <- function(){
  init <- all(file.exists(bblib(".git")),bblib()!="")
  if(init){ return(T) }
  stop("BBLIB is not initialized") 
}