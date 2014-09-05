require 'edifact_converter'

module EdifactConverter

  class DebugHandler < EmptyHandler

    def startDocument
      @level = 1
      print 'Edifact'
      super
    end

    def endDocument
      p @level
      #@level -= 1
      #print 'Edifact'
      super
    end

    def startSegmentGroup(name, position = nil, hidden = false)
      @level += 1
      print "Start Group #{name} #{position}"
      super
    end

    def endSegmentGroup(name)
      print "End Group #{name}"
      @level -= 1
      super
    end

    def startSegment(name, position = nil)
      print "#{name} #{position}"
      #@level += 1
      super
    end

    def endSegment(name)
      #@level -= 1
      super
    end

    def print(name)
      text = "  #{@level} - #{name}"
      puts text
    end

  end

end
