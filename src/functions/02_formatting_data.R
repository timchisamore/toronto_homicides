#' Formatting Data
#'
#' This function takes the cleaned Toronto homicides dataset and uses
#' the lubridate package to add and format important date and time
#' quantities, such as year and weekday. It then uses extract
#' to create the neighborhood name and ID from the neighbourhood field.
#' It also writes a .csv file to a local folder.
#'
#' @param data tbl_df
#'
#' @return tbl_df
#' @export
#'
#' @examples
#' formatting_data(toronto_homicides_cleaned)
formatting_data <- function(data) {
	toronto_homicides_cleaned_formatted <- data %>%
		mutate(
			occurrence_date_time = lubridate::ymd_hms(
				as.POSIXct(
					occurrence_date / 1000,
					origin = "1970-01-01",
					tz = "UTC"
				)
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
		)
	
	write_csv(
		toronto_homicides_cleaned_formatted,
		here::here("data",
							 "clean",
							 "toronto_homicides_cleaned_formatted.csv")
	)
	
	return(toronto_homicides_cleaned_formatted)
	
}