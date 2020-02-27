#' Reading Neighbourhood Spatial Data
#'
#' This function reads the Toronto neighbourhood spatial data in as an object
#' of class sf.
#'
#' @return sf
#' @export
#'
#' @examples
#' reading_neighbourhood_spatial_data()
reading_neighbourhood_spatial_data <- function() {
  neighbourhood_spatial_data <-
    sf::st_read(here::here("data",
                           "raw",
                           "neighbourhood_spatial"))
  
  return(neighbourhood_spatial_data)
  
}