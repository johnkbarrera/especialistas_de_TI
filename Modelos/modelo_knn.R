#Para knn se utiliza la liberia class
library(class)
#Leer la base de datos dbRcc
datos<-read.csv("C:/Users/josese/Documents/modelo/dbRcc.csv", sep = "|")
#semilla
set.seed(123456)
idTrain<-sample(1:435222,304655)
#Si Vencio es igual 1 quiere decir que han dejando de pagar el producto, y si es 0 pagaron el producto
Vencio<-function(x){
  aux<-sum(sum(x=="VENCIDO")||sum(x=="REESTRUCTURADO")||sum(x=="REFINANCIADO")||sum(x=="JUDICIAL"))
  if(aux>0){
    r<-1
  }else{
    r<-0
  }
  return(r)
}
ConcatUnique<-function(x){
  return(length(unique(x)))
}
#Construccion de las nuevas variables
count_subproducto<-tapply(datos$subproducto, datos$sbs_customer_id, ConcatUnique)
count_producto<-tapply(datos$producto, datos$sbs_customer_id, ConcatUnique)
mean_days_default_payment<-tapply(datos$num_days_default_payment_number, datos$sbs_customer_id, mean)
balance_amount<-tapply(datos$balance_amount , datos$sbs_customer_id, mean)
status<-tapply(datos$situacion_credito , datos$sbs_customer_id, Vencio)

#Construir de modelo 
#Vincular los vectores
NewD<-as.data.frame(cbind(status,mean_days_default_payment,balance_amount,count_producto,count_subproducto))
NewD$status<-as.factor(NewD$status)
#Definir una tabla de entrenamiento y prueba para el modelo y para verificar su calidad predictiva
#La matriz de entrenamiento
DataTrain<-NewD[idTrain,]
#Matriz de preba
DataTest<-NewD[-idTrain,]

#Para analizar el modelo se construye la matriz de confusion

knn.pred =knn(DataTrain[,c(-1)],DataTest[,c(-1)],NewD$status[idTrain],k=3)
table(knn.pred,DataTest$status) 

