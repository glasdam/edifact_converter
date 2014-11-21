require 'test/unit'
require 'edifact_converter'
require_relative 'log_reader_handler'


module EdifactConverter::EDI2XML

  class EdiReaderTest < Test::Unit::TestCase

    def handler
      @handler ||= LogReaderHandler.new
    end

    def reader
      @reader ||= EdiReader.new handler
    end

    def setup
      handler.startDocument
      reader.messages = []
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
      reader.parse_string(edifact, [])
      assert_equal 0, reader.messages.size
    end

    def test_missing_una
      edifact = %#TST+1'TST+2'TST+3'TST+4'TST+5'#
      reader.parse_string edifact, []
      assert_equal Position.new(0,0), reader.messages.first.position
    end

    def test_announces_segments
      edifact = %#UNA:+.? '
      TST+1'TST+2'TST+3'TST+4'TST+5'#
      reader.parse_string edifact, []
      assert_equal 5, handler.number_of(:segment)
      assert handler.balanced?
      edifact = %#TST+1'TST+2'TST+3'TST+4'TST+5'#
      handler.startDocument
      reader.parse_string edifact, []
      assert_equal 5, handler.number_of(:segment)
      assert handler.balanced?
    end

    def test_announces_elements
      edifact = %#TST+1'TST+2+2'TST+3+3:3+3'TST+4+4:4+:4'TST++5'#
      reader.parse_string edifact, []
      assert_equal 11, handler.number_of(:element)
      assert handler.balanced?
    end

    def test_passes_values
      edifact = %#UNB+1:2'
      TST+3:4+5:6:::9'#
      reader.parse_string edifact, []
      assert_equal 9, handler.number_of(:value)
    end

    def test_sends_line_and_column
      edifact = %#UNB+1:2'
      TST+3:4+5:6:::9'#
      reader.parse_string edifact, []
      assert_equal Position.new(1, 6), handler.last[:segment].position
      assert_equal Position.new(1, 14), handler.last[:element].position
      assert_equal Position.new(1, 20), handler.last[:value].position
    end

    def test_finds_illegal_escape
      edifact = %#UNB+UN?OC:3'#
      reader.parse_string edifact, []
      # Ignore warning from missing UNA
      assert_equal Position.new(0, 7), reader.messages.last.position
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
      reader.parse_string edifact, []
      assert_equal 0, reader.messages.size
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
      reader.send :parseUNA, edifile
      assert_equal 0, reader.messages.size
      assert_equal Position.new(0, edifact_ok.size), edifile.position

      edifile = PositionIO.new StringIO.new(edifact_error)
      reader.send :parseUNA, edifile
      assert_equal 1, reader.messages.size
      assert_equal Position.new(0, 0), edifile.position

    end

    def test_parseSegment
      edifact_ok = "TST+1:2+3:4'"
      edifile = PositionIO.new StringIO.new(edifact_ok)
      reader.send :parseSegment, edifile
      assert_equal 0, reader.messages.size
      assert_equal 1, handler.number_of(:segment)
      assert_equal 2, handler.number_of(:element)
      assert_equal 4, handler.number_of(:value)
      edifact_error = "TØT+1'".encode!('iso-8859-1')
      edifile = PositionIO.new StringIO.new(edifact_error)
      assert_raise EdifactConverter::EdifactError do
        reader.send :parseSegment, edifile
      end
    end

    def test_parseSegment_binary
      image_hex = ["47494638376102000200800000000000ffffff2c00000000020002000002028451003b"]
      image_data = image_hex.pack('H*')
      file = StringIO.new "".encode(Encoding::ASCII_8BIT)
      file.write "UNO+1+2+3+35:5'"
      file.write image_data
      file.write "UNP+1+2'"
      file.rewind
      file_input = PositionIO.new file
      reader.send :parseSegment, file_input
      assert handler.balanced?
      assert_equal 2, handler.number_of(:segment)
      assert_equal 5, handler.number_of(:element)
      assert_equal 6, handler.number_of(:value)
      reader.send :parseSegment, file_input
      assert handler.balanced?
      assert_equal 3, handler.number_of(:segment)
      assert_equal 7, handler.number_of(:element)
      assert_equal 8, handler.number_of(:value)
    end

    def test_parseElement
      edifact_ok = "+1:2+3:4'"
      edifile = PositionIO.new StringIO.new(edifact_ok)
      reader.send :parseElement, edifile
      assert_equal 0, reader.messages.size
      assert_equal 1, handler.number_of(:element)
      assert_equal 2, handler.number_of(:value)
      edifact_error = "TØT+1'".encode!('iso-8859-1')
      edifile = PositionIO.new StringIO.new(edifact_error)
      assert_raise EdifactConverter::EdifactError do
        reader.send :parseElement, edifile
      end
    end

    def test_parseElementWithSize
      edi_ok = "+35:5'"
      size = reader.send :parseElementWithSize, PositionIO.new(StringIO.new(edi_ok))
      assert_equal 35, size
      assert_equal 1, handler.number_of(:element)
      assert_equal 2, handler.number_of(:value)
      edi_errors = %w(35A:5' :5' +' 5' 5'5 '5)
      edi_errors.each do |edifact|
        assert_raise EdifactConverter::EdifactError do
          reader.send :parseElementWithSize, PositionIO.new(StringIO.new(edifact))
        end
      end
    end

    def test_parseValueSize
      edi_ok = "35:"
      size = reader.send :parseValueSize, PositionIO.new(StringIO.new(edi_ok))
      assert_equal 35, size
      assert_equal 1, handler.number_of(:value)
      assert_equal "35", handler.last[:value].value
      edi_errors = %w(35A: ')
      edi_errors.each do |edifact|
        assert_raise EdifactConverter::EdifactError do
          reader.send :parseValueSize, PositionIO.new(StringIO.new(edifact))
        end
      end
    end

    def test_parseValue
      edifact_ok = "1:2'"
      edifile = PositionIO.new StringIO.new(edifact_ok)
      reader.send :parseValue, edifile
      assert_equal 0, reader.messages.size
      assert_equal 1, handler.number_of(:value)
      assert_equal "1", handler.last[:value].value
      edifact_error = "?1:2'"
      edifile = PositionIO.new StringIO.new(edifact_error)
      reader.send :parseValue, edifile
      assert_equal 1, reader.messages.size
    end

    def test_escape
      escapable = reader.send :escape, '?', Position.new
      assert_equal '?', escapable
      assert_equal 0, reader.messages.size
      char = 'ø'.encode('iso-8859-1')
      escapable = reader.send :escape, char, Position.new
      assert_equal char, escapable
      assert_equal 1, reader.messages.size      
    end

    def test_eatCrap
      edifact = " \n \t \r 1"
      edifile = PositionIO.new StringIO.new(edifact)
      reader.send :eatCrap, edifile
      assert_equal Position.new(1, 5), edifile.position
    end

    def test_parseBinary
      edi_ok = "Hello World!:'+"
      edi_file = PositionIO.new(StringIO.new(edi_ok))
      reader.send :parseBinary, edi_file, edi_ok.size
      assert handler.balanced?
      assert_equal Base64.encode64(edi_ok), handler.last[:value].value
      assert_equal 1, handler.number_of(:segment)
      assert_equal 1, handler.number_of(:element)
      assert_equal 1, handler.number_of(:value)
      edi_file = PositionIO.new(StringIO.new(edi_ok))
      assert_raise EdifactConverter::EdifactError do
        reader.send :parseBinary, edi_file, edi_ok.size + 23
      end
    end

    def test_throws_edifact_error_when_wrong_encoding
      #        assert_raise EdifactError do
      #          reader.parse 'test/files/DIS20_ERROR_ENC0.edi'
      #        end
      #  Dont do anything...
    end

  end

end
