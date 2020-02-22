rmarkdown::render(
	input = here::here("src", "toronto_homicides.Rmd"),
	output_file = here::here("output", "documents", "toronto_homicides.html")
)