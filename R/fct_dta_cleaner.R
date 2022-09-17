
#' Clean users names
#' 
#' @importFrom dplyr mutate select arrange
#' @importFrom stringr str_c str_detect
#' @importFrom forcats as_factor
#' @importFrom magrittr %>%
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
        stringr::regex("taka|bukin|inchaus|fujs", ignore_case = T)
      )), 
      user_name) %>% 
    dplyr::mutate(user_name = forcats::as_factor(user_name))
  
}


#' Clean users names from the usage data
#' 
#' 
#' @importFrom forcats fct_c fct_explicit_na fct_relevel
#' @importFrom dplyr count left_join arrange mutate
#' 
#' @export
usage_users_clean <- function(usage_raw, users_raw) {
  usage_raw %>% 
    dplyr::count(user_guid) %>% 
    dplyr::left_join(users_raw %>% users_clean(), by = "user_guid") %>% 
    mutate(user_name = as.character(user_name),
           user_name = ifelse(is.na(user_name), "External users", user_name)) %>% 
    arrange(
      desc(n),
      desc(stringr::str_detect(
        user_name,
        stringr::regex("taka|bukin|inchaus|fujs|External", ignore_case = T)
        ))
      ) %>% 
    dplyr::mutate(user_name = forcats::as_factor(user_name))
}
