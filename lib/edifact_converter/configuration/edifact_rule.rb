require 'edifact_converter/configuration'

module EdifactConverter::Configuration

  class EdifactRule

    ATTRIBUTES = [:hidden, :children]

    attr_accessor *ATTRIBUTES #:hidden, :children

    def initialize(hidden = {}, children = [] )
      self.hidden = hidden
      self.children = children
    end

    def register_hidden(hidden)
      self.hidden.merge! hidden if hidden
    end

    def register_child(child)
      children << child if child
    end

    def register_children(children)
      self.children.concat(children).uniq! if children
    end

    def hidden?(name)
      hidden.has_key? name
    end

    def child?(name)
      children.include? name
    end

  end

end
