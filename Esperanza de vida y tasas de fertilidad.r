library(tidyverse)
library(dslabs)
data(gapminder)
head(gapminder)

###############################################################################
###############################################################################
###############################################################################
###############################################################################

#en este script analisaremos la esperanza de vida y familias pequeñas

###############################################################################
###############################################################################
###############################################################################
###############################################################################


#gráfico de dispersión básico de esperanza de vida frente a fertilidad
ds_theme_set()    # graficando
filter(gapminder, year == 1962) %>%
  ggplot(aes(fertility, life_expectancy)) +
  geom_point()

# color por continente
filter(gapminder, year == 1962) %>%
  ggplot(aes(fertility, life_expectancy, color = continent)) +
  geom_point()


