
module EdifactConverter

  class PositionIO
    attr_accessor :file, :lines, :line, :column

    def initialize(file)
      @file = file
      @column = @line = 0
      @lines = []
    end

    def read(amount = 1)
      text = ''
      while(amount > 0)
        nextchar = @file.getc
        raise EOFError.new unless nextchar
        case nextchar
        when /\n/
          @lines[@line] = @column
          @line += 1
          @column = 0
        when /\r/
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

    def position
      Position.new @line, @column
    end

    def close
      @file.close
    end

  end

end
