require 'edifact_converter/xml11'

module EdifactConverter::XML11

	class Paragraph
		MONOSPACE = 'F'
		PROPOTIONAL = 'P'
		CENTER = 'M'
		RIGHT = 'H'
		BOLD = 'F'
		UNDERLINE = 'U'
		ITALIC = 'K'
		NORMAL = 'Normal'

		attr_accessor :font, :format, :content

		Break = Struct.new(:break) do
			def break?
				true
			end
		end

		Text = Struct.new(:value) do
			def break?
				false
			end
		end

		def initialize()
			self.font = PROPOTIONAL
			self.format = NORMAL
		end

		def remove_start_break
			content.shift if start_breaks?
		end

		def start_breaks?
			content.first.break? if content.size > 0
		end

		def add_start_break(text_break)
			content.unshift text_break
		end

		def add_end_break(text_break)
			content.push text_break
		end

		def remove_end_break
			content.shift if end_breaks?
		end

		def end_breaks?
			content.last.break? > 0
		end

		def add_text(text)
			content.push Text.new(text)
		end

		def add_break
			content.push Break.new
		end

		def content
			@content ||= []
		end

		def texts?
			content.index { |obj| not obj.break? }
		end

		def empty_copy
			copy = Paragraph.new
			copy.format = format
			copy.font = font
			copy
		end

		def ftx_format
			text = "#{font}"
			text << case format
			when NORMAL
				'00'
			when CENTER
				'0M'
			when RIGHT
				'0H'
			when BOLD
				'F0'
			when ITALIC
				'K0'
			when UNDERLINE
				'U0'
			else
				'00'
			end
		end

		def to_subelms(next_paragraph)
			texts = []
			text = StringIO.new
			content_clone = content.clone
			content_clone.delete_if do |obj|
				if obj.break?
					text.write '.' if text.size == 0
					texts << text.string
					text.string = ""
				else
					text.string = divide_text(obj.value) { |t| texts << t }
				end
				true
			end
			text.seek text.size
			if text.size > 0
				if next_paragraph
					if next_paragraph.start_breaks?
						next_paragraph.remove_start_break
					else
						if text.size == 70
							last = text.chars.last
							text.seek 69
							text.write('\\')
							texts << text.string
							text.string = "#{last}"
							text.seek text.size
						end
						text.write('\\')
					end
				end
				texts << text.string
				text.string = ''
			end
			texts
		end

		def divide_text(value)
			chars = value.chars
			text = StringIO.new
			chars.delete_if do |c|
				if c =~ /[\?:\\\'\+]/
					case text.size
					when 68
						if chars.size > 1
							text.write '\\'
							yield text.string
							text.string = ""
						end
					when 69
						text.write '\\'
						yield text.string
						text.string = ""
					end
					text.write '?'
				else
					if text.size == 69 and chars.size > 1
						unless text.string[-1] =~ /[\?:\\\'\+\s\;\.\,]/
							index = text.string.rindex(/[\?:\\\'\+\s\;\.\,]/, -1)
							if index and index > 2
								yield "#{text.string[0..(index)]}\\"
								text.string = text.string[(index+1)..-1]
							end
						else
							text.write '\\'
							yield text.string
							text.string = ''
						end
					end
				end
				text.seek text.size
				text.write c
				true
			end
			text.string
		end

		def to_s
			text = "<#{ftx_format}>"
			content.each do |obj|
				if obj.break?
					text << "\n  "
				else
					text << obj.value
				end
			end
			text
		end

	end

end