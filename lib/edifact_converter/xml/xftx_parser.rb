require 'edifact_converter/xml'

module EdifactConverter::XML

  class XftxParser

    attr_accessor :paragraphs, :code, :xftx

    def self.parse(xftx_node)
      self.new(xftx_node).transform_xftx
    end

    def initialize(xftx_node)
      self.paragraphs = [Paragraph.new]
      self.xftx = xftx_node
    end

    def transform_xftx
      self.code = xftx.children[0].children[0].text
      transform_content xftx.children[3].children[0]
      pack_paragraphs
      to_ftx
    end

    def transform_content(subelm)
      subelm.children.each do |node|
        case node.node_type
        when Nokogiri::XML::Node::TEXT_NODE
          paragraphs.last.add_text node.text
        when Nokogiri::XML::Node::ELEMENT_NODE
          transform_element node
        end
      end
    end

    def transform_element(element)
      case element.name
      when 'Break'
        paragraphs.last.add_break
        return
      when 'Space'
        paragraphs.last.add_text ' '
        return
      when 'Center'
        set_alignment(Paragraph::CENTER) { transform_content element }
      when 'Right'
        set_alignment(Paragraph::RIGHT) { transform_content element }
      when 'Bold'
        set_style(Paragraph::BOLD) { transform_content element }
      when 'Italic'
        set_style(Paragraph::ITALIC) { transform_content element }
      when 'Underline'
        set_style(Paragraph::UNDERLINE) { transform_content element }
      when 'FixedFont'
        set_font(Paragraph::MONOSPACE) { transform_content element }
      else
        throw RuntimeError "Unknown xftx #{element.name}"
      end
    end

    def set_alignment(alignment)
      push_paragraph do |previous, paragraph|
        paragraph.format = alignment
        paragraph.add_break unless previous.end_breaks?
        yield
        paragraphs.last.add_break
      end
    end

    def set_font(font)
      push_paragraph do |previous, paragraph|
        paragraph.font = font
        yield
      end
    end

    def set_style(style)
      push_paragraph do |previous, paragraph|
        paragraph.format = style
        yield
      end
    end

    def push_paragraph
      previous = paragraphs.last
      paragraphs << current = previous.empty_copy
      yield previous, current
      paragraphs << previous.empty_copy
    end

    def pack_paragraphs
      paragraphs.reject! { |paragraph| paragraph.empty? }
      paragraphs.inject(nil) do |previous, current|
        if previous and not(previous.texts?)
          previous.content.delete_if do |elm|
            current.add_start_break elm
            true
          end
        end
      end
      paragraphs.reject! { |paragraph| paragraph.empty? }
    end

    def to_s
      text = "#{code}:\n"
      paragraphs.each do |paragraph|
        text << paragraph.to_s
      end
      text
    end

    FTXElm = Struct.new(:code, :format, :texts) do
      def insert_before(node)
        ftx =  Nokogiri::XML::Node.new "FTX", node.document
        Nokogiri::XML::Builder.with(ftx) do |xml|
          xml.Elm { xml.SubElm code }
          xml.Elm { xml.SubElm format }
          xml.Elm
          xml.Elm {
            texts.each do |text|
              xml.SubElm text
            end
          }
        end
        node.add_previous_sibling ftx
      end
    end

    def to_ftx()
      ftxs = []
      paragraphs.delete_if do |paragraph|
        next_paragraph = paragraphs[1]
        texts = paragraph.to_subelms(paragraphs[1])
        texts.each_slice(5) do |content|
          if content.size < 5 and next_paragraph
            while content.size < 5 and next_paragraph.start_breaks?
              content << "."
              next_paragraph.remove_start_break
            end
          end
          ftxs << FTXElm.new(code, paragraph.ftx_format, content)
        end
        true
      end
      ftxs.each do |ftx|
        ftx.insert_before(xftx)
      end
      xftx.remove
    end

  end

end
