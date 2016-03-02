require_relative 'knn'

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
puts neighbors.nearest(3)
