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

    def verify
      check_segments
      compare_xml11
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

    def check_segments
      
    end

    def compare_xml11
      return if source_format != :edifact || xml11.nil? || xml.nil?
      facit = XML.xml_to_xml11(xml, properties)
      comparator = Comparator.new
      comparator.compare_docs xml11, facit do |diff|
        pos = EdifactConverter::EDI2XML11::Position.new diff.source["linie"], diff.source["position"]
        text = comparison_error_text diff.kind
          properties[:errors] << Message.new(position: pos, text: text)
      end
    end

    def comparison_error_text(kind)
      case kind
      when :added
        "Der mangler et #{diff.facit.name} her"
      when :removed
        "Der er et #{diff.source.name} for meget her"
      when :root
        "Dokumenterne er for forskellige til sammenligning. Forventede #{diff.facit.name} men det var #{diff.source.name}"
      when :text
        "Teksten #{diff.source.text} skal være #{diff.facit.text}"
      when :removed_children
        "Dette element (#{diff.source.name}) burde ikke have noget indhold"
      when :added_children
        "Dette element (#{diff.source.name}) burde have følgende indhold: #{diff.facit.text}"
      else
        "Ukendt fejl(#{diff.kind})"
      end
    end

  end

end
