# Entropy is a concept from information theory
# that quantifies randomness within a set of class
# values. Sets with high entropy are diverse and
# provide little information about other items
# that may belong in the set.
def entropy(segment)
  segment.map { |p| -p * Math.log2(p) }.reduce(&:+)
end

# Given a partition of data with two classes
# Red (60%) and White (40%) we can calculate
# entropy as follows:
entropy [0.60, 0.40]

# 50-50 split results in max entropy.
entropy [0.50, 0.50]

# But as one class incresingly dominates the other,
# entropy reduces to zero
entropy [0.70, 0.30]
entropy [0.75, 0.25]
entropy [0.80, 0.20]

# Decision tree algorithms use entropy to determine which
# feature to split on. The algorithm calculates the
# change in homogenity of the set that would result
# from a split on each possible feature. This is known
# as information gain.
