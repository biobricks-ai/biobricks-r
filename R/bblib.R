#' get location for storing bricks
#' @export 
bblib = function(){
  bblib = Sys.getenv("bblib")
  if(bblib==""){
    stop("must set 'bblib' env
    try `Sys.setenv(bblib='???')`")
  }
  bblib  
}