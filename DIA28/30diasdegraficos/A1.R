

library(ggplot2)
library(gganimate)
data("iris")#data("iris")
View(iris)

ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  ggtitle("Box-plot") + 
  theme(plot.title = element_text(hjust = 0.3)) + 
  labs(x = "Especies", y = "Longitud del sépalo") +
  geom_boxplot(aes(fill = Species), outlier.color = "red") + 
  scale_fill_manual(values = colores_bx)

View(mtcars)
data("mtcars")
ggplot(mtcars, aes(factor(cyl), mpg)) +
  geom_boxplot() +
  # Here comes the gganimate code
  transition_states(
    gear,
    transition_length = 2,
    state_length = 1
  ) +
  enter_fade() +
  exit_shrink() +
  ease_aes('sine-in-out')
