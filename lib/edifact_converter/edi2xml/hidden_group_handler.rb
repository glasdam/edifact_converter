require 'edifact_converter/edi2xml'

module EdifactConverter::EDI2XML

	class HiddenGroupHandler < EdifactConverter::EmptyHandler

		attr_accessor :inserted_group, :groups

		def startSegmentGroup(name, hidden = false)
			groups << name
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
			groups.pop
		end

		def startSegment(name)
			if locator.rules['hidden'].include? name
				self.inserted_group = locator.rules['hidden'][name]
				next_handler.endSegmentGroup(groups.last) unless groups.last == 'BrevIndhold'
				next_handler.startSegmentGroup(inserted_group, true)
				groups << group
			end
			super
		end

		def endSegment(name)
			super
		end

		private

		def groups
			@groups ||= []
		end

	end

end
