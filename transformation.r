#las tranformaciones pueden seer muy utiles para
#comprender mejor las ditribuciones 

#columna del rpoducto interno bruto
 
#el PIB por persona se utiliza a menudo como un resumen  
#aproximado de lo rico que es un pais 

library(dslabs)
data(gapminder)

library(tidyverse)
library(dplyr)
library()
  gapminder <- gapminder %>%
     mutate (dollars_per_day = dgp/population /365)
  
  #tenga en cuenta que dentro de cada pais hay mucha variabilidad
  past_year <- 1970
  gapminder %>%
  filter(year == past_year & ! is.na (gdp)) %>%
    ggplot (aes(dollars_per_day))+
    geom_histogram(bindwith=1 ,color = "black")
  
  gapminder <- gapminder %>%
    mutate(dollars_per_day = gdp/population/365)
  
  # histogram of dollars per day
  past_year <- 1970
  gapminder %>%
    filter(year == past_year & !is.na(gdp)) %>%
    ggplot(aes(dollars_per_day)) +
    geom_histogram(binwidth = 1, color = "black")##cambiamos binwith
  
  # repeat histogram with log2 scaled data
  gapminder %>%
    filter(year == past_year & !is.na(gdp)) %>%
    ggplot(aes(log2(dollars_per_day))) +
    geom_histogram(binwidth = 1, color = "black")
  
  # repeat histogram with log2 scaled x-axis
  gapminder %>%
    filter(year == past_year & !is.na(gdp)) %>%
    ggplot(aes(dollars_per_day)) +
    geom_histogram(binwidth = 1, color = "black") +
    scale_x_continuous(trans = "log2")
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  