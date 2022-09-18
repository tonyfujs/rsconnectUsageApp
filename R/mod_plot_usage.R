#' plot_usage UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom esquisse ggplot_output
#' @export
mod_plot_usage_ui <- function(id){
  ns <- NS(id)
  tagList(
    esquisse::ggplot_output(ns("usg_period"), height = "500px"),
    esquisse::ggplot_output(ns("usg_app"), height = "500px")
    
    # shiny::plotOutput(ns("usg_period")),
    # shiny::plotOutput(ns("usg_app"))
 
  )
}
    
#' plot_usage Server Functions
#'
#' @noRd 
#' @importFrom esquisse render_ggplot
#' @export
mod_plot_usage_server <-
  function(id, 
           usage_raw = reactive(rsconnectUsageApp::usg_dta$usage_shiny), 
           users_raw = reactive(rsconnectUsageApp::usg_dta$users), 
           content_raw = reactive(rsconnectUsageApp::usg_dta$content)) {
    
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    usg_clean <- 
      reactive({usage_clean(req(usage_raw()), users_raw(), content_raw())}) %>% 
      debounce(750)
    
    esquisse::render_ggplot("usg_period", {
      plot_usage_by_period(usg_clean())
    })
    
    esquisse::render_ggplot("usg_app", {
      plot_usage_by_app(usg_clean())
    })
    #   
    # output$usg_period <- renderPlot({plot_usage_by_period(usg_clean())})
    # output$usg_app <- renderPlot({plot_usage_by_app(usg_clean())})
  })
}
    
## To be copied in the UI
# mod_plot_usage_ui("plot_usage_1")
    
## To be copied in the server
# mod_plot_usage_server("plot_usage_1")

#' test plot usage app with filters
test_plot_usage <- function(id = NULL) {
  ui <- shiny::fluidPage(
    mod_users_filter_ui(id = id),
    mod_plot_usage_ui(id = id)
  )
  
  server <- function(input, output, session) {
    noid_tbl <- mod_users_filter_server(
      id = id,
      reactive(rsconnectUsageApp::usg_dta$usage_shiny), 
      reactive(rsconnectUsageApp::usg_dta$users)
      )
    mod_plot_usage_server(id = id, usage_raw = noid_tbl)
  }
  
  shinyApp(ui, server)
}
