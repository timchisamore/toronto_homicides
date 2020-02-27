#' Cleaning Neighbourhood Spatial Data
#' 
#' This function takes the Toronto neighbourhood sf file and converts
#' it to a tbl_df class, uses the janitor clean_names() function to
#' clean field names, renames the fields using tidy evaluation and
#' a vector of names. It then uses another janitor function, remove_empty,
#' to remove empty columns, and finally converts the object back to class
#' sf
#'
#' @param data sf
#'
#' @return sf
#' @export
#'
#' @examples
#' cleaning_neighbourhood_spatial_data()
cleaning_neighbourhood_spatial_data <- function(data) {
  field_names <-
    c(
      "id" = "field_1",
      "area_id" = "field_2",
      "area_attr_id" = "field_3",
      "parent_area_id" = "field_4",
      "area_short_code" = "field_5",
      "area_long_code" = "field_6",
      "area_name" = "field_7",
      "area_desc" = "field_8",
      "x" = "field_9",
      "y" = "field_10",
      "longitude" = "field_11",
      "latitude" = "field_12",
      "object_id" = "field_13",
      "shape_area" = "field_14",
      "shape_length" = "field_15",
      "geometry" = "geometry"
    )
  
  toronto_neighbourhood_spatial_cleaned <-
    data %>%
    as_tibble() %>%
    janitor::clean_names() %>%
    rename(!!!field_names) %>%
    janitor::remove_empty("cols") %>%
    extract(
      area_name,
      into = c("neighbourhood_name", "neighbourhood_id"),
      regex = "(\\D+) \\((\\d+)\\)"
    ) %>%
    mutate(
      neighbourhood_name = case_when(
        neighbourhood_name == "Cabbagetown-South St.James Town" ~ "Cabbagetown-South St. James Town",
        neighbourhood_name == "HUmber Summit" ~ "Humber Summit",
        neighbourhood_name == "North St.James Town" ~ "North St. James Town",
        neighbourhood_name == "Weston-Pellam Park" ~ "Weston-Pelham Park",
        TRUE ~ neighbourhood_name
      )
    ) %>%
    sf::st_as_sf()
  
  #sf::st_write(toronto_neighbourhoods_cleaned,
  #             here::here("data", "clean", "neighbourhoods.shp"))
  
  return(toronto_neighbourhood_spatial_cleaned)
  
}