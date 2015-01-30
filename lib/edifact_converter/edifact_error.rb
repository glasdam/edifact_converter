require "edifact_converter"

module EdifactConverter

	class EdifactError < StandardError
		attr_accessor :message, :position, :edifact_base64

		def initialize(message, position, file = nil)
			self.message = message
			self.position = position
		  #self.file = file
		end

    def to_message
      Message.new(position, message, :error)
    end

	end

end
