#' Reading Homicide Data
#'
#' This function calls the api_call() function to pull the Toronto homcides
#' down and place it into a local folder. It then reads the .csv file from
#' this local folder and returns it
#'
#' @return
#' @export
#'
#' @examples
#' reading_homicide_data()
reading_homicide_data <- function() {
  api_call()
  
  homicide_data <- read_csv(here::here("data",
                                       "raw",
                                       "toronto_homicides.csv"))
  
  return(homicide_data)
  
}