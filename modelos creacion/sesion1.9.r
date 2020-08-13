
---
  title: "Construir Modelos - Part 1"
output: html_notebook
---
  ## Trainer: Ruth Chirinos
  Apuntes curso R para Ciencia de Datos, May 2020

# Modelos: Conceptos Básicos
```{r}
rm(list = ls())
library(tidyverse)
library(modelr)
options(na.action = na.warn)
```

## 23.2 Un modelo simple
### Entendamos cómo es el proceso de construcción de un
Veamos los Datos
```{r}
sim1
```

Identificamos patrones, nos ayudamos con las gráficas ggplot.

```{r}
ggplot(sim1, aes(x, y)) +
  geom_point()
```
Con la identificación de patrones , vemos que los puntos se asemejan a una regresión lineal. Y = a1 + a2*X
Comencemos por tener una idea de cómo son los modelos de esa familia generando aleatoriamente unos pocos y superponiéndolos sobre los datos. Para este caso simple, podemos usar geom_abline().

```{r}
modelos <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)
#
modelos
```

geom_abline toma una pendiente e intercepto (u ordenada al origen) como parámetros, este gráfico nos ayudará a revisar el modelo con los datos.

```{r}
ggplot(sim1, aes(x, y)) +
  geom_abline(aes(intercept = a1, slope = a2), data = modelos, alpha = 1/4) +
  geom_point()
```
Hay 250 modelos en el gráfico, ¡pero muchos son realmente malos! ...Un buen modelo está “cerca” de los datos. 
Necesitamos una manera de cuantificar la distancia entre los datos y un modelo. 
Para calcular esta distancia, primero transformamos nuestra familia de modelos en una función de R.
Esta función toma los parámetros del modelo y los datos como inputs, y retorna el valor predicho por el modelo como output:
  ```{r}
model1 <- function(a, data) {
  a[1] + data$x * a[2]
}
model1(c(7, 1.5), sim1)
```

Para tener un único valor usamos la “raíz del error cuadrático medio” (del inglés root-mean-squared deviation). Calculamos la diferencia entre los valores reales y los predichos, los elevamos al cuadrado, luego se promedian y tomamos la raíz cuadrada. 

```{r}
measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff^2))
}
measure_distance(c(7, 1.5), sim1)
```

purrr::map() is a function for applying a function to each element of a list. 
Ahora podemos usar purrr para calcular la distancia de todos los modelos definidos anteriormente. Necesitamos una función auxiliar debido a que nuestra función de distancia espera que el modelo sea un vector numérico de longitud 2.
```{r}
sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}
modelos <- modelos %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
modelos
```
Vamos a superponer los mejores 10 modelos en los datos:
  
  ```{r}
ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, colour = "red") +
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist),
    data = filter(modelos, rank(dist) <= 10)
  )
```
### Utilizando optim()
También podemos pensar en estos modelos como observaciones y visualizar un diagrama de dispersión (o scatterplot, en inglés) de a1 versus a2, nuevamente coloreado usando -dist
```{r}
ggplot(modelos, aes(a1, a2)) +
  geom_point(data = filter(modelos, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist))
```

### Búsqueda en cuadrícula
En lugar de probar con múltples modelos aleatorios, se puede sistematizar y generar una cuadrícula de puntos igualmente espaciados (esto se llama búsqueda en cuadrícula)
```{r}
grid <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
) %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
#
grid
#
grid %>%
  ggplot(aes(a1, a2)) +
  geom_point(data = filter(grid, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist))
```
```{r}
ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, colour = "grey30") +
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist),
    data = filter(grid, rank(dist) <= 10)
  )
```

### Búsqueda de Newton-Raphson
Existe una forma mejor de resolver el problema: una herramienta de minimización llamada búsqueda de Newton-Raphson. La intuición detrás de Newton-Raphson es bastante simple: tomas un punto de partida y buscas la pendiente más fuerte en torno a ese punto. Puedes bajar por esa pendiente un poco, para luego repetir el proceso varias veces, hasta que no se puede descender más. En R, esto se puede hacer con la función optim():
  ```{r}
best <- optim(c(0, 0), measure_distance, data = sim1)
best$par
#> [1] 4.22 2.05
ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, colour = "grey30") +
  geom_abline(intercept = best$par[1], slope = best$par[2])
```

### Modelos Lineales
Un modelo lineal es de la forma y = a_1 + a_2 * x_1 + a_3 * x_2 + ... + a_n * x_(n+1). R tiene la función lm()
Notación de Formulas : https://faculty.chicagobooth.edu/richard.hahn/teaching/formulanotation.pdf

```{r}
sim1_mod <- lm(y ~ x, data = sim1)
sim1_mod
coef(sim1_mod)
```

Lo graficamos y obtenemos el mismo resultado con optim()

