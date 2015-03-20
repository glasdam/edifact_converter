require 'test/unit'
require 'nokogiri'
require 'equivalent-xml'
require 'edifact_converter/edifact'
require 'edifact_converter/abstract_syntax_tree'

# Refactoring work in progress

module EdifactConverter

  class EdifactTest < Test::Unit::TestCase

    def ctl01_text
      <<-EOS
UNA:+.? '
UNB+UNOC:3+DKKMDKMDNET:14+5790000181872:14+991111:1850+KuvertNr1234'
UNH+BrevNr5678+CONTRL:D:93A:ZZ:C0130Q+CTL01'
UCI+MEDREF01095+5790000181872:14+5790000120420:14+4'
FTX+LOK+P00++EDI-kuvert afsendt 11/11 1999 kl 18.46 har ikke kunnet modtages. :Modtagerlokationsnummer har ikke kunnet identificeres.'
UCM+1111FRE01095+MEDREF:D:93A:UN:H0130R+4'
UCM+1111MAN01095+MEDREF:D:93A:UN:H0130R+4'
UNT+6+BrevNr5678'
UNZ+1+KuvertNr1234'
      EOS
    end

    def ctl01_xml
      Nokogiri::XML <<-EOS
    <Edifact linie="0" position="0">
      <UNB linie="1" position="0">
        <Elm linie="1" position="3">
          <SubElm linie="1" position="4">UNOC</SubElm>
          <SubElm linie="1" position="9">3</SubElm>
        </Elm>
        <Elm linie="1" position="10"><SubElm linie="1" position="11">DKKMDKMDNET</SubElm><SubElm linie="1" position="23">14</SubElm></Elm>
        <Elm linie="1" position="25"><SubElm linie="1" position="26">5790000181872</SubElm><SubElm linie="1" position="40">14</SubElm></Elm>
        <Elm linie="1" position="42"><SubElm linie="1" position="43">991111</SubElm><SubElm linie="1" position="50">1850</SubElm></Elm>
        <Elm linie="1" position="54"><SubElm linie="1" position="55">KuvertNr1234</SubElm></Elm>
      </UNB>
      <Brev>
        <UNH linie="2" position="0">
          <Elm linie="2" position="3"><SubElm linie="2" position="4">BrevNr5678</SubElm></Elm>
          <Elm linie="2" position="14"><SubElm linie="2" position="15">CONTRL</SubElm><SubElm linie="2" position="22">D</SubElm><SubElm linie="2" position="24">93A</SubElm><SubElm linie="2" position="28">ZZ</SubElm><SubElm linie="2" position="31">C0130Q</SubElm></Elm>
          <Elm linie="2" position="37"><SubElm linie="2" position="38">CTL01</SubElm></Elm>
        </UNH>
        <BrevIndhold>
          <UCI linie="3" position="0">
            <Elm linie="3" position="3"><SubElm linie="3" position="4">MEDREF01095</SubElm></Elm>
            <Elm linie="3" position="15"><SubElm linie="3" position="16">5790000181872</SubElm><SubElm linie="3" position="30">14</SubElm></Elm>
            <Elm linie="3" position="32"><SubElm linie="3" position="33">5790000120420</SubElm><SubElm linie="3" position="47">14</SubElm></Elm>
            <Elm linie="3" position="49"><SubElm linie="3" position="50">4</SubElm></Elm>
          </UCI>
          <FTX linie="4" position="0">
            <Elm linie="4" position="3"><SubElm linie="4" position="4">LOK</SubElm></Elm>
            <Elm linie="4" position="7"><SubElm linie="4" position="8">P00</SubElm></Elm>
            <Elm linie="4" position="11"/>
            <Elm linie="4" position="12"><SubElm linie="4" position="13">EDI-kuvert afsendt 11/11 1999 kl 18.46 har ikke kunnet modtages. </SubElm><SubElm linie="4" position="79">Modtagerlokationsnummer har ikke kunnet identificeres.</SubElm></Elm>
          </FTX>
          <UCM linie="5" position="0">
            <Elm linie="5" position="3"><SubElm linie="5" position="4">1111FRE01095</SubElm></Elm>
            <Elm linie="5" position="16"><SubElm linie="5" position="17">MEDREF</SubElm><SubElm linie="5" position="24">D</SubElm><SubElm linie="5" position="26">93A</SubElm><SubElm linie="5" position="30">UN</SubElm><SubElm linie="5" position="33">H0130R</SubElm></Elm>
            <Elm linie="5" position="39"><SubElm linie="5" position="40">4</SubElm></Elm>
          </UCM>
          <UCM linie="6" position="0">
            <Elm linie="6" position="3"><SubElm linie="6" position="4">1111MAN01095</SubElm></Elm>
            <Elm linie="6" position="16"><SubElm linie="6" position="17">MEDREF</SubElm><SubElm linie="6" position="24">D</SubElm><SubElm linie="6" position="26">93A</SubElm><SubElm linie="6" position="30">UN</SubElm><SubElm linie="6" position="33">H0130R</SubElm></Elm>
            <Elm linie="6" position="39"><SubElm linie="6" position="40">4</SubElm></Elm>
          </UCM>
        </BrevIndhold>
        <UNT linie="7" position="0">
          <Elm linie="7" position="3"><SubElm linie="7" position="4">6</SubElm></Elm>
          <Elm linie="7" position="5"><SubElm linie="7" position="6">BrevNr5678</SubElm></Elm>
        </UNT>
      </Brev>
      <UNZ linie="8" position="0">
        <Elm linie="8" position="3"><SubElm linie="8" position="4">1</SubElm></Elm>
        <Elm linie="8" position="5"><SubElm linie="8" position="6">KuvertNr1234</SubElm></Elm>
      </UNZ>
    </Edifact>    
      EOS
    end

    def s01_text
      <<-EOS
