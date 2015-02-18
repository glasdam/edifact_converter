require 'edifact_converter'

module EdifactConverter

  module ConverterMethods

    def convert
      self.xml11 = build_xml11 if xml11.nil?
      self.edifact = build_edifact if edifact.nil?
      self.xml = build_xml if xml.nil?
    end

    def format_edifact
      build_edifact(true)
    end

    def html
      if xml && xml.root && xml.root.namespace
        rules = Configuration.xml_rules xml.root.namespace.href
        if rules
          rules.to_html.transform xml
        else
          "<html><head><title>Fejl</title></head><body><h1>Ukendt namespace</h1><b>#{xml.root.namespace}</b></body></html>"
        end
      else
        "<html><head><title>Fejl</title></head><body><h1>Ingen xml tilgængelig</h1></body></html>"
      end
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

    def build_edifact(pretty = false)
      return nil if xml11.nil?
      Configuration.format_edi = pretty
      parser = EdifactConverter::XML112EDI::XmlReader.new
      parser.parse(xml11, properties)
    end

    def build_xml
      return nil if xml11.nil?
      XML.xml11_to_xml(xml11, properties)
    end

  end

end