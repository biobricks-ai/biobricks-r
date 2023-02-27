.onLoad <- function(libname, pkgname) {
  reticulate::configure_environment(pkgname)
}

check_biobricks_installed <- function() {
  if (!reticulate::py_module_available("biobricks")) {
    stop("The biobricks package is not installed. Please install it with pip install biobricks")
  }
}

#' Return a list of tables for a brick
#' @param brickref the name of the brick to load
#' @export
load <- function(brickref) {
  check_biobricks_installed()
  bb <- reticulate::import("biobricks")
  assets <- bb$assets(brickref)
  asslist <- lapply(assets, \(x){ 
    assname <- fs::path_file(x)
    print(sprintf("loading %s", assname))
    arrow::read_parquet(x,as_data_frame=FALSE) 
  })
  names(asslist) <- fs::path_file(assets)
  return(asslist)
}

#' Install a brickref
#' @param brickref either a repo name from github.com/biobricks-ai or a full github url.
#' @export
install <- function(brickref) {
  check_biobricks_installed()
  bb <- reticulate::import("biobricks")
  return(bb$install(brickref))
}

#' Install a brickref
#' @export
bblib <- function(){
  check_biobricks_installed()
  bb <- reticulate::import("biobricks")
  return(as.character(bb$bblib()))
}
