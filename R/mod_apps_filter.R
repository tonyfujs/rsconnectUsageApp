#' users_filter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @importFrom shinyWidgets pickerInput
mod_apps_filter_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyWidgets::pickerInput(
      inputId = ns("apps_include"), 
      label = "Apps usage to visualize", 
      choices = NULL,
      selected = NULL,
      multiple = TRUE,
      options = list(`actions-box` = TRUE),
      width = "100%"
      )
    )
}
    
#' users_filter Server Functions
#'
#' @importFrom purrr set_names
#' @importFrom shinyWidgets updatePickerInput
#' @noRd 
mod_apps_filter_server <-
  function(id,
           usage_raw =  reactive(rsconnectUsageApp::usg_dta$usage_shiny),
           users_raw =  reactive(rsconnectUsageApp::usg_dta$users),
           content_raw =  reactive(rsconnectUsageApp::usg_dta$content)) {
    
  moduleServer( id, function(input, output, session) {
    ns <- session$ns
    
    all_content <- reactive({
      req(usage_raw())
      req(users_raw())
      req(content_raw())
      usage_clean(usage_raw(), users_raw(), content_raw()) %>% 
        distinct(content_guid, content_title) %>% 
        arrange(content_title)
    })
    
    observeEvent(#
      all_content(), {
        req(all_content())
        
        local_choices <- 
          purrr::set_names(x = all_content()$content_guid, 
                           nm = all_content()$content_title)
        inputs_to_restore <- input$users_exclude
        
        if (isTruthy(inputs_to_restore)) {
          inputs_to_restore <-
            inputs_to_restore[inputs_to_restore %in% local_choices]
        } else {
          inputs_to_restore <- local_choices
        }
        
        shinyWidgets::updatePickerInput(
          session = session,
          inputId = "apps_include",  
          choices = local_choices,
          selected = inputs_to_restore
        )
      
    }, ignoreNULL = TRUE, ignoreInit = FALSE)
    
    reactive({
      req(usage_raw())
      if (isTruthy(input$apps_include)) {
        usage_raw() %>% filter(content_guid %in% input$apps_include)
      } else {
        usage_raw()
      }
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
test_mod_apps_filter <- function(id = NULL) {
  ui <- shiny::fluidPage(
    mod_apps_filter_ui(id = id),
    shiny::verbatimTextOutput("noid_print"),
    DT::DTOutput("noid_table")
  )
  
  server <- function(input, output, session) {
    noid_tbl <- mod_apps_filter_server(
      id = id,
      usage_raw = reactive(rsconnectUsageApp::usg_dta$usage_shiny),
      users_raw = reactive(rsconnectUsageApp::usg_dta$users),
      content_raw = reactive(rsconnectUsageApp::usg_dta$content)
    )
    
    output$noid_print <- shiny::renderPrint({req(noid_tbl()) %>% glimpse()})
    output$noid_table <- DT::renderDT(req(noid_tbl()))
  }
  
  shinyApp(ui, server)
  
}
