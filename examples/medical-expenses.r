insurance <- read.csv("./book/Chapter06/insurance.csv",
  stringsAsFactors=TRUE)

str(insurance)

# The variable we are trying to predict is
# insurance$expenses so let's look at a summary
# of that data:
summary(insurance$expenses)
IQR(insurance$expenses)
quantile(insurance$expenses)
hist(insurance$expenses)

# The histogram shows that we have a right skewed
# distribution. While most yearly medical expenses are
# under $16,000, the tail end of our distribution
# extends far beyond that to a maximum value of
# over $63,000.

# The distribution of our data is not ideal for linear
# regression. But by knowing this now we can take
# steps to design a better model.


# EXPLORING RELATIONSHIPS AMONG FEATURES
#
# Before fitting a regression model to data it is
# helpful to see how the independent variables are
# related to the dependent variable and each other.
# We can do that with a correlation matrix:
cor(insurance[c("age", "bmi", "children", "expenses")])

# After analyzing the correlation matrix, none of the
# correlations can be considered strong. But there are
# a couple interesting observations. First, age and bmi
# have a weak positive correlation. As someone ages, their
# bmi increases. Second, expenses has a moderate psotive
# correlation with age, and a weak positive correlation
# with bmi. Expenses has a weak positive correlation with
# children. Together these associations hint at the idea
# that as you get older, and your bmi increases, and you have
# more children, your medical expenses go up.
#
# Let's vizualize the relationships between these numeric
# features with a scatterplot matrix:
pairs(incurance[c("age", "bmi", "children", "expenses")])

library(psych)


# TRAINING THE MODEL

ins_model <- lm(
  expenses ~ age + children + bmi + sex + smoker + region,
  data = insurance)

# This is equivalent syntax
ins_model <- lm(expenses ~ ., data = insurance)

ins_model

# How do we interpret the model?
#
# The Intercept is the predicted value of "expenses"
# when the independent variables are equal to zero.
# The intercept is often ignored because it rarely has
# any real-world significance. For example, there is
# no real-world interpretation for someone having an
# age of 0 and a bmi of 0 at the same time.
#
# The other data this model provides are beta coefficients.
# These coefficients indicate the increase in expenses
# for an increase in one of the features, assuming
# all other values are held constant. So we could expect
# that being a smoker will increase your medical expenses
# by $23,000 on average, all else being equal.
#
# Our regions where split into a regerence group. All the
# values in output from the model are all negative. This implies
# that our reference category, the northeast region, tends
# to have the highest average expenses.
#
# Men tend to have $131 less in medical expenses than women.


# EVALUATING MODEL PERFORMANCE
summary(ins_model)

############
# Residuals
############
# This section provides a summary for the errors in our
# predictions. Since a residual is equal to the true value
# minus the predicted value, the maximum error of 29981
# means that our model under-predicted expenses by ~$30,000
# for at least one observation.
#
# However, most predictions fell within the IQR and generally
# ranged from being $2,850 over or $1,383 under the true
# value.

###############
# Coefficients
###############
# For each coefficient the p-value, denoted Pr(>|t|),
# is the probability the coefficient is zero givent the
# value of the estimate. Small p-values suggest that the
# coefficient is very unlikely to be zero, which means
# that the feature is extremely unlikely to have no
# relationship with the dependent variable.
#
# P-values less than the significance level, for example,
# "< 2e-16 ***", are considered to be statistically significant.
#

#####################
# Multiple R-squared
#####################
# The multiple R-squared value provides a measure of
# how well our model as a whole explains the values
# of the dependent variable. The closer the measure
# is to 1 the better the model explains the data.
#
# Since the adjusted R-squared value is 0.7494, we know
# that the model explains alomost 75% of the variation
# in the dependent variable.
#
# The adjusted R-squared metric works by penalizing models
# with large numbers of independent variables, because
# models with more features always explain more variation.



# IMPROVING MODEL PERFORMANCE

# Adding a non-linear relationship
insurance$age2 <- insurance$age^2

# Using binary indicators
insurance$bmi30 <- ifelse(insurance$bmi > 30, 1, 0)

# Adding interaction effects
# When two features have a combined effect this
# is called an interaction. If we suspect that two
# features interact then we can add their interaction
# to the model.

ins_model2 <- lm(
  expenses ~ age + age2 + children + bmi + sex + bmi30*smoker + region,
  data = insurance
)
