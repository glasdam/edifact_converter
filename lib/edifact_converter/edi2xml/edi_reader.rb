require 'edifact_converter/edi2xml'
require "base64"

module EdifactConverter::EDI2XML
  class EdiReader
    attr_accessor :handler, :locator, :edifile

    def initialize(handler)
      self.handler = handler
      self.locator = Locator.new
    end

    def parse_string(edistring, properties = nil)
      parse StringIO.new(edistring)
    end

    def parse(edifile, close=false)
      if edifile.kind_of? String
        close = true
        self.edifile = PositionIO.new (File.open edifile, 'rb', encoding: 'ISO-8859-1')
      else
        self.edifile = PositionIO.new edifile
      end
      @handler.startDocument
      begin
        eatCrap
        parseUNA
        eatCrap
        while(parseSegment)
          eatCrap
        end
      rescue EOFError
        @handler.endDocument
      end
      self.edifile.close if close
      @handler.xml
    end

    private

    def parseUNA
      segname = edifile.read 3
      if segname != "UNA"
        edifile.unread 3
        EdifactConverter.properties[:warnings] << EdifactConverter::Message.new(
          edifile.position,
          "Missing UNA segment",
          :warning
        )
        return
      end
      @handler.una
      while edifile.read != '\''
      end
    end

    def parseSegment
      locator.position = edifile.position
      name = edifile.read 3
      return false unless name
      raise EdifactConverter::EdifactError.new "Bad Segment name #{name} #{locator}", locator.position unless name =~ /[A-Z][A-Z0-9]{2}/
      @handler.startSegment name, locator.position
      if name == 'UNO'
        3.times { parseElement }
        size = parseElementWithSize
        while parseElement
        end
        @handler.endSegment name
        parseBinary(size.to_i)
      else
        while parseElement
        end
        @handler.endSegment name
      end
      true
    end

    def parseElement
      locator.position = edifile.position
      nextchar = edifile.read
      case nextchar
      when '+'
        @handler.startElement edifile.position
      when '\''
        return false
      else
        raise EdifactConverter::EdifactError.new "Bad Syntax at #{locator.position}", locator.position
      end
      while(parseValue)
      end
      @handler.endElement
      return true
    end

    def parseValue
      locator.position = edifile.position
      text = ''
      while not((nextchar = edifile.read) =~ /[+:']/)
        case nextchar
        when '?'
          text << escape
        when '\n'
        else
          text << nextchar
        end
      end
      @handler.value text, locator.position
      case nextchar
      when /[+']/
        edifile.unread
        return false
      end
      return true
    end

    def escape
      escapable = edifile.read
      unless escapable =~ /[':?+]/
        EdifactConverter.properties[:errors] << EdifactConverter::Message.new(edifile.position, "Wrong use of escape for #{escapable}")
      end
      return escapable
    end

    def eatCrap
      begin
        nextchar = edifile.read
      end while nextchar =~ /[\s\r]/
      edifile.unread
    end

    def parseElementWithSize
      locator.position = edifile.position
      nextchar = edifile.read
      case nextchar
      when '+'
        @handler.startElement locator.position
      else
        raise EdifactConverter::EdifactError.new "Bad Syntax #{locator.position}", locator.position
      end
      size = parseValueSize
      while(parseValue)
      end
      @handler.endElement
      return size
    end

    def parseValueSize
      locator.position = edifile.position
      text = ''
      while not((nextchar = edifile.read) =~ /[+:']/)
        case nextchar
        when '\n'
        else
          text << nextchar
        end
      end
      @handler.value text, locator.position
      case nextchar
      when /[+']/
        edifile.unread
      end
      begin
        Integer(text)
      rescue ArgumentError
        raise EdifactConverter::EdifactError.new "Wrong format for binary size (#{text})", locator.position
      end
    end    

    def parseBinary(size)
      locator.position = edifile.position
      @handler.startSegment "OBJ", locator.position
      @handler.startElement locator.position
      data = edifile.binread(size)
      if data.size < size
        raise EdifactConverter::EdifactError.new "Binary size is larger than edifact file", locator.position
      end
      @handler.value Base64.encode64(data), locator.position
      @handler.endElement
      @handler.endSegment "OBJ"
    end

  end

end
