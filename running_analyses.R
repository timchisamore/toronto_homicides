rmarkdown::render(
	input = here::here("src", "toronto_homicides.Rmd"),
	output_dir = here::here("output", "documents")
)