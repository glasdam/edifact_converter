
module EdifactConverter

	class EmptyHandler
		attr_accessor :next, :status

		def initialize(nexthandler = nil, status = nil)
			self.next = nexthandler
			self.status = status
		end

		def method_missing(sym, *args, &block)
			if self.next
				self.next.send(sym, *args, &block)
			end
		end

		def segments_seen
			@@segments_seen ||= 0
		end

		def active
			@@active ||= {}
		end

		def locator
			self.class.locator
		end

		def self.locator=(locator)
			@@locator = locator			
		end

		def self.locator
			@@locator ||= EdifactConverter::EDI2XML::Locator.new
		end

	end

end
