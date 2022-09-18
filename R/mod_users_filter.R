#' users_filter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_users_filter_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::selectizeInput(
      inputId = ns("users_exclude"), 
      label = "Users to exclude", 
      choices = NULL,
      selected = NULL,
      multiple = TRUE,
      size = 10,
      width = "100%"
      )
    )
}
    
#' users_filter Server Functions
#'
#' @importFrom purrr set_names
#' @noRd 
mod_users_filter_server <- function(id, usage_raw, users_raw){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    all_users <- reactive({
      req(usage_raw())
      req(users_raw())
      usage_users_clean(usage_raw(), users_raw())
    })
    
    observeEvent(#
      all_users(), {
        req(all_users())
        
        local_choices <- 
          purrr::set_names(x = all_users()$user_guid, 
                           nm = all_users()$user_name)
        
        shiny::updateSelectizeInput(
          inputId = "users_exclude",  
          choices = local_choices,
          selected = local_choices[2:4]
        )
      
    }, ignoreNULL = TRUE, ignoreInit = FALSE)
    
    reactive({
      req(usage_raw())
      # req(input$users_exclude)
      usage_raw() %>% filter(!user_guid %in% input$users_exclude)
      
    })
  })
}
    
## To be copied in the UI
# mod_users_filter_ui("users_filter_1")
    
## To be copied in the server
# mod_users_filter_server("users_filter_1")

#' Testing for the module mod_users_filte
#' 
#' @importFrom DT renderDT DTOutput
#' @import shiny 
#' @export
test_mod_users_filter <- function() {
  ui <- shiny::fluidPage(
    column(6,
           mod_users_filter_ui(NULL),
           shiny::verbatimTextOutput("noid_print"),
           DT::DTOutput("noid_table")),
    column(6, mod_users_filter_ui("mod_id"),
           shiny::verbatimTextOutput("id_print"),
           DT::DTOutput("id_table"))
  )
  server <- function(input, output, session) {
    noid_tbl <- mod_users_filter_server(NULL,
                                        reactive(rsconnectUsageApp::usg_dta$usage_shiny), 
                                        reactive(rsconnectUsageApp::usg_dta$users))
    id_tbl <- mod_users_filter_server("mod_id",
                                      reactive(rsconnectUsageApp::usg_dta$usage_shiny), 
                                      reactive(rsconnectUsageApp::usg_dta$users))
    
    observe({
      noid_tbl()
      id_tbl()
    })
    
    output$noid_print <-
      shiny::renderPrint({
        req(noid_tbl())
        noid_tbl() %>% glimpse()
      })
    
    output$id_print <-
      shiny::renderPrint({
        req(id_tbl())
        id_tbl() %>% glimpse()
      })

    output$noid_table <- DT::renderDT(req(noid_tbl()))
    output$id_table <- DT::renderDT(req(id_tbl()))
  }
  
  shinyApp(ui, server)
  
}
