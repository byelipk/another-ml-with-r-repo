letters <- read.csv("./book/Chapter07/letterdata.csv")

# Our data is pretty much clean. The R package
# we will use to run the SVM will normalize the
# data for us.

letters_train <- letters[1:16000, ]
letters_test  <- letters[16001:20000, ]

library(kernlab)

letter_classifier <- ksvm(
  letter ~ .,
  data = letters_train,
  kernel = "vanilladot"
)

letter_predictions <- predict(letter_classifier, letters_test)

table(letter_predictions, letters_test$letter)

agreement <- letter_predictions == letters_test$letter

table(agreement)

prop.table(table(agreement))

# IMPROVING MODEL PERFORMANCE

letter_classifier_rbf <- ksvm(
  letter ~ .,
  data = letters_train,
  kernel = "rbfdot"
)

letter_predictions_rbf <- predict(letter_classifier_rbf, letters_test)

table(letter_predictions_rbf, letters_test$letter)

agreement <- letter_predictions_rbf == letters_test$letter

table(agreement)

prop.table(table(agreement))

# 93% accuracy

# Next Steps
#
# 1. Try other kernels
# 2. Vary the cost of constraints parameter to modify
#    the width of the decision boundary


letter_classifier_other <- ksvm(
  letter ~ .,
  data = letters_train,
  kernel = "splinedot",
  C = 1
)

letter_predictions_other <- predict(letter_classifier_other, letters_test)
agreement <- letter_predictions_other == letters_test$letter
prop.table(table(agreement))
