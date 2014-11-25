module EdifactConverter

  class NullObject
    def method_missing(*args, &block)
      self
    end

    def self.Maybe(value)
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
      false
    end

  end

end
