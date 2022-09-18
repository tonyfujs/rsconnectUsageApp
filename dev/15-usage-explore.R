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
content_clean(usg_dta$content)
usage_users_clean(usg_dta$usage_shiny, usg_dta$users)
usage_clean(usg_dta$usage_shiny, usg_dta$users, usg_dta$content)

# # filter users ----------------------------------
# pkgload::load_all()
# test_mod_users_filter()

# Plot usage ---------------------------
usage_clean <- usage_clean(usg_dta$usage_shiny, usg_dta$users, usg_dta$content)

# Monthly bar chart
usage_clean_agg <- agg_clean_usage(usage_clean, "quarter")

# agg_clean_usage(usage_clean, "month") %>%
plot_usage_by_period(usage_clean, "month")
plot_usage_by_app(usage_clean)

usage_clean %>% agg_clean_usage( "year")

# Aggregating usage
agg_app_usage(usage_clean)

# Runn usage app ---------------------------------

pkgload::load_all()
test_plot_usage()
  


# pickerInput(
#   inputId = "Id094",
#   label = "Select/deselect all options", 
#   choices = LETTERS,
#   options = list(
#     `actions-box` = TRUE), 
#   multiple = TRUE
# )



