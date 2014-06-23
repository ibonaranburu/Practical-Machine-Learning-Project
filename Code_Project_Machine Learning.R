# Project Machine Learning
library(caret)
library(kernlab)

#reading data
training<-read.csv('pml-training.csv',header = TRUE, sep=",")
test<-read.csv('pml-testing.csv',header = TRUE, sep=",")

#Removing zero covariates
nsv<-nearZeroVar(training)
training <- training[-nsv]
test <- test[-nsv]

training[is.na(training)] <- 0
test[is.na(test)] <- 0

#taking only numeric values
num_features_idx = which(lapply(training,class) %in% c('numeric') )#68

#adding the classe
training <- cbind(training$classe, training[,num_features_idx])
test <- test[,num_features_idx]
names(training)[1] <- 'classe'

#building the prediction model
set.seed(33833)
model3<- randomForest(classe ~ ., training)

#training prediction results
pred_training<-predict(model3,training)
confusionMatrix(pred_training, training$classe)
print(mean(pred_training == training$classe))

#answers
answers<-predict(model3,test)


#writing files

pml_write_files = function(x){
        n = length(x)
        for(i in 1:n){
                filename = paste0("problem_id_",i,".txt")
                write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
        }
}
pml_write_files(as.character(answers))

