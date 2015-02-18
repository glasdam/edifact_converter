require 'edifact_converter/configuration'

module EdifactConverter::Configuration

  class XMLRule

    ATTRIBUTES = [
      :namespace,
      :versions,
      :schema,
      :schema_urls,
      :from_xml,
      :from_xml_urls,
      :to_xml,
      :to_xml_urls,
      :to_html,
      :to_html_urls
    ]

    attr_accessor *ATTRIBUTES

    def initialize(options)
      options.each do |name, value|
        if ATTRIBUTES.include? name.to_sym
          send "#{name}=", value
        end
      end
    end

    def schema
      @schema ||= begin
        xmldoc = load_doc_from_urls schema_urls
        Nokogiri::XML::Schema.from_document xmldoc
      end
    end

    def from_xml
      @from_xml ||= begin
        xmldoc = load_doc_from_urls from_xml_urls
        Nokogiri::XSLT::Stylesheet.parse_stylesheet_doc xmldoc
      end
    end

    def to_xml
      @to_xml ||= begin
        xmldoc = load_doc_from_urls to_xml_urls
        Nokogiri::XSLT::Stylesheet.parse_stylesheet_doc xmldoc
      end
    end

    def to_html
      @to_html ||= begin
        xmldoc = load_doc_from_urls to_html_urls
        Nokogiri::XSLT::Stylesheet.parse_stylesheet_doc xmldoc
      end
    end

    private

    def load_doc_from_urls(urls)
      urls.each do |url|
        begin
          xmldoc = Nokogiri::XML(open(url), url)
        rescue StandardError => e
          $stderr.puts e
          next
        end
        break xmldoc
      end
    end

  end

end
