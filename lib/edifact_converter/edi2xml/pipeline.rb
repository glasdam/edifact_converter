require 'edifact_converter/edi2xml'
require 'edifact_converter/debug_handler'

module EdifactConverter::EDI2XML

  class Pipeline

    attr_accessor :handler, :status

    def initialize
      xml_handler = XmlHandler.new
      settings = SettingsHandler.new(xml_handler)
      parent = ParentGroupHandler.new(settings)
      self.handler = BrevHandler.new(
        PropertiesHandler.new(
          SegmentGroupHandler.new(
            HiddenGroupHandler.new(parent)
          )
        )
      )
    end

  end

end
