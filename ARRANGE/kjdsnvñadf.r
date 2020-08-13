# install.packages("datos")
library(datos)
library(tidyverse)
library(dplyr)
Vuelos <- datos::vuelos
view(vuelos)
filter(vuelos, is.na(horario_salida))
