#' Run a cmd in the docker container
#' @param cmd The command to run
#' @param wd Working directory context (relative to bblib) to execute cmd
#' @export
docker_run <- function(cmd,wd=bblib(),image="insilica/biobricks:latest") {
    mnt    <- sprintf("-v %s:/biobricks/bricks",bblib())
    wd     <- sprintf("-w %s",fs::path("biobricks/bricks",wd))
    dkr    <- sprintf("docker run --rm %s %s %s",mnt,wd,image)
    dcmd   <- sprintf("%s %s",dkr,cmd)
    system(dcmd)
}