```{r}
best <- optim(c(0, 0), measure_distance, data = sim1)
best$par
#> [1] 4.22 2.05
ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, colour = "grey30") +
  geom_abline(intercept = 4.221, slope = 2.052)  #<-- Reemplazamos los coeficientes 
```
## 23.3 Visualizando modelos
Vamos a enfocarnos en entender un modelo mirando las predicciones que genera. Esto tiene una gran ventaja: cada tipo de modelo predictivo realiza predicciones (¿qué otra podría realizar?) de modo que podemos usar el mismo conjunto de técnicas para entender cualquier tipo de modelo predictivo.

### 23.3.1 Predicciones

data_grid, usa un data frame y, por cada argumento adicional, encuentra las variables únicas y luego genera todas las combinaciones
```{r}
grid <- sim1 %>%
  data_grid(x)
grid
```

Agregamos predicciones:
  ```{r}
grid <- grid %>%
  add_predictions(sim1_mod)  # where sim1_mod <- lm(y ~ x, data = sim1)
grid
```
Ahora graficamos la predicción:
  ```{r}
ggplot(sim1, aes(x,y)) +
  geom_point(aes(x,y)) +
  geom_line (aes(x,y = pred), data = grid, colour = "red", size = 1)
```
### 23.3.2 Residuos
Las predicciones te informan de los patrones que el modelo captura y los residuos te dicen lo que el modelo ignora.

Agregamos los residuos a los datos con add_residuals() con el data frame original sim1

```{r}
sim1 <- sim1 %>%
  add_residuals(sim1_mod) # where sim1_mod <- lm(y ~ x, data = sim1)
sim1
```


Entendamos cómo se propagan los residuos graficándolo:
  ```{r}
ggplot(sim1, aes(resid)) +
  geom_freqpoly(binwidth = 0.5, color ='blue')
```
Esto ayuda a calibrar la calidad del modelo: ¿qué tan lejos se encuentran las predicciones de los valores observados? Nota que el promedio del residuo es siempre cero.

Si el modelo ajustado a los datos era correcto, los residuos se aproximarían a los errores aleatorios que hacen que la relación entre las variables explicativas y la variable de respuesta sea una relación estadística. Por lo tanto, si los residuos parecen comportarse de forma aleatoria, sugiere que el modelo se ajusta bien a los datos. 

A menudo vas a querer crear gráficos usando los residuos en lugar del predictor original
```{r}
ggplot(sim1, aes(x, resid)) +
  geom_ref_line(h = 0) +
  geom_point()
```
### 23.4 Fórmulas y familias de modelos
Se usa la “notación de Wilkinson-Rogers”.
Ya habrás visto una conversión simple y ~ x que se convierte en y = a_1 + a_2 * x. Si quieres ver lo que hace R, puedes usar la función model_matrix()
```{r}
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)
model_matrix(df, y ~ x1)
```
La matriz del modelo crece de manera nada sorprendente si incluyes más variables al modelo:
  ```{r}
model_matrix(df, y ~ x1 + x2)
```
### 23.4.1 Variables Categóricas
Generar una función a partir de una fórmula es directo cuando el predictor es una variable continua, pero las cosas son más complicadas cuando el predictor es una variable categórica. Imagina que tienes una fórmula como y ~ sexo, donde el sexo puede ser hombre o mujer. No tiene sentido convertir a una fórmula del tipo y = x_0 + x_1 * sexo debido a que sexo no es un número - ¡no se puede multiplicar! En su lugar, lo que R hace es convertir a y = x_0 + x_1 * sexo_hombre donde sexo_hombre tiene valor 1 si sexo corresponde a hombre y cero a mujer:
  ```{r}
df <- tribble(
  ~genero, ~respuesta,
  "masculino", 1,
  "femenino", 2,
  "masculino", 1
)
model_matrix(df, respuesta ~ genero)
```
Veamos con un nuevo Dataset: sim2
```{r}
sim2
ggplot(sim2) +
  geom_point(aes(x, y))
```

Podemos ajustar un modelo a esto y generar predicciones:
  ```{r}
sim2
#
mod2 <- lm(y ~ x, data = sim2)
#
mod2
#
grid <- sim2 %>%
  data_grid(x) %>%
  add_predictions(mod2)
#
grid
```
Un modelo con una variable x categórica va a predecir el valor medio para cada categoría. (¿Por qué? porque la media minimiza la raíz de la distancia media cuadrática.)
```{r}
ggplot(sim2, aes(x)) +
  geom_point(aes(y = y)) +
  geom_point(data = grid, aes(y = pred), colour = "red", size = 4)
```


### 23.4.2 Interacciones (continuas y categóricas)
Veamos un nuevo data frame "sim3":
  ```{r}
sim3
#
ggplot(sim3, aes(x1, y)) +
  geom_point(aes(colour = x2))
```

Nuestros modelos:
  ```{r}
mod1 <- lm(y ~ x1 + x2, data = sim3)  # (+) Va a estimar cada efecto independientemente de los demás
#
mod1
#
mod2 <- lm(y ~ x1 * x2, data = sim3)   # (*) Se traduce a : y = a_0 + a_1 * x_1 + a_2 * x_2 + a_12 * x_1 * x_2
#
mod2
```


