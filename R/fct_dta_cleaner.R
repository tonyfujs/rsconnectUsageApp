
#' Clean users names
#' 
#' @importFrom dplyr mutate select arrange bind_rows
#' @importFrom tibble tibble
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
    dplyr::bind_rows(tibble::tibble(user_name = "External users", user_email = NA, user_guid = NA)) %>% 
    dplyr::arrange(
      desc(stringr::str_detect(
        user_name,
        stringr::regex("taka|bukin|inchaus|fujs|External", ignore_case = T)
      )), 
      user_name) %>% 
    dplyr::mutate(user_name = forcats::as_factor(user_name))
  
}

#' Clean content data
#' 
#' @importFrom dplyr mutate select arrange
#' 
#' @export
content_clean <- function(dta) {
  dta %>% 
    mutate(content_title = ifelse(is.na(title), name, title)) %>% 
    select(content_guid = guid, content_title)
  
}



#' Clean usage data
#' 
#' 
#' @export
usage_clean <- function(usage_raw, users_raw, content_raw) {
  usage_raw %>% 
    dplyr::left_join(users_clean(users_raw), by = "user_guid") %>% 
    dplyr::left_join(content_clean(content_raw), by = "content_guid") %>% 
    dplyr::mutate(duration = ended - started) %>% 
    dplyr::filter(!is.na(duration))
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
           # user_guid = ifelse(is.na(user_name),NA_character_, user_name)
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
