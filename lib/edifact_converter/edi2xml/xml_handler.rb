require 'edifact_converter/edi2xml'
require 'nokogiri'

module EdifactConverter::EDI2XML

  class XmlHandler < EdifactConverter::EmptyHandler

    class XmlElement
      attr_accessor :name, :children, :text, :position, :parent
      def initialize(name, position, parent = nil)
        @name = name
        @position = position
        @children = []
        @parent = parent
        @parent.children << self if @parent
      end

      def render(xml)
        puts "Rendering #{@name}" unless @position
        args = []
        args << @text if @text
        unless EdifactConverter::Configuration.hide_position?
          args << {linie: @position.line, position: @position.column} 
        end
        xml.send(@name, *args) do |newxml|
          @children.each do |child|
            child.render xml
          end
        end
      end
    end

    def startDocument
      @document = @current = XmlElement.new 'Edifact', Position.new(0, 0)
      super
    end

    def endDocument
      unless @current == @document
        p @current.name
        raise "BAD SYNTAX" 
      end
      super
    end

    def startSegmentGroup(name, position, hidden)
      @current = XmlElement.new name.encode(Encoding::UTF_8), position, @current
      super
    end

    def endSegmentGroup(name)
      @current = @current.parent
      super
    end

    def startSegment(name, position)
      @current = XmlElement.new name.encode(Encoding::UTF_8), position, @current
      super
    end

    def endSegment(name)
      @current = @current.parent
      super
    end

    def startElement(position)
      @current = XmlElement.new 'Elm', position, @current
      super
    end

    def endElement
      @current = @current.parent
      super
    end

    def value(value, position)
      val = XmlElement.new 'SubElm', position, @current
      val.text = value.encode(Encoding::UTF_8)
      super
    end

    def xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'ISO-8859-1') do |xml|
        xml.comment "Created from Edifact at #{Time.now.utc}, with software from MedWare"
        @document.render xml
      end
      xml = builder.doc
      xml.xpath("//Elm").each do |elm|
        elm.children.last.remove if elm.children.last.content == ""
      end
      xml
    end

  end

end
