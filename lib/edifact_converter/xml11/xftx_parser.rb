require 'edifact_converter/xml11'

module EdifactConverter::XML11

	class XftxParser

		attr_accessor :paragraphs, :code, :xftx

		def self.parse(xftx_node)
			self.new(xftx_node).parse_xftx
		end

		def initialize(xftx_node)
			self.paragraphs = []
			self.xftx = xftx_node
		end

		def parse_xftx
			paragraphs << Paragraph.new 
			self.code = xftx.children[0].children[0].text
			parse_mixed xftx.children[3].children[0]
			to_ftx
		end

		def parse_mixed(subelm)
			subelm.children.each do |node|
				case node.node_type
					when Nokogiri::XML::Node::TEXT_NODE
						paragraphs.last.add_text node.text
					when Nokogiri::XML::Node::ELEMENT_NODE
						parse_xftx_element node
					end
			end
		end

		def parse_xftx_element(element)
			old_format = paragraphs.last.format
			old_font = paragraphs.last.font
			case element.name
			when 'Break'
				paragraphs.last.add_break
				return
			when 'Space'
				paragraphs.last.add_text ' '
				return
			when 'Center'
				paragraphs << paragraphs.last.empty_copy if paragraphs.last.texts?
				paragraphs.last.format = Paragraph::CENTER
				paragraphs.last.add_break
				parse_mixed element
				paragraphs.last.add_break
			when 'Right'
				paragraphs << paragraphs.last.empty_copy if paragraphs.last.texts?
				paragraphs.last.format = Paragraph::RIGHT
				paragraphs.last.add_break
				parse_mixed element
				paragraphs.last.add_break
			when 'Bold'
				paragraphs << paragraphs.last.empty_copy if paragraphs.last.texts?
				paragraphs.last.format = Paragraph::BOLD
				parse_mixed element
			when 'Italic'
				paragraphs << paragraphs.last.empty_copy if paragraphs.last.texts?
				paragraphs.last.format = Paragraph::ITALIC
				parse_mixed element
			when 'Underline'
				paragraphs << paragraphs.last.empty_copy if paragraphs.last.texts?
				paragraphs.last.format = Paragraph::UNDERLINE
				parse_mixed element
			when 'FixedFont'
				paragraphs << paragraphs.last.empty_copy if paragraphs.last.texts?
				paragraphs.last.font = Paragraph::MONOSPACE
				parse_mixed element
			else
				throw RuntimeError "Unknown xftx #{element.name}"
			end
			paragraphs << paragraphs.last.empty_copy if paragraphs.last.texts?
			paragraphs.last.format = old_format
			paragraphs.last.font = old_font
		end

		def to_s
			text = "#{code}:\n"
			paragraphs.each do |paragraph|
				text << paragraph.to_s
			end
			text
		end

		FTXElm = Struct.new(:code, :format, :texts) do 
			def insert_before(node)
				ftx =  Nokogiri::XML::Node.new "FTX", node.document
				builder = Nokogiri::XML::Builder.with(ftx) do |xml|
					xml.Elm { xml.SubElm code }
					xml.Elm { xml.SubElm format }
					xml.Elm
					xml.Elm {
						texts.each do |text|
							xml.SubElm text
						end
					}
				end
				node.add_previous_sibling ftx
			end
		end

		def to_ftx()
			ftxs = []
			paragraphs.delete_if do |paragraph|
				next_paragraph = paragraphs[1]
				texts = paragraph.to_subelms(paragraphs[1])
				texts.each_slice(5) do |content|
					if content.size < 5 and next_paragraph
						while content.size < 5 and next_paragraph.start_breaks?
							content << "."
							next_paragraph.remove_start_break
						end
					end
					ftxs << FTXElm.new(code, paragraph.ftx_format, content)
				end
				true
			end
			ftxs.each do |ftx|
				ftx.insert_before(xftx)
			end
			xftx.remove
		end

	end

end
