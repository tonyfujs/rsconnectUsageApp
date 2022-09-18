#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  
  dta <- get_usage_dta("reactive", folder = "data-raw")
  
  usage_raw_1 <- 
    mod_users_filter_server(
      id = NULL,
      usage_raw = dta$usage_shiny,
      users_raw = dta$users
    )
  
  usage_raw <- 
    mod_apps_filter_server(
      id = NULL,
      usage_raw = usage_raw_1, 
      users_raw = dta$users, 
      content_raw = dta$content
    )
  
  usg_clean <-
    reactive({
      usage_clean(req(usage_raw()), dta$users(), dta$content())
    }) %>%
    debounce(750)
  
  mod_plot_usage_server2(id = NULL, usg_clean)
  mod_usage_table_server(id = NULL, usg_clean)
  
}
