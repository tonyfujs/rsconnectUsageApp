#' usage_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_usage_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      DT::DTOutput(ns("total_usage")),
      style = "zoom:0.6"
    )
  )
}
    
#' usage_table Server Functions
#'
#' @importFrom DT renderDT
#' @noRd 
mod_usage_table_server <- function(id, usage_clean){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$total_usage <- DT::renderDT({
      req(usage_clean()) %>% agg_app_usage()
    })
  })
}
    
## To be copied in the UI
# mod_usage_table_ui("usage_table_1")
    
## To be copied in the server
# mod_usage_table_server("usage_table_1")
