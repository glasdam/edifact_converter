require 'PositionIO'
require 'EdifactError'

module EdifactConverter
  class EDIReader
    attr_accessor :handler
    
    def initialize(handler)
      @handler = handler
    end

    def parse(edifile, close=false)
      if edifile.kind_of? String
        close = true
        edifile = PositionIO.new (File.open edifile, 'rb:ISO-8859-1')
      else
        edifile = PositionIO.new edifile
      end
      @handler.startDocument
      begin
        parseUNA edifile
        eatCrap edifile
        #printFile edifile
        while(parseSegment edifile)
          eatCrap edifile
          #printFile edifile
        end
      rescue EOFError => e
        @handler.endDocument
      end
      edifile.close if close
    end

    private

    def parseUNA(edifile)
      segname = edifile.read 3
      if segname != "UNA"
        edifile.unread 3
        return
      end
      @handler.una
      while edifile.read != '\''
      end
    end

    def parseSegment(edifile)
      start = edifile.position
      name = edifile.read 3
      return false unless name
      raise EdifactError.new "Bad Segment name #{start}", start unless name =~ /[A-Z][A-Z0-9]{2}/
      @handler.startSegment name, start
      while(parseElement edifile)
      end
      @handler.endSegment
      true
    end

    def parseElement(edifile)
      start = edifile.position
      nextchar = edifile.read
      case nextchar
      when '+'
        @handler.startElement start
      when '\''
        return false
      else
        raise EdifactError.new "Bad Syntax #{start}", start
      end
      while(parseValue edifile)
      end
      @handler.endElement
      return true
    end

    def parseValue(edifile)
      start = edifile.position
      text = ''
      while not((nextchar = edifile.read) =~ /[+:']/)
        case nextchar
        when '?'
          text << escape(edifile.read, edifile.position)
        when '\n'
        else
          text << nextchar
        end
      end
      @handler.value text, start
      case nextchar
      when /[+']/
        edifile.unread
        return false
      end
      return true
    end

    def escape(escapable, position)
      raise EdifactError.new "Wrong escape #{position}", position unless escapable =~ /[':?+]/
      return escapable
    end

    def eatCrap(edifile)
      begin
        nextchar = edifile.read
      end while nextchar =~ /[\s]/
      edifile.unread
    end

    #      def printFile(edifile)
    #        STDERR.puts ">>>>>"
    #        pos = edifile.pos
    #        STDERR.puts "\t#{edifile.readline}"
    #        STDERR.puts "<<<<<"
    #        edifile.pos = pos
    #      end
  end

end