Combinando las variables predictoras con gather_predictions:
  ```{r}
grid <- sim3 %>%
  data_grid(x1, x2) %>%
  gather_predictions(mod1, mod2)
#
grid
```
Visualizamos ambos modelos utilizando un separador de facetas. ¿Qué observamos?
  ```{r}
ggplot(sim3, aes(x1, y, colour = x2)) +
  geom_point() +
  geom_line(data = grid, aes(y = pred)) +
  facet_wrap(~model)
```

¿Cuál será el mejor modelo?
  ```{r}
sim3 <- sim3 %>%
  gather_residuals(mod1, mod2)
#
sim3
#
ggplot(sim3, aes(x1, resid, colour = x2)) +
  geom_point() +
  facet_grid(model ~ x2)
```
El modelo 2 parece tener residuos aleatorios.

### 23.4.3 Interacciones (dos variables continuas)

Procedemos de igual modo que el anterior:
  ```{r}
sim4
#
mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)
#
grid <- sim4 %>%
  data_grid(
    x1 = seq_range(x1, 5),
    x2 = seq_range(x2, 5)
  ) %>%
  gather_predictions(mod1, mod2)
#
grid
```
#### Conociendo un poco de se_range()
sec_range genera una secuencia sobre el rango de un vector.
##### pretty = TRUE
```{r}
seq_range(c(0.0123, 0.923423), n = 5)
seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE)
```

##### trim
```{r}
x1 <- rcauchy(100)  # Distribución de Cauchy con número de observaciones
seq_range(x1, n = 5)
#> [1] -115.9  -83.5  -51.2  -18.8   13.5
seq_range(x1, n = 5, trim = 0.10)
#> [1] -13.84  -8.71  -3.58   1.55   6.68
seq_range(x1, n = 5, trim = 0.25)
#> [1] -2.1735 -1.0594  0.0547  1.1687  2.2828
seq_range(x1, n = 5, trim = 0.50)
#> [1] -0.725 -0.268  0.189  0.647  1.104
```
##### expand
```{r}
x2 <- c(0, 1)
seq_range(x2, n = 5)
#> [1] 0.00 0.25 0.50 0.75 1.00
seq_range(x2, n = 5, expand = 0.10)
#> [1] -0.050  0.225  0.500  0.775  1.050
seq_range(x2, n = 5, expand = 0.25)
#> [1] -0.125  0.188  0.500  0.812  1.125
seq_range(x2, n = 5, expand = 0.50)
#> [1] -0.250  0.125  0.500  0.875  1.250
```
### 23.4.3 Interacciones (dos variables continuas)  (Continuación)
Tenemos dos predictores continuos, por lo que te imaginarás el modelo como una superficie 3d. Podemos mostrar esto usando geom_tile()
```{r}
ggplot(grid, aes(x1, x2)) +
  geom_tile(aes(fill = pred)) +
  facet_wrap(~model)
```
En lugar de mirar la superficie desde arriba, podríamos mirarla desde los costados, mostrando múltiples cortes:
  ```{r}
ggplot(grid, aes(x1, pred, colour = x2, group = x2)) +
  geom_line() +
  facet_wrap(~model)
#
ggplot(grid, aes(x2, pred, colour = x1, group = x1)) +
  geom_line() +
  facet_wrap(~model)
```
### 23.4.4 Transformaciones
```{r}
df <- tribble(
  ~y, ~x,
  1, 1,
  2, 2,
  3, 3
)
model_matrix(df, y ~ x^2 + x)
model_matrix(df, y ~ I(x^2) + x)
```

```{r}
model_matrix(df, y ~ poly(x, 2))
```

```{r}
library(splines)
model_matrix(df, y ~ ns(x, 2))
```

```{r}
sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)
#
ggplot(sim5, aes(x, y)) +
  geom_point()
```
```{r}
mod1 <- lm(y ~ splines::ns(x, 1), data = sim5)
mod2 <- lm(y ~ splines::ns(x, 2), data = sim5)
mod3 <- lm(y ~ splines::ns(x, 3), data = sim5)
mod4 <- lm(y ~ splines::ns(x, 4), data = sim5)
mod5 <- lm(y ~ splines::ns(x, 5), data = sim5)
grid <- sim5 %>%
  data_grid(x = seq_range(x, n = 50, expand = 0.1)) %>%
  gather_predictions(mod1, mod2, mod3, mod4, mod5, .pred = "y")
ggplot(sim5, aes(x, y)) +
  geom_point() +
  geom_line(data = grid, colour = "red") +
  facet_wrap(~model)
```

## 23.5 Valores faltantes
```{r}
df <- tribble(
  ~x, ~y,
  1, 2.2,
  2, NA,
  3, 3.5,
  4, 8.3,
  NA, 10
)
mod <- lm(y ~ x, data = df)
```
```{r}
mod <- lm(y ~ x, data = df, na.action = na.exclude)
```

```{r}
nobs(mod)
``