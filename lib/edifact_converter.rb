require "edifact_converter/version"

require "edifact_converter/abstract_syntax_tree"
require "edifact_converter/comparator"
require "edifact_converter/empty_handler"
require "edifact_converter/edifact_error"
require 'edifact_converter/edi2xml11'
require "edifact_converter/xml112edi"
require "edifact_converter/configuration"
require "edifact_converter/result"
require "edifact_converter/message"
require "edifact_converter/command_line_parser"
require "edifact_converter/converter_methods"
require "edifact_converter/xml"
require 'edifact_converter/converter'

module EdifactConverter

  def self.convert_edifact(text)
    result = Result.new edifact: text, source_format: :edifact
    result.convert
    result
  end

  def self.convert_xml11(text)
    result = Result.new xml11: text, source_format: :xml11
    result.convert
    result
  end

  def self.convert_xml(text)
    result = Result.new xml: text, source_format: :xml
    result.convert
    result
  end  

  def self.convert(text)
    if xml?(text)
      convert_xml(text)
    else
      convert_edifact(text)
    end
  end

  def self.read_file(filename)
    File.open(filename, 'r:iso-8859-1:iso-8859-1') { |f| f.read } #  encoding: 'ISO-8859-1'
  end

  def self.xml?(text)
    Nokogiri::XML(text).errors.empty?
  end

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.data
    File.join root, 'data'
  end

end
