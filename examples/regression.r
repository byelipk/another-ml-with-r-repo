launch <- read.csv("./book/Chapter06/challenger.csv")
# Regression is concerned with specifying the relationship
# between a single, numeric depdendent variable and one
# or more numeric independent variables.
#
# The dependent variable is the value to be predicted
# while the independent variables are the predictors.
#
#
# y = a + bx
# ==========
# y => Dependent variable - positioned along the vertical axis
# x => Independent variable - positioned along the horizontal axis
# b => The slope term specifies how much the line rises for each increase in x
# a => The point at which the line intercepts the y axis

# The depdendent variable is launch$distress_ct
# The independent variable is launch$temperature
b <- cov(launch$temperature, launch$distress_ct) / var(launch$temperature)
a <- mean(launch$distress_ct) - b * mean(launch$temperature)

# A linear equation for predicting the number of O-ring
# failures on a space shuttle launch.
linear <- function(x,y) {
  b <- cov(x, y) / var(x)       # slope
  a <- mean(y) - b * mean(x)    # y-intercept

  a + b * x
}

y2 <- linear(launch$temperature, launch$distress_ct)

# Ordinary Least Squares Estimation
#
# The correlation between two variables measures how
# closely their relationship follows a straight line.
# Correlation ranges between -1 and +1. The extreme
# values on either side indicate a perfectly linear
# relationship while a value close to 0 indicates no
# linear relationship.
correlation <- function(x,y) {
  cov(x, y) / (sd(x) * sd(y))
}

r <- correlation(launch$temperature, launch$distress_ct)
# -0.5111264 is a negative correlation. It implies that
# as the temperature increases there is a decrease
# in the number of distressed O-rings.
#
# Because -0.51 is halfway to the extreme of -1, we can
# say that there is a moderately strong negative linear
# association.


# Multiple Linear Regression
reg <- function(y, x) {
  x <- as.matrix(x)
  x <- cbind(Intercept = 1, x)
  b <- solve(t(x) %*% x) %*% t(x) %*% y
  colnames(b) <- "estimate"
  print(b)
}

# Simple Linear
reg(y = launch$distress_ct, x = launch[2])

# Multiple Linear
reg(y=launch$distress_ct, x = launch[2:4])
