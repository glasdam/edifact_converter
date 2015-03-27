require 'test/unit'
require 'edifact_converter'

module EdifactConverter

  class ConverterMethodsTest < Test::Unit::TestCase

    def xmedbin 
       <<-EOS
<Emessage xmlns="http://rep.oio.dk/sundcom.dk/medcom.dk/xml/schemas/2005/08/07/">
  <Envelope>
    <Sent>
      <Date>2002-11-20</Date>
      <Time>17:29</Time>
    </Sent>
    <Identifier>MEDBIN62528</Identifier>
    <AcknowledgementCode>minuspositivkvitt</AcknowledgementCode>
  </Envelope>
  <BinaryLetter>
    <Letter>
      <Identifier>021120PWE62528</Identifier>
      <VersionCode>XB0130X</VersionCode>
      <StatisticalCode>XBIN01</StatisticalCode>
      <Authorisation>
        <Date>2002-11-20</Date>
        <Time>17:29</Time>
      </Authorisation>
      <TypeCode>XBIN01</TypeCode>
      <StatusCode>nytbrev</StatusCode>
    </Letter>
    <Sender>
      <EANIdentifier>5790000128686</EANIdentifier>
      <Identifier>054496</Identifier>
      <IdentifierCode>ydernummer</IdentifierCode>
      <OrganisationName>Lægerne i Viuf</OrganisationName>
      <UnitName>Claus Noringriis</UnitName>
      <StreetName>Storgaden  67</StreetName>
      <DistrictName>Viuf</DistrictName>
      <PostCodeIdentifier>6052</PostCodeIdentifier>
      <MedicalSpecialityCode>almenlaege_laegevagt</MedicalSpecialityCode>
    </Sender>
    <Receiver>
      <EANIdentifier>5790000129508</EANIdentifier>
      <Identifier>277878</Identifier>
      <IdentifierCode>ydernummer</IdentifierCode>
      <OrganisationName>Peter Wendelboe</OrganisationName>
      <UnitName>Hudlæge</UnitName>
      <StreetName>Østergade 20</StreetName>
      <DistrictName>Grenå</DistrictName>
      <PostCodeIdentifier>8500</PostCodeIdentifier>
    </Receiver>
    <Patient>
      <CivilRegistrationNumber>0312851849</CivilRegistrationNumber>
      <PersonSurnameName>Petersen</PersonSurnameName>
      <PersonGivenName>Peter Helge</PersonGivenName>
    </Patient>
    <BinaryObject>
      <ObjectIdentifier>031285-1849_021121SKR0XX0166OBJ001</ObjectIdentifier>
      <ObjectCode>billede</ObjectCode>
      <ObjectExtensionCode>gif</ObjectExtensionCode>
      <OriginalObjectSize>1606</OriginalObjectSize>
      <Object_Base64Encoded>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
        gEMFfleIQAAAOw==</Object_Base64Encoded>
    </BinaryObject>
  </BinaryLetter>
</Emessage>
    EOS
    end

    def test_binary
      #file_path = "/Users/jacob/Desktop/xbin_gif.xml" # "#{File.dirname(__FILE__)}/complete/files/xml/BIN01_1.xml"
      result = EdifactConverter.convert_xml(xmedbin)
      binary = result.binary "031285-1849_021121SKR0XX0166OBJ001"
      assert binary
      File.open("/tmp/image.gif", "wb") do |file|
        file.write binary.binary
      end
      assert true
    end

  end

end