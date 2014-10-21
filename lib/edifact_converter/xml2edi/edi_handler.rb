require 'edifact_converter/xml2edi'
require 'base64'
require 'securerandom'

module EdifactConverter::XML2EDI

  class EdiHandler < EdifactConverter::EmptyHandler

    attr_accessor :linebreak,
      :edifact,
      :first_value,
      :processing_binary,
      :binary

    alias :first_value? :first_value
    alias :processing_binary? :processing_binary

    def edifact
      @edifact ||= StringIO.new('ISO-8859-1')
    end

    def initialize(nexthandler = nil)
      self.linebreak = "\n" if EdifactConverter::Configuration.format_edi
      super
    end

    def startDocument
      edifact.write("UNA:+.? '#{linebreak}")
    end

    def startSegment(name, position = nil)
      if name == "OBJ"
        self.processing_binary = true
      else
        edifact.write(name)
      end
    end

    def startElement
      unless processing_binary?
        edifact.write('+')
        self.first_value = true
      end
    end

    def value(text)
      if processing_binary?
        id = binary_id
        binary[id] = text
        edifact.write(id)
      else
        edifact.write(':') unless first_value?
        edifact.write(text)
        self.first_value = false
      end
    end

    def endSegment
      if processing_binary?
        self.processing_binary = false
      else
        edifact.write("'#{linebreak}")
      end
    end

    def binary?
      binary.any?
    end

    def binary
      @binary ||= {}
    end

    private

    def binary_id
      "@@BINARY#{SecureRandom.uuid}@@"
    end


  end

end
