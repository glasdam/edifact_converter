require 'edifact_converter'
require 'edifact_converter/xml11/xftx_parser'
require 'edifact_converter/xml11/paragraph'

module EdifactConverter::XML11

  def self.from_xml(xml, messages = [])
    namespace = xml.root.namespace
    xslt = EdifactConverter::Configuration.xml2edi(namespace.href)
    xml11 = xslt.transform(xml)
    xml11.encoding = "ISO-8859-1"
    extract_errors(xml11, messages)
    xml = process_xftxs xml11, messages
    p messages
    xml
  end

  def self.to_xml(xml11, messages = [])
    type = xml11.xpath("/Edifact/Brev[1]/UNH[1]/Elm[2]/SubElm[1]")
    version = xml11.xpath("/Edifact/Brev[1]/UNH[1]/Elm[2]/SubElm[5]")
    type = type && type.text
    version = version && version.text
    xslt = EdifactConverter::Configuration.edi2xml(type, version)
    xml = xslt.transform(xml11)
    extract_errors(xml, messages)
    xml
  end

  def self.process_xftxs(xml, messages)
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
      max = (max && max.to_i / 2) || Float::INFINITY
      if gftx.children.size > max
        messages << EdifactConverter::Message.new(
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

  def self.extract_errors(xml, messages)
    xml.xpath("//FEJL").each do |error|
      messages << EdifactConverter::Message.new(nil, error.content)
      error.remove
    end
  end

end
