#' Homicide Rate by Year and Neighbourhood
#'
#' This function takes a year, the Toronto homicide data, the
#' Toronto neighbourhoods spatial data, and the Toronto neighbourhoods
#' census data and produces a choropleth map of the neighbourhoods
#' coloured by the rate per 100,000 for that given year. It then saves
#' a .png file of this plot to a local folder.
#'
#' @param year double
#' @param homicide_data tbl_df
#' @param spatial_data sf
#' @param census_data tbl_df
#'
#' @return None
#' @export
#'
#' @examples
#' homicide_rate_by_year_and_neighbourhood(2019,
#' toronto_homicides_cleaned_formatted,
#' toronto_neighbourhoods_cleaned,
#' toronto_neighbourhood_profiles)
homicide_rate_by_year_and_neighbourhood <-
  function(year,
           homicide_data,
           spatial_data,
           census_data) {
    homicides_by_year_and_neighbourhood <- homicide_data %>%
      count(occurrence_year, neighbourhood_id) %>%
      complete(
        occurrence_year = 2004:2019,
        neighbourhood_id = as.character(1:140),
        fill = list(n = 0)
      ) %>%
      mutate(
        fuzzy_year = case_when(
          occurrence_year %in% 2004:2008 ~ 2006,
          occurrence_year %in% 2009:2013 ~ 2011,
          occurrence_year %in% 2014:2018 ~ 2016,
          TRUE ~ 2016
        )
      )
    
    homicides_and_spatial_by_year_and_neighbourhood <-
      homicides_by_year_and_neighbourhood %>%
      left_join(spatial_data, by = "neighbourhood_id")
    
    homicides_and_spatial_census_by_year_and_neighbourhood <-
      homicides_and_spatial_by_year_and_neighbourhood %>%
      left_join(census_data,
                by = c(fuzzy_year = "year", neighbourhood_name = "neighbourhood_name"))
    
    homicides_and_spatial_census_by_year_and_neighbourhood %>%
      mutate(rate = 100000 * (n / population)) %>%
      filter(occurrence_year == year) %>%
      sf::st_as_sf() %>%
      ggplot() +
      geom_sf(aes(fill = rate)) +
      labs(
        title = glue::glue("Homicide Rate per 100,000 by Neighbourhood in {year}"),
        fill = "Rate per 100,000"
      ) +
      scale_fill_viridis_c() +
      ggthemes::theme_map() +
      ggsave(
        here::here(
          "output",
          "plots",
          "homicides_by_neighbourhood",
          paste0("homicide_rate_by_neighbourhood_",
                 year,
                 ".png")
        ),
        height = 8,
        width = 12
      )
  }
