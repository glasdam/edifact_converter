
require 'edifact_converter/edi2xml11/xml_handler'
require 'edifact_converter/edi2xml11/edi_reader'

# Refactoring work in progress

module EdifactConverter

  class Edifact

    ATTRIBUTES = [:ast, :text]

    ATTRIBUTES.each do |attribute|
      attr_accessor attribute
    end

    def initialize(options = {})
      options.each do |name, value|
        if ATTRIBUTES.include? name
          send "#{name}=", value
        else
          raise ArgumentError, 'Argument(#{name}) is not supported '
        end
      end
    end

    def parse(options = {}, &block)
      return ast unless text
      handler = EdifactConverter::EDI2XML11::XmlHandler.new
      reader = EdifactConverter::EDI2XML11::EdiReader.new handler
      reader.parse_string text, properties
      xml = handler.xml
      insert_letters xml
      self.ast = AbstractSyntaxTree.new xml
    end

    def serialize(options = {}, &block)

    end

    private

    def properties
      @properties ||= Hash.new do |hash,key|
        case key
        when :errors
          hash[key] = []
        when :warnings
          hash[key] = []
        else
          nil
        end
      end
    end

    def insert_letters(xml)
      parent = dummy_element
      xml.root.elements.each do |elm|
        parent.add_child elm
        case elm.name
        when "UNB"
          parent = xml.create_element "Brev"
          elm.add_next_sibling parent
        when "UNT"
          parent = dummy_element
        end
      end
      xml.xpath("//Brev").each { |brev| insert_letter_content brev }
    end

    def insert_letter_content(letter)
      parent = dummy_element
      letter.elements.each do |elm|
        case elm.name
        when "UNH"
          parent = elm.document.create_element "BrevIndhold"
          elm.add_next_sibling parent
          next
        when "UNT"
          parent = dummy_element
        end
        parent.add_child elm
      end
      letter.xpath("//BrevIndhold").each { |content| group_segments content }
    end

    def group_segments(content)
      parent = dummy_element
      content.elements.each do |elm|
        case elm.name
        when /S[0-9]{2}/
          parent = elm
          next
        end
        parent.add_child elm
      end
    end

    DummyElement = Struct.new :dummy do 
      def add_child(elm)
      end
    end

    def dummy_element
      @dummy_element ||= DummyElement.new
    end

  end

end
