require 'edifact_converter/configuration'

module EdifactConverter::Configuration

  class YAMLConfigurator

    attr_accessor :default_ns

    def initialize
      load
    end

    def edifact_rules(type, segment_group)
      edifact_settings[type][segment_group]
    end

    def xml_rules(*args) #Either namespace or type and version
      case args.size
      when 1
        xml_settings[args.first]
      when 2
        rules = xml_settings.find do |namespace, values|
          values.versions && values.versions.include?(args[1])
        end
        rules &&= rules.last
        rules || xml_settings[default_ns] 
      else
        raise RuntimeError "Wrong number of arguments #{args.size}"
      end
    end

    private

    def load_from_file(filename)
      settings = YAML.load_file(filename)
      settings['EDIFACT'].each do |type, segments|
        rules_for_type = edifact_settings[type]
        segments.each do |segment, rules|
          rule = rules_for_type[segment]
          rule.register_hidden rules['hidden']
          rule.register_children rules['children']
        end
      end
      settings['XML'].each do |namespace, values|
        unless namespace == 'default'
          values.values.each do |urls|
            urls.map! do |url|
              url % { gem_data: EdifactConverter.data}
            end
          end
          xml_settings[namespace] = XMLRule.new values
        else
          self.default_ns = values
        end
      end
    end

    def load
      load_from_file(
        File.join(
          EdifactConverter.data,
          'configuration.yaml'
        )
      )
    end

    def edifact_settings
      @edifact_settings ||= Hash.new do |letters, type| 
        letters[type] = Hash.new do |segments, segment| 
          segments[segment] = EdifactRule.new
        end
      end
    end

    def xml_settings
      @xml_settings ||= Hash.new do |namespaces, namespace|
        if namespace.nil? or namespace.empty?
          namespaces[default_ns]
        end
      end 
    end

  end

end
