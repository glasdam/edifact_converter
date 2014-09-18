require 'edifact_converter'

module EdifactConverter

  Result = Struct.new(:xml11, :xml, :edifact, :messages) do
    def initialize(*)
      super
      self.messages ||= []
    end
  end

end
