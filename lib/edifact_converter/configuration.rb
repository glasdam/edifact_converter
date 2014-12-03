require 'edifact_converter'
require 'open-uri'
require 'yaml'

module EdifactConverter

	class Configuration

		class << self

			attr_accessor :default_namespace, :hide_position, :schemas, :xml2edis, :edi2xmls, :format_edi

			alias :hide_position? :hide_position

			def edifact
				@edifact ||= empty_properties
			end

			def xml
				@xml ||= empty_properties
			end

			def empty_properties
				Hash.new { |hash, key| hash['default'] if hash.has_key? 'default' }
			end

			def load_from_file(filename)
				settings = YAML.load_file(filename)
				@edifact = settings['edifact'] || {}
				@xml = settings['xml'] || {}
				@namespaces = if nss = @xml['namespaces']
					self.default_namespace = nss['default']
					nss.inject ({}) do |h, (key, value)|
						(value['messages'] || []).each do |msg|
							h[msg] = key
						end
						h
					end
				else
					{}
				end
			end

			def rules(type, version, segmentgroup)

			end

			def namespace(type, version)
				@namespaces[version] || default_namespace
			end

			def xml2edi(namespace)
				xml2edis[namespace] ||= begin
					ns = @xml['namespaces'][namespace] || @xml['namespaces'][default_namespace]
					if ns
						url = ns['xml2edi']
						xmldoc = Nokogiri::XML(open(url), url)
						Nokogiri::XSLT::Stylesheet.parse_stylesheet_doc(xmldoc)
					end
				end
			end

			def edi2xml(type, version)
				edi2xmls["#{type}_#{version}"] ||= begin
					ns = namespace(type, version)
					if ns
						url = @xml['namespaces'][ns]['edi2xml']
						xmldoc = Nokogiri::XML(open(url), url)
						Nokogiri::XSLT::Stylesheet.parse_stylesheet_doc(xmldoc)
					end
				end
			end

			def schema(namespace)
				schemas[namespace] ||= begin
					ns = @xml['namespaces'][namespace]
					if ns
						url = ns['schema']
						xmldoc = Nokogiri::XML(open(url), url)
						Nokogiri::XML::Schema.from_document xmldoc
					end
				end
			end

			def load
				load_from_file(
					File.join(
						File.dirname(
						File.expand_path(__FILE__)),
					'../../data/configuration.yaml')
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

		end

		# attr_accessor :settings

		# def initialize(settings)
		# 	self.settings = settings
		# end

		# def get(name)
		# 	value = (settings[name] || settings['default'])
		# 	if value.respond_to?(:has_key?)
		# 		self.class.new(value)
		# 	else
		# 		value
		# 	end
		# end

	end

end
