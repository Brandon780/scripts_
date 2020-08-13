




library(ggplot2)
library(tidyverse)
library(dslabs)
data(murders)
view(murders)
murders %>% ggplot() +
  geom_point(aes(x = population/10^6, y = total))+
  geom_text(aes(population/10^6, total, label = abb))

# add points layer to predefined ggplot object
p <- ggplot(data = murders)
p + geom_point(aes(population/10^6, total))

# add text layer to scatterplot
p + geom_point(aes(population/10^6, total)) +
  geom_text(aes(population/10^6, total, label = abb))


# for example -------------------------------------------------------------



# no error from this call
p_test <- p + geom_text(aes(population/10^6, total, label = abb))

# error - "abb" is not a globally defined variable and cannot be found outside of aes
p_test <- p + geom_text(aes(population/10^6, total), label = abb)



# explicacion -------------------------------------------------------------


