require 'edifact_converter/edi2xml'

module EdifactConverter::EDI2XML

	class StatusHandler < EdifactConverter::EmptyHandler

		attr_accessor :groups, :segment, :element_index, :value_index, :settings, :rules

		def hidden
			if rules
				rules['hidden'] || {}
			else
				{}
			end
		end

		def startDocument
			self.groups = []
			self.segment = 'Edifact'
			self.element_index = 0
			self.value_index = 0
			self.version = self.type = 'default'
			self.settings = EdifactConverter::Configuration.rules_edi('default', 'default')
			super
		end

		def endDocument
			super
		end

		def startSegmentGroup(name, position, hidden)
			groups << name
			self.rules = settings[:edifact][name]
			super
		end

		def endSegmentGroup(name)
			groups.pop
			self.rules = settings[:edifact][groups.last]
			super
		end

		def startSegment(name, position)
			self.segment = name
			self.element_index = 0
			super
		end

		def endSegment(name)
			self.segment = nil
			super
		end

		def startElement(position)
			self.element_index += 1
			self.value_index = 0
			super
		end

		def endElement
			super
		end

		def value(value, position)
			if segment == 'UNH' && element_index == 2
				case value_index
				when 0
					EdifactConverter.properties[:type] = value
					self.settings = EdifactConverter::Configuration.rules_edi(EdifactConverter.properties[:type], EdifactConverter.properties[:version])
				when 4
					EdifactConverter.properties[:version]
					self.settings = EdifactConverter::Configuration.rules_edi(EdifactConverter.properties[:type], EdifactConverter.properties[:version])
				end
			end
			self.value_index += 1
			super
		end

	end

end
