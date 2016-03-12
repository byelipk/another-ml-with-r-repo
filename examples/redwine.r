# STEP 1 - Collecting data
wine <- read.csv("./book/Chapter06/redwines.csv")

# STEP 2 - Exploring and preparing data

# There are fewer examples in the red wine dataset
# than in the white wine dataset.
str(wine)

# The data for wine quality seems to be normally
# distributed.
summary(wine$quality)
IQR(wine$quality)
hist(wine$quality)


# STEP 3 - Training a model
library(caret)

wine_partition <- createDataPartition(
  wine$quality,
  p=0.75,
  list=FALSE
)
wine_train <- wine[wine_partition, ]
wine_test  <- wine[-wine_partition, ]

nrow(wine_train) / (nrow(wine_train) + nrow(wine_test)) # 0.7501021
nrow(wine_test) / (nrow(wine_train) + nrow(wine_test))  # 0.2498979


library(rpart)
library(rpart.plot)

wine_model <- rpart(quality ~ ., data = wine)


# STEP 4 - Evaluating the model

# Like white wine, alcohol is the most important
# feature for determining wine quality. Sulphates
# are also an important determining factor.
wine_model

rpart.plot(
  wine_model,
  digits = 4,
  fallen.leaves = TRUE,
  type = 3,
  extra = 101)

wine_pred <- predict(wine_model, wine_test)

# Note how the predictions fall within a much narrower
# range than the actual values:
summary(wine_pred)
summary(wine_test$quality)

# There seems to already be a strong correlation.
cor(wine_pred, wine_test$quality) # 0.620322

MAE <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

MAE(wine_pred, wine_test$quality) # 0.4917325
# This result means that on average the difference
# between our model's prediciton and the actual
# quality score is 0.49 points. Pretty good for
# a first try!
#

# Are we sure we're not just predicting mean values?
mean(wine_train$quality)     # 5.636667
MAE(5.63, wine_test$quality) # 0.6816792

# Our model comes closer on average to the actual
# quality score than if we were only predicting the
# mean value!


# STEP 5 - Improving the model

library(RWeka)

wine_m5p <- M5P(quality ~ ., data = wine_train)
wine_m5p_pred <- predict(wine_m5p, wine_test)

# We've broadened the scope of our model. Our max
# predicted quality score (7.3) is closer
# to the actual max quality rating (8.0).
summary(wine_m5p_pred)
summary(wine_test$quality)

cor(wine_m5p_pred, wine_test$quality) # 0.5823815
MAE(wine_m5p_pred, wine_test$quality) # 0.505855

# Our mean absolute error has actually increased and
# the correlation has decreased.
