
module EdifactConverter

	class EdifactError < StandardError
		attr_accessor :message, :position, :edifact_base64

		def initialize(message, position, file = nil)
			@message = message
			@position = position
			@file = file
		end

	end

end
