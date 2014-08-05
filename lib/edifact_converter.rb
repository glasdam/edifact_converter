require "edifact_converter/version"
require "edifact_converter/xml_handler"
require "edifact_converter/edi_reader"

module EdifactConverter

  def self.convert_edifact(file)
    # StatusHandler.new UNTHandler.new UNZHandler.new BrevHandler.new SegmentGroupHandler.new
    edifact_pipeline = XmlHandler.new
    parser = EdiReader.new edifact_pipeline
    parser.parse file
    p edifact_pipeline.xml
  end

end
