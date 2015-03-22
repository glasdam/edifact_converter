require 'edifact_converter'

module EdifactConverter

  class Message

    ATTRIBUTES = [:position, :text, :source]

    ATTRIBUTES.each do |attribute|
      attr_accessor attribute
    end

    def initialize(options)
      self.position = options[:position] 
      self.text = options.fetch(:text, "Ukendt fejl")
      self.source = options.fetch(:source, :edifact)
    end

    def self.from_syntax_error(error)
      position = EdifactConverter::EDI2XML11::Position.new(error.line, error.column)
      self.new(position: position, text: error.to_s, source: :xml)
    end

    def to_s
      "#{source.to_s.capitalize}: #{text} #{position}"
    end

  end

end
