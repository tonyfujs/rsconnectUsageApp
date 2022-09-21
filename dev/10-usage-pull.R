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

# Glimpse at the data.
glimpse(usage_shiny)

# Combing data for use in the app -----------------------------------------------

client <- connect(prefix = "WBINTERNAL")

users2 <- get_users(client, limit = Inf)
groups2 <- get_groups(client, limit = Inf)
usage_shiny2 <- get_usage_shiny(client, limit = Inf)
usage_static2 <- get_usage_static(client, limit = Inf)
some_content2 <- get_content(client)



# saving data
dta_bd <- board_folder("data-raw", versioned = FALSE)

dta_bd %>% pin_write(bind_rows(usage_shiny, usage_shiny2), name = "usage_shiny", type = "rds")
dta_bd %>% pin_write(usage_static, name = "usage_static", type = "rds")
dta_bd %>% pin_write(
  users %>% 
    filter(!guid  %in% users2$guid ) %>% 
    bind_rows(users2), name = "users", type = "rds")
dta_bd %>% pin_write(groups, name = "groups", type = "rds")
dta_bd %>% pin_write(
  some_content %>% 
    filter(!guid %in% some_content2$guid) %>% 
    bind_rows(some_content2), name = "some_content", type = "rds")


# # saving data for use in the package ---------------------------------------------
# 
# library(synthpop)
# library(stringi)
# 
# usg_dta <- rsconnectUsageApp::usg_dta# get_usage_dta("list")
# usg_dta$users$email <-
#   usg_dta$users$email %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# usg_dta$users$username <-
#   usg_dta$users$username %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# usg_dta$users$first_name <-
#   usg_dta$users$first_name %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# usg_dta$users$last_name <-
#   usg_dta$users$last_name %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# 
# usg_dta$groups$name <-
#   usg_dta$groups$name %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# 
# 
# usg_dta$content$content_url <-
#   usg_dta$content$content_url %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# usg_dta$content$dashboard_url <-
#   usg_dta$content$dashboard_url %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# usg_dta$content$name <-
#   usg_dta$content$name %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# usg_dta$content$title <-
#   usg_dta$content$title %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# usg_dta$content$description <-
#   usg_dta$content$description %>% map_chr(~{stringi::stri_rand_strings(1, length = nchar(.x))  })
# usg_dta$content <-
#   usg_dta$content %>%
#   select(-owner)
# 
# usg_dta$users %>% glimpse()
# usg_dta$usage_shiny %>% glimpse()
# usg_dta$groups %>% glimpse()
# usg_dta$content %>% glimpse()
# 
# usethis::use_data(usg_dta, overwrite = TRUE)

  