UNA:+.? '
UNB+UNOC:3+DKKMDKMDNET:14+5790000181872:14+991111:1850+KuvertNr1234'
UNH+BrevNr5678+CONTRL:D:93A:ZZ:C0130Q+CTL01'
S01+1'
UCM+1111FRE01095+MEDREF:D:93A:UN:H0130R+4'
UCM+1111MAN01095+MEDREF:D:93A:UN:H0130R+4'
UNT+5+BrevNr5678'
UNZ+1+KuvertNr1234'
      EOS
    end

    def s01_xml
      Nokogiri::XML <<-EOS
<Edifact linie="0" position="0">
    <UNB linie="1" position="0">
        <Elm linie="1" position="3">
            <SubElm linie="1" position="4">UNOC</SubElm>
            <SubElm linie="1" position="9">3</SubElm>
        </Elm>
        <Elm linie="1" position="10">
            <SubElm linie="1" position="11">DKKMDKMDNET</SubElm>
            <SubElm linie="1" position="23">14</SubElm>
        </Elm>
        <Elm linie="1" position="25">
            <SubElm linie="1" position="26">5790000181872</SubElm>
            <SubElm linie="1" position="40">14</SubElm>
        </Elm>
        <Elm linie="1" position="42">
            <SubElm linie="1" position="43">991111</SubElm>
            <SubElm linie="1" position="50">1850</SubElm>
        </Elm>
        <Elm linie="1" position="54">
            <SubElm linie="1" position="55">KuvertNr1234</SubElm>
        </Elm>
    </UNB>
    <Brev>
        <UNH linie="2" position="0">
            <Elm linie="2" position="3">
                <SubElm linie="2" position="4">BrevNr5678</SubElm>
            </Elm>
            <Elm linie="2" position="14">
                <SubElm linie="2" position="15">CONTRL</SubElm>
                <SubElm linie="2" position="22">D</SubElm>
                <SubElm linie="2" position="24">93A</SubElm>
                <SubElm linie="2" position="28">ZZ</SubElm>
                <SubElm linie="2" position="31">C0130Q</SubElm>
            </Elm>
            <Elm linie="2" position="37">
                <SubElm linie="2" position="38">CTL01</SubElm>
            </Elm>
        </UNH>
        <BrevIndhold>
            <S01 linie="3" position="0">
                <Elm linie="3" position="3">
                    <SubElm linie="3" position="4">1</SubElm>
                </Elm>
                <UCM linie="4" position="0">
                    <Elm linie="4" position="3">
                        <SubElm linie="4" position="4">1111FRE01095</SubElm>
                    </Elm>
                    <Elm linie="4" position="16">
                        <SubElm linie="4" position="17">MEDREF</SubElm>
                        <SubElm linie="4" position="24">D</SubElm>
                        <SubElm linie="4" position="26">93A</SubElm>
                        <SubElm linie="4" position="30">UN</SubElm>
                        <SubElm linie="4" position="33">H0130R</SubElm>
                    </Elm>
                    <Elm linie="4" position="39">
                        <SubElm linie="4" position="40">4</SubElm>
                    </Elm>
                </UCM>
                <UCM linie="5" position="0">
                    <Elm linie="5" position="3">
                        <SubElm linie="5" position="4">1111MAN01095</SubElm>
                    </Elm>
                    <Elm linie="5" position="16">
                        <SubElm linie="5" position="17">MEDREF</SubElm>
                        <SubElm linie="5" position="24">D</SubElm>
                        <SubElm linie="5" position="26">93A</SubElm>
                        <SubElm linie="5" position="30">UN</SubElm>
                        <SubElm linie="5" position="33">H0130R</SubElm>
                    </Elm>
                    <Elm linie="5" position="39">
                        <SubElm linie="5" position="40">4</SubElm>
                    </Elm>
                </UCM>
            </S01>
        </BrevIndhold>
        <UNT linie="6" position="0">
            <Elm linie="6" position="3">
                <SubElm linie="6" position="4">5</SubElm>
            </Elm>
            <Elm linie="6" position="5">
                <SubElm linie="6" position="6">BrevNr5678</SubElm>
            </Elm>
        </UNT>
    </Brev>
    <UNZ linie="7" position="0">
        <Elm linie="7" position="3">
            <SubElm linie="7" position="4">1</SubElm>
        </Elm>
        <Elm linie="7" position="5">
            <SubElm linie="7" position="6">KuvertNr1234</SubElm>
        </Elm>
    </UNZ>
</Edifact>
      EOS
    end

    def test_parse
      [[ctl01_text, ctl01_xml], [s01_text, s01_xml]].each do |set|
      	edifact = Edifact.new text: set.first
      	errors = []
      	ast = edifact.parse { |error| errors << error }
      	assert errors.empty?, "Got errors #{errors.inspect}"
      	compare_xml ast.document, set.last
      end
    end

    def test_serialize
      ast = AbstractSyntaxTree.new ctl01_xml
      edifact = Edifact.new ast: ast
      errors = []
      text = edifact.serialize(pretty: true) { |error| errors << error }
      #assert text, ctl01_text
      #assert errors.empty?, "Got errors #{errors.inspect}"
    end

    private

    def compare_xml(source, facit)
      text = ""
      assert(
        EquivalentXml.equivalent?(
          source, 
          facit, 
          { :element_order => true, :normalize_whitespace => true}
        ) do |generated, expected, result|
            unless result
              text << "Expected \n#{expected}\nGot \n#{generated}"
              break false
            end
            result
          end, 
        text
      )
    end

  end

end
