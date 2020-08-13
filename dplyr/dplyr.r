datos::vuelos
library()
#remotes::install_github("cienciadedatos/datos")
library(datos)
library(tidyverse)
view(vuelos)
vuelos <- datos::vuelos
  filter(vuelos, mes == 1, dia == 1)
  

# ok ----------------------------------------------------------------------

  ene1 <- filter(vuelos, mes == 1, dia == 1)
  
  
  (dic25 <- filter(vuelos, mes == 12, dia == 25))
  
  
  
  nov_dic <- filter(vuelos, mes %in% c(11, 12))
  
  nov_dic 
  
  filter(vuelos, !(atraso_llegada > 120 | atraso_salida > 120))
  filter(vuelos  , atraso_llegada <= 120, atraso_salida <= 120)
  
  
  is.na(vuelos)
  #> [1] TRUE
  
  

# ok 2 --------------------------------------------------------------------

  df <- tibble(x = c(1, NA, 3))
  filter(vuelos, x > 1)
  #> # A tibble: 1 x 1
  #>       x
  #>   <dbl>
  #> 1     3
  filter(vuelos, is.na(x) | x > 1)
  #> # A tibble: 2 x 1
  #>       x
  #>   <dbl>
  #> 1    NA
  #> 2     3
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
    
  
  
  
  
  
  
  
  
  