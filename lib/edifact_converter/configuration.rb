require 'edifact_converter'
require 'edifact_converter/configuration/edifact_rule'
require 'edifact_converter/configuration/xml_rule'
require 'edifact_converter/configuration/yaml_configurator'
require 'edifact_converter/configuration/json_configurator'
require 'open-uri'

module EdifactConverter

  module Configuration

    class << self

      attr_accessor :hide_position, :format_edi

      alias :hide_position? :hide_position

      def edifact_rules(type, segment_group)
        configurator.edifact_rules(type, segment_group)
      end

      def xml_rules(*args) #Either namespace or type and version
        configurator.xml_rules *args
      end

      def configurator
        @configurator ||= JSONConfigurator.new
      end

      def configurator=(configurator)
        @configurator = configurator
      end

    end

  end

end
