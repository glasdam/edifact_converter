require 'test/unit'
require 'edifact_converter/empty_handler'
require 'edifact_converter/from_edi/edi_reader'

module EdifactConverter

  class EdiReaderTest < Test::Unit::TestCase

    class TestReaderHandler < EmptyHandler
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
      def endSegment
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
      assert_equal nil, reader.parse("test/files/DIS20_ok.edi")
      assert_equal nil, reader.parse("test/files/DIS20_ok_UNA.edi")
    end

    def test_announces_segments
      reader.parse "test/files/DIS20_ok.edi"
      assert_equal( 28, handler.number_of_startsegments)
      assert_equal(handler.number_of_endsegments, handler.number_of_startsegments)
      reader.parse "test/files/DIS20_ok_UNA.edi"
      assert_equal 28, handler.number_of_startsegments
      assert_equal handler.number_of_endsegments, handler.number_of_startsegments
    end

    def test_announces_elements
      reader.parse "test/files/DIS20_ok.edi"
      assert_equal 56, handler.number_of_startelements
      assert_equal handler.number_of_startelements, handler.number_of_endelements
    end

    def test_passes_values
      reader.parse "test/files/DIS20_ok.edi"
      assert_not_equal 0, handler.number_of_values
    end

    def test_sends_line_and_column
      reader.parse "test/files/DIS20_ok.edi"
      assert_equal Position.new(28, 0), handler.last_segment_position
      assert_equal Position.new(28, 5), handler.last_element_position
      assert_equal Position.new(28, 6), handler.last_value_position
    end

    def test_throws_edifact_error_when_bad_syntax
      assert_raise EdifactError do
        reader.parse 'test/files/DIS20_ERROR_SYNTAX0.edi'
      end
      assert_raise EdifactError do
        reader.parse 'test/files/DIS20_ERROR_SYNTAX1.edi'
      end
      assert_raise EdifactError do
        reader.parse 'test/files/DIS20_ERROR_SYNTAX2.edi'
      end
      assert_raise EdifactError do
        reader.parse 'test/files/DIS20_ERROR_SYNTAX3.edi'
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
