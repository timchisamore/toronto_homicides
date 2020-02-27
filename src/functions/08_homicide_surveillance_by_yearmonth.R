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
      rolling_alert = if_else(n > rolling_threshold, TRUE, FALSE)
    ) %>%
    ggplot() +
    geom_segment(
      aes(
        x = occurrence_yearmon,
        xend = occurrence_yearmon,
        y = 0,
        yend = n,
        colour = "Observed"
      ),
      linetype = "solid",
      stat = "identity"
    ) +
    geom_line(aes(x = occurrence_yearmon,
                  y = rolling_threshold,
                  colour = "Threshold"),
              linetype = "dashed") +
    geom_point(aes(
      x = occurrence_yearmon,
      y = if_else(rolling_alert, 0, NULL),
      colour = "Alert"
    ),
    shape = 2) +
    labs(x = "Year-Month",
         y = "Number of Homicides",
         title = "Homicide Surveillance by Year-Month") +
    zoo::scale_x_yearmon(breaks = scales::pretty_breaks(),
                         format = "%Y %b") +
    scale_y_continuous(breaks = scales::pretty_breaks()) +
    scale_colour_manual(
      name = NULL,
      values = c("red", "black", "blue"),
      guide = guide_legend(override.aes = list(
        linetype = c("blank", "solid", "dashed"),
        shape = c(2, NA, NA)
      ))
    ) +
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
