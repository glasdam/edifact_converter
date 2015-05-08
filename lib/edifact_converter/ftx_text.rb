module EdifactConverter

  class FTXText

    Line = Struct.new(:align) do

      def texts
        @texts ||= []
      end

      def texts=(texts)
        @texts = texts
      end

      def ==(line)
        align == line.align and texts == line.texts
      end

      def to_s
        txt = "#{align}:\t"
        texts.each do |text|
          txt << text.to_s
        end
        txt
      end

    end

    Text = Struct.new(:format, :font, :text) do

      def merge(text)
        self.text << text.text
        self
      end

      def ==(text)
        format == text.format and font == text.font and self.text == text.text
      end

      def to_s
        "(#{font} #{format})#{text}"
      end

    end

    attr_accessor :current_line

    def lines
      @lines ||= []
    end

    def self.parse(ftxs)
      self.new ftxs
    end

    def initialize(ftxs)
      ftxs.each do |ftx|
        font, format, align = extract_style ftx
        ftx.xpath('Elm[position() > 2]/SubElm/text()').each do |text|
          text = text.to_s
          continue_line = if text[-1] == '\\'
            text.chop!
            true
          end
          current_or_new_line(align).texts << Text.new(format, font, text)
          self.current_line = nil unless continue_line
        end
      end
      optimize_formatting
      pack_lines
      #lines.each { |line| puts line }
    end

    def ==(ftx_text)
      lines == ftx_text.lines
    end

    private

    def new_line(align)
      self.current_line = Line.new(align)
    end

    def current_or_new_line(align)
      if current_line and current_line.align == align
        current_line
      else
        new_line align
      end
    end

    def current_line=(line)
      lines << line if line
      @current_line = line
    end

    def extract_style(ftx)
      compressed = ftx.xpath('Elm[2]/SubElm/text()').to_s
      compressed.chars.map.with_index do |char, index|
        case char
        when 'P'
          :proportional
        when 'F'
          if index == 0
            :fixed
          else
            :bold
          end
        when 'H'
          :right
        when 'M'
          :center
        when 'U'
          :underline
        when '0'
          if index == 2
            :left
          else
            :normal
          end
        end
      end
    end

    def optimize_formatting
      start_spaces_regex = Regexp.new '^( +)'
      end_spaces_regex = Regexp.new '( +)$'
      lines.each do |line|
        line.texts.each_with_index do |text, index|
          next if text.format == :normal
          end_spaces_regex.match(text.text) do |m|
            line.texts.insert index+1, Text.new(:normal, text.font, m[0])
          end
          start_spaces_regex.match(text.text) do |m|
            line.texts.insert index, Text.new(:normal, text.font, m[0])
          end
          text.text.strip!
        end
      end
    end

    def pack_lines
      lines.each do |line|
        chunked = line.texts.chunk { |text| "#{text.format}:#{text.font}" }.map do |set|
          set[1] = set.last.reduce :merge
        end
        line.texts = chunked
      end
    end

  end

end
