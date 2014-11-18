require 'test/unit'
#require 'edifact_converter/empty_handler'
require 'edifact_converter'
#require 'edifact_converter/edi2xml/edi_reader'

module EdifactConverter::EDI2XML

  class EdiReaderTest < Test::Unit::TestCase

    class TestReaderHandler < EdifactConverter::EmptyHandler
      attr_accessor :number_of_startsegments,
        :number_of_endsegments,
        :number_of_startelements,
        :number_of_endelements,
        :number_of_values, :last_segment_position, :last_element_position, :last_value_position
      def startDocument
        @number_of_values = @number_of_startsegments = @number_of_endsegments = @number_of_startelements = @number_of_endelements = 0
      end
      def startSegment(name, position)
        @number_of_startsegments += 1
        @last_segment_position = position
        super name, position
      end
      def endSegment(name)
        @number_of_endsegments += 1
        super
      end
      def startElement(position)
        @number_of_startelements += 1
        @last_element_position = position
        super position
      end
      def endElement
        @number_of_endelements += 1
        super
      end
      def value(value, position)
        @number_of_values += 1
        @last_value_position = position
        super value, position
      end
    end

    def handler
      @handler ||= TestReaderHandler.new
    end

    def reader
      @reader ||= EdiReader.new handler
    end

    def test_parses_edifact
      edifact = %#UNA:+.? '
      UNB+UNOC:3+DKKMDKMDNET:14+5790000181872:14+991111:1850+KuvertNr1234'
      UNH+BrevNr5678+CONTRL:D:93A:ZZ:C0130Q+CTL01'
      UCI+MEDREF01095+5790000181872:14+5790000120420:14+4'
      FTX+LOK+P00++EDI-kuvert afsendt 11/11 1999 kl 18.46 har ikke kunnet modtages. :Modtagerlokationsnummer har ikke kunnet identificeres.'
      UCM+1111FRE01095+MEDREF:D:93A:UN:H0130R+4'
      UCM+1111MAN01095+MEDREF:D:93A:UN:H0130R+4'
      UNT+6+BrevNr5678'
      UNZ+1+KuvertNr1234#
      messages = []
      reader.parse_string(edifact, messages)
      assert_equal 0, messages.size
    end

    def test_missing_una
      edifact = %#TST+1'TST+2'TST+3'TST+4'TST+5'#
      messages = []
      reader.parse_string edifact, messages
      assert_equal Position.new(0,0), messages.first.position
    end

    def test_announces_segments
      edifact = %#UNA:+.? '
      TST+1'TST+2'TST+3'TST+4'TST+5'#
      reader.parse_string edifact, []
      assert_equal( 5, handler.number_of_startsegments)
      assert_equal(handler.number_of_endsegments, handler.number_of_startsegments)
      edifact = %#TST+1'TST+2'TST+3'TST+4'TST+5'#
      reader.parse_string edifact, []
      assert_equal 5, handler.number_of_startsegments
      assert_equal handler.number_of_endsegments, handler.number_of_startsegments
    end

    def test_announces_elements
      edifact = %#TST+1'TST+2+2'TST+3+3:3+3'TST+4+4:4+:4'TST++5'#
      reader.parse_string edifact, []
      assert_equal 11, handler.number_of_startelements
      assert_equal handler.number_of_startelements, handler.number_of_endelements
    end

    def test_passes_values
      edifact = %#UNB+1:2'
      TST+3:4+5:6:::9'#
      reader.parse_string edifact, []
      assert_equal 9, handler.number_of_values
    end

    def test_sends_line_and_column
      edifact = %#UNB+1:2'
      TST+3:4+5:6:::9'#
      reader.parse_string edifact, []
      assert_equal Position.new(1, 6), handler.last_segment_position
      assert_equal Position.new(1, 14), handler.last_element_position
      assert_equal Position.new(1, 20), handler.last_value_position
    end

    def test_finds_illegal_escape
      edifact = %#UNB+UN?OC:3'#
      messages = []
      reader.parse_string edifact, messages
      # Ignore warning from missing UNA
      assert_equal Position.new(0, 7), messages.last.position
    end

    def test_throws_edifact_error_when_bad_syntax
      edifacts = []
      edifacts << %#SEQ++1''UNZ+1'#
      edifacts << %#S1111'#
      edifacts << %#A?D+1'#
      edifacts << %#S1++11'#
      edifacts.each do |edifact|
        assert_raise EdifactConverter::EdifactError do
          reader.parse_string edifact, []
        end
      end
    end

    def test_binary
      edifact = %#UNA:+.? '
      UNO+1+AID:2BE66629DA66406D9E3FCD78219E1377+OBJ:IMG:TIF:91+17:14:1:A'
      HelloWorld
      UNP+1327700+1'#
      messages = []
      reader.parse_string edifact, messages
      assert_equal 0, messages.size
      edifact = %#UNA:+.? '
      UNO+1+AID:2BE66629DA66406D9E3FCD78219E1377+OBJ:IMG:TIF:91+10:14:1:A'
      HelloWorld
      UNP+1327700+1'#
      assert_raise EdifactConverter::EdifactError do
        reader.parse_string edifact, []
      end
    end

    #Test private methods

    def test_parseUNA
      edifact_ok = %#UNA:+? '#
      edifact_error = "UNP+1'"

      edifile = PositionIO.new StringIO.new(edifact_ok)
      reader.messages = []
      reader.send :parseUNA, edifile
      assert_equal 0, reader.messages.size
      assert_equal Position.new(0, edifact_ok.size), edifile.position

      edifile = PositionIO.new StringIO.new(edifact_error)
      reader.send :parseUNA, edifile
      assert_equal 1, reader.messages.size
      assert_equal Position.new(0, 0), edifile.position

    end

    def test_parseSegment
      
    end


    def test_throws_edifact_error_when_wrong_encoding
      #        assert_raise EdifactError do
      #          reader.parse 'test/files/DIS20_ERROR_ENC0.edi'
      #        end
      #  Dont do anything...
    end

  end

end
