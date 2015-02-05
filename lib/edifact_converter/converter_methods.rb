require 'edifact_converter'

module EdifactConverter

  module ConverterMethods

    def convert
      EdifactConverter.properties = nil
      if EdifactConverter.xml? source
        self.source_format = :xml
        self.xml11 = EdifactConverter.xml_to_xml11 source
      else
        self.source_format = :edifact
        self.xml11 = EdifactConverter.edifact_to_xml11 source
      end
      return if properties.fetch(:error){[]}.empty?
      self.edifact = EdifactConverter.xml11_to_edifact xml11
      self.xml = EdifactConverter.xml11_to_xml xml
    end

    def format_edifact

    end

  end

end