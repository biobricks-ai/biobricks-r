.onLoad <- function(libname, pkgname) {
  library(arrow)
  library(dplyr)
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
bbload <- function(brickref) {
  check_biobricks_installed()
  bb <- reticulate::import("biobricks")
  
  assets <- bb$assets(brickref)
  names(assets) <- gsub(".parquet","",fs::path_file(assets))

  purrr::imap(assets, \(x,name){ 
    print(sprintf("loading %s", name))
    if(fs::is_dir(x)) { return(arrow::open_dataset(x)) }
    return(arrow::read_parquet(x, as_data_frame = FALSE))
  })
}

#' Install a brickref
#' @param brickref either a repo name from github.com/biobricks-ai or a full github url.
#' @export
bbinstall <- function(brickref) {
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
