#
#
#
golem::fill_desc(
  pkg_name = "rsconnectUsageApp",
  pkg_title = "App for monitoring apps usage on R Studio connect",
  pkg_description = "Does data collection and monitorring.",
  author_first_name = "Eduard",
  author_last_name = "Bukin",
  author_email = "edwardbukin@gmail.com",
  repo_url = NULL
)
golem::set_golem_options()
usethis::use_mit_license("Golem User")
usethis::use_readme_rmd(open = FALSE)
usethis::use_code_of_conduct(contact = "Golem User")
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md(open = FALSE)
usethis::use_git()
golem::use_recommended_tests()
golem::use_favicon()
golem::use_utils_ui(with_test = TRUE)
golem::use_utils_server(with_test = TRUE)
rstudioapi::navigateToFile("dev/02_dev.R")
