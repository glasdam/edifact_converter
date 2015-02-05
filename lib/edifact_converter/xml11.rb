require 'edifact_converter'
require 'edifact_converter/xml11/xftx_parser'
require 'edifact_converter/xml11/paragraph'

module EdifactConverter::XML11

  def self.from_xml(xml)
    return unless xml and xml.root
    namespace = xml.root.namespace
    schema_validate(xml)
    xslt = EdifactConverter::Configuration.xml2edi(namespace.href)
    xml11 = xslt.transform(xml)
    xml11.encoding = "ISO-8859-1"
    extract_errors(xml11)
    process_ftxs xml11
    xml11 = process_xftxs xml11
  end

  def self.to_xml(xml11)
    return unless xml11 and xml11.root
    type = xml11.xpath("/Edifact/Brev[1]/UNH[1]/Elm[2]/SubElm[1]")
    version = xml11.xpath("/Edifact/Brev[1]/UNH[1]/Elm[2]/SubElm[5]")
    type = type && type.text
    version = version && version.text
    xslt = EdifactConverter::Configuration.edi2xml(type, version)
    xml = xslt.transform(xml11)
    extract_errors(xml)
    schema_validate(xml)
    xml
  end

  def self.process_ftxs(xml)
    xml.xpath("//FTX/Elm/SubElm").each do |subelm|
      subelm.content = subelm.text.gsub(/[\+\'\:\?]/) {|s| "?#{s}"}
    end
  end

  def self.process_xftxs(xml)
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
        EdifactConverter.properties[:errors] << EdifactConverter::Message.new(
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

  def self.extract_errors(xml)
    xml.xpath("//FEJL").each do |error|
      EdifactConverter.properties[:errors] << EdifactConverter::Message.new(nil, error.content)
      error.remove
    end
  end

  def self.schema_validate(xml)
    namespace = xml.root.namespace
    # TODO namespace may be nil, perhaps it is crap
    xsd = EdifactConverter::Configuration.schema(namespace.href)
    xsd.validate(xml).each do |error|
      EdifactConverter.properties[:errors] << EdifactConverter::Message.from_syntax_error(error)
    end
  end

end
