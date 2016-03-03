class Computation
  attr_reader :numerator, :denominator

  def initialize(numerator, denominator)
    @numerator   = numerator
    @denominator = denominator
  end

  def compute
    numerator.to_f / denominator.to_f
  end
end

class PriorProbability < Computation
end

class Likelihood < Computation
end

class MarginalLikelihood < Computation
end

class PosteriorProbability
  attr_reader :probability

  def initialize(probability)
    @probability = probability
  end
end

class Bayes
  attr_reader :prior, :marginal, :likelihood

  def initialize(prior: nil, marginal: nil, likelihood: nil)
    @prior      = prior
    @marginal   = marginal
    @likelihood = likelihood
  end

  def estimate
    PosteriorProbability.new(compute)
  end

  def compute
    (likelihood.compute * prior.compute) / marginal.compute
  end
end

# Given this likelihood table:
#
# ======= Viagra ======
# =      YES   NO     =
# =====================
# spam  4/20  16/20  20
# ham   1/80  79/80  80
# total 5/100 95/100
#
# The posterior probability is composed of three different
# probabilities: prior probability, likelihood, and marginal
# likelihood.
#
# The prior probability is the probability that any prior
# message was spam. After consulting our likelihood table
# we see that out of 100 messages, 20 were classified as
# spam.
#
# The likelihood is the probability that the word "Viagra"
# was used in previous spam messages. 4 out of 20 messages
# had the word "Viagra".
#
# The marginal likelihood is the probability that the word
# "Viagra" appeared in any message at all. "Viagra" appeared
# in a total of 5 messages.
#
bayes = Bayes.new(
  likelihood: Likelihood.new(4, 20),
  prior: PriorProbability.new(20, 100),
  marginal: MarginalLikelihood.new(5, 100)
)

puts bayes.estimate
