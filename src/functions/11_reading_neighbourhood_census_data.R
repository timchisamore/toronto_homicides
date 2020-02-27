#' Reading Neighbourhood Census Data
#'
#' This function reads the Toronto neighbourhood data in. Note,
#' this data was obtained from the Open Data Portal but was in very
#' poor format. There was a .csv file for the 2016 data and an .xlsx
#' file for the 2001, 2006, and 2011 data. Further, there was
#' inconsistencies between these files and so combining the files
#' was involved. See the R function combining_neighbourhood_census_profiles
#' to see this process
#'
#' @return tbl_df
#' @export
#'
#' @examples
#' reading_neighbourhood_census_data()
reading_neighbourhood_census_data <- function() {
  neighbourhood_census_data_cleaned <- read_csv(here::here(
    "data",
    "clean",
    "neighbourhood_census_profile_data_cleaned.csv"
  ))
  
  return(neighbourhood_census_data_cleaned)
  
}