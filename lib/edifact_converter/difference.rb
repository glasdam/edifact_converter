
module EdifactConverter

  class Difference

    ATTRIBUTES = [:source, :facit, :kind, :type, :message]

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
      return false unless diff.kind == kind
      if kind == :unt
        diff.source == source && diff.facit == facit
      else
        diff.source.name == source.name && diff.facit.name == facit.name 
      end
    end

    def to_s
      "#{source.path} afviger fra #{facit.path} ved at #{kind} af typen #{type} og meddelelsen #{message}"
    end

  end

end
