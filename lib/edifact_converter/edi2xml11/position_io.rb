require 'edifact_converter/edi2xml11/position'

module EdifactConverter::EDI2XML11

  class PositionIO
    attr_accessor :file, :lines, :line, :column

    def initialize(file)
      @file = file
      @file.set_encoding (Encoding::ASCII_8BIT)
      @column = @line = 0
      @lines = []
    end

    def read(amount = 1)
      text = ''
      while(amount > 0)
        nextchar = @file.getc
        raise EOFError.new unless nextchar
        nextchar.encode!(Encoding::UTF_8, Encoding::ISO_8859_1) #force_encoding Encoding::ISO_8859_1
        case nextchar
        when /\n/
          @lines[@line] = @column
          @line += 1
          @column = 0
        when /\r/
          @column += 1
        else
          text << nextchar
          amount -= 1
          @column += 1
        end
      end
      text
    end

    def unread(amount = 1)
      while amount > 0
        @file.pos -= 1
        old_pos = @file.pos
        nextchar = @file.getc
        # Hack for windows
        if @file.pos - old_pos > 1
          @file.pos -= 3
          nextchar = @file.getc
        end
        @file.pos -= 1
        case nextchar
        when /\r/
        when /\n/
          @line -= 1
          @column = @lines[@line]
        else
          @column -= 1
          amount -= 1
        end
      end
    end

    def binread(amount)
      @column += amount
      @file.read amount
    end

    def position
      Position.new @line, @column
    end

    def close
      @file.close
    end

  end

end
