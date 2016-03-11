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


# A linear equation for predicting the number of O-ring
# failures on a space shuttle launch.
def function(x)
  3.70 + -0.048 * x
end

# But how do we find the parameter estimates for a and b?
# We could use a technique called ordinary least squares
# estimation. In OLS regression, the slope (-0.048) and
# intercept (3.70) are chosen so that they minimize the
# sum of the squared errors.
#
# The sum of squared errors is the vertical distance
# between the predicted values on the y axis and the
# actual y values. These error are also known as residuals.

# The correlation between two variables measures how
# closely their relationship follows a straight line.
# Correlation ranges between -1 and +1. The extreme
# values on either side indicate a perfectly linear
# relationship while a value close to 0 indicates no
# linear relationship.
