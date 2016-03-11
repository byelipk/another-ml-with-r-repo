wine <- read.csv("./book/Chapter06/whitewines.csv")


# Decision trees can handle all kinds of data which
# means we do not have to normalize the features.
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
wine_n <- as.data.frame(lapply(wine[1:11], normalize))

# Let's check our data for pecularities such as a
# bimodal distribution or outliers.
hist(wine$quality)
summary(wine)


# Split data into training and testing
library(caret)

# How to create a 75% split between the data:
wine_partition <- createDataPartition(
  wine$quality,
  p=0.75,
  list=FALSE
)
wine_train <- wine[wine_partition, ]
wine_test  <- wine[-wine_partition, ]

nrow(wine_train) / (nrow(wine_train) + nrow(wine_test)) # 0.7501021
nrow(wine_test) / (nrow(wine_train) + nrow(wine_test))  # 0.2498979

# Since the data is already sorted in random order
# we can also partition it this way:
#
# First we find where 75% is:
print(nrow(wine) * 0.75)
wine_train <- wine[1:3673,]
wine_test  <- wine[3674:4898,]


# TRAINING THE MODEL
library(rpart)

wine_model <- rpart(quality ~ ., data = wine)

library(rpart.plot)

rpart.plot(
  wine_model,
  digits = 4,
  fallen.leaves = TRUE,
  type = 3,
  extra = 101)


# EVALUATING MODEL PERFORMANCE
wine_pred <- predict(wine_model, wine_test)

# Note how the predictions fall within a much narrower
# range than the actual values:
summary(wine_pred)
summary(wine_test$quality)

# These results suggest the model is not correctly identifying
# the extreme values, the best and worst wines. It's
# predicting each wine to be about average.

cor(wine_pred, wine_test$quality) # 0.5358789
# A correlation of 0.54 is good, but it only measures
# how strongly the predictors are related to the
# true values. It is not a measure of how far off the
# predictions were from the true values. We can also
# check performance with the mean absolute error.

# The mean absolute error is a measure of how far off,
# on average, the prediction was from the true value.
MAE <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

MAE(wine_pred, wine_test$quality) # 0.603642
# This result means that on average the difference
# between our model's prediciton and the actual
# quality score is 0.60 points. Not bad.
#
# But remember, most wines were rated as average, receiving
# a score of 5 or 6. Check the histogram for details.
# That means a classifier that only predicted the mean value
# would do very well.

# The mean quality rating for our training data is:
mean(wine_train$quality) # 5.871495

# If we predicted a value of 5.87 for every wine sample,
# then we would have a mean error of:
MAE(5.87, wine_test$quality) # 0.6742449

# So our model does come closer on average to the true
# quality score, but not by much.


# IMPROVING MODEL PERFORMANCE
library(RWeka)

wine_m5p <- M5P(quality ~ ., data = wine_train)
wine_m5p_pred <- predict(wine_m5p, wine_test)

# It seems we've broadened the range of values
# we are able to predict. But we're still don't
# reach out to the extremes on both ends.
summary(wine_m5p_pred)
summary(wine_test$quality)

# If we examine the model we see once again
# that alcohol is the most important factor
# of quality followed by volatil acidity and
# free sulfur dioxide.

# The correlation is significantly higher: 0.6231615
cor(wine_m5p_pred, wine_test$quality)

MAE(wine_m5p_pred, wine_test$quality) # 0.5502939
# Our mean absolute error is reduced, meaning the
# difference between our predictions and the true
# values has gotten smaller.
#
