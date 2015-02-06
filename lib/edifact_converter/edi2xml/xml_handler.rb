require 'edifact_converter/edi2xml'
require 'nokogiri'

module EdifactConverter::EDI2XML

  class XmlHandler < EdifactConverter::EmptyHandler

    attr_accessor :current, :document

    class XmlElement
      attr_accessor :name, :children, :text, :position, :parent
      def initialize(name, position, parent = nil)
        self.name = name
        self.position = position
        self.children = []
        self.parent = parent
        self.parent.children << self if @parent
      end

      def render(xml)
        args = []
        args << text if text
        unless EdifactConverter::Configuration.hide_position?
          args << {linie: position.line, position: position.column} 
        end
        xml.send(name, *args) do |newxml|
          children.each do |child|
            child.render xml
          end
        end
      end
    end

    def startDocument
      self.document = self.current = XmlElement.new 'Edifact', Position.new(0, 0)
      super
    end

    def endDocument
      unless current == document
        raise EdifactConverter::EdifactError.new "Internal Error, please report to jacob@medware.dk", Position.new(0,0)
      end
      super
    end

    def startSegmentGroup(name, position, hidden)
      self.current = XmlElement.new name.encode(Encoding::UTF_8), locator.position, current
      super
    end

    def endSegmentGroup(name)
      self.current = current.parent
      super
    end

    def startSegment(name)
      self.current = XmlElement.new name.encode(Encoding::UTF_8), locator.position, current
      super
    end

    def endSegment(name)
      self.current = self.current.parent
      super
    end

    def startElement
      self.current = XmlElement.new 'Elm', locator.position, current
      super
    end

    def endElement
      self.current = current.parent
      super
    end

    def value(value)
      val = XmlElement.new 'SubElm', locator.position, current
      val.text = value.encode(Encoding::UTF_8)
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
