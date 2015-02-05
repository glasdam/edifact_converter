require "edifact_converter"

require "edifact_converter/xml2edi/checksum_handler"
require "edifact_converter/xml2edi/edi_handler"
require "edifact_converter/xml2edi/segment_checks"
require "edifact_converter/xml2edi/xml_reader"


module EdifactConverter::XML2EDI

  def self.convert(xml11)
    parser.parse_xml(xml11)
  end

  def self.parser
    @parser ||= XmlReader.new
  end

end