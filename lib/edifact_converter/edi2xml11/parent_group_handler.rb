require 'edifact_converter/edi2xml11'

module EdifactConverter::EDI2XML11

	class ParentGroupHandler < EdifactConverter::EmptyHandler

		attr_accessor :ancestors

		def ancestors
			@ancestors ||= []
		end

		def startSegmentGroup(name, hidden = false)
			if ancestors
				self.ancestors = ancestors.drop_while do |parent_group|					
					if locator.rules.child?(name)
						false
					else
						next_handler.endSegmentGroup(parent_group)
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
			elsif locator.rules.children.any?
				ancestors << name
			else
				super
			end
		end

	end

end
