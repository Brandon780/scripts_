argar librerías --------------------------------------------------------
  library(ggplot2)
  library(tidyverse)
library(extrafont)
# loadfonts()


# Cargar y procesar datos -------------------------------------------------
datos <- read.csv2("Libro3.csv")
View(datos)
datos <- read.csv2("Libro3.csv") %>%
  pivot_longer(cols = -c(1:2),
               names_to = "Microplasticos",
               values_to = "Valor") %>% 
  mutate(Mes = factor(Mes, levels = c("Enero", "Febrero", "Marzo", "Abril", "Mayo",
                                      "Junio", "Julio", "Agosto", "Septiembre",
                                      "Octubre", "Noviembre", "Diciembre")))

datos_lab <- datos %>%
  group_by(Mes) %>%
  summarise(n = sum(Valor) + 500)
"#bfe6b4",
"#c2a1c7",
"#64b8c0",
"#e5a28f"
getwd()
view(datos)
# Visualización -----------------------------------------------------------

myAng <- seq(-15, -345, length.out = 12)


p <- ggplot() +
  geom_col(
    data = datos,
    aes(x = Mes, y = Valor, fill = Microplasticos),
    width = 1,
    colour = "grey50",
    size = 0.3,
    alpha = 0.7
  ) +
  geom_text(
    data = datos_lab,
    aes(label = Mes, x = Mes, y = n),
    angle = myAng,
    size = 2,
    fontface = "bold"
  ) +
  coord_polar() +
  scale_fill_manual(values = c("#ff9999",
                               "#99ff99",
                               "#9999ff",
                               "#e5a28f")) + 
  labs(
    title = "Microplasticos en tipos\nficticios",
    x = "",
    y = "",
    fill = "",
    caption = "fin de 30 dias de graficos"
  ) +
  theme(
    text = element_text(family = "Gill Sans MT Condensed"),
    legend.position = "top",
    axis.text.x = element_blank(),
    panel.grid = element_line(linetype = "dotted", colour = "blue"),
    plot.background = element_rect(fill = "khaki2"),
    legend.background = element_rect(fill = "khaki2"),
    panel.background = element_rect(fill = "khaki2"),
    panel.spacing = unit(1, "mm"),
    plot.title = element_text(family = "Gill Sans MT Condensed", hjust = 0.5)
  ) +
  guides(fill = guide_legend(
    nrow = 2,
    keywidth = unit(3, "mm"),
    keyheight = unit(3, "mm")
  ))

p