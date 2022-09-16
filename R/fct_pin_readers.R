#' Returns folder board
#' @importFrom pins board_folder
get_board_folder <- function() {
  pins::board_folder("data-raw")
}

#' Returns list with usage data previously saved
#' @importFrom shiny reactiveValues
#' @importFrom pins pin_reactive_read
get_usage_dta <- function(type = "reactive", ...) {
  
  dta_bd <- get_board_folder()
  
  if (type == "reactive") {
    reactiveValues(
      usage_shiny = pins::pin_reactive_read(dta_bd, "usage_shiny"),
      users = pins::pin_reactive_read(dta_bd, "users"),
      groups = pins::pin_reactive_read(dta_bd, "groups")#,
      # some_content = pins::pin_reactive_read(dta_bd, "some_content")
    )
  } else {
    list(
      usage_shiny = pins::pin_read(dta_bd, "usage_shiny"),
      users = pins::pin_read(dta_bd, "users"),
      groups = pins::pin_read(dta_bd, "groups")#,
      # some_content = pins::pin_reactive_read(dta_bd, "some_content")
    )
  }
}
