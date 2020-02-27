#' Reading ON-MARG Data
#'
#' This function reads the ON-MARG data for Toronto neighbourhoods in
#' using the readxl read_xlsx function. Note that the files were
#' inconsistent in field naming, field number, and overall
#' file structure, this is why pmap was used.
#'
#' @return list
#' @export
#'
#' @examples
#' reading_on_marg_data()
reading_on_marg_data <- function() {
  paths <- fs::dir_ls(here::here("data", "raw", "on_marg"))
  skip <- c(1, 2, 2)
  sheet <- c(2, 4, 4)
  list_of_data <- pmap(list(
    path = paths,
    sheet = sheet,
    skip = skip
  ),
  readxl::read_xlsx)
  
  return(list_of_data)
}