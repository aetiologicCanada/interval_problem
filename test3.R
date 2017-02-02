# This is Andre's original code, except that I have moved the "days" from dates (yymmdd) 
# to POSIXct with hms arguments. 
#
##I have brought in the "problem dates" from my analysis. Note that they are YMD and not POSIXct
## But "days" is not POSIXct (converted to YMD during dplyr step) 

# This fails with: 
# dates_in_intervals <- list_dates(intervals)
# Error in intervals[i, "start"]:intervals[i, "stop"] : NA/NaN argument
# and whenI try: 
# test <-intervals[1:"start"]:intervals[1:"stop"]
# Error in 1:"start" : NA/NaN argument
# In addition: Warning message:
#  In check_names_df(i, x) : NAs introduced by coercion
#> 
# 
library(lubridate)
library(magrittr)
library(feather)

# list of intervals
# 
# 
library(dplyr)
problems <-read_feather("./problems.RfeatherData")%>%
  select(date)%>%
  mutate(
    start=date,
    stop=date
  )
str(problems)

intervals <-problems

#<-data.frame(start=c(ymd("2015-01-01", "2015-02-01")),
#                       stop= c(ymd("2015-01-08", "2015-02-08"))
#)

intervals
# list of events
days <- data.frame(start=c(ymd_hms("2016-01-03 12:13:14", "2016-02-22  12:13:14", "2016-11-24  12:13:14", tz="Canada/Pacific")))
days$stop <-days$start
days
#Ojbective:
# if event occurs in these intervales - exclude from analysis
rm(dates_in_intervals)
# funtion that lists invidual dates in each interval
list_dates <- function(intervals){
  intervals <- as.data.frame(intervals)
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
