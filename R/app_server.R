#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session, dta = NULL) {
  
  if (is.null(dta)) {
    dta <- get_usage_dta("list", folder = "data-raw")
  }
  
  usage_raw_1 <- 
    mod_users_filter_server(
      id = NULL,
      usage_raw = reactive(dta$usage_shiny),
      users_raw = reactive(dta$users)
    )
  
  usage_raw <- 
    mod_apps_filter_server(
      id = NULL,
      usage_raw = usage_raw_1, 
      users_raw = reactive(dta$users), 
      content_raw = reactive(dta$content)
    )
  
  usg_clean <-
    reactive({
      usage_clean(req(usage_raw()), dta$users, dta$content)
    }) %>%
    debounce(750)
  
  mod_plot_usage_server2(id = NULL, usg_clean)
  mod_usage_table_server(id = NULL, usg_clean)
  
}
