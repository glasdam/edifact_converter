require 'test/unit'
require 'edifact_converter'

module EdifactConverter::XML11

  class ParagraphTest < Test::Unit::TestCase

    def text
      txt = %{Vagttab på 10 kg/ 2mdr, trathed, hudkloe og icterus. UL-scanning har afgivet mistanke om malign galdevejssygdom. Komplikationsfrit operations- og efterforlOb i afd.}
      #txt.encode("iso-8859-1")
    end

    def texts
      [
        %{Vagttab på 10 kg/ 2mdr, trathed, hudkloe og icterus. UL-scanning har \\},
        %{afgivet mistanke om malign galdevejssygdom. Komplikationsfrit \\},
        %{operations- og efterforlOb i afd.}
      ]
    end

    def setup
      @p = Paragraph.new
    end

    def test_initialize
      assert_equal Paragraph::PROPOTIONAL, @p.font
      assert_equal Paragraph::NORMAL, @p.format
    end

    def test_remove_start_break
      @p.remove_start_break
      assert @p.content.empty?
      @p.add_start_break Paragraph::Break.new
      @p.remove_start_break
      assert @p.content.empty?
      @p.add_text "text"
      @p.add_start_break Paragraph::Break.new
      @p.remove_start_break
      assert_equal 1, @p.content.size
      @p.add_break
      @p.remove_start_break
      assert_equal 2, @p.content.size
    end

    def test_start_breaks?
      assert not(@p.start_breaks?)
      @p.add_start_break Paragraph::Break.new
      assert @p.start_breaks?
    end

    def test_add_start_break
      mybreak = Paragraph::Break.new
      @p.add_text "text"
      @p.add_start_break mybreak
      assert_equal mybreak, @p.content.first
    end

    def test_add_end_break
      mybreak = Paragraph::Break.new
      @p.add_text "text"
      @p.add_end_break mybreak
      assert_equal mybreak, @p.content.last
    end

    def test_remove_end_break
      mybreak = Paragraph::Break.new
      @p.add_text "text"
      @p.add_end_break mybreak
      @p.add_break
      assert_equal mybreak, @p.content.last
    end

    def test_end_breaks?
      assert not(@p.end_breaks?)
      @p.add_break
      assert @p.end_breaks?
    end

    def test_add_text
      mytext = "Text"
      @p.add_text mytext
      assert_equal mytext, @p.content.first.value
    end

    def test_add_break
      @p.add_break
      assert @p.content.first.break?
    end

    def test_texts?
      assert not(@p.texts?)
      @p.add_break
      assert not(@p.texts?)
      @p.add_text "Text"
      assert @p.texts?
    end

    def test_empty_copy
      @p.font = Paragraph::MONOSPACE
      @p.format = Paragraph::CENTER
      @p.add_text "text"
      p = @p.empty_copy
      assert p.content.empty?
      assert_equal @p.font, p.font
      assert_equal @p.format, p.format
    end

    def test_ftx_format
      assert_equal "P00", @p.ftx_format
      @p.font = Paragraph::MONOSPACE
      @p.format = Paragraph::CENTER
      assert_equal "F0M", @p.ftx_format
    end

    def test_divide_text
      result = []
      result << @p.divide_text(text) { |txt| result << txt }      
      assert_equal 3, result.size
      3.times do |index|
        assert_equal texts[index], result[index], "Mismatch at #{index}"
      end
    end

  end

end
