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
					# puts "-----\n"
					# p status.groups
					# #puts position
					# p status.rules
					# puts "#{parent_group} #{status.rules['children']}.include?(#{name}) = #{ status.rules['children'] ? status.rules['children'].include?(name) : false}"
					# puts "-----\n"
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
