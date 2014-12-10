module EdifactConverter

  class NullObject

    def self.instance
      @instance ||= self.new
    end

    def method_missing(method, *args, &block)
      if method.to_s =~ /\?$/
        false
      else
        self
      end
    end

    def self.maybe(value)
      case value
      when nil
        self.new
      else
        value
      end
    end

    def to_a
      []
    end
    
    def to_s 
      ""
    end
    
    def to_f
      0.0
    end

    def to_i
      0
    end

    def null?
      true
    end

  end

end
