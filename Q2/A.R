Cargar librerías --------------------------------------------------------
  
  library(tidyverse)
library(extrafont)
# loadfonts()


# Cargar y procesar datos -------------------------------------------------
dat <- read.csv2("Libro2.csv")
View(datos)
dat <- read.csv2("Libro2.csv") %>%
  pivot_longer(cols = -c(1:2),
               names_to = "Lesion",
               values_to = "Valor") %>% 
  mutate(Mes = factor(Mes, levels = c("Enero", "Febrero", "Marzo", "Abril", "Mayo",
                                      "Junio", "Julio", "Agosto", "Septiembre",
                                      "Octubre", "Noviembre", "Diciembre")))


datos_la <- dat %>%
  group_by(Mes) %>%
  summarise(n = sum(Valor) + 500)

getwd()

# probando ----------------------------------------------------------------

   kok <- datos%>%
pivot_longer(cols = -c(1:3),
             names_to = "Lesion",
             values_to = "Valor")

# Visualización -----------------------------------------------------------

myAng <- seq(-15, -345, length.out = 12)


p <- ggplot() +
  geom_col(
    data = dat,
    aes(x = Mes, y = Valor, fill = Lesion),
    width = 1,
    colour = "grey33",
    size = 0.3,
    alpha = 0.7
  ) +
  geom_text(
    data = datos_la,
    aes(label = Mes, x = Mes, y = n),
    angle = myAng,
    size = 2,
    fontface = "bold"
  ) +
  coord_polar() +
  scale_fill_manual(values = c("#bfe6b4",
                               "#c2a1c7",
                               "#64b8c0",
                               "#e5a28f")) +
  labs(
    title = "Consecuencias de Accidentes de Tránsito en Chile\ficticios",
    x = "",
    y = "",
    fill = "",
    caption = "@sporella"
  ) +
  theme(
    text = element_text(family = "Gill Sans MT Condensed"),
    legend.position = "bottom",
    axis.text.x = element_blank(),
    panel.grid = element_line(linetype = "dotted", colour = "grey50"),
    plot.background = element_rect(fill = "grey92"),
    legend.background = element_rect(fill = "grey92"),
    panel.background = element_rect(fill = "grey92"),
    panel.spacing = unit(1, "mm"),
    plot.title = element_text(family = "Gill Sans MT Condensed", hjust = 0.5)
  ) +
  guides(fill = guide_legend(
    nrow = 2,
    keywidth = unit(3, "mm"),
    keyheight = unit(3, "mm")
  ))

p