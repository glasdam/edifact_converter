require 'test/unit'
require 'edifact_converter'

module EdifactConverter::EDI2XML

  class EdifactConverterTest < Test::Unit::TestCase

    EdifactConverter::Configuration.load

    def setup  
    end

    def test_edifact_to_xml
      #p Dir.pwd
      #p "#{File.dirname(__FILE__)}/files/edifact/*"
      return
      Dir.glob "#{File.dirname(__FILE__)}/files/edifact/*" do |filename|
        xml11 = nil
        messages = []
        assert_nothing_raised message="XML1-1 failed for #{filename}" do 
          xml11 = EdifactConverter::EDI2XML.convert(EdifactConverter.read_file(filename), messages)
        end
        assert_equal [], messages, "XML1-1 failed for #{filename}"
        xml = nil
        assert_nothing_raised message="XML failed for #{filename}" do 
          xml = EdifactConverter::XML11.to_xml(xml11, messages)
        end
        assert_equal [], messages, "XML failed for #{filename}"
      end 
    end

    def test_xml_to_edifact
      #p Dir.pwd
      #p "#{File.dirname(__FILE__)}/files/edifact/*"
      Dir.glob "#{File.dirname(__FILE__)}/files/xml/*" do |filename|
        next if File.directory?(filename)
        xml11 = nil
        messages = []
        xml = Nokogiri::XML(EdifactConverter.read_file(filename)) { |config| config.nonet }
        EdifactConverter.xml_parse_errors xml, messages
        assert_equal [], messages, "XML parsing failed for #{filename}"
        assert_nothing_raised message="XML1-1 failed for #{filename}" do 
          xml11 = EdifactConverter::XML11.from_xml(xml, messages)
        end
        assert_equal [], messages, "XML1-1 failed for #{filename}"
        edifact = ""
        p "Final part for #{filename}"
        assert_nothing_raised message="Edifact failed for #{filename}" do 
          edifact = EdifactConverter::XML2EDI.convert(xml11, messages)
        end
        assert_equal [], messages, "Edifact failed for #{filename}"
        edi_file = "#{File.dirname(__FILE__)}/files/edifact/#{File.basename(filename,'.*')}.edi"
        #p edi_file
        edi_text = EdifactConverter.read_file(edi_file).gsub(/[\n\r]/, '')  
        #p edi_text
        #p edifact
        assert_equal edi_text, edifact.encode("iso-8859-1")
      end 
    end

  end

end