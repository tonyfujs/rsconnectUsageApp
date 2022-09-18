#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    fluidPage(
      h4("Usage summary of the shiny apps deployed by Eduard Bukin to: https://datanalytics.worldbank.org/ and http://w0lxprconn01.worldbank.org:3939/connect/"),
      column(
        3, 
        mod_apps_filter_ui(NULL),
        mod_users_filter_ui(NULL),
        mod_usage_table_ui(NULL)
      ),
      column(
        9, 
        mod_plot_usage_ui(NULL)
      )
    )
  )
}
#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "rsconnectUsageApp"
    )
  )
}
