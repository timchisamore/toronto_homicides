#' Homicides by Year and Type
#'
#' This function takes the cleaned and formatted Toronto homicides data
#' and plots the number of homicides by year and type. It also saves
#' a .png file of this plot to a local folder
#'
#' @param data tbl_df
#'
#' @return None
#' @export
#'
#' @examples
#' homicides_by_year_and_type(toronto_homicides_cleaned_formatted)
homicides_by_year_and_type <- function(data) {
	data %>%
		ggplot(aes(x = occurrence_year,
							 fill = homicide_type)) +
		geom_bar(stat = "count") +
		geom_label(stat = "count",
							 aes(label = ..count..),
							 position = position_stack(vjust = 0.5)) +
		scale_x_continuous(breaks = 2004:2019) +
		scale_y_continuous(breaks = scales::pretty_breaks()) +
		scale_fill_brewer(type = "qual",
											palette = "Set1") +
		labs(
			title = "Homicides in Toronto by Year and Type",
			x = "Year",
			y = "Number of Homicides",
			fill = "Type"
		) +
		ggsave(
			filename = here::here(
				"output",
				"plots",
				"homicides_by_year_and_type.png"
			),
			height = 8,
			width = 12
		)
}