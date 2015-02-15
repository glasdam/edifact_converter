require 'edifact_converter'

module EdifactConverter

  module ConverterMethods

    def convert
      self.xml11 = build_xml11 if xml11.nil?
      self.edifact = build_edifact if edifact.nil?
      self.xml = build_xml if xml.nil?
    end

    def format_edifact
      return nil if xml11.nil?
      Configuration.format_edi = true
      parser = EdifactConverter::XML112EDI::XmlReader.new
      parser.parse(xml11, properties)
    end

    private

    def build_xml11(from_source = source_format)
      case from_source
      when :edifact
        parser = EdifactConverter::EDI2XML11::EdiReader.new
        begin
          parser.parse_string(edifact, properties)
        rescue EdifactConverter::EdifactError => error
          properties[:errors] << error.to_message
          nil
        end
      when :xml
        XML.xml_to_xml11(xml, properties)
      else
        xml11
      end
    end

    def build_edifact(pretty = true)
      return nil if xml11.nil?
      Configuration.format_edi = true
      parser = EdifactConverter::XML112EDI::XmlReader.new
      self.edifact = parser.parse(xml11, properties)
    end

    def build_xml
      return nil if xml11.nil?
      XML.xml11_to_xml(xml11, properties)
    end

  end

end