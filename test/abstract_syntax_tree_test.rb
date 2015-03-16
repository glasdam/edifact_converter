
require 'test/unit'
require 'nokogiri'
require 'edifact_converter/abstract_syntax_tree'

module EdifactConverter

  class AbstractSyntaxTreeTest < Test::Unit::TestCase

    def xml
      Nokogiri::XML <<-EOS
      <edifact>
      <UNA><Elm><SubElm/></Elm><Elm/><Elm/></UNA>
      <Brev>
      <UNB><Elm><SubElm/></Elm><Elm><SubElm> </SubElm></Elm><Elm/></UNB>
      <UNC/>
      <S01>
      <UND/>
      </S01>
      <UNT><Elm><SubElm>5</SubElm></Elm></UNT>
      </Brev>
      </edifact>
      EOS
    end

    def test_pack
      ast = AbstractSyntaxTree.new xml
      ast.pack
      assert ast.document.at("UNA").elements.empty?
      assert ast.document.at("UNB").elements.size == 2
      assert ast.document.at("UNB/Elm[1]").elements.empty?
      assert ast.document.at("UNB/Elm[2]").elements.size == 1
    end

    def test_compare
      ast = AbstractSyntaxTree.new xml
      errors = ast.compare(xml)
      assert errors.empty?
    end

    def test_verify_segments_checksum
      ast = AbstractSyntaxTree.new xml
      errors = ast.verify_segments_checksum
      assert errors.empty?, "Got errors #{errors.inspect}"
      unt = ast.document.at("UNT")
      unt.at("SubElm").content = 4
      errors = ast.verify_segments_checksum
      assert errors.size == 1
      error = Difference.new(
        source: unt,
        facit: 5,
        kind: :unt
      )
      assert error.eql? errors.first
      unt.unlink
      error = Difference.new(
        source: ast.document.at("Brev"),
        facit: 4,
        kind: :no_unt
      )
      errors = ast.verify_segments_checksum
      assert errors.size == 1
      assert error.eql? errors.first
    end

  end

end
