
library(HistData)
data(Nightingale)
library(tidyverse)
library(stringr)

cause_fun <- function(x) {
  x %>% 
    str_replace_all("\\.rate", "") %>% 
    return()
}


Nightingale %>% 
  select(Date, Disease.rate, Wounds.rate, Other.rate) %>% 
  gather(Cause, Deaths, -Date) %>% 
  mutate(Cause = cause_fun(Cause), 
         Regime = rep(c(rep("Before", 12), rep("After", 12)), 3)) -> Night 



theme_set(theme_minimal())

p1 <- Night %>% 
  ggplot(aes(x = factor(Date), y = Deaths, fill = Cause)) +
  geom_col(color = "black") + 
  # geom_bar(width = 1, position = "identity", stat = "identity", color = "black") + 
  scale_y_sqrt() +
  facet_grid(. ~ Regime, scales = "free", labeller = label_both) + 
  coord_polar(start = 3*pi/2) +
  labs(x = NULL, y = NULL, 
       title = "Causes of Mortality in the Army in the East", 
       subtitle = "Created by R Statistical Software", 
       caption = "Data Source: Deaths from various causes in the Crimean War") + 
  scale_fill_manual(values = c('#377eb8','#4daf4a','#984ea3'))

p1

p2 + 
  theme_fivethirtyeight() + 
  scale_fill_fivethirtyeight() +
  theme(legend.position = "top")







