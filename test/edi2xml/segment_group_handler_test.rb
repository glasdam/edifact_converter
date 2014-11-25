require 'test/unit'
require 'edifact_converter'
require_relative 'log_reader_handler'


module EdifactConverter::EDI2XML

  class SegmentGroupHandlerTest < Test::Unit::TestCase

    def log_handler
      @log_handler ||= LogReaderHandler.new
    end

    def handler
      @handler ||= SegmentGroupHandler.new log_handler
    end

    def reader
      @reader ||= EdiReader.new handler
    end

    def setup
      handler.startDocument
      reader.messages = []
    end

    def test_startSegmentGroup
      assert not(handler.indhold?)
      handler.startSegmentGroup 'BrevIndhold', "Pos", true
      assert handler.indhold?
      assert_equal 1, log_handler.number_of(:segment_group)
    end

    def test_endSegmentGroup
      assert handler.open_groups.empty?
      handler.startSegmentGroup 'Unused', "Pos", true
      handler.startSegment 'S01', 'Pos'
      assert handler.open_groups.empty?
      assert_equal 1, log_handler.number_of(:segment)
      assert_equal 1, log_handler.number_of(:segment_group)
      handler.endSegment 'S01'
      handler.endSegmentGroup 'Unused'
      handler.startSegmentGroup 'BrevIndhold', "Pos", true
      assert handler.open_groups.empty?
      assert_equal 1, log_handler.number_of(:segment)
      assert_equal 2, log_handler.number_of(:segment_group)
      handler.startSegment 'S01', 'Pos'
      assert_equal 1, handler.open_groups.size
      assert_equal 1, log_handler.number_of(:segment)
      assert_equal 3, log_handler.number_of(:segment_group)
      handler.endSegment 'S01'
      assert_equal 1, handler.open_groups.size
      assert_equal 1, log_handler.number_of(:segment)
      assert_equal 3, log_handler.number_of(:segment_group)
      assert handler.indhold?
      assert_equal 1, handler.open_groups.size
      handler.endSegmentGroup 'BrevIndhold'
      assert handler.open_groups.empty?
      assert log_handler.balanced?
    end

    def test_startSegment_and_endSegment
      assert handler.open_groups.empty?
      handler.startSegmentGroup 'Root', 'Pos', true
      handler.startSegment 'S01', 'Pos'
      assert handler.open_groups.empty?
      handler.endSegment 'S01'
      handler.startSegmentGroup 'BrevIndhold', 'Pos', true
      handler.startSegment 'SS1', 'Pos'
      handler.endSegment 'SS1'
      assert handler.open_groups.empty?
      handler.startSegment 'S01', 'Pos'
      handler.endSegment 'S01'
      assert_equal 1, handler.open_groups.size
      handler.startSegment 'TST', 'Pos'
      handler.endSegment 'TST'
      assert_equal 1, handler.open_groups.size
      handler.endSegmentGroup 'BrevIndhold'
      assert handler.open_groups.empty?
      handler.endSegmentGroup 'Root'
      assert log_handler.balanced?
      assert_equal 3, log_handler.number_of(:segment_group)
      assert_equal 3, log_handler.number_of(:segment)
    end

  end

end