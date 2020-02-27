#' Cleaning ON-MARG Data
#'
#' This function takes the results from the reading_on_marg_data function,
#' a list of tbl_dfs, and fixes the field ordering and field naming issues
#' and then combines the individual tbl_dfs into one using bind_rows.
#' Further, it removes the factor loadings and then pivots into a long
#' form with the quintile values for each dimension. Finally, some errors
#' in the spelling of neighbourhood names are fixed. This is then saved
#' to a local folder.
#'
#' @param data_list list
#'
#' @return tbl_df
#' @export
#'
#' @examples
#' cleaning_on_marg_data(on_marg_data)
cleaning_on_marg_data <- function(data_list) {
  # renaming fields using position
  vector_of_names <-
    c(
      "neighbourhood_id" = 1,
      "neighbourhood_name" = 2,
      "population" = 3,
      "instability" = 4,
      "instability_q" = 5,
      "deprivation" = 6,
      "deprivation_q" = 7,
      "dependency" = 8,
      "dependency_q" = 9,
      "ethniccon" = 10,
      "ethniccon_q" = 11
    )
  
  # modifying the 2006 ON-MARG data to be ordered properly and then
  # cleaning field names and renaming them. Then, setting the list
  # element names and using bind_rows to create a single tbl_df and
  # removing the factor loading fields before pivoting the tbl_df
  # into a long format for the quantile values. Finally, mistakes in
  # spelling of neighbour hood names are fixed.
  on_marg_data_cleaned <-
    data_list %>%
    modify_at(.at = 1, ~ select(.x, 1, 2, 3, 4, 5, 6, 7, 10, 11, 8, 9)) %>%
    map( ~ janitor::clean_names(.x)) %>%
    map(~ rename(.x, !!!vector_of_names)) %>%
    set_names(c("2006", "2011", "2016")) %>%
    bind_rows(.id = "year") %>%
    select(-c(instability, deprivation, dependency, ethniccon)) %>%
    pivot_longer(
      cols = instability_q:ethniccon_q,
      names_to = "dimension",
      values_to = "quintile"
    ) %>%
    mutate(
      dimension = str_remove_all(dimension, "_q"),
      neighbourhood_name = case_when(
        neighbourhood_name == "Weston-Pellam Park" ~ "Weston-Pelham Park",
        neighbourhood_name == "Mimico" ~ "Mimico (includes Humber Bay Shores)",
        neighbourhood_name == "Briar Hill - Belgravia" ~ "Briar Hill-Belgravia",
        neighbourhood_name == "Crescent Town" ~ "Taylor-Massey",
        neighbourhood_name %in% c("Danforth Village - East York", "Danforth-East York") ~ "Danforth East York",
        neighbourhood_name == "Oakwood-Vaughan" ~ "Oakwood Village",
        neighbourhood_name == "Danforth Village - Toronto" ~ "Danforth",
        TRUE ~ neighbourhood_name
      )
    )
  
  
  # writing to a local folder
  write_csv(on_marg_data_cleaned,
            here::here("data",
                       "clean",
                       "on_marg_data_cleaned.csv"))
  
  return(on_marg_data_cleaned)
  
}