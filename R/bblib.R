#' get location for storing bricks
#' @export 
bblib = function(){
  bblib = Sys.getenv("bblib")
  if(bblib==""){
    stop("no bblib. Set with `Sys.setenv(bblib='???')`. ??? should be a large directory you can access")
  }
  fs::path_real(bblib)
}