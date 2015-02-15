require 'edifact_converter'

module EdifactConverter

  class Result

    ATTRIBUTES = [:xml11, :xml, :edifact, :properties, :source]

    ATTRIBUTES.each do |attribute|
      attr_accessor attribute
    end

    def initialize(options)
      options.each do |key, value|
        if ATTRIBUTES.member? key.to_sym
          self.send "#{key}=", value
        end
      end
    end

  end

end
