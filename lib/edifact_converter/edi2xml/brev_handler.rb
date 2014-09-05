require 'edifact_converter'

module EdifactConverter::EDI2XML

	class BrevHandler < EdifactConverter::EmptyHandler

		attr_accessor :last_position, :brev, :indhold

		def brev?
			@brev ||= false
		end

		def indhold?
			@indhold ||= false
		end

		def startSegment(name, position)
			self.last_position = position.dup
			case name
			when 'UNH'
				startSegmentGroup('Brev', position, true)
				self.brev = true
			when 'UNT'
				endSegmentGroup 'BrevIndhold' if indhold?
			end
			super
		end

		def endSegment(name)
			super
			if brev?
				case name
				when 'UNT'
					endSegmentGroup('Brev')
				when 'UNH'
					unless indhold?
						startSegmentGroup 'BrevIndhold', last_position, false
						self.indhold = true
					end
				end
			end
		end

	end

end