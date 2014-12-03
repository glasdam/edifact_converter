require 'nokogiri'
require 'edifact_converter/xml2edi'

module EdifactConverter::XML2EDI

  class XmlReader

    attr_accessor :handler, :state, :edifact

    def initialize()
      self.edifact = EdiHandler.new
      self.handler = ChecksumHandler.new edifact
    end

    def parse_string(xmlstr, messages)
      parse_xml(
        Nokogiri::XML(xmlstr){ |config| config.default_xml.noblanks },
        messages
      )
    end

    def parse_file(file, messages)
      parse_xml(
        Nokogiri::XML(File.open(file, encoding: 'ISO-8859-1')){ |config| config.default_xml.noblanks },
        messages
      )
    end

    def parse_xml(xml, messages)
      xml = self.class.stylesheet.transform(xml) do |config|
        config.default_xml.noblanks
      end
      handler.startDocument
      xml.root.children.each do |segment|
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
      edi_text = enc_converter.convert(edifact.edifact.string)
      if edifact.binary.any?
        edi_text.force_encoding 'ASCII-8BIT'
        edifact.binary.each do |id, base64|
          edi_text.gsub!(id, Base64.decode64(base64))
        end
      end
      edi_text
    end

    def self.stylesheet
      @stylesheet ||= begin
        Nokogiri::XSLT.register "http://edifact.medware.dk/converter", SegmentChecks
        Nokogiri.XSLT(
          File.open(
            File.join(
              File.dirname(
                File.expand_path(__FILE__)
              ),
              '../../../data/remove_grouping.xsl'
            )
          )
        )
      end
    end

    def self.test(file)
      puts self.new.parse_file('test/files/DIS91_XFTX.xml')
    end

  end

end
