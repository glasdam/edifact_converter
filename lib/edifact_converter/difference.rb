
module EdifactConverter

  class Difference

    ATTRIBUTES = [:source, :facit, :kind, :type]

    ATTRIBUTES.each do |attribute|
      attr_accessor attribute
    end

    def initialize(options)
      options.fetch(:type) { |key| options[key] = :errors }
      options.each do |name, value|
        if ATTRIBUTES.include? name
          send "#{name}=", value
        end
      end
    end

    def eql?(diff)
      diff.source == source && diff.facit == facit && diff.kind == kind
    end

  end

end
