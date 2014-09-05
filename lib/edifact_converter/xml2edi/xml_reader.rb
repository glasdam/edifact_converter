require 'nokogiri'
require 'edifact_converter/xml2edi'

module EdifactConverter::XML2EDI

  class XmlReader

    attr_accessor :handler, :state, :edifact

    def initialize()
      self.edifact = EdiHandler.new
      self.handler = ChecksumHandler.new edifact
    end

    def parse_string(xmlstr)
      parse_xml(Nokogiri::XML(xmlstr){ |config| config.default_xml.noblanks })
    end

    def parse_file(file)
      parse_xml(Nokogiri::XML(File.open(file, encoding: 'ISO-8859-1')){ |config| config.default_xml.noblanks })
    end

    def parse_xml(xml)
      Nokogiri::XSLT.register "http://edifact.medware.dk/converter", SegmentChecks
      xsl = Nokogiri.XSLT(File.open("data/remove_grouping.xsl"))
      result = xsl.transform(xml) do |config|
        config.default_xml.noblanks
      end
      process_xftxs result
      handler.startDocument
      result.root.children.each do |segment|
        handler.startSegment(segment.name)
        segment.children.each do |element|
          handler.startElement()
          element.children.each do |subelm|
            handler.value subelm.text
          end
          handler.endElement()
        end
        handler.endSegment()
      end
      handler.endDocument
      enc_converter = Encoding::Converter.new("utf-8", "iso-8859-1")
      enc_converter.convert(edifact.edifact.string)
    end

    def process_xftxs(xml)
      xml.xpath("//XFTX").each do |xftx|
        XftxParser.parse xftx        
      end
    end

    def self.test(file)
      puts self.new.parse_file('test/files/DIS91_XFTX.xml')
    end

  end

end
