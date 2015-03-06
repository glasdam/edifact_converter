require 'test/unit'
require 'equivalent-xml'
require 'edifact_converter'

module EdifactConverter::XML

  class ParagraphTest < Test::Unit::TestCase

    LONG_TEXT = <<-EOS.gsub(/^ */, '')
    1995 indlagt Køge Sygehus under mistanke om AMI, afkræftedes. Januar 98 indlagt Frederiksborg Sgh., med afd., med stenokardi. Februar 98 samme afd. amb. til EKG-belastningsus.
      Gift fabrikant. Siden barnealderen været overvægtig., altid dårlige kostvaner spec. med overflødig fedtkalorie-tilførsel. I flere perioder beh. for addiktivt alkoholmisbrug.
      Virker velbegavet, men trods dette dårlig sygdomsindsigt og manglende motivation for livsstilsændring.
      Konsulterede primo sept. 98 med kraftig diffus dunkende hovedpine. BT fandtes kraftigt forhøjet - siddende 205/120 efter 15 min.s
    Patienten angiver sig nu indstillet på den nødvendige intervention, evt. også længerevarende indl.
      EOS

    LONG_TEXT_XML_DEFAULT = Nokogiri::XML <<-EOS
    <edifact><FTX><Elm><SubElm>NC</SubElm></Elm><Elm><SubElm>P00</SubElm></Elm><Elm/><Elm>
    <SubElm>1995 indlagt Køge Sygehus under mistanke om AMI, afkræftedes. Januar \\</SubElm>
    <SubElm>98 indlagt Frederiksborg Sgh., med afd., med stenokardi. Februar 98 \\</SubElm>
    <SubElm>samme afd. amb. til EKG-belastningsus. </SubElm>
    <SubElm>Gift fabrikant. Siden barnealderen været overvægtig., altid dårlige \\</SubElm>
    <SubElm>kostvaner spec. med overflødig fedtkalorie-tilførsel. I flere \\</SubElm>
    </Elm></FTX><FTX><Elm><SubElm>NC</SubElm></Elm><Elm><SubElm>P00</SubElm></Elm><Elm/><Elm>
    <SubElm>perioder beh. for addiktivt alkoholmisbrug. </SubElm>
    <SubElm>Virker velbegavet, men trods dette dårlig sygdomsindsigt og \\</SubElm>
    <SubElm>manglende motivation for livsstilsændring. </SubElm>
    <SubElm>Konsulterede primo sept. 98 med kraftig diffus dunkende hovedpine. \\</SubElm>
    <SubElm>BT fandtes kraftigt forhøjet - siddende 205/120 efter 15 min.s </SubElm>
    </Elm></FTX><FTX><Elm><SubElm>NC</SubElm></Elm><Elm><SubElm>P00</SubElm></Elm><Elm/><Elm>
    <SubElm>Patienten angiver sig nu indstillet på den nødvendige intervention, \\</SubElm>
    <SubElm>evt. også længerevarende indl.</SubElm></Elm></FTX></edifact>
    EOS

    LONG_TEXT_XML_FIXED = Nokogiri::XML <<-EOS
    <edifact><FTX><Elm><SubElm>NC</SubElm></Elm><Elm><SubElm>F00</SubElm></Elm><Elm/><Elm>
    <SubElm>1995 indlagt Køge Sygehus under mistanke om AMI, afkræftedes. Januar \\</SubElm>
    <SubElm>98 indlagt Frederiksborg Sgh., med afd., med stenokardi. Februar 98 \\</SubElm>
    <SubElm>samme afd. amb. til EKG-belastningsus. </SubElm>
    <SubElm>Gift fabrikant. Siden barnealderen været overvægtig., altid dårlige \\</SubElm>
    <SubElm>kostvaner spec. med overflødig fedtkalorie-tilførsel. I flere \\</SubElm>
    </Elm></FTX><FTX><Elm><SubElm>NC</SubElm></Elm><Elm><SubElm>F00</SubElm></Elm><Elm/><Elm>
    <SubElm>perioder beh. for addiktivt alkoholmisbrug. </SubElm>
    <SubElm>Virker velbegavet, men trods dette dårlig sygdomsindsigt og \\</SubElm>
    <SubElm>manglende motivation for livsstilsændring. </SubElm>
    <SubElm>Konsulterede primo sept. 98 med kraftig diffus dunkende hovedpine. \\</SubElm>
    <SubElm>BT fandtes kraftigt forhøjet - siddende 205/120 efter 15 min.s </SubElm>
    </Elm></FTX><FTX><Elm><SubElm>NC</SubElm></Elm><Elm><SubElm>F00</SubElm></Elm><Elm/><Elm>
    <SubElm>Patienten angiver sig nu indstillet på den nødvendige intervention, \\</SubElm>
    <SubElm>evt. også længerevarende indl.</SubElm></Elm></FTX></edifact>
    EOS


    TWO_LINES_TEXT = <<-EOS.gsub(/^ */, '')
    1995 indlagt Køge Sygehus under mistanke om AMI, afkræftedes. Januar 98 indlagt Frederiksborg Sgh., med afd., med stenokardi. Februar 98 samme afd. amb. til EKG-belastningsus.
      Gift fabrikant. Siden barnealderen været overvægtig., altid dårlige kostvaner spec. med overflødig fedtkalorie-tilførsel. I flere perioder beh. for addiktivt alkoholmisbrug.
      EOS

    ONE_LINE_TEXT = <<-EOS.gsub(/^ */, '')
    1995 indlagt Køge Sygehus under mistanke om AMI, afkræftedes. Januar 98 indlagt Frederiksborg Sgh., med afd., med stenokardi. Februar 98 samme afd. amb. til EKG-belastningsus.
      EOS



    def default_node
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.edifact {
          xml.xftx {
            xml.Elm {
              xml.SubElm "NC"
            }
            xml.Elm
            xml.Elm
            xml.Elm {
              xml.SubElm {
                LONG_TEXT.each_line do |text|
                  xml.text text.gsub(/\n/, '')
                  xml.Break
                end
              }
            }
          }
        }
      end
      builder.doc.at('xftx')
    end

    def fixed_node
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.edifact {
          xml.xftx {
            xml.Elm {
              xml.SubElm "NC"
            }
            xml.Elm
            xml.Elm
            xml.Elm {
              xml.SubElm {
                xml.FixedFont {
                  LONG_TEXT.each_line do |text|
                    xml.text text
                    xml.Break
                  end
                }
              }
            }
          }
        }
      end
      builder.doc.at('xftx')
    end

    def xftx_content
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.edifact {
          xml.SubElm {
            xml.FixedFont {
              xml.text "F00"
              xml.Break
              xml.Bold "FF0"
              xml.text "F00"
              xml.Italic "FK0"
              xml.Right "F0H"
              xml.Break
              xml.Center "F0M"
              xml.Break
              xml.Bold
              xml.text "F00"
            }
            xml.text "P00"
          }
        }
      end
      builder.doc.at('SubElm')
    end

    XFTX_CONTENT_TXT = <<-EOS
