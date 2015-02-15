require 'edifact_converter/edi2xml'

module EdifactConverter::EDI2XML

  class SettingsHandler < EdifactConverter::EmptyHandler

    attr_accessor :groups, :segment, :element_index, :value_index, :settings

    def startDocument
      self.groups = []
      self.segment = 'Edifact'
      self.element_index = 0
      self.value_index = 0
      self.version = self.type = 'default'
      self.settings = EdifactConverter::Configuration.rules_edi('default', 'default')
      super
    end

    def startSegmentGroup(name, hidden = false)
      groups << name
      if name == 'BrevIndhold'
        self.settings = EdifactConverter::Configuration.rules_edi(
          EdifactConverter.properties[:type],
          EdifactConverter.properties[:version]
        )
      end
      locator.rules = settings[:edifact][name]
      super
    end

    def endSegmentGroup(name)
      groups.pop
      locator.rules = settings[:edifact][groups.last]
      super
    end

  end

end
