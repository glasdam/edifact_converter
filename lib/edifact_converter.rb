require "edifact_converter/version"
require "edifact_converter/empty_handler"
require "edifact_converter/edifact_error"
require 'edifact_converter/edi2xml'
require "edifact_converter/xml2edi"
require "edifact_converter/xml11"
require "edifact_converter/configuration"
require "edifact_converter/result"
require "edifact_converter/message"

module EdifactConverter

  def self.convert_edifact(text)
    messages = []
    xml11 = EdifactConverter::EDI2XML.convert(text, messages)
    xml = EdifactConverter::XML11.to_xml(xml11, messages)
    Result.new xml11, xml, text, messages
  end

  def self.convert_xml(text)
    messages = []
    xml = Nokogiri::XML(text) { |config| config.nonet }
    xml_parse_errors xml, messages
    xml11 = EdifactConverter::XML11.from_xml(xml, messages)
  	edifact = EdifactConverter::XML2EDI.convert(xml11, messages)
  	Result.new xml11, xml, edifact, messages
  end

  def self.read_file(filename)
  	File.open(filename, 'r', encoding: 'ISO-8859-1') { |f| f.read }
  end

  def self.xml_parse_errors(xml, messages)
    xml.errors.each do |error|
      messages << Message.from_syntax_error(error)
    end
  end

end
