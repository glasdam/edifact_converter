require 'edifact_converter/edi2xml'

module EdifactConverter::EDI2XML

	class HiddenGroupHandler < EdifactConverter::EmptyHandler

		attr_accessor :inserted_group

		def startSegmentGroup(name, position, hidden)
			super
		end

		def endSegmentGroup(name)
			if inserted_group
				super(inserted_group)
				self.inserted_group = nil
				super if name == 'BrevIndhold'
			else
				super
			end
		end

		def startSegment(name)
			if status.hidden.include? name
				self.inserted_group = status.hidden[name]
				self.next.endSegmentGroup(status.groups.last) unless status.groups.last == 'BrevIndhold'
				self.next.startSegmentGroup(inserted_group, locator.position, true)
			end
			super
		end

		def endSegment(name)
			super
		end

	end

end
