require 'nokogiri'

module EdifactConverter

  class XmlReader

    attr_accessor :handler

    def initialize(handler = EmptyHandler.new)
      @handler = handler
    end

    def parse_string(xmlstr = "")
      reader = Nokogiri::XML::Reader(xmlstr)
      reader.each do |node|
      end
    end

    def parse_file(file)
      reader = Nokogiri::XML::Reader(File.open(file, encoding: 'ISO-8859-1'))
      reader.each do |node|
      end
    end

    def self.test

    end

  end

end
