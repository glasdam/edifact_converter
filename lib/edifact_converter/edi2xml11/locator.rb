require 'edifact_converter/edi2xml11'

module EdifactConverter::EDI2XML11

  class Locator

    attr_writer :rules, :settings, :position, :properties

    def settings
      raise 'hell'
      @settings ||= EdifactConverter::Configuration.rules['default']
    end

    def rules
      @rules ||= EdifactConverter::Configuration.edifact_rules(properties[:type], 'default')
    end

    def position
      @position ||= Position.new
    end

    def properties
      @properties 
    end

  end

end
