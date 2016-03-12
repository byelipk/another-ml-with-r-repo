# An activation function will sum the total input signal
# then determine if it meets a certain firing threshold.
#
# In this case the neuron fires when the sum of inputs
# is at least 0.
def activation_function(x)
  if x >= 0
    1
  else
    0
  end
end

# Sigmoid activation function
#
# Note the output of this function is not binary
# like the threshold activation function; output
# values can fall anywhere from 0 to 1.
def sigmoid(x)
  1 / (1 + (Math::E ** -x))
end
