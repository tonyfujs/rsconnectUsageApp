# Existing servers:
# WBINTERNAL_SERVER
# WBINTERNAL_API_KE
# WBEXTERNAL_NTERNAL_SERVER
# WBEXTERNAL_NTERNAL_API_KEY


library(tidyverse)

# remotes::install_github("rstudio/connectapi")
library(connectapi)

library(ggplot2)
library(dplyr)
library(stringr)
library(pins)

# My apps manually collected -----------------------------------------------

# Reloading data and saving it all in the pins 
client <- connect(prefix = "WBEXTERNAL_NTERNAL")

users <- get_users(client, limit = Inf)
groups <- get_groups(client, limit = Inf)
usage_shiny <- get_usage_shiny(client, limit = Inf)
usage_static <- get_usage_static(client, limit = Inf)
some_content <- get_content(client)

# saving data
dta_bd <- board_folder("data-raw", versioned = FALSE)

dta_bd %>% pin_write(usage_shiny, name = "usage_shiny", type = "rds")
dta_bd %>% pin_write(usage_static, name = "usage_static", type = "rds")
dta_bd %>% pin_write(users, name = "users", type = "rds")
dta_bd %>% pin_write(groups, name = "groups", type = "rds")
dta_bd %>% pin_write(some_content, name = "some_content", type = "rds")


# Glimpse at the data.

glimpse(usage_shiny)

# 
# 
# usage_shiny %>% 
#   filter(is.na(user_guid)) %>%
#   group_by(content_guid) %>% 
#   summarise(across(c(session_duration), ~ sum(.)),
#             connections = n()) %>% 
#   # left_join(my_apps) %>% 
#   ggplot() + aes(y = titel, x = connections) +
#   geom_bar(stat = "identity")
# 
# 
# shiny_rsc %>% 
#   filter(user_guid != me | is.na(user_guid)) %>%
#   group_by(content_guid) %>% 
#   summarise(across(c(session_duration), ~ sum(.)),
#             connections = n()) %>% 
#   left_join(my_apps) %>% 
#   ggplot() + aes(y = titel, x = session_duration / 3600 / 24) +
#   geom_bar(stat = "identity")
  
