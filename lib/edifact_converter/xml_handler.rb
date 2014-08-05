require 'empty_handler'
require_relative 'Position'
require 'nokogiri'

module EdifactConverter

  class XmlHandler < EmptyHandler

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
        args << {linie: @position.line, position: @position.column}
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
      raise "BAD SYNTAX" unless @current == @document
      super
    end

    def startSegmentGroup(name, position, hidden)
      @current = XmlElement.new name.encode(Encoding::UTF_8), position, @current
      super
    end

    def endSegmentGroup
      @current = @current.parent
      super
    end

    def startSegment(name, position)
      @current = XmlElement.new name.encode(Encoding::UTF_8), position, @current
      super
    end

    def endSegment
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
      builder.doc
    end

  end

end
