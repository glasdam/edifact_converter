require 'test/unit'
require 'edifact_converter'

module EdifactConverter::EDI2XML11

  class EdifactConverterTest < Test::Unit::TestCase

    def setup
    end

    def test_edifact_to_xml
      Dir.glob "#{File.dirname(__FILE__)}/files/edifact/*" do |filename|
        next if File.directory?(filename)
        result = nil
        #EdifactConverter.convert_edifact(EdifactConverter.read_file(filename))
        assert_nothing_raised message="XML failed for #{filename}" do
          result = EdifactConverter.convert_edifact(EdifactConverter.read_file(filename))
        end
        #        assert result[:errors].empty?, "XML failed for #{filename}"
        #        assert_nothing_raised message="XML failed for #{filename}" do
        #          xml = EdifactConverter::XML11.to_xml(xml11)
        #        end
        assert result.properties[:errors].empty?, "XML failed for #{filename} with errors #{result.properties[:errors].map(&:text).join(' - ')} "
        assert result.properties[:warnings].empty?, "XML failed for #{filename} with warnings #{result.properties[:warnings].map(&:text).join(' - ')} "
      end
    end

    def test_xml_to_edifact
      Dir.glob "#{File.dirname(__FILE__)}/files/xml/*" do |filename|
        next if File.directory?(filename)
        result = nil
        EdifactConverter.convert_xml(EdifactConverter.read_file(filename))
        assert_nothing_raised message="XML1-1 failed for #{filename}" do
          result = EdifactConverter.convert_xml(EdifactConverter.read_file(filename))
        end
        assert result.properties[:errors], "XML parsing failed for #{filename}"
        assert result.properties[:warnings], "XML parsing failed for #{filename}"

        edi_file = "#{File.dirname(__FILE__)}/files/edifact/#{File.basename(filename,'.*')}.edi"
        edi_text = if File.basename(filename) =~ /^BIN/
          File.open edi_file, 'rb:ASCII-8BIT' do |file|
            file.read
          end
        else
          EdifactConverter.read_file(edi_file).gsub(/[\n\r]/, '')
        end
        max = [edi_text.size, result.edifact.size].max
        step = 50
        (0..max).step(step) do |start|
          assert_equal edi_text[start, step], result.edifact[start, step], "EDI failed for #{filename}." #.encode("iso-8859-1")
        end
      end
    end

  end

end
