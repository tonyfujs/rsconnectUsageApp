

# Exploring useage data

library(ggplot2)
library(dplyr)
library(connectapi)
library(stringr)

library(shiny)
library(pins)
library(forcats)

# Setups 
golem::document_and_reload()
pkgload::load_all()


# Reading pins 
dta <- get_usage_dta("list")

users_exclude <- dta$users %>% users_clean() %>% slice(1:3)

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
  
  



