require 'edifact_converter/xml2edi'

module EdifactConverter::XML2EDI

	class ChecksumHandler < EdifactConverter::EmptyHandler

		attr_accessor :segments, :letters, :inside_UNT, :inside_UNZ

		def startDocument
			self.segments = self.letters = 0
			super
		end

		def startSegment(name, position = nil)
			case name
			when 'UNH'
				self.letters += 1
				self.segments = 0
			when 'UNT'
				self.inside_UNT = true
			when 'UNZ'
				self.inside_UNZ = true
			end
			self.segments += 1
			super
		end

		def value(text)
			if inside_UNT
				super(segments) 
			elsif inside_UNZ
				super(letters) 
			else 
				super
			end
			self.inside_UNT = false
			self.inside_UNZ = false
		end

	end

end
