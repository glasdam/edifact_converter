require 'edifact_converter/edi2xml11'
require 'nokogiri'

module EdifactConverter::EDI2XML11

  class XmlHandler < EdifactConverter::EmptyHandler

    attr_accessor :current, :document

    class XmlElement

      ATTRIBUTES = [:name, :children, :text, :position, :parent, :position, :hidden]

      ATTRIBUTES.each do |attribute|
        attr_accessor attribute
      end

      def initialize(options)
        self.children = []
        options.each do |attribute, value|
          if ATTRIBUTES.include? attribute.to_sym
            send "#{attribute}=", value
          end
        end
        parent.children << self if parent
      end

      def render(xml)
        args = []
        args << text if text
        attributes = {}
        unless EdifactConverter::Configuration.hide_position?
          attributes[:linie] = position.line
          attributes[:position] = position.column
        end
        attributes[:hidden] = true if hidden
        args << attributes
        xml.send(name, *args) do |newxml|
          children.each do |child|
            child.render xml
          end
        end
      end
    end

    def startDocument
      self.document = self.current = XmlElement.new name: 'Edifact', position: Position.new(0, 0)
      super
    end

    def endDocument
      unless current == document
        raise EdifactConverter::EdifactError.new "Internal Error, please report to jacob@medware.dk", Position.new(0,0)
      end
      super
    end

    def startSegmentGroup(name, hidden = false)
      self.current = XmlElement.new name: name.encode(Encoding::UTF_8), position: locator.position, parent: current, hidden: hidden
      super
    end

    def endSegmentGroup(name)
      self.current = current.parent
      super
    end

    def startSegment(name)
      self.current = XmlElement.new name: name.encode(Encoding::UTF_8), position: locator.position, parent: current
      super
    end

    def endSegment(name)
      self.current = self.current.parent
      super
    end

    def startElement
      self.current = XmlElement.new name: 'Elm', position: locator.position, parent: current
      super
    end

    def endElement
      self.current = current.parent
      super
    end

    def value(value)
      XmlElement.new name: 'SubElm', position: locator.position, parent: current, text: value.encode(Encoding::UTF_8)
      #val.text = value.encode(Encoding::UTF_8)
      super
    end

    def xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'ISO-8859-1') do |xml|
        xml.comment "Created from Edifact at #{Time.now.utc}"
        document.render xml
      end
      xml = builder.doc
      xml.xpath("//Elm").each do |elm|
        elm.children.last.remove if elm.children.last.content == ""
      end
      xml
    end

  end

end
