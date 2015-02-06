
module EdifactConverter

	class EmptyHandler
		attr_accessor :next_handler

		def initialize(nexthandler = nil)
			self.next_handler = nexthandler
		end

		def method_missing(sym, *args, &block)
			if self.next_handler
				self.next_handler.send(sym, *args, &block)
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
