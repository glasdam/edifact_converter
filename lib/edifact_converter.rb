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
    self.properties = nil
    xml11 = xml = nil
    begin
      xml11 = edifact_to_xml11(text)
      xml = xml11_to_xml(xml11) unless only_xml11 and xml11
    rescue EdifactConverter::EdifactError => error
      properties[:errors] << error.to_message
    end
    Result.new xml11: xml11, xml: xml, edifact: text, properties: properties, source: :edifact
  end

  def self.convert_xml(text, only_xml11 = false)
    self.properties = nil
    xml = Nokogiri::XML(text) { |config| config.nonet }
    xml_parse_errors xml
    xml11 = xml_to_xml11(xml)
  	edifact = xml11_to_edifact(xml11) unless only_xml11
  	Result.new xml11: xml11, xml: xml, edifact: edifact, properties: properties, source: :xml
  end

  def self.edifact_to_xml11(text)
    EdifactConverter::EDI2XML.convert(text)
  end

  def self.xml_to_xml11(xml)
    EdifactConverter::XML11.from_xml(xml)
  end

  def self.xml11_to_edifact(xml11)
    EdifactConverter::XML2EDI.convert(xml11)
  end

  def self.xml11_to_xml(xml11)
    EdifactConverter::XML11.to_xml(xml11)
  end

  def self.convert(text)
    if xml?(text)
      convert_xml(text)
    else
      convert_edifact(text)
    end
  end

  def self.read_file(filename)
  	File.open(filename, 'r:iso-8859-1:iso-8859-1') { |f| f.read } #  encoding: 'ISO-8859-1'
  end

  def self.xml?(text)
    Nokogiri::XML(text).errors.empty?
  end

  def self.properties
    @properties ||= Hash.new do |hash,key|
      case key
      when :errors
        hash[key] = []
      when :warnings
        hash[key] = []
      else
        nil
      end
    end
  end

  def self.properties=(hash)
    @properties = hash
  end

  private

  def self.xml_parse_errors(xml)
    xml.errors.each do |error|
      properties.fetch(:errors) << Message.from_syntax_error(error)
    end
  end

end
