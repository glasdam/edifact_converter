require "edifact_converter/version"
require "edifact_converter/empty_handler"
require "edifact_converter/edifact_error"
require 'edifact_converter/edi2xml'
require "edifact_converter/xml2edi"
require "edifact_converter/xml11"
require "edifact_converter/configuration"
require "edifact_converter/result"
require "edifact_converter/message"
require "edifact_converter/command_line_parser"
require "edifact_converter/null_object"

module EdifactConverter

  def self.convert_edifact(text, only_xml11 = false)
    messages = []
    xml11 = xml = nil
    begin
      xml11 = EdifactConverter::EDI2XML.convert(text, messages)
      xml = EdifactConverter::XML11.to_xml(xml11, messages) unless only_xml11 and xml11
    rescue EdifactConverter::EdifactError => error
      messages << error.to_message
    end
    Result.new xml11, xml, text, messages
  end

  def self.convert_xml(text, only_xml11 = false)
    messages = []
    xml = Nokogiri::XML(text) { |config| config.nonet }
    xml_parse_errors xml, messages
    xml11 = EdifactConverter::XML11.from_xml(xml, messages)
  	edifact = EdifactConverter::XML2EDI.convert(xml11, messages) unless only_xml11
  	Result.new xml11, xml, edifact, messages
  end

  def self.read_file(filename)
  	File.open(filename, 'r:iso-8859-1:iso-8859-1') { |f| f.read } #  encoding: 'ISO-8859-1'
  end

  def xml?(text)
    Nokogiri::XML(text).errors.empty?
  end

  private

  def self.xml_parse_errors(xml, messages)
    xml.errors.each do |error|
      messages << Message.from_syntax_error(error)
    end
  end

end
