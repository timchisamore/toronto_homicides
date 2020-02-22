#' Homicides by Year and Neighbourhood
#' 
#' This function takes the Toronto homicide date, the Toronto neighbourhoods
#' data, and a year of interest and produces a map displaying the number
#' of homicides by neighbourhood for that given year.
#'
#' @param data tbl_df
#' @param spatial sf
#' @param year double
#'
#' @return None
#' @export
#'
#' @examples
#' homicides_by_year_and_neighbourhood(toronto_homicides_cleaned_formatted, toronto_neighbourhoods, 2019)
homicides_by_year_and_neighbourhood <-
  function(year, data, spatial) {
    data %>%
      mutate(neighbourhood_id = as.double(neighbourhood_id)) %>%
      filter(occurrence_year == year) %>%
      count(neighbourhood_id) %>%
      complete(neighbourhood_id = unique(spatial$area_short_code),
               fill = list(n = 0)) %>%
      full_join(spatial, by = c(neighbourhood_id = "area_short_code")) %>%
      sf::st_as_sf() %>%
      ggplot() +
      geom_sf(aes(fill = n)) +
      scale_fill_viridis_c() +
      labs(fill = "Number of Homicides",
           title = paste0("Homicides by Neighbourhood in ", year)) +
      ggthemes::theme_map() +
      ggsave(here::here(
        "output",
        "plots",
        "homicides_by_neighbourhood",
        paste0("homicides_by_neighbourhood_", year, ".png")
      ),
      height = 8,
      width = 12)
    
  }
