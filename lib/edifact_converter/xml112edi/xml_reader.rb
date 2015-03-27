require 'nokogiri'
require 'edifact_converter/xml112edi'

module EdifactConverter::XML112EDI

  class XmlReader

    attr_accessor :handler, :state, :edifact

    def initialize()
      self.edifact = EdiHandler.new
      self.handler = ChecksumHandler.new edifact
    end

    def parse(xmlstr, properties)
      xml11 = if xmlstr.is_a? String
        Nokogiri::XML(xmlstr) { |config| config.nonet }
      else
        xmlstr
      end
      xml11.errors.each do |error|
        properties[:errors] << EdifactConverter::Message.from_syntax_error(error)
      end
      parse_xml xml11
    end

    private

    def parse_xml(xmlsrc)
      xml = xmlsrc.dup
      return unless xml.root
      remove_grouping xml
      handler.startDocument
      xml.root.elements.each do |segment|
        handler.startSegment(segment.name)
        segment.elements.each do |element|
          handler.startElement()
          element.elements.each do |subelm|
            handler.value subelm.text
          end
          handler.endElement()
        end
        handler.endSegment()
      end
      handler.endDocument
      enc_converter = Encoding::Converter.new("utf-8", "iso-8859-1")
      edi_text = enc_converter.convert(edifact.edifact.string)
      include_binaries edi_text
    end

    def remove_grouping(xml)
      hidden, groups = [], []
      xml.root.traverse do |element|
        case element.name
        when /^[S][0-9]{2}$/
          if element['hidden']
            hidden << element
          else
            groups << element
          end
        when "Brev"
          hidden << element
        when "BrevIndhold"
          hidden << element
        end
      end
      hidden.each { |elm| elm.replace elm.elements }
      groups.each do |elm|
        first = elm.first_element_child
        first.unlink
        elm.next = elm.elements
        first.parent = elm
      end
    end

    def include_binaries(source)
      return source if edifact.binary.empty?
      source.force_encoding 'ASCII-8BIT'
      edifact.binary.each do |id, base64|
        start = source.index(id)
        source[start, id.size] = Base64.decode64(base64)
      end
      source      
    end

  end

end
