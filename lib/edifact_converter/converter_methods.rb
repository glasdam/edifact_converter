require 'edifact_converter'

module EdifactConverter

  module ConverterMethods

    def convert
      self.ast = build_ast if ast.nil?
      self.edifact = build_edifact if edifact.nil?
      self.xml = build_xml if xml.nil?
    end

    def format_edifact
      if edifact
        formatted = edifact.encode 'utf-8'
        formatted.gsub! /[\n\r]/, ""
        formatted.gsub! /([^?]{1}')/, "\\1\n"
        formatted.gsub! /^\s*/, ""
        formatted.encode 'iso8859-1'
      else
        build_edifact(true)
      end
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
      compare_xml11
    end

    private

    def build_ast(from_source = source_format)
      ast = case from_source
      when :edifact
        xml11 = parse_edifact (format_edifact)
        if Configuration.binary? properties[:version]
          self.properties = nil
          xml11 = parse_edifact(edifact)
        end
        AbstractSyntaxTree.new xml11
      when :xml
        ast = AbstractSyntaxTree.new XML.xml_to_xml11(self.xml, properties)
        ast.pack
        ast.set_checksums
        ast
      end
      ast.verify_segments_checksum &error_proc
      ast
    end

    def build_edifact(pretty = false)
      return nil if ast.nil?
      Configuration.format_edi = pretty
      parser = EdifactConverter::XML112EDI::XmlReader.new
      parser.parse(ast.document, properties)
    end

    def build_xml
      return nil if ast.nil?
      XML.xml11_to_xml(ast.document, properties)
    end

    def parse_edifact(edifact_string)
      parser = EdifactConverter::EDI2XML11::EdiReader.new
      parser.parse_string(edifact_string, properties)
    rescue EdifactConverter::EdifactError => error
      properties[:errors] << error.to_message
      Nokogiri::XML "<Edifact/>"
    end
    

    def compare_xml11
      return if source_format != :edifact || ast.nil? || xml.nil?
      ast_facit = AbstractSyntaxTree.new XML.xml_to_xml11(xml, properties)
      ast_facit.pack
      ast_facit.set_checksums
      comparator = Comparator.new
      comparator.compare_docs ast.document, ast_facit.document, &error_proc
    end

    def error_proc
      @proc ||= Proc.new do |diff|
        pos = EdifactConverter::EDI2XML11::Position.new diff.source["linie"], diff.source["position"]
        text = comparison_error_text diff
        properties[:errors] << Message.new(position: pos, text: text)
      end
    end

    def comparison_error_text(diff)
      case diff.kind
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
      when :no_unt
        "Denne besked mangler et UNT element"
      when :unt
        "Der er #{diff.facit} segmenter, men der er kun angivet #{diff.source.at("Elm[1]/SubElm/text()")}"
      else
        "Ukendt fejl(#{diff.kind})"
      end
    end

  end

end
