require 'edifact_converter'

module EdifactConverter

  class Message

    attr_accessor :position, :text

    def initialize(position = EDI2XML11::Position.new, text)
      self.position = position
      self.text = text
    end

    def self.from_syntax_error(error)
      position = EdifactConverter::EDI2XML11::Position.new(error.line, error.column)
      self.new(position, error.to_s)
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
      "#{text} #{position}"
    end

  end

end
