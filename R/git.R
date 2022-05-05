#' Set the git user.name and user.email
set_git_config <- function(){
    if(docker_run("git config user.email") != 0){
        docker_run("git config user.email 'biobricks@insilica.co'")
    }
    if(docker_run("git config user.name") != 0){
        docker_run("git config user.name 'Biobricks'")
    }
}