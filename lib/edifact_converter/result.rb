require 'edifact_converter'

module EdifactConverter

  Result = Struct.new(:xml11, :xml, :edifact, :properties, :source) do
    def initialize(options)
      super(options[:xml11], options[:xml], options[:edifact], options[:properties], options[:source])
    end
  end

end
