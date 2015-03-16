require 'edifact_converter'

module EdifactConverter::EDI2XML11

	class BrevHandler < EdifactConverter::EmptyHandler

		attr_accessor :last_position, :brev, :indhold

		def brev?
			@brev ||= false
		end

		def indhold?
			@indhold ||= false
		end

		def startDocument
			self.brev = self.indhold = false
			super
		end

		def startSegment(name)
			case name
			when 'UNH'
				startSegmentGroup('Brev', true)
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
					self.brev = false
				when 'UNH'
					unless indhold?
						startSegmentGroup 'BrevIndhold', true
						self.indhold = true
					end
				end
			end
		end

	end

end