#' get location for storing bricks
#' @param path get path relative to bblib
#' @export 
bblib = function(path=""){
  if(Sys.getenv("bblib")==""){ stop("no bblib. Set with `Sys.setenv(bblib='???')`.") }
  bblib = fs::dir_create(Sys.getenv("bblib"))
  fs::path_real(bblib) |> fs::path(path)
}
