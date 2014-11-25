require 'edifact_converter'

module EdifactConverter::EDI2XML

	class SegmentGroupHandler < EdifactConverter::EmptyHandler

		attr_accessor :indhold, :open_groups

		alias :indhold? :indhold

		def open_groups
			@open_groups ||= []
		end

		def startSegmentGroup(name, position, hidden)
			super
			self.indhold = (name == 'BrevIndhold') unless indhold?
		end

		def startSegment(name, position)
			if indhold? && name =~ /S[0-9]{2}/
				if open_groups.last
					endSegmentGroup(open_groups.pop)
				end
				open_groups.push name
				startSegmentGroup name, position, false
			else
				super
			end
		end

		def endSegment(name)
			super unless indhold? and name =~ /S[0-9]{2}/
		end

		def endSegmentGroup(name)
			if name == 'BrevIndhold'
				self.indhold = false
				open_groups.reject! do |name|
					endSegmentGroup name
					true
				end
			end
			super
		end

	end

end