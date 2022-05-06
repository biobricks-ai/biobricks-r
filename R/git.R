#' Set the git user.name and user.email
set_git_config <- function(){
    config <- file.path(bblib(),".git","config")

    if(system(sprintf("git config --file %s user.email",config),
              ignore.stdout=TRUE,ignore.stderr=TRUE) != 0) {
        system(sprintf("git config --file %s user.email 'biobricks@insilica.co'",config),
               ignore.stdout=TRUE,ignore.stderr=TRUE)
    }

    if(system(sprintf("git config --file %s user.name",config),
              ignore.stdout=TRUE,ignore.stderr=TRUE) != 0){
        system(sprintf("git config --file %s user.name 'Biobricks'",config),
               ignore.stdout=TRUE,ignore.stderr=TRUE)
    }
}
