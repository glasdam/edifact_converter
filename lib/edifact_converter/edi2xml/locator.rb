require 'edifact_converter/edi2xml'

module EdifactConverter::EDI2XML

  class Locator

    attr_accessor :rules, :settings, :position

    def rules
      @rules ||= Hash.new { |hash, key| hash[key] = {} }
    end
    
  end

end
