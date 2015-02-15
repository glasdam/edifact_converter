require 'edifact_converter'
require 'edifact_converter/xml/paragraph'
require 'edifact_converter/xml/xftx_parser.rb'

module EdifactConverter

  module XML

    def self.xml_to_xml11(xml, properties)
      xml = parse_xml(xml, properties)
      if xml.nil? or xml.root.nil?
        properties[:errors] << EdifactConverter::Message.new("Mangel fuldt XML dokument, konvertering stoppet")
        return 
      end
      #return unless xml and xml.root
      properties[:namespace] = xml.root.namespace && xml.root.namespace.href
      rules = EdifactConverter::Configuration.xml_rules(properties[:namespace])
      if rules.nil?
        properties[:errors] << EdifactConverter::Message.new("Ingen regler for konverteringen af #{properties[:namespace]}")
        return nil
      end
      schema_validate(xml, rules.schema, properties)
      xml11 = rules.from_xml.transform(xml)
      xml11.encoding = "ISO-8859-1"
      extract_errors(xml11, properties)
      process_ftxs xml11
      process_xftxs xml11, properties
    end

    def self.xml11_to_xml(xml11, properties)
      xml11 = parse_xml(xml11, properties)
      return unless xml11 and xml11.root
      properties[:type] = nil
      properties[:version] = nil
      unless properties[:type]
        type = xml11.xpath("/Edifact/Brev[1]/UNH[1]/Elm[2]/SubElm[1]")
        properties[:type] = type && type.text
      end
      unless properties[:version]
        version = xml11.xpath("/Edifact/Brev[1]/UNH[1]/Elm[2]/SubElm[5]")
        properties[:version] = version && version.text
      end
      rules = EdifactConverter::Configuration.xml_rules(properties[:type], properties[:version])
      if rules.nil?
        properties[:errors] << EdifactConverter::Message.new("Ingen regler for konverteringen af #{properties[:type]} - #{properties[:version]}")
        return nil
      end
      xml = rules.to_xml.transform(xml11)
      xml.encoding = "ISO-8859-1"
      extract_errors(xml, properties)
      schema_validate(xml, rules.schema, properties)
      xml
    end

    def self.extract_errors(xml, properties)
      xml.xpath("//*[local-name() = 'FEJL']").each do |error|
        position = EDI2XML11::Position.new error['linie'], error['position']
        properties[:errors] << Message.new(position, error.content.strip)
        error.remove
      end
    end

    def self.schema_validate(xml, schema, properties)
      schema.validate(xml).each do |error|
        properties[:errors] << EdifactConverter::Message.from_syntax_error(error)
      end
    end

    def self.process_ftxs(xml)
      xml.xpath("//FTX/Elm/SubElm").each do |subelm|
        subelm.content = subelm.text.gsub(/[\+\'\:\?]/) {|s| "?#{s}"}
      end
    end

    def self.process_xftxs(xml, properties)
      xml.xpath("//XFTX").each do |xftx|
        xftx.name = "GFTX"
        xftx.children.each_slice(4) do |elms|
          new_xftx = Nokogiri::XML::Node.new "XFTX", xml
          elms.each { |elm| elm.parent = new_xftx }
          xftx << new_xftx
        end
      end
      xml.xpath("//XFTX").each do |xftx|
        XftxParser.parse xftx
      end
      xml.xpath("//GFTX").each do |gftx|
        max = gftx['maxOccurs']
        max = (max && max.to_i) || Float::INFINITY
        if gftx.children.size > max
          properties[:errors] << EdifactConverter::Message.new(
            nil,
            "Too many FTXs in segmentgroup #{gftx.parent.name}. Max allowed is #{max}, needs #{gftx.children.size} FTX."
          )
        end
        gftx.children.each do |ftx|
          gftx.before ftx
        end
        gftx.remove
      end
      xml
    end

    def self.parse_xml(xmlstr, properties)
      if xmlstr && xmlstr.is_a?(String)
        xmlstr = Nokogiri::XML(xmlstr) { |config| config.nonet }
        xmlstr.errors.each do |error|
          properties[:errors] << EdifactConverter::Message.from_syntax_error(error)
        end
        xmlstr
      else
        xmlstr
      end
    end

  end

end
