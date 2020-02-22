#' Homicide Surveillance by Year-Month
#' 
#' This function takes the Toronto homicide data and applies a simple
#' EARS C1 surveillance algorithm and produces a plot with a threshold and
#' alert indicators. It also saves a .png file to a local folder
#'
#' @param data tbl_df
#'
#' @return None
#' @export
#'
#' @examples
#' homicide_surveillance_yearmonth(toronto_homicides_cleaned_formatted)
homicide_surveillance_by_yearmonth <- function(data) {
	data %>%
		group_by(occurrence_yearmon = zoo::as.yearmon(occurrence_date)) %>%
		tally() %>%
		ungroup() %>%
		mutate(
			rolling_average = slider::slide_dbl(
				.x = n,
				.f = mean,
				.before = 7,
				.after = -1,
				.complete = TRUE
			),
			rolling_sd = slider::slide_dbl(
				.x = n,
				.f = sd,
				.before = 7,
				.after = -1,
				.complete = TRUE
			),
			rolling_threshold = rolling_average + 2 * rolling_sd,
			rolling_alert = if_else(n > rolling_threshold, 0, NULL)
		) %>%
		ggplot() +
		geom_segment(aes(
			x = occurrence_yearmon,
			xend = occurrence_yearmon,
			y = 0,
			yend = n
		),
		stat = "identity") +
		geom_line(
			aes(x = occurrence_yearmon, y = rolling_threshold),
			lty = 2,
			colour = "blue"
		) +
		geom_point(aes(x = occurrence_yearmon, y = rolling_alert),
							 shape = 2,
							 colour = "red") +
		labs(x = "Year-Month",
				 y = "Number of Homicides",
				 title = "Homicide Surveillance by Year-Month") +
		zoo::scale_x_yearmon(breaks = scales::pretty_breaks(),
												 format = "%Y %b") +
		scale_y_continuous(breaks = scales::pretty_breaks()) +
		ggsave(
			here::here(
				"output",
				"plots",
				"homicide_surveillance_by_yearmonth.png"
			),
			height = 8,
			width = 12
		)
}