require "edifact_converter"

module EdifactConverter

	class EdifactError < StandardError
		attr_accessor :message, :position, :edifact_base64

		def initialize(message, position)
			self.message = message
			self.position = position
		end

    def to_message
      Message.new(position: position, text: message)
    end

	end

end
