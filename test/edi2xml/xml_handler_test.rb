require 'test/unit'
require 'edifact_converter'
require 'equivalent-xml'


module EdifactConverter::EDI2XML

  class XmlHandlerTest < Test::Unit::TestCase

    def test_matches_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'ISO-8859-1') do |xml|
        xml.Edifact linie: 0, position: 0 do
          xml.S01 linie: 1, position: 0 do
            xml.Elm linie: 1, position: 3 do
              xml.SubElm "01", linie: 1, position: 4
            end
            xml.UNB linie: 2, position: 0 do
              xml.Elm linie: 2, position: 4 do
                xml.SubElm "UNOC", linie: 2, position: 5
                xml.SubElm "3", linie: 2, position: 9
              end
              xml.Elm linie: 2, position: 11 do
                xml.SubElm "5790000143054", linie: 2, position: 12
                xml.SubElm "14", linie: 2, position: 26
              end
            end
          end
        end
      end
      handler = XmlHandler.new
      handler.startDocument
      handler.startSegmentGroup "S01", Position.new(1, 0), false
      handler.startElement Position.new(1, 3)
      handler.value "01", Position.new(1, 4)
      handler.endElement
      handler.startSegment "UNB", Position.new(2, 0)
      handler.startElement Position.new(2, 4)
      handler.value "UNOC", Position.new(2, 5)
      handler.value "3", Position.new(2, 9)
      handler.endElement
      handler.startElement Position.new(2, 11)
      handler.value "5790000143054", Position.new(2, 12)
      handler.value "14", Position.new(2, 26)
      handler.endElement
      handler.endSegment 'UNOC'
      handler.endSegmentGroup 'S01'
      handler.endDocument
      #puts handler.xml.to_xml

      assert EquivalentXml.equivalent?(handler.xml.root, builder.doc.root)
    end

    def test_bad_syntax_error
      handler = XmlHandler.new
      handler.startDocument
      handler.startSegment "UNB", Position.new(2, 0)
      handler.startElement Position.new(2, 4)
      handler.value "UNOC", Position.new(2, 5)
      handler.value "3", Position.new(2, 9)
      #handler.endElement
      handler.startElement Position.new(2, 11)
      handler.value "5790000143054", Position.new(2, 12)
      handler.value "14", Position.new(2, 26)
      handler.endElement
      handler.endSegment 'UNB'
      assert_raise EdifactConverter::EdifactError do
        handler.endDocument
      end
    end

  end

end
