#' Combining Neighbourhood Census Profiles
#'
#' This function takes the various files for the Toronto neighbourhoods
#' provided by the Toronto Open Data Portal and uses dplyr and tidyr
#' to shape and manipulate them. Finally, it combines them together
#' into one tbl_df
#'
#' @return None
#' @export
#'
#' @examples
#' combining_neighbourhood_census_profiles()
combining_neighbourhood_census_profiles <-
  function() {
    # reading 2016 neighbourhood census profile data in
    neighbourhoods_census_profile_2016 <-
      read_csv(
        here::here(
          "data",
          "raw",
          "neighbourhood_census",
          "neighbourhoods_census_profile_2016.csv"
        )
      )
    
    # using dplyr and tidyr to get the data in the right form
    neighbourhoods_census_profile_2016 <-
      neighbourhoods_census_profile_2016 %>%
      filter(Characteristic == "Population, 2016") %>%
      select(-c(`_id`:`City of Toronto`)) %>%
      pivot_longer(col = everything(),
                   names_to = "neighbourhood_name",
                   values_to = "population") %>%
      mutate(population = str_remove_all(population, ","),
             population = parse_double(population))
    
    # settting the path to the 2001-2011 neighbourhood census data file
    path_to_data <- here::here(
      "data",
      "raw",
      "neighbourhood_census",
      "neighbourhoods_census_profile_2001_2011.xlsx"
    )
    
    # getting the sheet names from the 2001-2011 neighbourhood census data file
    sheet_names <- readxl::excel_sheets(path_to_data)
    
    # reading all sheets from the 2001-2011 neighbourhood census data file
    # and storing them in a list as tbl_df
    list_of_data <-
      map(.x = sheet_names,
          .f = readxl::read_xlsx,
          path = path_to_data)
    
    # setting the names of the tbl_df in this list
    list_of_data <- list_of_data %>%
      set_names(sheet_names)
    
    # using dplyr and tidyr, like above, to get this data into a
    # long format
    list_of_data <- list_of_data %>%
      map( ~ mutate(
        .x,
        Attribute = str_to_lower(Attribute),
        Attribute = str_remove_all(Attribute, " - 100% data")
      )) %>%
      map2(.y = names(list_of_data), ~ filter(.x, Attribute == glue::glue("population, {.y}"))) %>%
      map(
        ~ select(.x,-c(Category:`City of Toronto`)) %>%
          pivot_longer(
            col = everything(),
            names_to = "neighbourhood_name",
            values_to = "population"
          )
      )
    
    # combining the 2001 to 2016 data
    list_of_data <-
      list_modify(list_of_data, `2016` = neighbourhoods_census_profile_2016)
    
    # using bind_rows to create a single tbl_df
    neighbourhoods_census_profile <-
      bind_rows(list_of_data, .id = "year")
    
    # writing to a local folder
    write_csv(neighbourhoods_census_profile,
              here::here("data",
                         "clean",
                         "neighbourhood_census_profile_data_cleaned.csv"))
  }
