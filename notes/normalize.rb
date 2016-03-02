require 'descriptive_statistics'

module NormalizationMethods
  class Base
    attr_reader :features, :collection
    def initialize(features: [], collection: [])
      @features   = features
      @collection = collection
    end

    def execute
      raise NotImplementedError
    end
  end

  class MinMax < Base
    def execute
      features.each do |feature|
        values = collection.map {|n| n.send(feature)}
        min = values.min
        max = values.max

        collection.each do |ex|
          ex.send(
            "#{feature}=",
            ((ex.send(feature) - min) / (max - min))
          )
        end
      end
    end
  end

  class ZScore < Base
    def execute
      features.each do |feature|
        values = collection.map {|n| n.send(feature)}
        mean = values.mean
        stdd = values.standard_deviation

        collection.each do |ex|
          ex.send(
            "#{feature}=",
            ((ex.send(feature) - mean) / stdd)
          )
        end
      end
    end
  end
end
