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

# saving data for future use ----------------------------------------------
library(synthpop)
library(stringi)

usg_dta <- get_usage_dta("list")
usg_dta$users$email <- 
  usg_dta$users$email %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
usg_dta$users$username <- 
  usg_dta$users$username %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
usg_dta$users$first_name <- 
  usg_dta$users$first_name %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
usg_dta$users$last_name <- 
  usg_dta$users$last_name %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })

usg_dta$groups$name <- 
  usg_dta$groups$name %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })

usg_dta$users %>% glimpse()
usg_dta$usage_shiny %>% glimpse()
usg_dta$groups %>% glimpse()

usethis::use_data(usg_dta, overwrite = TRUE)

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
  
