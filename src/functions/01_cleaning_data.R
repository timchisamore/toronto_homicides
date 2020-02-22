#' Cleaning Data
#'
#' This function data the toronto_homicides tbl_df and cleans the
#' column names using the janitor package's clean_names()
#' function. It then saves the tbl_df as a .csv to a local folder.
#'
#' @param data tbl_df
#'
#' @return tbl_df
#' @export
#'
#' @examples
#' cleaning_data(toronto_homicides)
cleaning_data <- function(data) {
	toronto_homicides_cleaned <- data %>%
		janitor::clean_names()
	
	write_csv(
		toronto_homicides_cleaned,
		here::here("data", "intermediate", "toronto_homicides_cleaned.csv")
	)
	return(toronto_homicides_cleaned)
	
}