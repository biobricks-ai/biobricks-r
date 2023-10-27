check_biobricks_installed <- function() {
  if (Sys.which('biobricks') == '') {
    stop("biobricks is not installed. install with `pip install biobricks`")
  }
}

bbversion <- function(){
  versions = system("biobricks version", intern = TRUE, ignore.stderr = TRUE) |> strsplit(":") 
  list(installed = trimws(versions[[1]][[2]]),latest = trimws(versions[[2]][[2]]))
}

#' Return a list of tables for a brick
#' @param brick the name of the brick to load
#' @export
bbassets <- function(brick) {
  check_biobricks_installed()
  
  tryCatch({
    versions <- bbversion()
    if(versions$installed != versions$latest){
      message("biobricks is not up to date.\nRun `pip install biobricks --upgrade` on the command line")
    }
  }, error = function(e) {})

  out <- system(sprintf("biobricks assets %s",brick), intern = TRUE) |> strsplit(":")
  paths <- lapply(out, \(x){ trimws(x[2]) })
  names(paths) <- sapply(out, \(x){ x[1] })
  
  return(paths)
}