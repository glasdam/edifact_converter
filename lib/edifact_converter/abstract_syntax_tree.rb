require 'edifact_converter/comparator'

module EdifactConverter

  class AbstractSyntaxTree

    attr_accessor :document

    def initialize(document)
      self.document = document
      raise 'hell' unless document
    end

    def pack
      pack_root(document.root) if document.root
    end

    def compare(document, &proc)
      Comparator.new.compare_docs(self.document, document, &proc)
    end

    def verify_segments_checksum(&proc)
      errors = []
      proc ||= Proc.new { |n| errors << n }
      document.xpath("//Brev").each do |brev|
        sum = count_segments brev
        unt = brev.at("UNT/Elm[1]/SubElm/text()") || '0'
          if sum != unt.to_s.to_i
            proc.call(
              Difference.new(
                source: brev.at("UNT"),
                facit: sum,
                kind: :unt
              )
            )
          end
      end
      errors
    end

    def set_checksums
      document.xpath("//Brev").each do |brev|
        sum = count_segments(brev)
        brev.xpath("UNT/Elm[1]/SubElm").each do |elm|
          elm.content = sum
        end
      end
    end

    private

    def pack_root(root)
      root.elements.each do |segment|
        pack_segment segment
      end
    end

    def pack_element(element)
      element.elements.reverse.each do |subelm|
        if subelm.children.empty?
          subelm.unlink
        else
          break
        end
      end
    end

    def pack_segment(segment)
      if 'Elm' == last_child_name(segment)
        segment.elements.each { |elm| pack_element elm }
        segment.elements.reverse.each do |elm|
          break if elm.elements.any?
          elm.unlink
        end
      else
        segment.elements.each do |child|
          pack_segment(child)
        end
      end
    end

    def last_child_name(element)
      element.last_element_child && element.last_element_child.name
    end

    def count_segments(letter)
      sum = 0
      letter.traverse do |elm|
        next if not(elm.element?) || elm.name == "OBJ" || elm['hidden']
        sum += 1 if elm.name =~ /[A-Z][A-Z0-9]{2}/
      end
      sum
    end

  end

end
