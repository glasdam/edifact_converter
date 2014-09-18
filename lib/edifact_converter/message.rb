require 'edifact_converter'

module EdifactConverter

  class Message

    attr_accessor :position, :text, :type

    def initialize(position, text, type = :error)
      self.position = position
      self.text = text
      self.type = type
    end

    def self.from_syntax_error(error)
      position = EdifactConverter::EDI2XML::Position.new(error.line, error.column)
      case error.level
      when 3
        self.new(position, error.to_s, :error)
      when 2
        self.new(position, error.to_s, :error)
      when 1
        self.new(position, error.to_s, :warning)
      end
    end

  end

end
