#' API Call
#'
#' This function pulls down the Toronto homicide data made available through
#' the Public Safety Data Portal hosted by the Toronto Police Service at
#' http://data.torontopolice.on.ca
#'
#' The data is written as a .csv to a local folder after being converted
#' from .json to a tbl_df
#'
#' @return tbl_df
#' @export
#'
#' @examples
#' api_call()
api_call <- function() {
	base_url <-
		"https://services.arcgis.com/S9th0jAJ7bqgIRjw/arcgis/rest/services/Homicide/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
	
	full_url <- URLencode(base_url)
	
	toronto_homicides_json <- rjson::fromJSON(RCurl::getURL(full_url))
	
	toronto_homicides_tbl_df <-
		map_df(toronto_homicides_json$features, 1)
	
	toronto_homicides_tbl_df %>%
		write_csv(path = here::here("data",
																"raw",
																"toronto_homicides.csv"))
	
	return(toronto_homicides_tbl_df)
	
}