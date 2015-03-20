require 'nokogiri'
require 'edifact_converter'
require 'edifact_converter/edi2xml11'

module EdifactConverter

  class Converter

    def convert(text, &proc)
      self.error_proc = proc || Proc.new { |msg| STDERR.puts msg }
      xml = Nokogiri::XML(text)
      if xml.errors.empty?
        convert_xml(xml)
      else
        convert_edifact(text)
      end
    end

    private

    attr_accessor :error_proc

    def convert_edifact(text)
      handler = EdifactConverter::EDI2XML11::XmlHandler.new
      reader = EdifactConverter::EDI2XML11::EdiReader.new handler
      reader.parse_string text, properties
      puts handler.xml
    end

    def convert_xml(xml)

    end

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


  end

end
