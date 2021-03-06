require 'edifact_converter'
require 'edifact_converter/xml/paragraph'
require 'edifact_converter/xml/xftx_parser.rb'

module EdifactConverter

  module XML

    def self.xml_to_xml11(xml, properties)
      xml = parse_xml(xml, properties)
      if xml.nil? or xml.root.nil?
        properties[:errors] << EdifactConverter::Message.new(text: "Mangel fuldt XML dokument, konvertering stoppet", source: :xml)
        return
      end
      properties[:namespace] = xml.root.namespace && xml.root.namespace.href
      rules = EdifactConverter::Configuration.xml_rules(properties[:namespace])
      if rules.nil?
        properties[:errors] << EdifactConverter::Message.new(text: "Ingen regler for konverteringen af #{properties[:namespace]}", source: :xml)
        return nil
      end
      schema_validate(xml, rules.schema, properties)
      xml11 = rules.from_xml.transform(xml)
      xml11.encoding = "ISO-8859-1"
      extract_errors(xml11, properties)
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
        properties[:errors] << EdifactConverter::Message.new(text: "Ingen regler for konverteringen af #{properties[:type]} - #{properties[:version]}", source: :xml)
        return nil
      end
      xml = rules.to_xml.transform(xml11)
      xml.encoding = "ISO-8859-1"
      extract_errors(xml, properties, :edifact)
      schema_validate(xml, rules.schema, properties)
      xml
    end

    def self.extract_errors(xml, properties, source = :xml)
      xml.xpath("//*[local-name() = 'FEJL']").each do |error|
        position = EDI2XML11::Position.new error['linie'], error['position']
        properties[:errors] << Message.new(position: position, text: error.content.strip, source: source)
        error.remove
      end
    end

    def self.schema_validate(xml, schema, properties)
      schema.validate(xml).each do |error|
        properties[:errors] << EdifactConverter::Message.from_syntax_error(error)
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
      process_gftxs xml, properties
      xml.xpath("//S12").each do |s12|
        split_group s12, properties
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

    def self.process_gftxs(xml, properties)
      xml.xpath("//GFTX").each do |gftx|
        max = gftx['maxOccurs']
        max = (max && max.to_i) || Float::INFINITY
        max = Float::INFINITY if gftx.parent['maxOccurs']
        if gftx.children.size > max
          properties[:errors] << EdifactConverter::Message.new(
            text: "Too many FTXs in segmentgroup #{gftx.parent.name}. Max allowed is #{max}, needs #{gftx.children.size} FTX."
          )
        end
        gftx.children.each do |ftx|
          gftx.before ftx
        end
        gftx.remove
      end
    end

    def self.split_group(group, properties)
      max = group['maxOccurs']
      max = (max && max.to_i) || Float::INFINITY
      ftxs = group.xpath("FTX")
      ftxs.each { |ftx| ftx.unlink }
      ftxgroups = ftxs.each_slice(10).to_a
      if ftxgroups.size > max
        properties[:errors] << EdifactConverter::Message.new(
          text: "Too many FTXs in segmentgroup #{group.name}. Max allowed is #{max * 10}, needs #{ftxs.size} FTXs."
        )
      end
      previous = group.previous_element
      group.unlink
      ftxgroups.reverse.each do |ftxs|
        new_group = group.dup
        ftxs.each { |ftx| new_group << ftx }
        previous.add_next_sibling new_group
      end
    end

  end

end
