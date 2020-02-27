#' Homicide Rate by ON-MARG Quintile, Dimension, and Year
#'
#' This function takes the Toronto homicide data and the Toronto ON-MARG
#' data and joins them together by year and neighbourhood. Note that we
#' have to use a fuzzy join since the ON-MARG data only exists for
#' census years. It then creates a plot of the rates per 100,000 by
#' quintile for a specific year and dimension. Further, a linear fit
#' is added.
#'
#' @param year character
#' @param dimension character
#' @param homicide_data tbl_df
#' @param on_marg_data tbl_df
#'
#' @return
#' @export
#'
#' @examples
#' homicide_rate_by_on_marg_quintile_dimension_and_year("2018", "deprivation", homicide_data_cleaned_formatted, on_marg_data_cleaned)
homicide_rate_by_on_marg_quintile_dimension_and_year <-
  function(year,
           dimension,
           homicide_data,
           on_marg_data) {
    year <- enquo(year)
    dimension <- enquo(dimension)
    path <- here::here(
      "output",
      "plots",
      "homicide_rate_by_on_marg_quintile_dimension_and_year",
      rlang::as_name(dimension),
      glue::glue("homicide_rate_by_on_marg_quintile_{rlang::as_name(dimension)}_{rlang::as_name(year)}.png")
    )
    
    homicide_data_by_year_and_neighbourhood <- homicide_data %>%
      count(occurrence_year,
            neighbourhood_name) %>%
      complete(
        occurrence_year = 2004:2019,
        neighbourhood_name = on_marg_data$neighbourhood_name,
        fill = list(n = 0)
      ) %>%
      mutate(
        fuzzy_year = case_when(
          occurrence_year %in% 2004:2008 ~ "2006",
          occurrence_year %in% 2009:2013 ~ "2011",
          occurrence_year %in% 2014:2018 ~ "2016",
          TRUE ~ "2016"
        )
      )
    
    homicide_and_on_marg_data_by_year_and_neighbourhood <-
      homicide_data_by_year_and_neighbourhood %>%
      left_join(on_marg_data,
                by = c(fuzzy_year = "year",
                       neighbourhood_name = "neighbourhood_name")) %>%
      group_by(occurrence_year, dimension, quintile) %>%
      summarise(n = sum(n),
                population = sum(population)) %>%
      mutate(rate = 100000 * (n / population)) %>%
      ungroup()
    
    homicide_and_on_marg_data_by_year_and_neighbourhood %>%
      filter(occurrence_year == !!year,
             dimension == !!dimension) %>%
      ggplot(aes(
        x = quintile,
        y = rate,
        label = scales::comma(rate, accuracy = 0.01)
      )) +
      geom_col() +
      geom_label() +
      geom_smooth(method = "lm", se = FALSE) +
      labs(
        title = glue::glue(
          "Homicide Rate by {str_to_title(rlang::as_name(dimension))} Quintile in {rlang::as_name(year)}"
        ),
        x = "Quintile",
        y = "Rate per 100,000"
      ) +
      scale_x_continuous(breaks = 1:5,
                         labels = c("1 - Least", "2", "3", "4", "5 - Most")) +
      scale_y_continuous(breaks = scales::pretty_breaks()) +
      ggsave(filename = path,
             height = 8,
             width = 12)
    
    
  }
