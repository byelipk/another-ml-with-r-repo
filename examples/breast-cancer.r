###################################
# COLLECTING THE DATA
###################################
wbcd <- read.csv("../book/Chapter03/wisc_bc_data.csv")

###################################
# EXPLORING AND PREPARING THE DATA
###################################

# Remove the id column
wbcd$id <- NULL

# Let's look into the diagnosis feature
# because it's what we want to predict
table(wbcd$diagnosis)

# Many machine learning classifiers require
# the target feature be coded as a factor.
wbcd$diagnosis <- factor(
  wbcd$diagnosis,
  levels = c("B", "M"),
  labels = c("Benign", "Malignant")
)

round(
  prop.table(
    table(wbcd$diagnosis)) * 100, digits=1)


summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])

# Here's our min/max normalize function
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# Apply the normailze function to all features except
# the diagnosis feature. All values now range from
# 0 to 1.
wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))


# Now it is time for a little data extraction. Using
# the `wbcd_n` data set, we're going to partition it
# into a training and test set. We'll experiment
# partitioning the data set using two different methods.
# First, we'll partition the data using R's [column, row]
# syntax for accessing data from data frames.
wbcd_train <- wbcd_n[1:469, ]
wbcd_test  <- wbcd_n[470:569, ]

# When we normalized our data we excluded the target variable,
# diagnosis. We'll need to store those class labels
# in vector factors, split between training and test datasets.
wbcd_train_labels <- wbcd[1:469,1]
wbcd_test_labels  <- wbcd[470:569,1]

# Here we're going to use the createDataPartition()
# function from the caret library to create a 70/30
# split of the data. Note that we're partitioning
# the data along the diagnosis feature because that
# is the feature we're trying to predict.
library(caret)
wbcd_caret <- wbcd_n
wbcd_caret$diagnosis <- wbcd$diagnosis
inTrainRows <- createDataPartition(
  wbcd_caret$diagnosis,
  p=0.70,
  list=FALSE
)
trainDataFiltered <- wbcd_caret[inTrainRows,]
testDataFiltered  <- wbcd_caret[-inTrainRows,]
trainDataLabels   <- trainDataFiltered$diagnosis
testDataLabels    <- testDataFiltered$diagnosis

###################################
# TRAINING A MODEL
###################################
library(class)

# The knn() function returns a factor vector
# of predicted labels for each of the examples
# in the test dataset.
wbcd_test_pred <- knn(
  train = wbcd_train,
  test  = wbcd_test,
  cl    = wbcd_train_labels,
  k     = 21 # odd number eliminates a tie
)

predictorCaret <- knn(
  train = trainDataFiltered[1:30],
  test  = testDataFiltered[1:30],
  cl    = trainDataLabels,
  k     = 21
)


###################################
# EVALUATING A MODEL
###################################
#
# The next step is to evaluate how well the predicted
# labels for our test data match up with the known
# test labels.
library(gmodels)

CrossTable(
  x = wbcd_test_labels,
  y = wbcd_test_pred,
  prop.chisq=FALSE
)

CrossTable(
  x = testDataLabels,
  y = predictorCaret,
  prop.chisq = FALSE
)

###################################
# IMPROVING MODEL PERFORMANCE
###################################

wbcd_z <- as.data.frame(scale(wbcd[-1]))
wbcd_train <- wbcd_z[1:469, ]
wbcd_test  <- wbcd_z[470:569, ]
wbcd_train_labels <- wbcd[1:469,1]
wbcd_test_labels  <- wbcd[470:569,1]

wbcd_test_pred <- knn(
  train = wbcd_train,
  test  = wbcd_test,
  cl    = wbcd_train_labels,
  k     = 21 # odd number eliminates a tie
)

CrossTable(
  x = wbcd_test_labels,
  y = wbcd_test_pred,
  prop.chisq=FALSE
)

# Unfortunately our accuracy dropped from 98% to 95%
# What about alternative values of `k`?
