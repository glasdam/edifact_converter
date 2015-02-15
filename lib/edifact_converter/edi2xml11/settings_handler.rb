require 'edifact_converter/edi2xml11'

module EdifactConverter::EDI2XML11

  class SettingsHandler < EdifactConverter::EmptyHandler

    attr_accessor :groups, :segment, :element_index, :value_index

    def startDocument
      self.groups = []
      self.segment = 'Edifact'
      self.element_index = 0
      self.value_index = 0
      super
    end

    def startSegmentGroup(name, hidden = false)
      groups << name
      locator.rules = EdifactConverter::Configuration.edifact_rules(locator.properties[:type], name)
      super
    end

    def endSegmentGroup(name)
      groups.pop
      locator.rules = EdifactConverter::Configuration.edifact_rules(locator.properties[:type], groups.last)
      super
    end

  end

end
