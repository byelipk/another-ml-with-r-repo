# STEP 1: Collecting data
concrete <- read.csv("./book/Chapter07/concrete.csv")


# STEP 2: Exploring and preparing the data
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# Apply the normailze function to all features except
# the diagnosis feature. All values now range from
# 0 to 1.
concrete_norm <- as.data.frame(lapply(concrete, normalize))


library(caret)

# How to create a 75% split between the data:
concrete_partition <- createDataPartition(
  concrete_norm$strength,
  p=0.75,
  list=FALSE
)

concrete_train <- concrete_norm[concrete_partition, ]
concrete_test  <- concrete_norm[-concrete_partition, ]

nrow(concrete_train) / (nrow(concrete_train) + nrow(concrete_test)) # 0.75
nrow(concrete_test) / (nrow(concrete_train) + nrow(concrete_test))  # 0.25


# STEP 3: Training the model
library(neuralnet)

m <- neuralnet(
  strength ~ cement + slag + ash + water +
    superplastic + coarseagg + fineagg + age,
  data=concrete_train)

plot(m)

# STEP 4: Evaluating model performance

m_results <- compute(m, concrete_test[1:8])

predicted_strength <- m_results$net.result

cor(predicted_strength, concrete_test$strength) # 0.82
# Correlations close to 1 indicate a strong linear relationship
# between to variables. Therefore, a correlation of 0.82
# indicates a strong relationship. Our model is doing
# very well given only 1 hidden layer.

# STEP 5: Improving the model

m2 <- neuralnet(
  strength ~ cement + slag + ash + water + superplastic + coarseagg + fineagg + age,
  data = concrete_train,
  algorithm = "rprop+",
  hidden = c(5))

plot(m2)
# Notice that the sum of squared errors (SSE) has
# been reduced from over 5 to 1.7.

m2_results <- compute(m2, concrete_test[1:8])
predicted_strength2 <- m2_results$net.result
cor(predicted_strength2, concrete_test$strength) # 0.94
# By increasing the number of hidden layers to 5 we've
# improved the correlation of our model to 0.94.
