require 'test/unit'
require 'edifact_converter'

module EdifactConverter::EDI2XML

  class EdifactConverterTest < Test::Unit::TestCase

    EdifactConverter::Configuration.load

    def setup
    end

    def test_edifact_to_xml
      Dir.glob "#{File.dirname(__FILE__)}/files/edifact/*" do |filename|
        xml11 = nil
        assert_nothing_raised message="XML1-1 failed for #{filename}" do
          xml11 = EdifactConverter::EDI2XML.convert(EdifactConverter.read_file(filename))
        end
        assert EdifactConverter.properties[:errors].empty?, "XML1-1 failed for #{filename}"
        xml = nil
        assert_nothing_raised message="XML failed for #{filename}" do
          xml = EdifactConverter::XML11.to_xml(xml11)
        end
        assert EdifactConverter.properties[:errors].empty?, "XML failed for #{filename} with errors #{EdifactConverter.properties[:errors].map(&:text).join(' - ')} "
      end
    end

    def test_xml_to_edifact
      Dir.glob "#{File.dirname(__FILE__)}/files/xml/*" do |filename|
        next if File.directory?(filename)
        xml11 = nil
        xml = Nokogiri::XML(EdifactConverter.read_file(filename)) { |config| config.nonet }
        EdifactConverter.xml_parse_errors xml
        assert EdifactConverter.properties[:errors], "XML parsing failed for #{filename}"
        assert_nothing_raised message="XML1-1 failed for #{filename}" do
          xml11 = EdifactConverter::XML11.from_xml(xml)
        end
        assert EdifactConverter.properties[:errors].empty?, "XML1-1 failed for #{filename}"
        edifact = ""
        assert_nothing_raised message="Edifact failed for #{filename}" do
          edifact = EdifactConverter::XML2EDI.convert(xml11)
        end
        assert EdifactConverter.properties[:errors].empty?, "Edifact failed for #{filename}"
        edi_file = "#{File.dirname(__FILE__)}/files/edifact/#{File.basename(filename,'.*')}.edi"
        edi_text = if File.basename(filename) =~ /^BIN/
          File.open edi_file, 'rb:ASCII-8BIT' do |file|
            file.read
          end
        else
          EdifactConverter.read_file(edi_file).gsub(/[\n\r]/, '')
        end
        max = [edi_text.size, edifact.size].max
        step = 50
        (0..max).step(step) do |start|
          assert_equal edi_text[start, step], edifact[start, step] #.encode("iso-8859-1")
        end
      end
    end

  end

end
