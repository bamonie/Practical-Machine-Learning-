# Quiz 2
#Question 1

##Load the Alzheimer's disease data using the commands:  
library(AppliedPredictiveModeling)
library(caret)
data(AlzheimerDisease)  

## Which of the following commands will create non-overlapping training and test sets with about 50% of the observations assigned to each?

## Ans: 
 adData = data.frame(diagnosis,predictors)  
 testIndex = createDataPartition(diagnosis, p = 0.50,list=FALSE)  
 training = adData[-testIndex,]  
 testing = adData[testIndex,]  
 Make a plot of the outcome (CompressiveStrength) versus the index of the samples. Color by each of the variables in the data set (you may find the cut2() function in the Hmisc package useful for turning continuous covariates into factors). What do you notice in these plots?
   
   #Question 2
 
 ##Load the cement data using the commands:
   
   library(AppliedPredictiveModeling)  
 data(concrete)  
 library(caret)  
 set.seed(1000)  
 inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]  
 training = mixtures[ inTrain,]  
 testing = mixtures[-inTrain,]  
##Make a plot of the outcome (CompressiveStrength) versus the index of the samples. Color by each of the variables in the data set (you may find the cut2() function in the Hmisc package useful for turning continuous covariates into factors). What do you notice in these plots?   
   
library(AppliedPredictiveModeling)
 data(concrete)
 library(caret)
 set.seed(1000)
 inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
 training = mixtures[ inTrain,]
 testing = mixtures[-inTrain,]
 
 library(GGally)
 library(Hmisc)
 ## Using ggpair
 training2 <- training
 #cut CompressiveStrength into 4 levels.  This is the only way to work with colour in ggpair
 training2$CompressiveStrength <- cut2(training2$CompressiveStrength, g=4)
 ggpairs(data = training2, columns = c("FlyAsh","Age","CompressiveStrength"), mapping = ggplot2::aes(colour = CompressiveStrength))
 
 
 ## Ans:
 ##  There is a non-random pattern in the plot of the outcome versus index that does not appear to be perfectly explained by any predictor suggesting a variable may be missing.
 
 ##Question 3
 
 ##Load the cement data using the commands:  
   library(AppliedPredictiveModeling)  
 data(concrete)  
 library(caret)  
 set.seed(1000)  
 inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]  
 training = mixtures[ inTrain,]  
 testing = mixtures[-inTrain,]  
 
 ##Make a histogram and confirm the SuperPlasticizer variable is skewed. 
 ##Normally you might use the log transform to try to make the data more symmetric. Why would that be a poor choice for this variable?
   
 library(AppliedPredictiveModeling)
 data(concrete)
 suppressMessages(library(caret))
 set.seed(1000)
 inTrain = createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
 training = mixtures[ inTrain,]
 testing = mixtures[-inTrain,]
 ##Make a histogram and confirm the SuperPlasticizer variable is skewed. 
 ##Normally you might use the log transform to try to make the data more symmetric. 
 ##Why would that be a poor choice for this variable?
   
   ggplot(data = training, aes(x = Superplasticizer)) + geom_histogram() + theme_bw()
 
 ##Ans:
 ##There are values of zero so when you take the log() transform those values will be -Inf.
 
   
   #Question 4
   
   ##Load the Alzheimer’s disease data using the commands:
     
   library(caret)
   library(AppliedPredictiveModeling)
   set.seed(3433)
   data(AlzheimerDisease)
   adData = data.frame(diagnosis,predictors)
   inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
   training = adData[ inTrain,]
   testing = adData[-inTrain,]
   ##Find all the predictor variables in the training set that begin with IL. 
   ##Perform principal components on these variables with the preProcess() function from the caret package. 
   ##Calculate the number of principal components needed to capture 90% of the variance. How many are there?
   
   trainingIL <- training[,grep("^IL", names(training))]
   procTrain <- preProcess(trainingIL, method = "pca", thresh = 0.9 )
   procTrain
   
   
   #Question 5
   
   ##Load the Alzheimer’s disease data using the commands:
   install.packages('e1071')
   library(e1071 )
     
     library(caret)
   library(AppliedPredictiveModeling)
   set.seed(3433)
   
   data(AlzheimerDisease)
   adData = data.frame(diagnosis,predictors)
   inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
   training = adData[ inTrain,]
   testing = adData[-inTrain,]
   
  ## Create a training data set consisting of only the predictors with variable names beginning with IL and the diagnosis. Build two predictive models, one using the predictors as they are and one using PCA with principal components explaining 80% of the variance in the predictors. Use method=“glm” in the train function.
   
   ## What is the accuracy of each method in the test set? Which is more accurate?
   
   # grep all columns with IL and diagnosis in the traning and testing set
   trainingIL <- training[,grep("^IL|diagnosis", names(training))]
   testingIL <- testing[,grep("^IL|diagnosis", names(testing))]
   
   # non-PCA
   model <- train(diagnosis ~ ., data = trainingIL, method = "glm")
   predict_model <- predict(model, newdata= testingIL)
   matrix_model <- confusionMatrix(predict_model, testingIL$diagnosis)
   matrix_model$overall[1]
   # PCA
   modelPCA <- train(diagnosis ~., data = trainingIL, method = "glm", preProcess = "pca",trControl=trainControl(preProcOptions=list(thresh=0.8)))
   matrix_modelPCA <- confusionMatrix(testingIL$diagnosis, predict(modelPCA, testingIL))
   matrix_modelPCA$overall[1]   

   ### 0.7195122
   
  ## Ans:
     ### Non-PCA Accuracy: 0.65
   
     ###  PCA Accuracy: 0.72   
   