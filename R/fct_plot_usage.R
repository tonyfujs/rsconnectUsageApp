#' Aggregate clean usage data by time periods
#' 
#' @inheritParams lubridate::ceiling_date
#' @importFrom lubridate ceiling_date as_date round_date floor_date
#' @importFrom dplyr summarise group_by ungroup
#' @export
agg_clean_usage <- function(usage_clean, unit = "month") {
  usage_clean %>% 
    dplyr::mutate(date = 
                    lubridate::floor_date(started, unit = unit) %>% 
                    lubridate::as_date(),
                  duration = as.numeric(duration)) %>% 
    dplyr::group_by(date, content_title, user_name) %>% 
    dplyr::summarise(duration = sum(duration),
                     connections = dplyr::n()) %>% 
    dplyr::ungroup()
}

#' @describeIn agg_clean_usage aggregate apps usage 
#' 
#' @export
agg_app_usage <- function(usage_clean, ...) {
  usage_clean %>% 
    group_by(content_title) %>% 
    dplyr::summarise(duration = sum(duration),
                     connections = dplyr::n()) %>% 
    dplyr::ungroup() %>% 
    bind_rows(
      dplyr::summarise(
        ., 
        duration = sum(duration),
        connections = sum(connections)) %>% 
        mutate(content_title = "TOTAL of selected apps")
    ) %>% 
    mutate(content_title = 
             forcats::as_factor(content_title) %>% 
             forcats::fct_reorder(duration) %>% 
             forcats::fct_rev()) %>% 
    arrange(content_title) %>% 
    mutate(Usage = lubridate::seconds_to_period(duration) %>% as.character()) %>% 
    select(App = content_title, Usage, Connections = connections)
}



#' compute time axis breaks with a fixed 12 hours interval
#' 
#' @importFrom scales breaks_width
#' @importFrom lubridate as_datetime
#' 
#' @export
my_day_breaks <- function(a) {
  # browser()
  a <- ifelse(a < 0, 0, a)
  breaking <- scales::breaks_width("12 hour")
  breaking(a %>% lubridate::as_datetime()) %>% as.numeric()
}

#' compute duration labels for a ggplot
#' 
#' @importFrom lubridate seconds_to_period
#' @importFrom stringr str_replace_all str_trim
#' 
#' @export
my_day_labels <- function(a) {
  a %>% 
    lubridate::seconds_to_period() %>% 
    stringr::str_replace_all("0M|0S|0H", "") %>% 
    stringr::str_trim()
}


#' Make a usage ggplot
#' 
#' @param dta is the clean usage data
#' @param period is one of c("month", "year", "quarter")
#' 
#' @import ggplot2
#' @importFrom lubridate seconds_to_period
#' @export
plot_usage_by_period <- function(dta, period = "month", fill = user_name) {
  
  usg_agg <- agg_clean_usage(dta, period)
  
  unique_apps <- usg_agg$content_title %>% unique()
  unique_apps_msg <- str_c("Usage of ", length(unique_apps), " apps is aggregated under each bar.")
  
  usage_clean_summ <-
    usg_agg %>% 
    group_by(date) %>% 
    summarise(duration = sum(duration), connections = sum(connections)) %>% 
    ungroup() %>% 
    mutate(label = str_c(lubridate::seconds_to_period(duration), " (", connections," con.)")) %>% 
    mutate(hjust_lab = ifelse(duration < max(duration) / 2, -.02, 1.02))
  
  usg_agg %>% 
    ggplot() + 
    aes(x = date, y = duration, fill = {{fill}}, colour = {{fill}}) + 
    geom_bar(stat = "identity") + 
    scale_x_date(date_breaks = "1 month", date_labels="%b%y") +
    scale_y_continuous(labels = my_day_labels, breaks = my_day_breaks) + 
    geom_text(
      data = usage_clean_summ,
      mapping = aes(x = date, y = duration, label = label, hjust = hjust_lab),
      inherit.aes = FALSE,
      angle = 90,
      vjust = 0.5, 
      size = 3) +
    labs(title = str_c("Cumulative usage of the selected apps by ", period), 
         subtitle = unique_apps_msg) +
    ylab("Cumulative usage") +
    xlab("Period") +
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}


#' @describeIn plot_usage_by_period plot usage by app
#' 
#' @export
plot_usage_by_app <- function(dta) {
  
  usg_agg <- agg_clean_usage(dta, "year")
  
  usage_clean_summ <-
    usg_agg %>% 
    group_by(content_title) %>% 
    summarise(duration = sum(duration), connections = sum(connections)) %>% 
    ungroup() %>% 
    mutate(label = str_c(lubridate::seconds_to_period(duration), " (", connections," con.)")) %>% 
    mutate(hjust_lab = ifelse(duration < max(duration) / 2, -.02, 1.02))
  
  usg_agg %>% 
    mutate(content_title = forcats::as_factor(content_title),
           content_title = forcats::fct_reorder(content_title, duration, sum),
           date = forcats::as_factor(str_c(lubridate::year(date))) %>% 
             forcats::fct_rev()) %>% 
    # pull(content_title)
    ggplot() + 
    aes(x = duration , y = content_title, fill = date, colour = date) + 
    geom_bar(stat = "identity") + 
    # scale_x_date(date_breaks = "1 month", date_labels="%b%y") +
    scale_x_continuous(labels = my_day_labels, 
                       breaks = my_day_breaks) + 
    geom_text(
      data = usage_clean_summ,
      mapping = aes(x = duration , y = content_title, label = label, hjust = hjust_lab),
      inherit.aes = FALSE,
      vjust = 0.5,
      size = 3) +
    xlab("Cumulative usage") +
    ylab("App") +
    labs(title = str_c("Cumulative usage of selected apps by year")) +
    theme_bw() + 
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  
}

