require 'edifact_converter/empty_handler'
require 'edifact_converter/edi2xml11/position'

class LogReaderHandler < EdifactConverter::EmptyHandler

  class Node
    NODE_TYPES = [:root, :segment_group, :segment, :element, :value]
    attr_accessor :value, :children, :position, :type

    NODE_TYPES.each do |type|
      define_singleton_method(type) do |value, position = nil|
        self.new value, position, type
      end
    end

    def initialize(value, position, type, children = [])
      self.value = value
      self.position = position
      raise ArgumentError unless NODE_TYPES.include? type
      self.type = type
      self.children = children if type != :value
    end

    def select(of_type, prev_groups = [])
      return prev_groups unless can_be_child? of_type
      children.inject(prev_groups) do |groups, child|
        groups << child if child.type == of_type
        child.select of_type, groups
        groups
      end
    end

    def can_be_child?(node_type)
      NODE_TYPES.index(type) < NODE_TYPES.index(node_type) || type == :segment_group
    end

  end

  attr_accessor :document, :stack

  def last
    @last ||= {}
  end

  def number_of(type)
    document.select(type).size
  end

  def balanced?
    stack.last == document
  end

  def push(node)
    unless stack.last.can_be_child? node.type
      p stack.last  
      raise 'Hell' 
    end
    stack.last.children << node
    last[node.type] = node
    stack.push node unless node.type == :value
  end

  def pop(name, type)
    unless stack.last.value == name && stack.last.type == type
      raise 'Hell' 
    end
    stack.pop
  end

  def startDocument
    self.document = Node.root('Edifact')
    self.stack = [document]
    super
  end

  def startSegmentGroup(name, hidden = false)
    push Node.segment_group(name, locator.position)
    super
  end

  def endSegmentGroup(name)
    pop name, :segment_group
    super
  end

  def startSegment(name)
    push Node.segment(name, locator.position)
    super
  end

  def endSegment(name)
    pop name, :segment
    super
  end
  
  def startElement
    push Node.element('elm', locator.position)
    super
  end

  def endElement
    pop 'elm', :element
    super
  end
  def value(value)
    push Node.value(value, locator.position)
    super
  end
end
