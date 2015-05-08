require 'edifact_converter/xml'

module EdifactConverter::XML

  class Paragraph
    MONOSPACE = 'F'
    PROPOTIONAL = 'P'
    CENTER = 'M'
    RIGHT = 'H'
    BOLD = 'F'
    UNDERLINE = 'U'
    ITALIC = 'K'
    NORMAL = 'Normal'

    attr_accessor :font, :format, :content

    Break = Struct.new(:break) do
      def break?
        true
      end
    end

    Text = Struct.new(:value) do
      def break?
        false
      end
    end

    def initialize()
      self.font = PROPOTIONAL
      self.format = NORMAL
    end

    def remove_start_break
      content.shift if start_breaks?
    end

    def start_breaks?
      content.first.break? if content.any?
    end

    def add_start_break(text_break)
      content.unshift text_break
    end

    def add_end_break(text_break)
      content.push text_break
    end

    def remove_end_break
      content.shift if end_breaks?
    end

    def end_breaks?
      content.last.break? if content.any?
    end

    def add_text(text)
      content.push Text.new(text)
    end

    def add_break
      content.push Break.new
    end

    def empty?
      content.empty?
    end

    def content
      @content ||= []
    end

    def texts?
      content.index { |obj| not obj.break? }
    end

    def empty_copy
      copy = Paragraph.new
      copy.format = format
      copy.font = font
      copy
    end

    def ftx_format
      text = "#{font}"
      text << case format
      when NORMAL
        '00'
      when CENTER
        '0M'
      when RIGHT
        '0H'
      when BOLD
        'F0'
      when ITALIC
        'K0'
      when UNDERLINE
        'U0'
      else
        '00'
      end
    end

    def to_subelms(next_paragraph)
      texts = []
      text = StringIO.new
      content_clone = content.clone
      content_clone.delete_if do |obj|
        if obj.break?
          text.write '.' if text.size == 0
          texts << text.string
          text.string = ""
        else
          text.string = divide_text(obj.value) { |t| texts << t }
        end
        true
      end
      text.seek text.size
      if text.size > 0
        if next_paragraph
          if next_paragraph.start_breaks?
            next_paragraph.remove_start_break
          else
            if text.size == 70
              last = text.chars.last
              text.seek 69
              text.write('\\')
              texts << text.string
              text.string = "#{last}"
              text.seek text.size
            end
            text.write('\\')
          end
        end
        texts << text.string
        text.string = ''
      end
      texts
    end

    def divide_text(value, &block)
      chars = value.encode("iso-8859-1").chars
      text = StringIO.new
      text.set_encoding("iso-8859-1")
      chars = chars.reject do |c|
        if text.size == 69 and chars.count > 1
          text.string = insert_split(text, &block)
        end
        text.seek text.size
        text.write c
        true
      end
      text.string.encode "UTF-8"
    end

    def insert_split(text)
      index = text.string.rindex(/[\s]/)
      if index and index > 2
        yield "#{text.string[0..(index)]}\\".encode "UTF-8"
        text.string[(index+1)..-1]
      else
        text.write '\\'
        yield text.string.encode "UTF-8"
        ''
      end
    end

    def to_s
      txt = "<#{ftx_format}:"
      content.each do |obj|
        if obj.break?
          txt << "\n"
        else
          txt << obj.value
        end
      end
      txt << ">"
    end

  end

end
