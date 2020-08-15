





###############################################################################
###############################################################################
###############################################################################
###############################################################################


# facet by continent and year
filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_grid(continent ~ year)

# facet by year only
filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_grid(. ~ year)





# ############# -----------------------------------------------------------

#Pasaron de tener familias numerosas y una vida útil corta
#a tener familias más pequeñas y una vida útil más larga.


# practica con nombres ----------------------------------------------------


n<-datos::nombres     
head()

filter(n, nombre %in% c("Minnie", "Margaret")) %>%
  ggplot(aes(anio, n, col = sexo)) +
  geom_point() +
  facet_grid(. ~ nombre)


# facet by year, plots wrapped onto multiple rows
years <- c(1962, 1980, 1990, 2000, 2012)
continents <- c("Europe", "Asia")
gapminder %>%
  filter(year %in% years & continent %in% continents) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_wrap(~year)





# pracitica con nombres ---------------------------------------------------

head(n)

anios <- c( 1993,1994,1995,1996)
nombres <- c("Elizabeth","Mary","Emma")
gapminder %>%
  filter(nombre %in% nombres & anio %in% anios) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_wrap(~anio)




