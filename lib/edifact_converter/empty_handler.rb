
module EdifactConverter

	class EmptyHandler
		attr_accessor :next
		@@segments_seen = 0
		@@active = {}

		def initialize(nexthandler = nil)
			@next = nexthandler
		end

		def method_missing(sym, *args, &block)
			if @next
				@next.send(sym, *args, &block)
			end
		end

		def segments_seen
			@@segments_seen
		end

		def active
			@@active
		end

	end

end
