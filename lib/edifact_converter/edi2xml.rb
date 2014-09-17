require "edifact_converter/edi2xml/xml_handler"
require "edifact_converter/edi2xml/edi_reader"
require "edifact_converter/edi2xml/brev_handler"
require "edifact_converter/edi2xml/segment_group_handler"
require "edifact_converter/edi2xml/position"
require "edifact_converter/edi2xml/position_io"
require "edifact_converter/edi2xml/status_handler"
require "edifact_converter/edi2xml/hidden_group_handler"
require "edifact_converter/edi2xml/parent_group_handler"
require "edifact_converter/edi2xml/pipeline"
require "edifact_converter"


module EdifactConverter::EDI2XML

  def self.convert(edifact, messages = [])
    xml11 = parser.parse_string(edifact, messages)
  end


  def self.parser
    @parser ||= EdiReader.new pipeline.handler
  end

  def self.pipeline
    @pipeline ||= Pipeline.new
  end

end