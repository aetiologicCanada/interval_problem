# This is Andre's original code, save that the function call was corrected to list_dates 
# from list_intervals
# it does exactly what I wanted. 
# One choice is to generate a "day" from my POSIXct and then this model will work
#
library(lubridate)
library(magrittr)
# list of intervals
intervals <-data.frame(start=c(ymd("2015-01-01", "2015-02-01")),
                       stop= c(ymd("2015-01-08", "2015-02-08"))
)

# list of events
days <- data.frame(start=c(ymd("2015-01-03", "2015-02-06", "2015-03-08")))
days$stop <-days$start

intervals
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
    include = start %in% dates_in_intervals
  )
days
