require 'edifact_converter'

module EdifactConverter

	Result = Struct.new(:xml11, :xml, :edifact)

end
