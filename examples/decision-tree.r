# STEP 1: Asking the right question
#
# Use the adapted machine learning workflow
# to process and transform UCI data on defaulted
# German credit cards to create a model
# that must predict whether a loan will
# go into default with a +95% accuracy.

# STEP 2: Collecting the data
#
# see: http://archive.ics.uci.edu/ml/datasets/Statlog+%28German+Credit+Data%29
#
# The data we'll be using is numeric and has already
# undergone preprocessing. For example, the original
# feature names have been changed to make them easier
# to handle in R.
#

# STEP 3: Exploring the data
credit <- read.csv("../book/Chapter05/credit.csv")
str(credit)
summary(credit$amount)
table(credit$default)
hist(credit$amount)

# STEP 4: Preparing the data

# 90% training data
# 10% test data
set.seed(123)

# Generate a random vector of indexes -
# from a 1 dimensional vector of 1000 numbers
# choose 900 elements at random.
train_sample <- sample(1000,900)
credit_train <- credit[train_sample, ]
credit_test  <- credit[-train_sample, ]

# We should have about 30% of the defaulted
# loans in each data set
prop.table(table(credit_train$default))
prop.table(table(credit_test$default))


# STEP 5: Selecting an algorithm
#
# We will use a decision tree to make predictions
# because they have relatively high accuracy
# and generate models that can easily be described
# in plain English. This is an important factor to
# consider because when we accept or decline someone
# for a loan we need to clearly explain our reasoning
# to regulatory bodies and customers.
library(C50)

# STEP 6: Training the model
credit_model <- C5.0(
  credit_train[-17],    # Include all data except for the default feature
  credit_train$default  # This is what we are trying to predict
)

credit_model
summary(credit_model)



# STEP 7: Evaluating the model performance
credit_pred <- predict(credit_model, credit_test)

library(gmodels)

CrossTable(
  credit_test$default,
  credit_pred,
  prop.chisq = FALSE,
  prop.c = FALSE,
  prop.r = FALSE,
  dnn = c('actual default', 'predicted default')
)

# Our model was only able to correctly predict defaulted
# loans 42% of the time. This error rate is too high, much
# lower than our desired error rate of 95%. We'll need
# to figure out how to improve our model performance.


# STEP 8: Improving model performance
#
# We'll use a method called boosting to improve model
# performance. Boosting is rooted in the notion that
# by combining several weaker models together, it
# produces a team of models that is stronger than
# any individual model alone.
credit_boost10 <- C5.0(
  credit_train[-17],
  credit_train$default,
  trials = 10
)

credit_boost_pred10 <- predict(credit_boost10, credit_test)


CrossTable(
  credit_test$default,
  credit_boost_pred10,
  prop.chisq = FALSE,
  prop.c = FALSE,
  prop.r = FALSE,
  dnn = c('actual default', 'predicted default')
)

# Our tree size shrunk to 47 from 57.
#
# Our original classifier had a 14.2% error rate making
# 132 mistakes out of 900. But this new classifier only
# made a total of 34 mistakes giving us an error rate
# of 0.03
#
# Our model performance improved to being able to predict
# which loans would default 60% of the time (not great).
summary(credit_model)
summary(credit_boost10)


# Improving model performance with a cost matrix...
#
# Let's suppose that some mistakes are costlier than others.
# Giving out a loan to someone who is likely to default
# will be a costly experience. So our goal is to reduce
# the number of false negatives.
#
# One solution is to reduce the number of borderline
# applicants - applicants whose status is too close
# to call - because an applicant who defaults on their
# loan is more expensive than not giving out a loan
# in the first place.
#
# The C5.0 algorithm let's us assign a penalty to different
# errors in order to discourage a decision tree from
# making costly mistakes. The penalties are designated
# in a "cost matrix".
#
# Since the predicted and actual values an both take two
# values, "yes" or "no", we need to design a 2x2 matrix.
matrix_dimensions        <- list(c("no", "yes"), c("no", "yes"))
names(matrix_dimensions) <- c("predicted", "actual")

# We believe it is 4 times costlier have a loan
# go into default than it is to not give out the
# loan. R fills a matrix by filling columns one
# by one from top to bottom.
#
# As defined by this matrix there is no cost assigned
# when the algorithm classifies a "no" or "yes" correctly.
# But a false negative has a cost of 4 while a false
# positive has a cost of 1.
matrix_costs <- c(
  0,     # predicted no,  actual no
  1,     # predicted yes, actual no
  4,     # predicted no,  actual yes
  0      # predicted yes, actual yes
)

error_cost <- matrix(
  matrix_costs,
  nrow=2,
  dimnames=matrix_dimensions
)

credit_cost10 <- C5.0(
  credit_train[-17],
  credit_train$default,
  costs=error_cost
)

credit_cost_pred10 <- predict(credit_cost10, credit_test)

CrossTable(
  credit_test$default,
  credit_cost_pred10,
  prop.chisq = FALSE,
  prop.c = FALSE,
  prop.r = FALSE,
  dnn = c('actual default', 'predicted default')
)

summary(credit_cost10)
# Our tree size shrinks to 28.
#
# This model has an error rate of 29% which is greater
# than previous error rates. However because we've provided
# a cost matrix, our model makes different kinds of mistakes.
# We've made a trade-off between having more false-positives
# and less false-negatives.
#
# Our model performance improved to being able to predict
# which loans would default 78% of the time (better).
