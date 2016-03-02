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

  private

    def vote(sorted)
      rank = Hash.new(0)
      sorted.each { |n| rank[n.label] += 1 }
      rank
    end
end

# We want to know how similar tomatoes are to green beans.
tomato = Ingredient.new(6, 4, :tomato, :unlabeled)

neighbors = Neighbors.new([
  Ingredient.new(3, 7, :green_bean, :vegetable),
  Ingredient.new(8, 5, :grape, :fruit),
  Ingredient.new(3, 6, :nuts, :protein),
  Ingredient.new(7, 3, :orange, :fruit)
])

neighbors.calculate_distances_from tomato
puts neighbors.nearest(1)
