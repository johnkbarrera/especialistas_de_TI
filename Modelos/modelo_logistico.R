library("readr")
#Cargamos los datos
dataRcc<-read_delim("C:/Users/lenovo/Documents/Hackathon BBVA/dbRcc.csv",
                  delim = "|",col_names = TRUE)
#dataUni<-read_delim("C:/Users/lenovo/Documents/Hackathon BBVA/dbUniverso.csv",delim = "|",
#                  col_names = TRUE)

#Definimos algunas funciones para agrupar las obervaciones por sbs_customer_id

# Esta funcion calculará los productos diferentes que tiene una PyME
ConcatUnique<-function(x){
  return(length(unique(x)))
}

## Esta funcion indicará con un 1 si la PyME ha estaod en situacion de no pagar y 0 de otro modo
Vencio<-function(x){
  aux<-sum(sum(x=="VENCIDO")||sum(x=="REESTRUCTURADO")||sum(x=="REFINANCIADO")||sum(x=="JUDICIAL"))
  if(aux>0){
    r<-1
  }else{
    r<-0
  }
  return(r)
}

#Definimos nuestras nuevas variables
count_producto<-tapply(dataRcc$producto , dataRcc$sbs_customer_id, ConcatUnique)
mean_days_default_payment<-tapply(dataRcc$num_days_default_payment_number, dataRcc$sbs_customer_id, mean)
balance_amount<-tapply(dataRcc$balance_amount , dataRcc$sbs_customer_id, mean)
status<-tapply(dataRcc$situacion_credito , dataRcc$sbs_customer_id, Vencio)

#Fijamos una semilla para futuras replicas
set.seed(123456)

#Definimos un id para partir el conjunto de datos en Train y Test
idTrain<-sample(1:435222,304655)

#Definimos  nuestra nueva base
NewD<-as.data.frame(cbind(status,mean_days_default_payment,balance_amount,
            count_producto))

#Definimos los conjuntos de datos en Train y Test, haaciendo status de tipo factor además.
NewD$status<-as.factor(NewD$status)
DataTrain<-NewD[idTrain,]
DataTest<-NewD[-idTrain,]

#Ajustamos el modelo logístico
mod<-glm(status~balance_amount+mean_days_default_payment+
           count_producto,data = DataTrain,family = binomial)

#Observamos los coeficientes estimados y algunas otras estadisticas del modelo
summary(mod)

#Validamos que tan bien predice con el conjunto de datos Test
pred<-predict(mod,newdata = DataTest ,type = "response")

#Definimos una "regla de dedo", si la empresa está por arriba del 80% de probabilidad
# entonces es probable que deje de pagar en algun moento

y<-rep(NA,length(DataTest$status))
y[pred>0.8]<-1
y[pred<0.8]<-0

#Si la diferencia de "y" con "pred" es 0 entonces la prediccion es correcta por lo que
# la siguiente linea calcula el porcentaje que no predijo bien, 
sum(as.numeric(DataTest$status)-y)/435222

#El reultado anterior nos da 0.3118592 por lo que podriamos indicar que
#con nuestra "regla de dedo" estamos acertando un 68.8 %