#' get location for storing bricks
#' @param path get path relative to bblib
#' @export 
bblib <- function(path=""){
  if(Sys.getenv("BBLIB")==""){ stop("No BBLIB. Use `Sys.setenv(BBLIB='...')`") }
  bblib = fs::dir_create(Sys.getenv("BBLIB"))
  fs::path_real(bblib) |> fs::path(path)
}
