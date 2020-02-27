#' Homicides by Month and Type
#' 
#' This function takes the Toronto homicides dataset and produces a plot
#' of the monthly timeseries by homicide type. It uses the tsibble
#' package to do much of the work with reindiexing and summarising.
#'
#' @param homicide_data tbl_df
#'
#' @return None
#' @export
#'
#' @examples
#' homicides_by_month_and_type(homicide_data_cleaned_formatted)
homicides_by_month_and_type <- function(homicide_data) {
  homicide_monthly_ts <- homicide_data %>%
    count(occurrence_date, homicide_type) %>%
    pivot_wider(names_from = "homicide_type", values_from = "n", values_fill = list(n = 0)) %>%
    mutate(Total = Other + Shooting + Stabbing) %>%
    pivot_longer(cols = Other:Total, names_to = "homicide_type", values_to = "n") %>%
    mutate(homicide_type = fct_relevel(homicide_type,
                                       "Total",
                                       "Shooting",
                                       "Stabbing",
                                       "Other")) %>%
    tsibble::as_tsibble(key = homicide_type, index = occurrence_date) %>%
    tsibble::fill_gaps(n = 0) %>%
    tsibble::group_by_key() %>%
    tsibble::index_by(occurrence_yearmon = ~ tsibble::yearmonth(.)) %>%
    summarise(n = sum(n))
  
  homicide_monthly_ts %>%
    ggplot(aes(x = occurrence_yearmon, y = n, colour = homicide_type)) +
    geom_line() +
    labs(x = "Year-Month",
         y = "Number of Homicides") +
    scale_y_continuous(breaks = scales::pretty_breaks()) +
    scale_color_brewer(type = "qual",
                       palette = "Set1") +
    facet_wrap( ~ homicide_type, ncol = 1) +
    theme(legend.position = "none") +
    ggsave(
      here::here("output",
                 "plots",
                 "homicides_by_month_and_type.png"),
      height = 8,
      width = 12
    )
  
}
