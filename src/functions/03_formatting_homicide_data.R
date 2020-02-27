#' Formatting Homicide Data
#'
#' This function takes the cleaned Toronto homicides dataset and uses
#' the lubridate package to add and format important date and time
#' quantities, such as year and weekday. It then fixes mistakes
#' in neighbourhood_name found, then uses extract
#' to create the neighborhood name and ID from the neighbourhood field.
#' It also writes a .csv file to a local folder.
#'
#' @param data tbl_df
#'
#' @return tbl_df
#' @export
#'
#' @examples
#' formatting_homicide_data(homicide_data_cleaned)
formatting_homicide_data <- function(data) {
  homicide_data_cleaned_formatted <- data %>%
    mutate(
      occurrence_date_time = lubridate::ymd_hms(
        as.POSIXct(occurrence_date / 1000,
                   origin = "1970-01-01",
                   tz = "UTC")
      ),
      occurrence_date = lubridate::date(occurrence_date_time),
      occurrence_year = lubridate::year(occurrence_date_time),
      occurrence_quarter = lubridate::quarter(occurrence_date_time),
      occurrence_month = lubridate::month(occurrence_date_time),
      occurrence_day = lubridate::day(occurrence_date_time),
      occurrence_week_day = lubridate::wday(occurrence_date_time, label = TRUE),
      occurrence_hour = lubridate::hour(occurrence_date_time),
      occurrence_minute = lubridate::minute(occurrence_date_time),
      occurrence_second = lubridate::second(occurrence_date_time)
    ) %>%
    extract(
      neighbourhood,
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
    )
  
  write_csv(
    homicide_data_cleaned_formatted,
    here::here("data",
               "clean",
               "homicide_data_cleaned_formatted.csv")
  )
  
  return(homicide_data_cleaned_formatted)
  
}