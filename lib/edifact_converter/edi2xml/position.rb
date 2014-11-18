module EdifactConverter::EDI2XML

  class Position
    attr_reader :line, :column

    def initialize(line = 0, column = 0)
      @line, @column = line, column
    end

    def ==(other)
      @line == other.line and @column == other.column
    end

    def to_s
      "At line #{@line}, column #{@column}"
    end

  end

end
