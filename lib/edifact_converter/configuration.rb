require 'edifact_converter'
require 'open-uri'
require 'yaml'

module EdifactConverter

  class Configuration

    class << self

      attr_accessor  :settings, :hide_position, :format_edi

      alias :hide_position? :hide_position

      def edifact
        @edifact ||= empty_properties
      end

      def xml
        @xml ||= empty_properties
      end

      def settings
        @settings ||= Hash.new { |hash, key| NullObject.new }
      end

      def empty_properties
        Hash.new { |hash, key| hash['default'] if hash.has_key? 'default' }
      end

      def load_from_file(filename)
        self.settings = YAML.load_file(filename)
        set_default settings
      end

      def set_default(hash)
        return hash unless hash.respond_to? :default_proc
        hash.default_proc = proc do |hash, key|
          hash.fetch 'default', NullObject.instance
        end
        hash.each do |key, value|
          set_default value
        end
      end

      def rules_edi(type, version)
        versions = settings['edifact'][type]
        namespace = settings['xml']['namespaces'].detect do |key, value|
          if value.kind_of? Hash
            value['messages'].include? version
          end
        end
        namespace ||= [ settings['xml']['namespaces']['default'] ]
        rules = versions[version]
        {
          edifact: rules,
          namespace: namespace.first,
          xml: settings['xml']['namespaces'][namespace.first]
        }
      end

      def rules_xml(namespace)
        {
          namespace: namespace,
          xml: settings['xml']['namespaces'][namespace]
        }
      end

      def namespace(type, version)
        namespace = settings['xml']['namespaces'].detect do |key, value|
          if value.kind_of? Hash
            value['messages'].include? version
          end
        end
        namespace || [ settings['xml']['namespaces']['default'] ]
      end

      def load_doc_from_urls(urls)
        urls.each do |url|
        	url = url % { gem_data: gem_data }
          begin
            xmldoc = Nokogiri::XML(open(url), url)
          rescue StandardError => e
            next
          end
          break xmldoc
        end
      end

      def xml2edi(namespace)
        xml2edis[namespace] ||= begin
          rules = rules_xml namespace
          xmldoc = load_doc_from_urls(rules[:xml]['xml2edi'])
          Nokogiri::XSLT::Stylesheet.parse_stylesheet_doc(xmldoc)
        end
      end

      def edi2xml(type, version)
        edi2xmls["#{type}_#{version}"] ||= begin
          rules = rules_edi(type, version)
          xmldoc = load_doc_from_urls(rules[:xml]['edi2xml'])
          Nokogiri::XSLT::Stylesheet.parse_stylesheet_doc(xmldoc)
        end
      end

      def schema(namespace)
        schemas[namespace] ||= begin
          ns = settings['xml']['namespaces'][namespace]['schema']
          xmldoc = load_doc_from_urls ns
          Nokogiri::XML::Schema.from_document xmldoc
        end
      end

      def load
        load_from_file(
          File.join(
            gem_data,
            'configuration.yaml'
          )
        )
      end

      def edi2xmls
        @edi2xmls ||= {}
      end

      def xml2edis
        @xml2edis ||= {}
      end

      def schemas
        @schemas ||= {}
      end

      def gem_path
        @gem_path ||= begin
          File.dirname(
            File.expand_path(__FILE__)
          )
        end
      end

      def gem_data
        @gem_data ||= begin
          File.join(
            gem_path,
            '../../data'
          )
        end
      end

    end

  end

end
