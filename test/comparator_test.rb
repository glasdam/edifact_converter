require 'test/unit'
require 'nokogiri'
require 'edifact_converter/comparator'

module EdifactConverter

  class ComparatorTest < Test::Unit::TestCase

    def setup
      @comparator = Comparator.new
    end

    def test_exact_same
      xml = Nokogiri::XML <<-EOS
      <edifact><Brev>
      <UNA/>
      <UNB/>
      <S01><ATX><Elm><SubElm>Hej</SubElm></Elm></ATX></S01>
      <UNT/>
      <UNZ/>
      </Brev></edifact>
      EOS
      assert_nothing_raised do
        @comparator.compare_docs xml, xml do |diff|
          raise "Got #{diff.kind} at #{diff.source.path}"
        end
      end
    end

    def test_different_children
      source = Nokogiri::XML <<-EOS
      <edifact><Brev>
      <UNA/>
      <UNB><Elm/></UNB>
      <S01><ATX><Elm><SubElm>Hej</SubElm></Elm></ATX><BTX/></S01>
      <UNT/>
      <UNZ/>
      </Brev></edifact>
      EOS
      facit = Nokogiri::XML <<-EOS
      <edifact><Brev>
      <UNA/>
      <UNH/>
      <UNB/>
      <S01><ATX><Elm><SubElm>Hej</SubElm></Elm></ATX></S01>
      <UNT/>
      <UNZ><Elm><SubElm>3</SubElm></Elm></UNZ>
      </Brev></edifact>
      EOS
      errors = []
      errors << Difference.new(
        source: source.at("UNB"),
        facit: facit.at("UNH"),
        kind: :added
      )
      errors << Difference.new(
        source: source.at("UNB"),
        facit: facit.at("UNB"),
        kind: :removed_children
      )
      errors << Difference.new(
        source: source.at("BTX"),
        facit: facit.at("ATX"),
        kind: :removed
      )
      errors << Difference.new(
        source: source.at("UNZ"),
        facit: facit.at("UNZ"),
        kind: :added_children
      )
      @comparator.compare_docs source, facit do |diff|
        #puts "Diff: #{diff.source.name} <-> #{diff.facit.name} #{diff.kind}"
        assert diff.eql?(errors.first), "Uens fejl, forventede #{errors.first}\n fik #{diff}"
        errors.shift
      end
      assert errors.empty?, "All errors no used #{errors.size} left"
    end

    def test_different_text
      source = Nokogiri::XML <<-EOS
      <edifact><Brev>
      <UNA/>
      <UNB><Elm><SubElm>Hej</SubElm></Elm></UNB>
      <S01><ATX><Elm>
      <SubElm>Hello</SubElm><SubElm> </SubElm>
      <SubElm>World!</SubElm>
      </Elm></ATX></S01>
      <UNT/>
      <UNZ><Elm><SubElm/></Elm></UNZ>
      </Brev></edifact>
      EOS
      facit = Nokogiri::XML <<-EOS
      <edifact><Brev>
      <UNA/>
      <UNB><Elm><SubElm>Hej</SubElm></Elm></UNB>
      <S01><ATX><Elm>
      <SubElm>Hello</SubElm><SubElm> </SubElm>
      <SubElm>World</SubElm>
      </Elm></ATX></S01>
      <UNT/>
      <UNZ><Elm><SubElm>6</SubElm></Elm></UNZ>
      </Brev></edifact>
      EOS
      errors = []
      errors << Difference.new(
        source: source.at("//ATX/Elm/SubElm[3]"),
        facit: facit.at("//ATX/Elm/SubElm[3]"),
        kind: :text
      )
      errors << Difference.new(
        source: source.at("//UNZ/Elm/SubElm"),
        facit: facit.at("//UNZ/Elm/SubElm"),
        kind: :text
      )
      @comparator.compare_docs source, facit do |diff|
        #puts "Diff: #{diff.source.text} <-> #{diff.facit.text} #{diff.kind}"
        assert diff.eql?(errors.first), "Uens fejl, forventede #{errors.first}\n fik #{diff}"
        errors.shift
      end
      assert errors.empty?, "All errors no used #{errors.size} left"

    end

  end

end
