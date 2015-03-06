require 'edifact_converter'

module EdifactConverter

  class Message

    ATTRIBUTES = [:position, :text, :source]

    ATTRIBUTES.each do |attribute|
      attr_accessor attribute
    end

    def initialize(options) #position = EDI2XML11::Position.new, text, source)
      self.position = options[:position] 
      self.text = options.fetch(:text, "Ukendt fejl")
      self.source = options.fetch(:source, :edifact)
    end

    def self.from_syntax_error(error)
      position = EdifactConverter::EDI2XML11::Position.new(error.line, error.column)
      self.new(position: position, text: error.to_s, source: xml)
      # case error.level
      # when 3
      #   self.new(position, error.to_s, :error)
      # when 2
      #   self.new(position, error.to_s, :error)
      # when 1
      #   self.new(position, error.to_s, :warning)
      # end
    end

    def to_s
      "#{source.to_s.capitalize}: #{text} #{position}"
    end

  end

end
