# load and inspect gapminder data
library(tidyverse)
library(dslabs)
data(gapminder)#conjunto de datos gapminder proporcionados en la biblioteca dslabs
head(gapminder) #ver los datos

#pulation                       #country     #dgp
#resultados economicos          #pais        #resultados economicos


# ########resulatdo de analisis con respecto alas diferencias mort en diferentes paises--------
#que pais cree que tuvo la mayor mortalidad infantil en el 2015
#para cada par de pais

#Sri lanka or Turkey
#Poland or suuth korea
#Malaysia or Russia
#Pakistan or Vietnam
#thailand or south Africa
###############################################################################
###############################################################################
###############################################################################
###############################################################################


# Que pares son similares -------------------------------------------------


###############################################################################
###############################################################################
###############################################################################
###############################################################################

#Responder esta pregunta sin datos

#elegimos los paises europeos
#sri lanka 
#south korea
#malasya

#los que son parte del mundo de desarrollo

#africa tiene tasa de mortyalidad igualmente alta

###############################################################################
###############################################################################
###############################################################################
###############################################################################

#Sri lanka or Turkey
#Poland or suuth korea
#Malaysia or Russia
#Pakistan or Vietnam
#thailand or south Africa

 #Ahora vamos a responder esta pregunta con datos

#para esta primera comparacion



# este simple código dplyr puedes ver que Turquía tiene una mayor mortalidad que siril lanka

gapminder %>%
    filter(year == 2015 & country %in% c("Sri Lanka", "Turkey")) %>%
   select(country, infant_mortality)


#ESTE CODIGO PARA VER el comportamiento
WA <-gapminder %>%
  filter(year == 2015 & country %in% c("Sri Lanka", "Turkey" ,  "Poland"  , "south korea "," Malaysia ", "Russia" ," Pakistan" , "Vietnam " ,"thailand" ,"south Africa" )) %>%
  select(country, infant_mortality)

WA


# respondiendo por comparaciones ------------------------------------------


WB <-gapminder %>%
  filter(year == 2015 & country %in% c("Sri Lanka", "Turkey")) %>%
  select(country, infant_mortality)

WC <-gapminder %>%
  filter(year == 2015 & country %in% c( "South korea " , "Poland" )) %>%
  select(country, infant_mortality)

WL <- gapminder %>%
  filter( country %in% c( " Malaysia ", "South korea "  )) %>%
  select(country, infant_mortality , year )



########A partir de aquí, vemos que estas comparaciones, los países europeos
#tienen tasas más altas.
#También vemos que los países del mundo en desarrollo
#puede tener RESULTADOS muy diferentes.
#Resulta que la mayoría de la gente hace peor que si fueran sólo
#adivinar, lo que implica que somos más que ignorantes, estamos mal informados.
