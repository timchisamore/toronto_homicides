#' Homicides by Day and Type
#'
#' This function takes the Toronto homicides data and returns a barplot
#' of the number of homicides by day and type. It also saves a .png
#' file of this plot in a local directory
#'
#' @param data tbl_df
#'
#' @return None
#' @export
#'
#' @examples
#' homicides_by_day_and_type(toronto_homicides_cleaned_formatted)
homicides_by_day_and_type <- function(data) {
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
		ggplot(aes(x = occurrence_week_day,
							 fill = homicide_type)) +
		geom_bar(stat = "count") +
		geom_label(stat = "count",
							 aes(label = ..count..),
							 position = position_stack(vjust = 0.5)) +
		scale_y_continuous(breaks = scales::pretty_breaks()) +
		scale_fill_brewer(type = "qual",
											palette = "Set1") +
		labs(
			title = "Homicides in Toronto by Day and Type",
			x = "Day",
			y = "Number of Homicides",
			fill = "Type"
		) +
		ggsave(
			filename = here::here("output",
														"plots",
														"homicides_by_day_and_type.png"),
			height = 8,
			width = 12
		)
}