
s <-datos::diamantes


View(s)

library(ggplot2)
ggplot(s, aes(x = claridad, y = tabla, col = x, group = x)) + geom_point() + geom_line() + coord_polar()



Q <-datos::comunes 


n<-10
muestramala<- sample(1:nrow(Q), size = n,replace = FALSE)

X<-Q[muestramala,]

ggplot(data =X, aes(x = fabricante, fill = modelo)) + geom_bar(colour= "black", position = "dodge" , size = 0.3 ) +  coord_polar()

M<-datos::frutas
View(M)

ggplot(data =J, aes(x = pais, fill = casos)) + geom_bar(colour= "black", position = "dodge" , size = 0.3 ) +  coord_polar()


h1n1 <- readr::read_csv("https://raw.githubusercontent.com/cienciadedatos/datos-de-miercoles/master/datos/2020/2020-03-11/h1n1.csv")
OY <- h1n1
Q <-datos::comunes 


n<-20
muestramala<- sample(1:nrow(OY), size = n,replace = FALSE)
J<-OY[muestramala,]
View(J)
s< as.data.frame(s)
ggplot(data = s, aes(x = corte, fill = color)) + geom_bar(colour= "black", position = "dodge" , size = 0.3 ) +  coord_polar()

write.table(s,file = "/Users/limco/OneDrive/Documents/Rproject/colo.csv" ,row.names = F , sep = ",")

rlang::last_error()

   getwd()
   
  Fi <- read.csv2("Libro2.csv")
  View(Fi)
  head(Fi)
  ggplot(data = Fi, aes(x = Estado.Civil, fill = Número.de.cónyuges)) + geom_bar(colour= "black", position = "dodge" , size = 0.3 ) +  coord_polar()
  
  
  