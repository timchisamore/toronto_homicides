#' Homicides by Year and Type
#'
#' This function takes the cleaned and formatted Toronto homicides data
#' and plots the number and proportion of homicides by year and type in
#' seperate plots. It used patchwork to combine these plots with a
#' common title, legend, and x-axis and then saves it as a .png
#' to a local folder.
#'
#' @param data tbl_df
#'
#' @return None
#' @export
#'
#' @examples
#' homicides_by_year_and_type(toronto_homicides_cleaned_formatted)
homicides_by_year_and_type <- function(data) {
  p1 <- data %>%
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
    labs(x = "Year",
         y = "Number of Homicides",
         fill = "Type") +
    coord_flip()
  
  p2 <-
    data %>%
    count(occurrence_year, homicide_type) %>%
    group_by(occurrence_year) %>%
    mutate(prop = n / sum(n)) %>%
    ungroup() %>%
    ggplot(aes(x = occurrence_year, y = prop, fill = homicide_type)) +
    geom_bar(stat = "identity") +
    geom_label(stat = "identity",
               aes(label = scales::percent(prop, accuracy = 0.1)),
               position = position_stack(vjust = 0.5)) +
    scale_x_continuous(breaks = 2004:2019) +
    scale_y_continuous(breaks = scales::pretty_breaks(),
                       labels = scales::percent_format()) +
    scale_fill_brewer(type = "qual",
                      palette = "Set1") +
    labs(x = "Year",
         y = "Proportion of Homicides",
         fill = "Type") +
    theme(
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.title.y = element_blank()
    ) +
    coord_flip()
  
  combined <- p1 +
    p2 +
    plot_layout(guides = "collect") +
    plot_annotation(title = "Homicides by Year and Type",
                    tag_levels = "A")
  
  print(combined)
  
  ggsave(
    combined,
    filename = here::here("output",
                          "plots",
                          "homicides_by_year_and_type.png"),
    height = 8,
    width = 12
  )
  
}