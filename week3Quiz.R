# Quiz 3


##Question 1

###For this quiz we will be using several R packages. R package versions change over time, the right answers have been checked using the following versions of the packages.

###AppliedPredictiveModeling: v1.1.6

###caret: v6.0.47

###ElemStatLearn: v2012.04-0

###pgmm: v1.1

###rpart: v4.1.8

###If you aren't using these versions of the packages, your answers may not exactly match the right answer, but hopefully should be close.

###Load the cell segmentation data from the AppliedPredictiveModeling package using the commands:

### 1. Subset the data to a training set and testing set based on the Case variable in the data set.

### 2. Set the seed to 125 and fit a CART model with the rpart method using all predictor variables and default caret settings.

### 3. In the final model what would be the final model prediction for cases with the following variable values:

###  a. TotalIntench2 = 23,000; FiberWidthCh1 = 10; PerimStatusCh1=2

###  b. TotalIntench2 = 50,000; FiberWidthCh1 = 10;VarIntenCh4 = 100

###  c. TotalIntench2 = 57,000; FiberWidthCh1 = 8;VarIntenCh4 = 100

###  d. FiberWidthCh1 = 8;VarIntenCh4 = 100; PerimStatusCh1=2

# 1. Subset the data to a training set and testing set based on the Case variable in the data set. 

##Load the cell segmentation data from the AppliedPredictiveModeling package using the commands:
  
  library(AppliedPredictiveModeling)
data(segmentationOriginal)
suppressMessages(library(caret))

inTrain <- createDataPartition(y = segmentationOriginal$Case, p = 0.6, 
                               list = FALSE) # 60% training
training <- segmentationOriginal[inTrain, ]
testing <- segmentationOriginal[-inTrain, ]
# 2. Set the seed to 125 and fit a CART model with the rpart method using all predictor variables and default caret settings. (The outcome class is contained in a factor variable called Class with levels "PS" for poorly segmented and "WS" for well segmented.)
set.seed(125)
modFit <- train(Class ~ ., method = "rpart", data = training)

## Loading required package: rpart

# 3. 
modFit$finalModel


suppressMessages(library(rattle))
library(rpart.plot)
rattle::fancyRpartPlot(modFit$finalModel)


###Based on the decision tree, the model prediction is

###PS

###WS

###PS

###Not possible to predict

####Question 2

### If K is small in a K-fold cross validation is the bias in the estimate of out-of-sample (test set) accuracy smaller or bigger? If K is small is the variance in the estimate of out-of-sample (test set) accuracy smaller or bigger. Is K large or small in leave one out cross validation?
  
  ###1, The bias is smaller and the variance is smaller. Under leave one out cross validation K is equal to one.

###2, The bias is larger and the variance is smaller. Under leave one out cross validation K is equal to the sample size.

###3, The bias is larger and the variance is smaller. Under leave one out cross validation K is equal to two.

###4, The bias is smaller and the variance is bigger. Under leave one out cross validation K is equal to one.

## Quetin 3
###Load the olive oil data using the commands:
 
install.packages('pgmm')
library(pgmm)
data(olive)
olive = olive[,-1]
  
 ### (NOTE: If you have trouble installing the pgmm package, you can download the -code-olive-/code- dataset here: olive_data.zip. After unzipping the archive, you can load the file using the -code-load()-/code- function in R.)

###These data contain information on 572 different Italian olive oils from multiple regions in Italy. Fit a classification tree where Area is the outcome variable. Then predict the value of area for the following data frame using the tree command with all defaults

newdata = as.data.frame(t(colMeans(olive)))
###What is the resulting prediction? Is the resulting prediction strange? Why or why not?
str(olive) 

table(olive$Area)

olive_rpart <- train(Area~.,data=olive,method="rpart")  
fancyRpartPlot(olive_rpart$finalModel)
predict(olive_rpart,newdata=newdata)


## Question 4

### Load the South Africa Heart Disease Data and 
###create training and test sets with the following code:
install.packages('ElemStatLearn')
library(ElemStatLearn)
data(SAheart)
set.seed(8484)
train = sample(1:dim(SAheart)[1],size=dim(SAheart)[1]/2,replace=F)
trainSA = SAheart[train,]
testSA = SAheart[-train,]
  
  ###Then set the seed to 13234 and fit a logistic regression model (method="glm", be sure to specify family="binomial") with Coronary Heart Disease (chd) 
###as the outcome and age at onset, current alcohol consumption, obesity levels, cumulative tabacco, type-A behavior, and low density lipoprotein cholesterol as predictors.
###Calculate the misclassification rate for your model using this function and a prediction on the "response" scale:

missClass = function(values,prediction){sum(((prediction > 0.5)*1) != values)/length(values)}

##Solution
set.seed(13234)
modelSA <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl, 
                 data = trainSA, method = "glm", family = "binomial")
missClass(testSA$chd, predict(modelSA, newdata = testSA))
missClass(trainSA$chd, predict(modelSA, newdata = trainSA))
###Hence, the misclassification rate on the training set is 0.27 and the misclassification rate on the test set is 0.31.

##Question 5

### Load the vowel.train and vowel.test data sets:
library(ElemStatLearn)
data(vowel.train)
data(vowel.test)
  
###Set the variable y to be a factor variable in both the training and test set. Then set the seed to 33833. Fit a random forest predictor relating the factor variable y to the remaining variables. Read about variable importance in random forests here: http://www.stat.berkeley.edu/~breiman/RandomForests/cc_home.htm#ooberr The caret package uses by default the Gini importance.

###Calculate the variable importance using the varImp function in the caret package. What is the order of variable importance?
  
 ### [NOTE: Use randomForest() specifically, not caret, as there's been some issues reported with that approach. 11/27/2019]

## Solution

  
  vowel.train$y <- as.factor(vowel.train$y)
vowel.test$y <- as.factor(vowel.test$y)
set.seed(33833)
install.packages('randomForest')
library(randomForest)

modvowel <- randomForest(y ~ ., data = vowel.train)
order(varImp(modvowel), decreasing = T)
###Therefore, the order of the variables is: x.2, x.1, x.5, x.6, x.8, x.4, x.9, x.3, x.7, x.10