#' Installs a brick from a github repo
#' @param url a url like https://github.com/biobricks-ai/clinvar.git
#' @export
install <- function(url){ 
  
  if(!grepl("https://.*.git",url)){stop("url must be https://.../owner/repo.git")}

  bdir  <- bblib()
  repo  <- rev(fs::path_split(url)[[1]])[1:2]
  brick <- fs::path(bdir,repo[2],repo[1]) |> fs::path_ext_remove()

  cmd <- sprintf('git submodule add %s %s',url,brick)
  gitcmd <- sprintf('(cd $bblib; %s)',cmd)
  system(gitcmd)
}

#' Installs a brick from a github repo
#' @param owner a github owner "biobricks-ai" in https://github.com/biobricks-ai/clinvar
#' @param repo a github repo "clinvar" in https://github.com/biobricks-ai/clinvar
#' @export
install_gh <- function(owner,repo){
  cmd <- sprintf("https://github.com/%s/%s.git",owner,repo)
  install(cmd)
}