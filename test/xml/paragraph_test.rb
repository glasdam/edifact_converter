require 'test/unit'
require 'edifact_converter'

module EdifactConverter::XML

  class ParagraphTest < Test::Unit::TestCase

    def text1
      %{Vagttab på 10 kg/ 2mdr, trathed, hudkloe og icterus. UL-scanning har afgivet mistanke om malign galdevejssygdom. Komplikationsfrit operations- og efterforlOb i afd.}
      #txt.encode("iso-8859-1")
    end

    def text1s
      [
        %{Vagttab på 10 kg/ 2mdr, trathed, hudkloe og icterus. UL-scanning har \\},
        %{afgivet mistanke om malign galdevejssygdom. Komplikationsfrit \\},
        %{operations- og efterforlOb i afd.}
      ]
    end

    def text2
      %{paravertebralmuskulatur primært på højre side. Smerterne stråler fra lænden ned i højre lår. Smerterne centraliseres ved gentagne øvelser (centraliseringsfænomenet er ifølge Mc.Kenziekonceptet tegn på }
    end

    def text2s
      [
        %{paravertebralmuskulatur primært på højre side. Smerterne stråler fra \\},
        %{lænden ned i højre lår. Smerterne centraliseres ved gentagne øvelser \\},
        %{(centraliseringsfænomenet er ifølge Mc.Kenziekonceptet tegn på }
      ]
    end

    def paragraph
      @paragraph ||= Paragraph.new
    end

    def setup
      raise "hell" unless paragraph
    end

    def test_initialize
      assert_equal Paragraph::PROPOTIONAL, paragraph.font
      assert_equal Paragraph::NORMAL, paragraph.format
    end

    def test_remove_start_break
      paragraph.remove_start_break
      assert paragraph.content.empty?
      paragraph.add_start_break Paragraph::Break.new
      paragraph.remove_start_break
      assert paragraph.content.empty?
      paragraph.add_text "text"
      paragraph.add_start_break Paragraph::Break.new
      paragraph.remove_start_break
      assert_equal 1, paragraph.content.size
      paragraph.add_break
      paragraph.remove_start_break
      assert_equal 2, paragraph.content.size
    end

    def test_start_breaks?
      assert not(paragraph.start_breaks?)
      paragraph.add_start_break Paragraph::Break.new
      assert paragraph.start_breaks?
    end

    def test_add_start_break
      mybreak = Paragraph::Break.new
      paragraph.add_text "text"
      paragraph.add_start_break mybreak
      assert_equal mybreak, paragraph.content.first
    end

    def test_add_end_break
      mybreak = Paragraph::Break.new
      paragraph.add_text "text"
      paragraph.add_end_break mybreak
      assert_equal mybreak, paragraph.content.last
    end

    def test_remove_end_break
      mybreak = Paragraph::Break.new
      paragraph.add_text "text"
      paragraph.add_end_break mybreak
      paragraph.add_break
      assert_equal mybreak, paragraph.content.last
    end

    def test_end_breaks?
      assert not(paragraph.end_breaks?)
      paragraph.add_break
      assert paragraph.end_breaks?
    end

    def test_add_text
      mytext = "Text"
      paragraph.add_text mytext
      assert_equal mytext, paragraph.content.first.value
    end

    def test_add_break
      paragraph.add_break
      assert paragraph.content.first.break?
    end

    def test_texts?
      assert not(paragraph.texts?)
      paragraph.add_break
      assert not(paragraph.texts?)
      paragraph.add_text "Text"
      assert paragraph.texts?
    end

    def test_empty_copy
      paragraph.font = Paragraph::MONOSPACE
      paragraph.format = Paragraph::CENTER
      paragraph.add_text "text"
      p = paragraph.empty_copy
      assert p.content.empty?
      assert_equal paragraph.font, p.font
      assert_equal paragraph.format, p.format
    end

    def test_ftx_format
      assert_equal "P00", paragraph.ftx_format
      paragraph.font = Paragraph::MONOSPACE
      paragraph.format = Paragraph::CENTER
      assert_equal "F0M", paragraph.ftx_format
    end

    def test_insert_split
      texts = {
        "Hej Arne Bjarne" => ["Hej Arne \\", "Bjarne"],
        "Hej Arne_Bjarne" => ["Hej \\", "Arne_Bjarne"],
        "Hej_Arne_Bjarne" => ["Hej_Arne_Bjarne\\", ''],
        "Hej Arne Bjarne " => ["Hej Arne Bjarne \\", '']
      }
      texts.each do |text, result|
        source = StringIO.new
        source.write text
        line = ""
        source.string = paragraph.insert_split(source) { |text| line = text }  
        assert_equal result.first, line, "Wrong split for #{text}"
        assert_equal result.last, source.string, "Wrong split for #{text}"
      end
    end

    def test_divide_text
      result = []
      result << paragraph.divide_text(text1) { |txt| result << txt }      
      assert_equal 3, result.size
      3.times do |index|
        assert_equal text1s[index], result[index].encode("utf-8"), "Mismatch at #{index}"
      end
      result = []
      result << paragraph.divide_text(text2) { |txt| result << txt }      
      assert_equal 3, result.size, "Result = #{result}"
      3.times do |index|
        assert_equal text2s[index], result[index].encode("utf-8"), "Mismatch at #{index}"
      end
    end

  end

end
