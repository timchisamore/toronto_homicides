#' Reading Spatial Data
#' 
#' This function reads the Toronto neighbourhood data in as an object
#' of class sf.
#'
#' @return sf
#' @export
#'
#' @examples
#' reading_spatial_data()
reading_spatial_data <- function() {
  toronto_neighbourhoods <-
    sf::st_read(here::here("data", "raw", "neighbourhoods"))
  
  return(toronto_neighbourhoods)
  
}





#test <- toronto_homicides_cleaned_formatted %>%
#  #filter(occurrence_year == 2019) %>%
#  count(occurrence_year, neighbourhood_id) %>%
#  complete(
#    occurrence_year = 2004:2019,
#    neighbourhood_id = unique(toronto_neighbourhoods$field_5),
#    fill = list(n = 0)
#  )
#toronto_neighbourhoods <- toronto_neighbourhoods %>%
#  left_join(test, by = c(field_5 = "neighbourhood_id"))

#ggplot(data = toronto_neighbourhoods) + geom_sf(aes(fill = n)) +
#  scale_fill_gradient(low = "white", high = "red") +
#  labs(fill = NULL,
#       title = "Homicides by Neighbourhood",
#       subtitle = )
