#' Homicides by Day and Year
#'
#' This function creates a heatmap of the the number of homicides by
#' year and day and saves a .png file to a local folder
#'
#' @param data tbl_df
#'
#' @return None
#' @export
#'
#' @examples
#' homicides_by_day_and_year(toronto_homicides_cleaned_formatted)
homicides_by_day_and_year <- function(data) {
	data %>%
		mutate(
			occurrence_week_day = fct_relevel(
				occurrence_week_day,
				"Sun",
				"Mon",
				"Tue",
				"Wed",
				"Thu",
				"Fri",
				"Sat"
			)
		) %>%
		group_by(occurrence_year, occurrence_week_day) %>%
		tally() %>%
		ungroup() %>%
		ggplot(aes(x = occurrence_year, y = occurrence_week_day, fill = n)) +
		geom_raster() +
		scale_x_continuous(breaks = 2004:2019) +
		scale_fill_viridis_c() +
		labs(
			x = "Year",
			y = "Day",
			fill = NULL,
			title = "Homicides by Year and Day"
		) +
		coord_flip() +
		ggsave(
			filename = here::here("output",
														"plots",
														"homicides_by_day_and_year.png"),
			height = 8,
			width = 12
		)
	
}
