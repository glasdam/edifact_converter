require 'test/unit'
require 'edifact_converter/edi2xml/position_io'

module EdifactConverter::EDI2XML

  class PositionIOTest < Test::Unit::TestCase

    attr_accessor :text_input, :space_input
    def setup
      self.text_input = PositionIO.new StringIO.new %#Løne 1
Line2
Line3#.encode(Encoding::ISO_8859_1)
      self.space_input = PositionIO.new StringIO.new " \t \t  \n \r "
    end

    def test_zero_at_start
      assert_equal Position.new(0, 0), text_input.position
      assert_equal Position.new(0, 0), space_input.position
    end

    def test_changes_column_on_read
      text_input.read 5
      assert_equal Position.new(0, 5), text_input.position
      space_input.read 5
      assert_equal Position.new(0, 5), space_input.position
    end

    def test_changes_line_on_read
      text_input.read 7
      assert_equal 1, text_input.position.line
      space_input.read 7
      assert_equal 1, space_input.position.line
    end

    def test_resets_column_on_newline
      text_input.read 7
      assert_equal Position.new(1, 1), text_input.position
      space_input.read 7
      assert_equal Position.new(1, 1), space_input.position
    end

    def test_decrements_column_on_unread
      text_input.read 5
      text_input.unread 2
      assert_equal Position.new(0, 3), text_input.position
      space_input.read 5
      space_input.unread 2
      assert_equal Position.new(0, 3), space_input.position
    end

    def test_decrements_line_on_unread
      text_input.read 7
      text_input.unread 2
      assert_equal Position.new(0, 5), text_input.position
      space_input.read 7
      space_input.unread 2
      assert_equal Position.new(0, 5), space_input.position
    end

    def test_spaces
      space_input.read 6
      assert_equal Position.new(0, 6), space_input.position
      assert_equal Position.new(0, 6), space_input.position
      space_input.read #It filters newlines out of result
      assert_equal Position.new(1, 1), space_input.position
    end

    def test_binary
      image_hex = ["47494638376102000200800000000000ffffff2c00000000020002000002028451003b"]
      image_data = image_hex.pack('H*')
      file = StringIO.new "".encode(Encoding::ASCII_8BIT)
      file.write "UNO+1+AID:5051D8515CAC4F6980E1F4BC6B86BF62+OBJ:IMG:GIF:91+35:14:1:A'"
      file.write image_data
      file.write "UNP+32+1'"
      file.rewind
      file_input = PositionIO.new file
      file_input.read(68)
      assert_equal Position.new(0, 68), file_input.position
      read_data = file_input.binread(image_data.size)
      assert_equal image_hex, read_data.unpack('H*')
      assert_equal Position.new(0, 68+image_data.size), file_input.position
      assert_equal 'U', file_input.read
    end

  end

end
