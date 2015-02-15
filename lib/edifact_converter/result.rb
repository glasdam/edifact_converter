require 'edifact_converter'
require 'edifact_converter/converter_methods'

module EdifactConverter

  class Result

    include EdifactConverter::ConverterMethods

    ATTRIBUTES = [:xml, :xml11, :edifact, :properties, :source_format]

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

    def properties
      @properties ||= Hash.new do |hash,key|
        case key
        when :errors
          hash[key] = []
        when :warnings
          hash[key] = []
        else
          nil
        end
      end
    end

  end

end
