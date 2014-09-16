require "edifact_converter/version"
require "edifact_converter/empty_handler"
require "edifact_converter/edifact_error"
require 'edifact_converter/edi2xml'
require "edifact_converter/xml2edi"
require "edifact_converter/configuration"
require "edifact_converter/result"

module EdifactConverter

  def self.convert_edifact(text)
    edifact_pipeline = EdifactConverter::EDI2XML::Pipeline.new
    parser = EDI2XML::EdiReader.new edifact_pipeline.handler
    parser.parse_string(text)
    namespace = Configuration.namespace(edifact_pipeline.type, edifact_pipeline.version)
   	xslt = Configuration.edi2xml(edifact_pipeline.type, edifact_pipeline.version)
    Result.new edifact_pipeline.xml, xslt.transform(edifact_pipeline.xml), text
  end

  def self.convert_xml(text)
    xml = Nokogiri::XML(text) 
    namespace = xml.root.namespace
    xslt = Configuration.xml2edi(namespace.href)
  	xml11 = xslt.transform(xml)
  	edifact = EdifactConverter::XML2EDI::XmlReader.new.parse_xml(xml11)
  	Result.new xml11, xml, edifact
  end

  def self.read_file(filename)
  	File.open(filename, 'r', encoding: 'ISO-8859-1') { |f| f.read }
  end

end
