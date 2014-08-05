require 'test/unit'
require 'edifact_converter/position_io'

module EdifactConverter

  class PositionIOTest < Test::Unit::TestCase
    def test_zero_at_start
      pos_io = PositionIO.new File.new "test/files/DIS20_ok.edi"
      assert_equal Position.new(0, 0), pos_io.position
    end

    def test_changes_column_on_read
      pos_io = PositionIO.new File.new "test/files/DIS20_ok.edi"
      pos_io.read 5
      assert_equal Position.new(0, 5), pos_io.position
    end

    def test_changes_line_on_read
      pos_io = PositionIO.new File.new "test/files/DIS20_ok.edi"
      pos_io.read 12
      assert_equal 1, pos_io.position.line
    end

    def test_resets_column_on_newline
      pos_io = PositionIO.new File.new "test/files/DIS20_ok.edi"
      pos_io.read 12
      assert_equal 3, pos_io.position.column
    end

    def test_decrements_column_on_unread
      pos_io = PositionIO.new File.new "test/files/DIS20_ok.edi"
      pos_io.read 12
      pos_io.unread 3
      assert_equal 0, pos_io.position.column
    end

    def test_decrements_line_on_unread
      pos_io = PositionIO.new File.new "test/files/DIS20_ok.edi"
      pos_io.read 12
      pos_io.unread 4
      assert_equal 0, pos_io.position.line
    end

    def test_restores_column_at_line_decrements
      pos_io = PositionIO.new File.new "test/files/DIS20_ok.edi"
      pos_io.read 12
      pos_io.unread 4
      assert_equal 8, pos_io.position.column
    end

  end

end