:
<P00:><F00:F00
><FF0:FF0><F00:F00><FK0:FK0><F00:><F0H:
F0H
><F00:
><F0M:F0M
><F00:
><FF0:><F00:F00><P00:P00>
    EOS

    XFTX_CONTENT_PACKED = <<-EOS
:
<F00:F00
><FF0:FF0><F00:F00><FK0:FK0><F0H:
F0H
><F00:
><F0M:F0M
><F00:
><F00:F00><P00:P00>
    EOS

    def setup
      @xparser_default = XftxParser.new default_node
      @xparser_fixed = XftxParser.new fixed_node
    end

    def test_transform_xftx
      doc =  @xparser_default.xftx.document
      @xparser_default.transform_xftx
      text = ""
      assert(EquivalentXml.equivalent?(doc, LONG_TEXT_XML_DEFAULT, opts = { :element_order => true, :normalize_whitespace => true}) do |generated, expected, result|
               text << "Expected \n#{expected}\nGot \n#{generated}" unless result
               result
      end, text)
      doc = @xparser_fixed.xftx.document
      @xparser_fixed.transform_xftx
      text = ""
      doc.encoding = "utf-8"
      assert(EquivalentXml.equivalent?(doc, LONG_TEXT_XML_FIXED, opts = { :element_order => true, :normalize_whitespace => true}) do |generated, expected, result|
               unless result
                 text << "Expected \n#{expected}\nGot \n#{generated}"
                 break false
               end
               result
      end, text)
    end

    def test_transform_content
      @xparser_default.transform_content xftx_content
      #puts @xparser_default
      assert_equal XFTX_CONTENT_TXT, @xparser_default.to_s << "\n"
    end

    def test_pack_paragraphs
      @xparser_default.transform_content xftx_content
      @xparser_default.pack_paragraphs
      assert_equal XFTX_CONTENT_PACKED, @xparser_default.to_s << "\n"
    end


  end

end
