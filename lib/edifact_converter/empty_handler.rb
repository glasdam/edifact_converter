
module EdifactConverter

	class EmptyHandler
		attr_accessor :next_handler, :locator

		def initialize(nexthandler = nil)
			self.next_handler = nexthandler
		end

		def method_missing(sym, *args, &block)
			if self.next_handler
				self.next_handler.send(sym, *args, &block)
			end
		end

		def locator=(locator)
			@locator = locator
			next_handler.locator = locator if next_handler
		end

		def locator
			@locator ||= (next_handler.locator if next_handler )
		end

	end

end
