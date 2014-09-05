require 'edifact_converter/edi2xml'

module EdifactConverter::EDI2XML

	class ParentGroupHandler < EdifactConverter::EmptyHandler

		attr_accessor :ancestors, :previous

		def ancestors
			@ancestors ||= []
		end

		def startSegmentGroup(name, position, hidden)
			if ancestors
				self.ancestors = ancestors.drop_while do |parent_group|
					if (children = status.rules['children']) and children.include?(name)
						false
					else
						self.next.endSegmentGroup(parent_group)
						true
					end
				end
			end
			super
		end

		def endSegmentGroup(name)
			if name == 'BrevIndhold'
				ancestors.reverse_each do |parent|
					super(parent)
				end
				super
				self.ancestors = nil
				previous = nil
			elsif status.rules and status.rules['children']
				ancestors << name
			else
				super
			end
		end

	end

end
