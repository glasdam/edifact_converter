require 'test/unit'
require 'edifact_converter'

module EdifactConverter::EDI2XML

  class PositionTest < Test::Unit::TestCase
    def test_position_line
      pos = Position.new 1, 2
      assert_equal 1, pos.line
    end

    def test_position_column
      pos = Position.new 1, 2
      assert_equal 2, pos.column
    end

  end

end
