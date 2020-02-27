#' Cleaning Homicide Data
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
#' cleaning_homicide_data(homicide_data)
cleaning_homicide_data <- function(data) {
  homicide_data_cleaned <- data %>%
    janitor::clean_names()
  
  write_csv(
    homicide_data_cleaned,
    here::here("data", "intermediate", "homicide_data_cleaned.csv")
  )
  
  return(homicide_data_cleaned)
  
}