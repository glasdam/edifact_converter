require 'edifact_converter/edi2xml'

module EdifactConverter::EDI2XML

  class UNBHandler < EdifactConverter::EmptyHandler

    attr_accessor :elements, :values, :date_str, :time_str

    def initialize
      clear
    end

    def clear
      self.elements = 0
      self.values = 0
    end

    def startElement
      self.elements += 1
      self.values = 0
    end

    def value(value)
      self.values += 1
      case
      when elements == 2 && values == 1
        EdifactConverter.properties[:sender_ean] = value
      when elements == 3 && values == 1
        EdifactConverter.properties[:receiver_ean] = value
      when elements == 4 && values == 1
        self.time_str = value
      when elements == 4 && values == 2
        self.time_str << value
        EdifactConverter.properties[:sent_at] = Time.strptime time_str, "%y%m%d%H%M"
      when elements == 5 && values == 1
        EdifactConverter.properties[:envelope_id] = value
      end
    end

  end

  class UNHHandler < EdifactConverter::EmptyHandler
    attr_accessor :elements, :values

    def initialize
      clear
    end

    def clear
      self.elements = 0
      self.values = 0
    end

    def startElement
      self.elements += 1
      self.values = 0
    end

    def value(value)
      self.values += 1
      case
      when elements == 2 && values == 1
        EdifactConverter.properties[:type] = value
      when elements == 2 && values == 5
        EdifactConverter.properties[:version] = value
      end
    end
  end


  class PropertiesHandler < EdifactConverter::EmptyHandler

    attr_accessor :state

    def method_missing(sym, *args, &block)
      state.send(sym, *args, &block) if state
      if next_handler
        next_handler.send(sym, *args, &block)
      end
    end

    def startSegment(name)
      case name
      when 'UNB'
        self.state = UNBHandler.new
      when 'UNH'
        self.state = UNHHandler.new
      end
      super
    end

    def endSegment(name)
      self.state = nil
      super
    end

  end

end
