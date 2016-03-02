require_relative 'normalize'

# When comparing fruits, vegetables, and protein in this
# example we're only concerned about two features:
# sweetness and crunchiness.
Ingredient = Struct.new(:sweetness, :crunchiness, :name, :label, :distance) do
  include Comparable

  def features
    [sweetness, crunchiness]
  end

  def <=>(other)
    distance <=> other.distance
  end
end

class Neighbors < DelegateClass(Array)
  def nearest(k=0)
    if k > 0
      # It's more natural to think of kNN as if
      # the array index begins at 1. We allow
      # for that here.
      k = k - 1

      # We need to perform a vote to determine
      # the frequency of labels among the
      # sorted k-NN. The label with the highest
      # count wins.
      vote(sort[Range.new(0,k)]).sort.first[0]
    else
      sort[Range.new(0,k)].first.label
    end
  end

  def calculate_distances_from(example)
    each do |k|
      k.distance = euclidian(example.features.zip(k.features))
    end

    self
  end

  # Traditionally the k-NN algorithm uses the Euclidian distance
  # to group examples into nearest neighbors.
  #
  # Euclidian distance is specified by the following example:
  def euclidian(features)
    # Take the squared difference of all the features
    squared_diff = features.map { |f| (f[0]-f[1])**2 }

    # Add them together
    summation = squared_diff.reduce(&:+)

    # Then find the square root of the sum
    Math.sqrt(summation)
  end

  # We typically transform features to a standard range
  # because the distance formula is highly sensitive
  # to how features are measured. If two features are
  # measured along different ranges then their impact
  # will be weighted according to how large their scale
  # is. Features that are measured from 1-5 will be weighted
  # less than features ranging from 0-1000000.
  #
  # To account for this we can perform a min-max normalization
  # step before we feed the data to the distance function.
  # This function rescales a feature such that all of its
  # values fall between 0 and 1.
  def normalize
    NormalizationMethods::ZScore.new(
      features: [
        :sweetness,
        :crunchiness
      ],
      collection: self
    ).execute
  end

  def vote(sorted)
    rank = Hash.new(0)
    sorted.each { |n| rank[n.label] += 1 }
    rank
  end
end
