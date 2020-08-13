library("nycflights13")
library("tidyverse")
data("flights")
view(flights)
flights <- data::flights

flights
as.data.frame(x = flights)
filter(flights, is.na(dep_time))


