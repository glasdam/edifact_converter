require 'edifact_converter/edi2xml'
require 'edifact_converter/debug_handler'

module EdifactConverter::EDI2XML

  class Pipeline

    attr_accessor :handler, :status

    def initialize
      @xml_handler = XmlHandler.new # (EdifactConverter::DebugHandler.new)
      self.status = StatusHandler.new(@xml_handler)
      parent = ParentGroupHandler.new(status)
      self.handler = BrevHandler.new(
        PropertiesHandler.new(
          SegmentGroupHandler.new(
            HiddenGroupHandler.new(parent)
          )
        )
      )
    end

    def xml
      @xml_handler.xml
    end

    def type
      status.type
    end

    def version
      status.version
    end

  end

end
