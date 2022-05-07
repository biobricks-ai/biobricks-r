#' Run a cmd in the docker container
#' @param cmd The command to run
#' @param wd Working directory context to execute cmd
#' @export
docker_run <- function(cmd,wd=bblib()) {
    mnt    <- sprintf("-v %s:/biobricks/bricks",bblib())
    wd     <- sprintf("-w %s",wd)
    dkr    <- sprintf("docker run --rm %s %s insilica/biobricks:latest",mnt,wd)
    dcmd   <- sprintf("%s %s",dkr,cmd)
    system(dcmd)
}
