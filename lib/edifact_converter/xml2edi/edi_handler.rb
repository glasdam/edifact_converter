require 'edifact_converter/xml2edi'

module EdifactConverter::XML2EDI

  class EdiHandler < EdifactConverter::EmptyHandler

    attr_accessor :linebreak, :edifact, :first_value

    alias :first_value? :first_value

    def edifact
      @edifact ||= StringIO.new('ISO-8859-1')
    end

    def initialize(nexthandler = nil)
      self.linebreak = "\n"
      super
    end

    def startDocument
      edifact.write("UNA:+.? '#{linebreak}")
    end

    def startSegment(name, position = nil)
      edifact.write(name)
    end

    def startElement
      edifact.write('+')
      self.first_value = true
    end

    def value(text)
      edifact.write(':') unless first_value?
      edifact.write(text)
      self.first_value = false
    end

    def endSegment
      edifact.write("'#{linebreak}")
    end

  end

end
