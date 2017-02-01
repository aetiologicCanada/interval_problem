# This is Andre's original code, except that I have moved the "days" from dates (yymmdd) 
# to POSIXct with hms arguments. 
# 
# This also works, once as.Date(start) rather than Date is added to dplyr step
# 
library(lubridate)
library(magrittr)
# list of intervals
# 
intervals <-data.frame(start=c(ymd("2015-01-01", "2015-02-01")),
                       stop= c(ymd("2015-01-08", "2015-02-08"))
)
intervals
str(intervals)

# list of events
days <- data.frame(start=c(ymd_hms("2015-01-03 12:13:14", "2015-02-06  12:13:14", "2015-03-08  12:13:14", tz="Canada/Pacific")))
days$stop <-days$start
days
#Ojbective:
# if event occurs in these intervales - exclude from analysis

# funtion that lists invidual dates in each interval
list_dates <- function(intervals){
  ls <- list()
  n_intervals <- nrow(intervals)
  for(i in 1:n_intervals){
    ls[[i]] <- intervals[i,"start"]:intervals[i,"stop"]
  }
  dates <- unlist(ls) %>% as.Date(origin)
  return(dates)
}

dates_in_intervals <- list_dates(intervals)
dates_in_intervals


days <- days %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    include = as.Date(start) %in% dates_in_intervals
  )
days
