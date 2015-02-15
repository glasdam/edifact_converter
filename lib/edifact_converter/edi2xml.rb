require "edifact_converter/edi2xml/xml_handler"
require "edifact_converter/edi2xml/edi_reader"
require "edifact_converter/edi2xml/brev_handler"
require "edifact_converter/edi2xml/segment_group_handler"
require "edifact_converter/edi2xml/position"
require "edifact_converter/edi2xml/position_io"
require "edifact_converter/edi2xml/settings_handler"
require "edifact_converter/edi2xml/hidden_group_handler"
require "edifact_converter/edi2xml/parent_group_handler"
require "edifact_converter/edi2xml/pipeline"
require "edifact_converter/edi2xml/locator"
require "edifact_converter/edi2xml/properties_handler.rb"

require "edifact_converter"


module EdifactConverter::EDI2XML

  def self.convert(edifact)
    xml = begin
      parser.parse_string(edifact)
    rescue EdifactConverter::EdifactError => error
      EdifactConverter.properties[:errors] << error.to_message
      nil
    end
    xml
  end

  def self.parser
    @parser ||= EdiReader.new pipeline.handler
  end

  def self.pipeline
    @pipeline ||= Pipeline.new
  end

end