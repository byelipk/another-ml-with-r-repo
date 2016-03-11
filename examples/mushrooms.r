mushrooms <- read.csv(
  "./book/Chapter05/mushrooms.csv",
  stringsAsFactor=TRUE)


str(mushrooms)

# Is it odd that "partial" is the only value
# for mushrooms$veil_type?
nrow(mushrooms[mushrooms$veil_type != "partial", ])

# We can remove the column.
mushrooms$veil_type <- NULL

# Let's check the proportions of the feature
# we will try to predict:
prop.table(table(mushrooms$type))

# By assuming our data is an exhaustive set
# of the population of all wild mushrooms,
# we can build and test the model on the same data.

library(RWeka)

# 1R
mushroom_1R <- OneR(type ~ ., data = mushrooms)

# Ripper
mushroom_JRip <- JRip(type ~ ., data = mushrooms)
