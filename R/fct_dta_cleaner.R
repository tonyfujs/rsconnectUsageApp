
#' Clean users names
#' 
#' @importFrom dplyr mutate select arrange
#' @importFrom stringr str_c str_detect
#' @importFrom forcats as_factor
#' 
#' @export
users_clean <- function(dta) {
  dta %>% 
    dplyr::mutate(
      user_name = stringr::str_c(last_name, ", ", first_name)
    ) %>% 
    dplyr::select(user_name, user_email = email, user_guid = guid) %>% 
    dplyr::arrange(
      desc(stringr::str_detect(
        user_name,
        stringr::regex("taka|bukin|inchaus", ignore_case = T)
      )), 
      user_name) %>% 
    dplyr::mutate(user_name = forcats::as_factor(user_name))
  
}
