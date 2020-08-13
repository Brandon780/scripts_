iris<-data.frame(iris)
view(iris)


head(iris)
ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  ggtitle("Box-plot") + 
  theme(plot.title = element_text(hjust = 0.3)) + 
  labs(x = "Especies", y = "Longitud del sépalo") +
  geom_boxplot(aes(fill = Species), outlier.color = "red") + 
  
  # Here comes the gganimate code
  transition_states(
    Sepal.Width,
    transition_length = 2,
    state_length = 1
  ) +
  enter_fade() +
  exit_shrink() +
  ease_aes('sine-in-out')

