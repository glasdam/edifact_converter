require 'edifact_converter/xml2edi'

module EdifactConverter::XML2EDI

  class SegmentChecks
    def is_segment(nodeset)
      (nodeset.first.name =~ /\p{Upper}{3}/) == 0
    end

    def is_segmentgroup(nodeset)
      (nodeset.first.name =~ /S[0-9]{2}/) == 0
    end

    def valid_elms(nodeset)
      nodeset.each do |elm|
        elm.children = pop_last_empty(elm.children)
      end
      pop_last_empty nodeset
    end

    def escape_subelms(nodeset)
      nodeset.each do |elm|
        elm.content = escape_text elm.text unless elm['base64']
      end
    end

    private

    def pop_last_empty(nodeset)
      while nodeset.size > 0 && nodeset.last.children.size == 0
        nodeset.pop
      end
      nodeset
    end

    def escape_text(text)
      text.gsub(/[\+\'\:\?]/) {|s| "?#{s}"} 
    end

  end
  
end
