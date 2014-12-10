require 'edifact_converter/edi2xml'

module EdifactConverter::EDI2XML

	class StatusHandler < EdifactConverter::EmptyHandler

		attr_accessor :groups, :segment, :element_in_segment, :value_in_element, :type, :version, :settings, :rules

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
			self.element_in_segment = 0
			self.value_in_element = 0
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
			self.element_in_segment = 0
			super
		end

		def endSegment(name)
			self.segment = nil
			super
		end

		def startElement(position)
			self.element_in_segment += 1
			self.value_in_element = 0
			super
		end

		def endElement
			super
		end

		def value(value, position)
			if segment == 'UNH' && element_in_segment == 2
				case value_in_element
				when 0
					self.type = value
					self.settings = EdifactConverter::Configuration.rules_edi(type, version)
				when 4
					self.version = value
					self.settings = EdifactConverter::Configuration.rules_edi(type, version)
				end
			end
			self.value_in_element += 1
			super
		end

	end

end
