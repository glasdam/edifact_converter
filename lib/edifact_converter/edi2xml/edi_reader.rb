require 'edifact_converter/edi2xml'
require "base64"

module EdifactConverter::EDI2XML
  class EdiReader
    attr_accessor :handler, :locator

    def initialize(handler)
      @handler = handler
      self.locator = Locator.new
    end

    def parse_string(edistring, properties = nil)
      parse StringIO.new(edistring)
    end

    def parse(edifile, close=false)
      if edifile.kind_of? String
        close = true
        edifile = PositionIO.new (File.open edifile, 'rb', encoding: 'ISO-8859-1')
      else
        edifile = PositionIO.new edifile
      end
      @handler.startDocument
      begin
        eatCrap edifile
        parseUNA edifile
        eatCrap edifile
        while(parseSegment edifile)
          eatCrap edifile
        end
      rescue EOFError
        @handler.endDocument
      end
      edifile.close if close
      @handler.xml
    end

    private

    def parseUNA(edifile)
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

    def parseSegment(edifile)
      locator.position = edifile.position
      name = edifile.read 3
      return false unless name
      raise EdifactConverter::EdifactError.new "Bad Segment name #{name} #{locator}", locator.position unless name =~ /[A-Z][A-Z0-9]{2}/
      @handler.startSegment name, locator.position
      if name == 'UNO'
        3.times { parseElement edifile }
        size = parseElementWithSize(edifile)
        while(parseElement edifile)
        end
        @handler.endSegment name
        parseBinary(edifile, size.to_i)
      else
        while(parseElement edifile)
        end
        @handler.endSegment name
      end
      true
    end

    def parseElement(edifile)
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
      while(parseValue edifile)
      end
      @handler.endElement
      return true
    end

    def parseValue(edifile)
      value_start = edifile.position
      text = ''
      while not((nextchar = edifile.read) =~ /[+:']/)
        case nextchar
        when '?'
          position = edifile.position
          text << escape(edifile.read, position)
        when '\n'
        else
          text << nextchar
        end
      end
      @handler.value text, value_start
      case nextchar
      when /[+']/
        edifile.unread
        return false
      end
      return true
    end

    def escape(escapable, position)
      unless escapable =~ /[':?+]/
        EdifactConverter.properties[:errors] << EdifactConverter::Message.new(position, "Wrong use of escape for #{escapable}")
      end
      return escapable
    end

    def eatCrap(edifile)
      begin
        nextchar = edifile.read
      end while nextchar =~ /[\s\r]/
      edifile.unread
    end

    def parseElementWithSize(edifile)
      start = edifile.position
      nextchar = edifile.read
      case nextchar
      when '+'
        @handler.startElement start
      else
        raise EdifactConverter::EdifactError.new "Bad Syntax #{start}", start
      end
      size = parseValueSize edifile
      while(parseValue edifile)
      end
      @handler.endElement
      return size
    end

    def parseValueSize(edifile)
      start = edifile.position
      text = ''
      while not((nextchar = edifile.read) =~ /[+:']/)
        case nextchar
        when '\n'
        else
          text << nextchar
        end
      end
      @handler.value text, start
      case nextchar
      when /[+']/
        edifile.unread
      end
      begin
        Integer(text)
      rescue ArgumentError
        raise EdifactConverter::EdifactError.new "Wrong format for binary size (#{text})", start
      end
    end    

    def parseBinary(edifile, size)
      start = edifile.position
      @handler.startSegment "OBJ", start
      @handler.startElement start
      data = edifile.binread(size)
      if data.size < size
        raise EdifactConverter::EdifactError.new "Binary size is larger than edifact file", start
      end
      @handler.value Base64.encode64(data), start
      @handler.endElement
      @handler.endSegment "OBJ"
    end

  end

end
