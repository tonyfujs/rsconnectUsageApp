# Exploring usage data


# Setups
library(ggplot2)
library(dplyr)
library(connectapi)
library(stringr)
library(shiny)
library(pins)
library(forcats)
library(purrr)

 
golem::document_and_reload()
pkgload::load_all()

# Cleaning functions -------------------------
users_clean(usg_dta$users)
usage_users_clean(usg_dta$usage_shiny, usg_dta$users)

# filter users ----------------------------------
pkgload::load_all()
test_mod_users_filter()

# Reading data

dta$usage_shiny %>% 
  filter(!user_guid %in% c())


all_users <- usge_users_clean(dta$usage_shiny, dta$users)

users_all <- set_names(x = all_users$user_guid, nm = all_users$user_name)



users_id <- dta$users %>% users_clean()



usage_raw <- dta$usage_shiny 
users_raw <- dta$users




# Exclude users
users_all_dta <- dta$users %>% users_clean()

users_all <- set_names(x = users_all_dta$user_guid, nm = users_all_dta$user_name)
exclude <- all_users[1:3]

users_exclude <- users_all[!users_all %in% exclude]

usage_agg_stats <- function(dta) {
  dta %>% 
    summarise(
      session_count = n(),
      session_duration = sum(session_duration, na.rm = TRUE)
    ) %>% 
    ungroup() %>% 
    mutate(
      session_label = 
        str_c(lubridate::seconds_to_period(session_duration),
              ". (", session_count,")")
    )
}

# Preparing data usage:
library(lubridate)
usage_dta <- 
  dta$usage_shiny  %>% 
  anti_join(users_exclude, "user_guid") %>% 
  mutate(session_duration = as.numeric(ended - started),
         year = lubridate::year(started),
         month = lubridate::month(started),
         date = str_c(year, "-", month, "-01") %>% ymd())


# Plot usage of the selected apps over time
agged_dta <- 
  usage_dta %>% 
  group_by(date) %>% 
  usage_agg_stats() 

agged_dta

agged_dta %>% 
  ggplot() + 
  aes(x = date, y = session_duration, 
      label = 
        str_c(lubridate::seconds_to_period(..y..),
              ". (", ,")")) + 
  geom_bar(stat = "sum") %>% +
  scale_x_date(date_breaks = "month", date_labels = "%y-%b") + 
  geom_label()
  # theme()
  scale_y_time()
  
  



